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
    self.display        = {}
    self.important      = string.format('%s,%s,%s', 25, 165, 200)

    -- Private Variables.
    local bp            = false
    local private       = {events={}, buffs=T{}, time={last=0, delay=1}}
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

    -- Private Functions.
    private.add = function(target, spell, delay)
        local spell = private.getSpell(spell)
        local delay = delay or 120

        if bp and spell and target then
            local exists = private.exists(target.id)

            if not exists and bp.helpers['target'].castable(target, spell) then
                table.insert(private.buffs, {

                    player  = target,
                    spells  = {[spell.id]={last=0, delay=delay, icon=images.new({color={alpha = 255}, texture={fit=false}, draggable=false})}},
                    text    = texts.new('', {flags={draggable=false}}),

                })

                do -- ADJUST TEXT AND IMAGE SETTINGS.
                    local text = private.buffs[#private.buffs].text
                    local time = private.buffs[#private.buffs].spells[spell.id].time
                    local icon = private.buffs[#private.buffs].spells[spell.id].icon

                    text:font(self.layout.font.name)
                    text:color(self.layout.colors.text.r, self.layout.colors.text.g, self.layout.colors.text.b)
                    text:alpha(self.layout.colors.text.alpha)
                    text:size(self.layout.font.size)
                    text:pad(self.layout.padding)
                    text:bg_color(self.layout.colors.bg.r, self.layout.colors.bg.g, self.layout.colors.bg.b)
                    text:bg_alpha(self.layout.colors.bg.alpha)
                    text:stroke_width(self.layout.stroke_width)
                    text:stroke_color(self.layout.colors.stroke.r, self.layout.colors.stroke.g, self.layout.colors.stroke.b)
                    text:stroke_alpha(self.layout.colors.stroke.alpha)
                    text:update()

                    icon:path(string.format("%sbp/resources/icons/buffs/%s.png", windower.addon_path, conversion[spell.id]))
                    icon:transparency(0)
                    icon:update()

                end

            elseif private.buffs[exists] and not private.buffs[exists].spells[spell.id] and bp.helpers['target'].castable(target, spell) then
                private.buffs[exists].spells[spell.id] = {last=0, delay=delay, icon=images.new({color={alpha = 255}, texture={fit=false}, draggable=false})}

                do -- ADJUST TEXT AND IMAGE SETTINGS.
                    local text = private.buffs[exists].text
                    local time = private.buffs[exists].spells[spell.id].time
                    local icon = private.buffs[exists].spells[spell.id].icon

                    text:font(self.layout.font.name)
                    text:color(self.layout.colors.text.r, self.layout.colors.text.g, self.layout.colors.text.b)
                    text:alpha(self.layout.colors.text.alpha)
                    text:size(self.layout.font.size)
                    text:pad(self.layout.padding)
                    text:bg_color(self.layout.colors.bg.r, self.layout.colors.bg.g, self.layout.colors.bg.b)
                    text:bg_alpha(self.layout.colors.bg.alpha)
                    text:stroke_width(self.layout.stroke_width)
                    text:stroke_color(self.layout.colors.stroke.r, self.layout.colors.stroke.g, self.layout.colors.stroke.b)
                    text:stroke_alpha(self.layout.colors.stroke.alpha)
                    text:update()

                    icon:path(string.format("%sbp/resources/icons/buffs/%s.png", windower.addon_path, conversion[spell.id]))
                    icon:transparency(0)
                    icon:update()

                end

            end
            private.update()

        end

    end

    private.remove = function(target, spell)
        local spell = private.getSpell(spell)

        if bp and spell and target then
            local exists = private.exists(target.id)
            
            if exists and spell and spell.id and private.buffs[exists] and private.buffs[exists].spells[spell.id] then
                private.buffs[exists].spells[spell.id].text:destroy()
                private.buffs[exists].spells[spell.id].icon:destroy()
                private.buffs[exists].spells[spell.id] = nil

            end
            private.update()

        end

    end

    private.clear = function()

        for _,data in ipairs(private.buffs) do

            if data.spells then
                
                for _,spell in pairs(data.spells) do
                    spell.icon:destroy()
                end

            end
            data.text:destroy()

        end

    end

    private.reset = function(target, spell)

        if bp and spell and target then
            local exists = private.exists(target.id)
            
            if exists and spell and spell.id and private.buffs[exists] and private.buffs[exists].spells[spell.id] then
                private.buffs[exists].spells[spell.id].last = os.time()
            end

        end

    end

    private.update = function()
            
        if bp and #private.buffs > 0 then

            for index, data in ipairs(private.buffs) do
                local player = windower.ffxi.get_mob_by_id(data.player.id) or false

                if player and bp.helpers['target'].distance(bp.me, player) < 30 and (bp.helpers['target'].distance(bp.me, player) ~= 0 or bp.player.id == player.id) then
                    local spells = data.spells
                    local text = data.text

                    do -- CALCULATE ALL THE TEXT & IMAGES FOR THE PLAYER.
                        local adjusted  = (15 - (#player.name:sub(1, #player.name)))
                        local length    = #player.name <= 15 and 15 or #player.name
                        local x         = index == 1 and self.layout.pos.x or 0
                        local y         = index == 1 and self.layout.pos.y or 0

                        text:text(('%s%s►'):format(player.name:sub(1, length), (''):rpad('-', adjusted)))
                        if index == 1 then
                            text:pos(x, y)

                        else
                            local offset_x, offset_y = private.buffs[index-1].text:extents()

                            do -- CALCULATE POSITION.
                                text:pos(text:pos(private.buffs[index-1].text:pos_x(), private.buffs[index-1].text:pos_y() + (offset_y + 1)))
                            end

                        end
                        text:update()

                        if not text:visible() then
                            text:show()
                        end

                        coroutine.schedule(function()
                            local track = false

                            for id, spell in pairs(data.spells) do
                                local xx, yy = text:extents()

                                if not track then
                                    spell.icon:pos((text:pos_x() + xx) + 2, text:pos_y())
                                    spell.icon:size(yy, yy)
                                    spell.icon:update()

                                    if not spell.icon:visible() then
                                        spell.icon:show()
                                    end

                                else
                                    spell.icon:pos((data.spells[track].icon:pos_x() + yy) + 1, text:pos_y())
                                    spell.icon:size(yy, yy)
                                    spell.icon:update()

                                    if not spell.icon:visible() then
                                        spell.icon:show()
                                    end

                                end
                                track = id

                            end

                        end, 0.1)

                    end                        

                else
                    local spells = data.spells
                    local text = data.text

                    for _,spell in pairs(data.spells) do
                        spell.icon:hide()
                        text:hide()

                    end

                end

            end

        end

    end

    private.exists = function(id)

        if id then

            for index, data in ipairs(private.buffs) do

                if data.player.id == id then
                    return index
                end

            end

        end
        return false

    end

    private.getSpell = function(name)
        local name = windower.convert_auto_trans(name)
        local orders = {

            ['Protect']         = {47,46,45,44,43},
            ['Shell']           = {52,51,50,49,48},
            ['Haste']           = {511,57},
            ['Flurry']          = {846,845},
            ['Phalanx']         = {107},
            ['Regen']           = {504,477,111,110,108},
            ['Refresh']         = {894,473,109},
            ['Adloquium']       = {495},
            ['Animus Augeo']    = {308},
            ['Animus Minuo']    = {309},

        }

        if bp and name and tostring(name) ~= nil then

            for spell, spells in pairs(orders) do

                if spell:lower() == name:lower() then
                    
                    for _,id in ipairs(spells) do

                        if allowed[id] and bp.helpers['actions'].isReady('MA', allowed[id].en) then
                            return allowed[id]
                        end

                    end

                end

            end

        end
        return false

    end

    -- Public Functions.
    self.setSystem = function(buddypal)
        if buddypal then
            bp = buddypal
        end

    end

    self.cast = function()
        
        for _,data in ipairs(private.buffs) do
            local target = data.player

            for id, spell in pairs(data.spells) do
                
                if spell.delay and (spell.delay - (os.time() - spell.last)) > 0 then
                    spell.icon:color(75,75,75)
                    spell.icon:transparency(100)

                else
                    spell.icon:color(255,255,255)
                    spell.icon:transparency(255)
                    
                    if bp.res.spells[id] and not bp.helpers['queue'].inQueue(bp.res.spells[id], target) then
                        bp.helpers['queue'].hardAdd(bp.res.spells[id], target)
                    end

                end

            end

        end

    end

    self.pos = function(x, y)
        local x = tonumber(x) or self.layout.pos.x
        local y = tonumber(y) or self.layout.pos.y

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

    -- Private Events.
    private.events.commands = windower.register_event('addon command', function(...)
        local a = T{...}
        local c = a[1] or false

        if c == 'buff' and a[2] then
            local command = a[2]:lower()
            local target = windower.ffxi.get_mob_by_target('t') or false

            if (command == '+' or command == 'a') and target and a[3] then
                private.add(target, a[3], a[4] or false)

            elseif (command == '-' or command == 'r') and target and a[3] then
                private.remove(target, a[3])

            elseif (command == 'clear' or command == 'c') then
                private.reset()

            end

        end

    end)

    private.events.actions = windower.register_event('incoming chunk', function(id, original, modified, injected, blocked)
        
        if id == 0x028 and bp then
            local parsed    = bp.packets.parse('incoming', original)
            local actor     = windower.ffxi.get_mob_by_id(parsed['Actor'])
            local target    = windower.ffxi.get_mob_by_id(parsed['Target 1 ID'])
            local category  = parsed['Category']
            local param     = parsed['Param']

            if bp and parsed['Category'] == 4 then
        
                if actor and bp.player and actor.id == bp.player.id then
                    local spell = bp.res.spells[param] or false

                    if spell and type(spell) == 'table' and spell.type then
                        private.reset(target, spell)
                    end

                end

            end

        end

    end)

    return self

end
return buffer.new()
