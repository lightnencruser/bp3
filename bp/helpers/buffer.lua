local buffer    = {}
local player    = windower.ffxi.get_player()
local files     = require('files')
local texts     = require('texts')
local images    = require('images')
local res       = require('resources').spells:skill(34)
local f = files.new(string.format('bp/helpers/settings/buffer/%s_settings.lua', player.name))

if not f:exists() then
  f:write(string.format('return %s', T({}):tovstring()))
end

function buffer.new()
    local self = {}

    -- Static Variables.
    self.settings       = dofile(string.format('%sbp/helpers/settings/buffer/%s_settings.lua', windower.addon_path, player.name))
    self.layout         = self.settings.layout or {pos={x=100, y=100}, colors={text={alpha=255, r=100, g=215, b=0}, bg={alpha=0, r=0, g=0, b=0}, stroke={alpha=255, r=0, g=25, b=15}}, font={name='Lucida Console', size=10}, padding=5, stroke_width=2, draggable=false}
    self.display        = { {id=1, display=texts.new('--{ BUFFING }--', {flags={draggable=self.layout.draggable}})} }
    self.important      = string.format('%s,%s,%s', 25, 165, 200)

    -- Private Variables.
    local bp            = false
    local private       = {events={}}
    local buffs         = {}
    local icons         = {}
    local list          = {}
    local allowed       = {}
    local conversion    = {

        [43]=40, [44]=40, [45]=40, [46]=40, [47]=40, -- Protect.
        [48]=41, [49]=41, [50]=41, [51]=41, [52]=41, -- Shell.
        [57]=33, [511]=33, -- Haste.
        [99]=181, [113]=183, [114]=180, [115]=178, [116]=179, [117]=182, [118]=185, [119]=184, [864]=595, [862]=593, [858]=594, [860]=589, [857]=592, [859]=591, [861]=590, [863]=596, -- Storms.
        [107]=116, -- Phalanx.
        [108]=42, [110]=42, [111]=42, [477]=42, [504]=42, -- Regen.
        [109]=43, [473]=43, [894]=43, -- Refresh.
        [845]=265, [846]=265, -- Flurry.
        [495]=170, -- Adloquium.
        [308]=289, -- Animus Augeo.
        [309]=291, -- Animus Minuo.
        [478]=228, -- Embrava.

    }
    for i,v in pairs(res) do
        local targets = T(v.targets)
        
        if (#targets == 1 and targets[1] ~= 'Self') or #targets > 1 then
            allowed[i] = v
        end        

    end

    -- Private Functions
    local persist = function()
        local next = next

        if self.settings then
            self.settings.layout = self.layout
        end

    end
    persist()

    local resetDisplay = function(n)

        if n and type(n) == 'number' then
            self.display[n].display:pos(self.layout.pos.x, self.layout.pos.y + (n * (self.layout.font.size + self.layout.padding)))
            self.display[n].display:font(self.layout.font.name)
            self.display[n].display:color(self.layout.colors.text.r, self.layout.colors.text.g, self.layout.colors.text.b)
            self.display[n].display:alpha(self.layout.colors.text.alpha)
            self.display[n].display:size(self.layout.font.size)
            self.display[n].display:pad(self.layout.padding)
            self.display[n].display:bg_color(self.layout.colors.bg.r, self.layout.colors.bg.g, self.layout.colors.bg.b)
            self.display[n].display:bg_alpha(self.layout.colors.bg.alpha)
            self.display[n].display:stroke_width(self.layout.stroke_width)
            self.display[n].display:stroke_color(self.layout.colors.stroke.r, self.layout.colors.stroke.g, self.layout.colors.stroke.b)
            self.display[n].display:stroke_alpha(self.layout.colors.stroke.alpha)
            self.display[n].display:show()
            self.display[n].display:update()

        end

    end
    resetDisplay(1)

    -- Static Functions.
    self.writeSettings = function()
        persist()

        if f:exists() then
            f:write(string.format('return %s', T(self.settings):tovstring()))

        elseif not f:exists() then
            f:write(string.format('return %s', T({}):tovstring()))

        end

    end
    self.writeSettings()

    -- Public Functions.
    self.setSystem = function(buddypal)
        if buddypal then
            bp = buddypal
        end

    end
    
    self.reset = function()

        if bp then

            for _,v in pairs(buffs) do
                local player = v
                
                for i=1, #player do
                    local buff = player[i] or false
                    
                    if buff and buff.last then
                        buff.last = 0
                    end

                end

            end

        end

    end

    self.add = function(target, spell, delay)
        local target    = target or false
        local spell     = spell or false
        local delay     = delay or 2

        if bp and target and spell then

            if type(target) == 'table' and target.id and self.valid(spell) then
                local spell = self.valid(spell)

                if not self.exists(target, spell) and bp.helpers['actions'].isReady('MA', spell.en) then
                
                    if buffs[target.id] then
                        table.insert(buffs[target.id], {target=target.id, id=spell.id, last=0, delay=delay*60})

                        for _,v in ipairs(self.display) do
                            local list = {}

                            for _,v in ipairs(buffs[target.id]) do
                                table.insert(list, bp.res.spells[v.id].en)
                            end

                            if v.id and v.display and v.id == target.id then
                                v.display:text(string.format('%s%s[ \\cs(%s)%s\\cr ]', target.name, (' '):rpad(' ', 20-tostring(target.name):len()), self.important, table.concat(list, ' | ')))
                                v.display:show()
                                v.display:update()

                            end

                        end

                    
                    else
                        buffs[target.id] = {}
                        table.insert(buffs[target.id], {target=target.id, id=spell.id, last=0, delay=delay*60})
                        table.insert(self.display, {id=target.id, display=texts.new('', {flags={draggable=self.layout.draggable}})})

                        resetDisplay(#self.display)
                        self.display[#self.display].display:text(string.format('%s%s[ \\cs(%s)%s\\cr ]', target.name, (' '):rpad(' ', 20-tostring(target.name):len()), self.important, bp.res.spells[spell.id].en))
                        self.display[#self.display].display:show()
                        self.display[#self.display].display:update()

                    end

                end

            elseif type(target) == 'number' or (type(target) == 'string' and tonumber(target) ~= nil) and not self.exists(target, spell) then
                local target    = windower.ffxi.get_mob_by_id(target) or windower.ffxi.get_mob_by_index(target) or false
                local spell     = self.valid(spell)

                if target and not self.exists(target, spell) then
                    
                    if buffs[target.id] then
                        table.insert(buffs[target.id], {target=target.id, id=spell.id, last=0, delay=delay*60})

                        for _,v in ipairs(self.display) do
                            local list = {}

                            for _,v in ipairs(buffs[target.id]) do
                                table.insert(list, bp.res.spells[v.id].en)
                            end

                            if v.id and v.display and v.id == target.id then
                                v.display:text(string.format('%s%s[ \\cs(%s)%s\\cr ]', target.name, (' '):rpad(' ', 20-tostring(target.name):len()), self.important, table.concat(list, ' | ')))
                                v.display:show()
                                v.display:update()

                            end

                        end

                    
                    else
                        buffs[target.id] = {}
                        table.insert(buffs[target.id], {target=target.id, id=spell.id, last=0, delay=delay*60})
                        table.insert(self.display, {id=target.id, display=texts.new('', {flags={draggable=self.layout.draggable}})})

                        resetDisplay(#self.display)
                        self.display[#self.display].display:text(string.format('%s%s[ \\cs(%s)%s\\cr ]', target.name, (' '):rpad(' ', 20-tostring(target.name):len()), self.important, bp.res.spells[spell.id].en))
                        self.display[#self.display].display:show()
                        self.display[#self.display].display:update()

                    end

                end

            elseif type(target) == 'string' and tonumber(target) == nil and not self.exists(target, spell) then
                local target    = windower.ffxi.get_mob_by_name(target) or false
                local spell     = self.valid(spell)

                if target and not self.exists(target, spell) then
                    
                    if buffs[target.id] then
                        table.insert(buffs[target.id], {target=target.id, id=spell.id, last=0, delay=delay*60})

                        for _,v in ipairs(self.display) do
                            local list = {}

                            for _,v in ipairs(buffs[target.id]) do
                                table.insert(list, bp.res.spells[v.id].en)
                            end

                            if v.id and v.display and v.id == target.id then
                                v.display:text(string.format('%s%s[ \\cs(%s)%s\\cr ]', target.name, (' '):rpad(' ', 20-tostring(target.name):len()), self.important, table.concat(list, ' | ')))
                                v.display:show()
                                v.display:update()

                            end

                        end

                    
                    else
                        buffs[target.id] = {}
                        table.insert(buffs[target.id], {target=target.id, id=spell.id, last=0, delay=delay*60})
                        table.insert(self.display, {id=target.id, display=texts.new('', {flags={draggable=self.layout.draggable}})})

                        resetDisplay(#self.display)
                        self.display[#self.display].display:text(string.format('%s%s[ \\cs(%s)%s\\cr ]', target.name, (' '):rpad(' ', 20-tostring(target.name):len()), self.important, bp.res.spells[spell.id].en))
                        self.display[#self.display].display:show()
                        self.display[#self.display].display:update()

                    end

                end

            end

        end        

    end

    self.remove = function(target, spell)
        local bp        = bp or false
        local target    = target or false
        local spell     = spell or false

        if bp and target and spell and target.id and buffs[target.id] then

            if type(target) == 'table' and target.id and self.valid(spell) then
                local spell = self.valid(spell)

                if self.exists(target, spell) then
                
                    for i,v in ipairs(buffs[target.id]) do

                        if v.id and v.id == spell.id then
                            table.remove(buffs[target.id], i)
                            break

                        end

                    end
                    self.updateBuffs(target)

                end

            elseif type(target) == 'number' or (type(target) == 'string' and tonumber(target) ~= nil) and not self.exists(target, spell) then
                local target    = windower.ffxi.get_mob_by_id(target) or windower.ffxi.get_mob_by_index(target) or false
                local spell     = self.valid(spell)                

                if target and self.exists(target, spell) then

                    for i,v in ipairs(buffs[target.id]) do

                        if v.id and v.id == spell.id then
                            table.remove(buffs[target.id], i)
                            break

                        end

                    end
                    self.updateBuffs(target)
                    
                end

            elseif type(target) == 'string' and tonumber(target) == nil and not self.exists(target, spell) then
                local target    = windower.ffxi.get_mob_by_name(target) or false
                local spell     = self.valid(spell)

                if target and self.exists(target, spell) then

                    for i,v in ipairs(buffs[target.id]) do

                        if v.id and v.id == spell.id then
                            table.remove(buffs[target.id], i)
                            break

                        end

                    end
                    self.updateBuffs(target)
                    
                end

            end

        end

    end

    self.updateBuffs = function(target)

        if target then

            for _,v in ipairs(self.display) do
                local list = {}

                for _,v in ipairs(buffs[target.id]) do
                    table.insert(list, bp.res.spells[v.id].en)
                end

                if v.id and v.display and v.id == target.id then
                    v.display:text(string.format('%s%s[ \\cs(%s)%s\\cr ]', target.name, (' '):rpad(' ', 20-tostring(target.name):len()), self.important, table.concat(list, ' | ')))
                    v.display:show()
                    v.display:update()

                end

            end

        end

    end

    self.valid = function(spell)
        local bp    = bp or false
        local spell = spell or false

        if bp and spell then

            if type(spell) == 'table' and spell.id and allowed[spell.id] then
                return allowed[spell.id]

            elseif (type(spell) == 'number' or type(spell) == 'string' and tonumber(spell) ~= nil) and allowed[spell] then
                return allowed[spell]

            elseif type(spell) == 'string' and tonumber(spell) == nil then
                
                for _,v in pairs(allowed) do

                    if v.en and spell:lower() == v.en:lower() then
                        return v
                    end

                end

            end

        end
        return false

    end

    self.exists = function(target, spell)
        local bp        = bp or false
        local target    = target or false
        local spell     = spell or false

        if bp and target and spell and target.id and buffs[target.id] and spell.id then

            for _,v in ipairs(buffs[target.id]) do

                if v.id and v.id == spell.id then
                    return true
                end

            end

        end
        return false

    end

    self.cast = function()

        if bp then

            for i in pairs(buffs) do
                local player = windower.ffxi.get_mob_by_id(i) or false

                if player and buffs[player.id] then

                    for index,buff in ipairs(buffs[player.id]) do

                        if (os.clock()-buff.last) > buff.delay and bp.res.spells[buff.id] and bp.helpers['actions'].isReady('MA', bp.res.spells[buff.id].en) and not bp.helpers['queue'].inQueue(bp.res.spells[buff.id]) then
                            bp.helpers['queue'].add(bp.res.spells[buff.id], player)
                        end

                    end

                end

            end

        end

    end

    self.updateDelay = function(target, spell)
        local target    = target or false
        local spell     = spell or false

        if bp and target and spell and target.id and buffs[target.id] then

            if type(target) == 'table' and target.id and self.valid(spell) then
                local spell = self.valid(spell)

                if self.exists(target, spell) then

                    for i,v in ipairs(buffs[target.id]) do
                        
                        if v.id and v.id == spell.id then
                            
                            buffs[target.id][i].last = os.clock()
                            break

                        end

                    end

                end

            elseif type(target) == 'number' or (type(target) == 'string' and tonumber(target) ~= nil) and not self.exists(target, spell) then
                local target    = windower.ffxi.get_mob_by_id(target) or windower.ffxi.get_mob_by_index(target) or false
                local spell     = self.valid(spell)                

                if target and self.exists(target, spell) then

                    for i,v in ipairs(buffs[target.id]) do

                        if v.id and v.id == spell.id then
                            buffs[target.id][i].last = os.clock()
                            break

                        end

                    end
                    
                end

            elseif type(target) == 'string' and tonumber(target) == nil and not self.exists(target, spell) then
                local target    = windower.ffxi.get_mob_by_name(target) or false
                local spell     = self.valid(spell)

                if target and self.exists(target, spell) then

                    for i,v in ipairs(buffs[target.id]) do

                        if v.id and v.id == spell.id then
                            buffs[target.id][i].last = os.clock()
                            break

                        end

                    end
                    
                end

            end

        end

    end

    self.convert = function(id)
        local bp = bp or false
        local id = id or false

        if bp and id and conversion[id] then
            return conversion[id]
        end
        return false

    end

    self.pos = function(x, y)
        local bp    = bp or false
        local x     = tonumber(x) or self.layout.pos.x
        local y     = tonumber(y) or self.layout.pos.y

        if bp and x and y then
            self.layout.pos.x = x
            self.layout.pos.y = y
            self.writeSettings()

            for i=1, #self.display do
                resetDisplay(i)
            end
        
        elseif bp and (not x or not y) then
            bp.helpers['popchat'].pop('PLEASE ENTER AN "X" OR "Y" COORDINATE!')

        end

    end

    return self

end
return buffer.new()
