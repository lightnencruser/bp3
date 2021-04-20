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
    self.settings   = dofile(string.format('%sbp/helpers/settings/buffer/%s_settings.lua', windower.addon_path, player.name))
    self.layout     = self.settings.layout or {pos={x=100, y=100}, colors={text={alpha=255, r=100, g=215, b=0}, bg={alpha=0, r=0, g=0, b=0}, stroke={alpha=255, r=0, g=25, b=15}}, font={name='Lucida Console', size=13}, padding=2, stroke_width=2, draggable=false}
    self.display    = texts.new('', {flags={draggable=self.layout.draggable}})

    -- Private Variables.
    local buffs     = {}
    local icons     = {}
    local list      = {}
    local allowed   = {}
    for i,v in pairs(res) do
        local targets = T(v.targets)
        
        if (#targets == 1 and targets[1] ~= 'Self') or #targets > 1 then
            allowed[i] = v
        end        

    end
    local conversion = {

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

    -- Private Functions
    local persist = function()
        local next = next

        if self.settings then
            self.settings.layout = self.layout
        end

    end
    persist()

    local resetDisplay = function()
        self.display:pos(self.layout.pos.x, self.layout.pos.y)
        self.display:font(self.layout.font.name)
        self.display:color(self.layout.colors.text.r, self.layout.colors.text.g, self.layout.colors.text.b)
        self.display:alpha(self.layout.colors.text.alpha)
        self.display:size(self.layout.font.size)
        self.display:pad(self.layout.padding)
        self.display:bg_color(self.layout.colors.bg.r, self.layout.colors.bg.g, self.layout.colors.bg.b)
        self.display:bg_alpha(self.layout.colors.bg.alpha)
        self.display:stroke_width(self.layout.stroke_width)
        self.display:stroke_color(self.layout.colors.stroke.r, self.layout.colors.stroke.g, self.layout.colors.stroke.b)
        self.display:stroke_alpha(self.layout.colors.stroke.alpha)
        self.display:hide()
        self.display:update()

    end
    resetDisplay()

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
    self.reset = function(bp)
        local bp = bp or false

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

    self.add = function(bp, target, spell, delay)
        local bp        = bp or false
        local target    = target or false
        local spell     = spell or false
        local delay     = delay or 2

        if bp and target and spell then

            if type(target) == 'table' and target.id and self.valid(bp, spell) then
                local spell = self.valid(bp, spell)

                if not self.exists(bp, target, spell) then
                
                    if buffs[target.id] then
                        table.insert(buffs[target.id], {target=target.id, id=spell.id, last=0, delay=delay*60})
                    
                    else
                        buffs[target.id] = {}
                        table.insert(buffs[target.id], {target=target.id, id=spell.id, last=0, delay=delay*60})

                    end
                    self.updateIcons(bp)

                end

            elseif type(target) == 'number' or (type(target) == 'string' and tonumber(target) ~= nil) and not self.exists(bp, target, spell) then
                local target    = windower.ffxi.get_mob_by_id(target) or windower.ffxi.get_mob_by_index(target) or false
                local spell     = self.valid(bp, spell)

                if target and not self.exists(bp, target, spell) then
                    
                    if buffs[target.id] then
                        table.insert(buffs[target.id], {target=target.id, id=spell.id, last=0, delay=delay*60})
                    
                    else
                        buffs[target.id] = {}
                        table.insert(buffs[target.id], {target=target.id, id=spell.id, last=0, delay=delay*60})

                    end
                    self.updateIcons(bp)

                end

            elseif type(target) == 'string' and tonumber(target) == nil and not self.exists(bp, target, spell) then
                local target    = windower.ffxi.get_mob_by_name(target) or false
                local spell     = self.valid(bp, spell)

                if target and not self.exists(bp, target, spell) then
                    
                    if buffs[target.id] then
                        table.insert(buffs[target.id], {target=target.id, id=spell.id, last=0, delay=delay*60})
                    
                    else
                        buffs[target.id] = {}
                        table.insert(buffs[target.id], {target=target.id, id=spell.id, last=0, delay=delay*60})

                    end
                    self.updateIcons(bp)

                end

            end

        end        

    end

    self.remove = function(bp, target, spell)
        local bp        = bp or false
        local target    = target or false
        local spell     = spell or false

        if bp and target and spell and target.id and buffs[target.id] then

            if type(target) == 'table' and target.id and self.valid(bp, spell) then
                local spell = self.valid(bp, spell)

                if self.exists(bp, target, spell) then
                
                    for i,v in ipairs(buffs[target.id]) do

                        if v.id and v.id == spell.id then
                            table.remove(buffs[target.id], i)
                            break

                        end

                    end
                    self.updateIcons(bp)

                end

            elseif type(target) == 'number' or (type(target) == 'string' and tonumber(target) ~= nil) and not self.exists(bp, target, spell) then
                local target    = windower.ffxi.get_mob_by_id(target) or windower.ffxi.get_mob_by_index(target) or false
                local spell     = self.valid(bp, spell)                

                if target and self.exists(bp, target, spell) then

                    for i,v in ipairs(buffs[target.id]) do

                        if v.id and v.id == spell.id then
                            table.remove(buffs[target.id], i)
                            break

                        end

                    end
                    self.updateIcons(bp)
                    
                end

            elseif type(target) == 'string' and tonumber(target) == nil and not self.exists(bp, target, spell) then
                local target    = windower.ffxi.get_mob_by_name(target) or false
                local spell     = self.valid(bp, spell)

                if target and self.exists(bp, target, spell) then

                    for i,v in ipairs(buffs[target.id]) do

                        if v.id and v.id == spell.id then
                            table.remove(buffs[target.id], i)
                            break

                        end

                    end
                    self.updateIcons(bp)
                    
                end

            end

        end

    end

    self.valid = function(bp, spell)
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

    self.exists = function(bp, target, spell)
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

    self.updateIcons = function(bp)
        local count = 0
        local font  = (self.settings.layout.font.size+3)

        for i in pairs(buffs) do

            if icons[i] then
            
                for _,v in ipairs(icons[i]) do
                    v.icon:destroy()
                end
            
            end
            
            if buffs[i] then
                icons[i] = {}

                for _,v in ipairs(buffs[i]) do
                    table.insert(icons[i], {icon=images.new({color={alpha = 255},texture={fit=false},draggable=false}), id=v.id})

                    local id     = self.convert(bp, v.id)
                    local index  = #icons[i]
                    local offset = (count*(font+2))
                    
                    if icons[i] and icons[i][index] and icons[i][index].icon then
                        
                        if index == 1 then
                            icons[i][index].icon:path(string.format("%sbp/resources/icons/buffs/%s.png", windower.addon_path, id))
                            icons[i][index].icon:size(font, font)
                            icons[i][index].icon:transparency(0)
                            icons[i][index].icon:pos_x(self.display:pos_x()-(font+1))
                            icons[i][index].icon:pos_y(self.display:pos_y()+offset+3)
                            icons[i][index].icon:show()


                        else
                            icons[i][index].icon:path(string.format("%sbp/resources/icons/buffs/%s.png", windower.addon_path, id))
                            icons[i][index].icon:size(font, font)
                            icons[i][index].icon:transparency(0)
                            icons[i][index].icon:pos_x(icons[i][index-1].icon:pos_x()-(font+1))
                            icons[i][index].icon:pos_y(icons[i][index-1].icon:pos_y())
                            icons[i][index].icon:show()

                        end                        
                        
                    end

                end

            end
            count = (count + 1)

        end

    end

    self.cast = function(bp)
        local bp = bp or false

        if bp then

            for i in pairs(buffs) do
                local player = windower.ffxi.get_mob_by_id(i) or false

                if player and buffs[player.id] then

                    for index,buff in ipairs(buffs[player.id]) do
                        
                        if (os.clock()-buff.last) > buff.delay and bp.res.spells[buff.id] and bp.helpers['actions'].isReady(bp, 'MA', bp.res.spells[buff.id].en) and not bp.helpers['queue'].inQueue(bp, bp.res.spells[buff.id]) then
                            bp.helpers['queue'].add(bp, bp.res.spells[buff.id], player)
                        end

                    end

                end

            end

        end

    end

    self.updateDelay = function(bp, target, spell)
        local bp        = bp or false
        local target    = target or false
        local spell     = spell or false

        if bp and target and spell and target.id and buffs[target.id] then

            if type(target) == 'table' and target.id and self.valid(bp, spell) then
                local spell = self.valid(bp, spell)

                if self.exists(bp, target, spell) then
                
                    for i,v in ipairs(buffs[target.id]) do

                        if v.id and v.id == spell.id then
                            buffs[target.id][i].last = os.clock()
                            break

                        end

                    end

                end

            elseif type(target) == 'number' or (type(target) == 'string' and tonumber(target) ~= nil) and not self.exists(bp, target, spell) then
                local target    = windower.ffxi.get_mob_by_id(target) or windower.ffxi.get_mob_by_index(target) or false
                local spell     = self.valid(bp, spell)                

                if target and self.exists(bp, target, spell) then

                    for i,v in ipairs(buffs[target.id]) do

                        if v.id and v.id == spell.id then
                            buffs[target.id][i].last = os.clock()
                            break

                        end

                    end
                    
                end

            elseif type(target) == 'string' and tonumber(target) == nil and not self.exists(bp, target, spell) then
                local target    = windower.ffxi.get_mob_by_name(target) or false
                local spell     = self.valid(bp, spell)

                if target and self.exists(bp, target, spell) then

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

    self.convert = function(bp, id)
        local bp = bp or false
        local id = id or false

        if bp and id and conversion[id] then
            return conversion[id]
        end
        return false

    end

    self.render = function(bp)

        if T(buffs):length() > 0 then
            local update = {}

            for i in pairs(buffs) do

                if windower.ffxi.get_mob_by_id(i) then
                    table.insert(update, string.format(':%s', windower.ffxi.get_mob_by_id(i).name))
                end

            end
            self.display:text(table.concat(update, '\n'))
            self.display:update()

            if not self.display:visible() then
                self.display:show()
            end

        end
        
    end

    self.pos = function(bp, x, y)
        local bp    = bp or false
        local x     = tonumber(x) or self.layout.pos.x
        local y     = tonumber(y) or self.layout.pos.y

        if bp and x and y then
            self.display:pos(x, y)
            self.layout.pos.x = x
            self.layout.pos.y = y
            self.updateIcons(bp)
            self.writeSettings()
        
        elseif bp and (not x or not y) then
            bp.helpers['popchat'].pop('PLEASE ENTER AN "X" OR "Y" COORDINATE!')

        end

    end

    return self

end
return buffer.new()
