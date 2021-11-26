local buffs     = {}
local player    = windower.ffxi.get_player()
local files     = require('files')
local texts     = require('texts')
local images    = require('images')
local res       = require('resources').spells:skill(34)
local f = files.new(string.format('bp/helpers/settings/buffs/%s_settings.lua', player.name))

if not f:exists() then
  f:write(string.format('return %s', T({}):tovstring()))
end

function buffs.new()
    local self = {}

    -- Private Variables.
    local bp            = false
    local private       = {events={}, buffs={}, buffing=T{}, time={last=0, delay=1}}
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

    -- Static Variables.
    self.settings       = dofile(string.format('%sbp/helpers/settings/buffs/%s_settings.lua', windower.addon_path, player.name))
    self.layout         = self.settings.layout or {pos={x=100, y=100}, colors={text={alpha=255, r=100, g=215, b=0}, bg={alpha=0, r=0, g=0, b=0}, stroke={alpha=255, r=0, g=25, b=15}}, font={name='Lucida Console', size=10}, padding=5, stroke_width=2, draggable=false}
    self.display        = {}
    self.important      = string.format('%s,%s,%s', 25, 165, 200)

    -- Public Variables
    self.buffs      = {}
    self.alliance   = {}
    self.count      = 0
    self.enabled    = self.settings.enabled or false


    -- Build Allowed resources.
    for i,v in pairs(res) do
        local targets = T(v.targets)
        
        if (#targets == 1 and targets[1] ~= 'Self') or #targets > 1 then
            allowed[i] = v
        end        

    end

    -- Count buffs on start.
    local countBuffs = function()

        if bp and bp.player then
            local buffs = bp.player.buffs

            for i=1, 32 do
                    
                if buffs[i] ~= 255 then
                    self.count = (self.count + 1)
                end

            end

        end

    end
    countBuffs()

    -- Private Functions.
    private.persist = function()

        if self.settings then
            self.settings.layout    = self.layout
            self.settings.enabled   = self.enabled
        end

    end
    private.persist()

    private.writeSettings = function()
        private.persist()

        if f:exists() then
            f:write(string.format('return %s', T(self.settings):tovstring()))

        elseif not f:exists() then
            f:write(string.format('return %s', T({}):tovstring()))

        end

    end
    private.writeSettings()

    private.parseParty = function(data) -- Credit: Byrth.
        local parsed = bp.packets.parse('incoming', data)
        local buffs = {}

        for i=1,5 do
            table.insert(buffs, {id=parsed[string.format('ID %s', i)], list={}})

            for ii=1,32 do
                local buff = data:byte((i-1)*48+5+16+ii-1) + 256 * (math.floor( data:byte((i-1)*48+5+8 + math.floor((ii-1)/4)) / 4^((ii-1)%4) )%4)

                if buff > 0 and buff ~= 255 then
                    table.insert(buffs[i].list, buff)
                end

            end

        end
        private.send(buffs)
        
    end

    private.parsePlayer = function(data)
        local parsed = bp.packets.parse('incoming', data)
        local buffs = {}

        if bp and bp.player then
            table.insert(buffs, {id=bp.player.id, list={}})

            for i=1, 32 do
                local buff = tonumber(parsed[string.format('Buffs %s', i)]) or 0
                
                if buff > 0 and buff ~= 255 then
                    table.insert(buffs[1].list, buff)
                end

            end
            private.send(buffs)

        end

    end

    private.send = function(buffs)
        
        if bp and bp.player and buffs and type(buffs) == 'table' then
            
            if #buffs > 0 then
                
                for _,v in ipairs(buffs) do
                    
                    if #v.list > 0 then
                        windower.send_ipc_message(string.format('%s+%s+%s', 'BUFFS', v.id, table.concat(v.list, ':')))

                    else
                        windower.send_ipc_message(string.format('%s+%s', 'BUFFS', v.id))

                    end

                end

            end

        end

    end

    private.receive = function(message)

        if message then
            local split = message:split('+')
            local buffs
            
            if split[1] and split[2] and split[1] == 'BUFFS' and tonumber(split[2]) > 0 then
                local member = windower.ffxi.get_mob_by_id(tonumber(split[2])) or false

                if split[3] then
                    buffs = split[3]:split(':')

                else
                    buffs = false

                end
                
                if member and private.exists(member.id) then
                    
                    for i,v in ipairs(private.buffs) do

                        if v.id == member.id then
                            private.buffs[i] = {id=member.id, list={}}

                            if buffs and #buffs > 0 then

                                for _,vv in ipairs(buffs) do
                                    table.insert(private.buffs[i].list, tonumber(vv))
                                end
                            
                            end
                            break
                        
                        end

                    end

                elseif member and not private.exists(member.id) then
                    table.insert(private.buffs, {id=member.id, list={}})
                    
                    if buffs and #buffs > 0 then

                        for _,v in ipairs(buffs) do
                            table.insert(private.buffs[#private.buffs].list, tonumber(v))
                        end
                    
                    end

                end

            end

        end

    end

    private.update = function()
            
        if bp and #private.buffing > 0 then

            for index, data in ipairs(private.buffing) do
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
                            local offset_x, offset_y = private.buffing[index-1].text:extents()

                            do -- CALCULATE POSITION.
                                text:pos(text:pos(private.buffing[index-1].text:pos_x(), private.buffing[index-1].text:pos_y() + (offset_y + 1)))
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

    private.add = function(target, spell)
        local spell = private.getSpell(spell)

        if bp and spell and target then
            local index = private.getPlayerIndex(target.id)

            if not index and bp.helpers['target'].castable(target, spell) then
                table.insert(private.buffing, {

                    player  = target,
                    spells  = {[spell.id]={last=0, delay=3, icon=images.new({color={alpha = 255}, texture={fit=false}, draggable=false})}},
                    text    = texts.new('', {flags={draggable=false}}),

                })

                do -- ADJUST TEXT AND IMAGE SETTINGS.
                    local text = private.buffing[#private.buffing].text
                    local time = private.buffing[#private.buffing].spells[spell.id].time
                    local icon = private.buffing[#private.buffing].spells[spell.id].icon

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

            elseif private.buffing[index] and not private.buffing[index].spells[spell.id] and bp.helpers['target'].castable(target, spell) then
                private.buffing[index].spells[spell.id] = {icon=images.new({color={alpha = 255}, texture={fit=false}, draggable=false})}

                do -- ADJUST TEXT AND IMAGE SETTINGS.
                    local text = private.buffing[index].text
                    local time = private.buffing[index].spells[spell.id].time
                    local icon = private.buffing[index].spells[spell.id].icon

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
            local index = private.getPlayerIndex(target.id)
            
            if index and spell and spell.id and private.buffing[index] and private.buffing[index].spells[spell.id] then
                private.buffing[index].spells[spell.id].text:destroy()
                private.buffing[index].spells[spell.id].icon:destroy()
                private.buffing[index].spells[spell.id] = nil

            end
            private.update()

        end

    end

    private.clear = function()

        for _,data in ipairs(private.buffing) do

            if data.spells then
                
                for _,spell in pairs(data.spells) do
                    spell.icon:destroy()
                end

            end
            data.text:destroy()

        end

    end

    private.getPlayerIndex = function(id)

        if id then

            for index, data in ipairs(private.buffing) do

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

    private.exists = function(id)

        for _,v in ipairs(private.buffs) do

            if v.id == id then
                return true
            end

        end
        return false

    end

    private.pos = function(x, y)
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

    -- Public Functions.
    self.setSystem = function(buddypal)
        if buddypal then
            bp = buddypal
        end

    end

    self.cast = function()

        if bp then
        
            for _,data in ipairs(private.buffing) do
                local target = data.player

                for id, spell in pairs(data.spells) do
                    
                    if spell.last and conversion[id] and not self.hasBuff(target.id, conversion[id]) and (os.clock()-spell.last) > spell.delay then
                        spell.icon:color(255,255,255)
                        spell.icon:transparency(255)

                        if bp.res.spells[id] and not bp.helpers['queue'].inQueue(bp.res.spells[id], target) then
                            bp.helpers['queue'].hardAdd(bp.res.spells[id], target)
                            spell.last = os.clock()

                        end

                    end

                end

            end

        end

    end
    
    self.buffActive = function(id)

        if bp and bp.player then

            for _,v in ipairs(bp.player.buffs) do

                if v == id then
                    return true
                end

            end

        end
        return false

    end

    self.hasBuff = function(player, id)

        if bp and player and id then

            for _,v in ipairs(private.buffs) do

                if v.id == player then

                    if v.list and #v.list > 0 then

                        for _,vv in ipairs(v.list) do
                            
                            if vv == id then
                                return true
                            end

                        end
                    
                    end
                
                end

            end

        end
        return false

    end

    self.getFinishingMoves = function()

        if bp and bp.player then

            for _,v in ipairs(bp.player.buffs) do

                if v == 381 then
                    return 1
                elseif v == 382 then
                    return 2
                elseif v == 382 then
                    return 3
                elseif v == 382 then
                    return 4
                elseif v == 382 then
                    return 5
                elseif v == 588 then
                    return 6
                end

            end

        end
        return 0

    end

    -- Private Events.
    private.events.commands = windower.register_event('addon command', function(...)
        local commands = T{...}
        
        if commands[1] and commands[1]:lower() == 'buffs' then
            
            if commands[2] then
                local command = commands[2]:lower()
                local target = windower.ffxi.get_mob_by_target('t') or false

                if (command == '+' or command == 'a') and target and commands[3] then
                    private.add(target, commands[3])

                elseif (command == '-' or command == 'r') and target and commands[3] then
                    private.remove(target, commands[3])

                elseif (command == 'clear' or command == 'c') then
                    private.reset()

                elseif command == 'pos' and commands[3] then
                    private.pos(commands[3], commands[4] or false)

                end

            elseif not commands[2] then
                self.enabled = self.enabled ~= true and true or false
                bp.helpers['popchat'].pop(string.format('AUTU-BUFFING SET TO: %s.', tostring(self.enabled)))

            end
            private.writeSettings()

        end
        

    end)

    private.events.actions = windower.register_event('incoming chunk', function(id, original, modified, injected, blocked)
        
        if id == 0x028 and bp then
            local parsed    = bp.packets.parse('incoming', original)
            local actor     = windower.ffxi.get_mob_by_id(parsed['Actor'])
            local target    = windower.ffxi.get_mob_by_id(parsed['Target 1 ID'])
            local category  = parsed['Category']
            local param     = parsed['Param']

            if bp and parsed['Category'] == 4 and target then
        
                if actor and bp.player and actor.id == bp.player.id then
                    local spell = bp.res.spells[param] or false

                    if spell and type(spell) == 'table' and spell.type then
                        local index = private.getPlayerIndex(target.id)
                        
                        if index and spell and spell.id and private.buffing[index] and private.buffing[index].spells[spell.id] then
                            private.buffing[index].spells[spell.id].icon:color(75,75,75)
                            private.buffing[index].spells[spell.id].icon:transparency(100)

                        end

                    end

                end

            end

        end

    end)

    private.events.incoming = windower.register_event('incoming chunk', function(id, original, modified, injected, blocked)

        if id == 0x076 then
            private.parseParty(original)

        elseif id == 0x063 then
            private.parsePlayer(original)

        end

    end)

    private.events.ipc = windower.register_event('ipc message', function(message)
        
        if message and message:sub(1,5) == 'BUFFS' then
            private.receive(message)
        end
    
    end)

    private.events.commands = windower.register_event('time change', function(new, old)

        if self.enabled then
            self.cast()
        end

    end)

    return self

end
return buffs.new()
