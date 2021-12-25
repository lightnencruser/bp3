local status    = {}
local player    = windower.ffxi.get_player()
local files     = require('files')
local texts     = require('texts')
local f = files.new(string.format('bp/helpers/settings/status/%s_settings.lua', player.name))
require('tables')

if not f:exists() then
  f:write(string.format('return %s', T({}):tovstring()))
end

function status.new()
    local self = {}

    -- Static Variables.
    self.settings   = dofile(string.format('%sbp/helpers/settings/status/%s_settings.lua', windower.addon_path, player.name))
    self.layout     = self.settings.layout or {pos={x=300, y=400}, colors={text={alpha=255, r=100, g=215, b=0}, bg={alpha=0, r=0, g=0, b=0}, stroke={alpha=255, r=0, g=25, b=15}}, font={name='Lucida Console', size=8}, padding=2, stroke_width=2, draggable=false}
    self.update     = self.settings.update or {delay=2, last=0}
    self.display    = texts.new('', {flags={draggable=self.layout.draggable}})

    -- Private Variables.
    local bp        = false
    local private   = {events={}, statuses={}}
    local priority  = self.settings.priorities or {}
    local debug     = false
    local timer     = {last=0, delay=1}
    local bluemage  = T{144,145,134,135,186,13,21,146,147,148,149,167,174,175,194,217,223,404,557,558,559,560,561,562,563,564,11,12,128,129,130,131,132,133,136,137,138,139,140,141,142,567}
    local spells    = T{14,15,16,17,18,19,20,143}
    local allowed   = T{15,14,17,2,19,193,7,9,20,144,145,134,135,186,13,21,146,147,148,149,167,174,175,194,217,223,404,557,558,559,560,561,562,563,564,3,4,5,6,8,31,566,11,12,128,129,130,131,132,133,136,137,138,139,140,141,142,567}
    local map       = {

        -- Priority Status Removal map.
        {
            list={15}, 
            remove={[15]=20},
        },
        {
            list={14,17}, 
            remove={[14]=98,[17]=98},
        },
        {
            list={2,19,193}, 
            remove={[2]=1,[19]=1,[193]=1},
        },
        {
            list={7},
            remove={[7]=18},
        },
        {
            list={9,20,144,145}, 
            remove={[9]=20,[20]=20,[144]=143,[145]=143},
        },
        {
            list={134,135,186},
            remove={[134]=143,[135]=143,[186]=143},
        },
        {
            list={13,21,146,147,148,149,167,174,175,194,217,223,404,557,558,559,560,561,562,563,564},
            remove={[13]=143,[21]=143,[146]=143,[147]=143,[148]=143,[149]=143,[167]=143,[174]=143,[175]=143,[194]=143,[217]=143,[223]=143,[404]=143,[557]=143,[558]=143,[559]=143,[560]=143,[561]=143,[562]=143,[563]=143,[564]=143},
        },
        {
            list={3,4,5,6,8,31,566},
            remove={[3]=14,[4]=15,[5]=16,[6]=17,[8]=19,[31]=19,[566]=15},
        },
        {
            list={11,12,128,129,130,131,132,133,136,137,138,139,140,141,142,567},
            remove={[11]=143,[12]=143,[128]=143,[129]=143,[130]=143,[131]=143,[132]=143,[133]=143,[136]=143,[137]=143,[138]=143,[139]=143,[140]=143,[141]=143,[142]=143,[567]=143},
        },

    }

    -- Public Variables.
    self.enabled = self.settings.enabled or false

    -- Private Functions
    private.persist = function()
        local next = next

        if self.settings then
            self.settings.layout = self.layout
            self.settings.priorities = priority
            self.settings.enabled = self.enabled
        end

    end
    private.persist()

    private.resetDisplay = function()
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
    private.resetDisplay()

    self.writeSettings = function()
        private.persist()

        if f:exists() then
            f:write(string.format('return %s', T(self.settings):tovstring()))

        elseif not f:exists() then
            f:write(string.format('return %s', T({}):tovstring()))
        end

    end
    self.writeSettings()

    private.parseParty = function(data) -- Credit: Byrth.
        local parsed = bp.packets.parse('incoming', data)
        local buffs = {}

        for i=1,5 do
            table.insert(buffs, {id=parsed[string.format('ID %s', i)], priority=priority[parsed[string.format('ID %s', i)]] or 1, list={}})

            for ii=1,32 do
                local buff = data:byte((i-1)*48+5+16+ii-1) + 256 * (math.floor( data:byte((i-1)*48+5+8 + math.floor((ii-1)/4)) / 4^((ii-1)%4) )%4)

                if buff > 0 and buff ~= 255 and allowed:contains(buff) then
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
            table.insert(buffs, {id=bp.player.id, priority=priority[bp.player.id] or 1, list={}})

            for i=1, 32 do
                local buff = tonumber(parsed[string.format('Buffs %s', i)]) or 0
                
                if buff > 0 and buff ~= 255 and allowed:contains(buff) then
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
                        windower.send_ipc_message(string.format('%s+%s+%s+%s', 'STATUS', v.id, v.priority, table.concat(v.list, ':')))

                    else
                        windower.send_ipc_message(string.format('%s+%s+%s', 'STATUS', v.id, v.priority))

                    end

                end

            end

        end

    end

    private.receive = function(message)
        
        if message then
            local split = message:split('+')
            local buffs
            
            if split[1] and split[2] and split[3] and split[1] == 'STATUS' and tonumber(split[2]) > 0 and tonumber(split[3]) then
                local member = windower.ffxi.get_mob_by_id(tonumber(split[2])) or false

                if split[4] then
                    buffs = split[4]:split(':')

                else
                    buffs = false

                end
                
                if member and private.exists(member.id) then

                    for i,v in ipairs(private.statuses) do

                        if v.id == member.id then
                            private.statuses[i] = {id=member.id, priority=priority[member.id] or tonumber(split[3]), list={}}

                            if buffs and #buffs > 0 then

                                for _,vv in ipairs(buffs) do
                                    table.insert(private.statuses[i].list, tonumber(vv))
                                end
                            
                            end
                            break
                        
                        end

                    end

                elseif member and not private.exists(member.id) then
                    table.insert(private.statuses, {id=member.id, priority=priority[member.id] or tonumber(split[3]), list={}})

                    if buffs and #buffs > 0 then

                        for _,v in ipairs(buffs) do
                            table.insert(private.statuses[#private.statuses].list, tonumber(v))
                        end
                    
                    end

                end
                private.sort()

            end

        end

    end

    private.exists = function(id)

        for _,v in ipairs(private.statuses) do

            if v.id == id then
                return true
            end

        end
        return false

    end

    private.getPriority = function(id)

        for _,v in ipairs(private.statuses) do

            if v.id == id then
                return v.priority
            end

        end
        return 1

    end

    private.setPriority = function(value, target)

        if value and target and tonumber(value) ~= nil and target.id then
            priority[target.id] = tonumber(value)
            self.writeSettings()
            bp.helpers['popchat'].pop(string.format('%s priority now set to %s!', target.name, tonumber(value)))

        end

    end

    private.sort = function()
        table.sort(private.statuses, function(a, b)
            return a.priority > b.priority
        end)

    end

    private.pos = function(x, y)
        local x = tonumber(x) or self.layout.pos.x
        local y = tonumber(y) or self.layout.pos.y

        if bp and x and y then
            self.display:pos(x, y)
            self.layout.pos.x = x
            self.layout.pos.y = y
            self.writeSettings()
        
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

    self.windsRemoval = function()

        if bp and bp.player and private.statuses[bp.player.id] then

            if #private.statuses[bp.player.id].list > 0 then

                for _,remove in ipairs(private.statuses[bp.player.id].list) do

                    if windsRemoval:contains(remove) then
                        return true
                    end

                end

            end

        end
        return false

    end

    self.fixStatus = function()

        if #private.statuses > 0 and (bp.player.main_job == 'WHM' or bp.player.sub_job == 'WHM') then

            for i,m in ipairs(map) do
                local list = T(m.list)
                
                for _,v in ipairs(private.statuses) do

                    for _,buff in ipairs(v.list) do

                        if list:contains(buff) then
                            local target = windower.ffxi.get_mob_by_id(v.id) or false
                            local spell = m.remove[buff]

                            if spell and target and bp.res.spells[spell] then
                                local spell = bp.res.spells[spell]

                                if i == 1 then

                                    if bp.helpers['actions'].isReady('MA', spell.en) and not bp.helpers['queue'].inQueue(spell, target) then
                                        bp.helpers['queue'].addToFront(spell, target)
                                    end

                                elseif i == 2 then

                                    if bp.helpers['actions'].isReady('MA', spell.en) and not bp.helpers['queue'].inQueue(spell, target) then
                                        bp.helpers['queue'].add(spell, target)
                                    end

                                elseif i == 3 then

                                    if bp.helpers['party'].isInParty(target, false) then
                                        local spell = bp.MA['Curaga']

                                        if bp.helpers['actions'].isReady('MA', spell.en) and not bp.helpers['queue'].inQueue(spell) then
                                            bp.helpers['queue'].add(spell, target)
                                        end

                                    else

                                        if bp.helpers['actions'].isReady('MA', spell.en) and not bp.helpers['queue'].inQueue(spell, target) then
                                            bp.helpers['queue'].add(spell, target)
                                        end

                                    end

                                else
                                    
                                    if spell.en == 'erase' and bp.helpers['target'].isInParty(target, false) then

                                        if bp.helpers['actions'].isReady('MA', spell.en) and not bp.helpers['queue'].inQueue(spell, target) then
                                            bp.helpers['queue'].add(spell, target)
                                        end

                                    else

                                        if bp.helpers['actions'].isReady('MA', spell.en) and not bp.helpers['queue'].inQueue(spell, target) then
                                            bp.helpers['queue'].add(spell, target)
                                        end

                                    end

                                end

                            end

                        end

                    end

                end

            end            

        end

    end

    self.isSpellRemoval = function(id)
        return spells:contains(id)
    end

    self.checkStatus = function(target, spell)
        local target = bp.helpers['target'].getValidTarget(target)
        local removeable = {

            [014] = {3},
            [015] = {4,566},
            [016] = {5},
            [017] = {6},
            [018] = {7},
            [019] = {8,31},
            [020] = {9,15,20},
            [143] = {11,12,13,21,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,144,145,146,147,148,149,167,174,175,186,194,217,223,404,557,558,559,560,561,562,563,564,567},

        }
        
        if target and target.id and removeable[spell] and #private.statuses > 1 then
            
            for _,v in ipairs(private.statuses) do

                if v.id and v.id == target.id then

                    for _,status in ipairs(removeable[spell]) do

                        if T(v.list):contains(status) then
                            return true
                        end

                    end
                    return false

                end

            end

        end
        return false

    end

    -- Private Events.
    private.events.commands = windower.register_event('addon command', function(...)
        local commands = T{...}

        if commands[1] and commands[1]:lower() == 'status' then

            if commands[2] then
                local command = commands[2]:lower()

                if command == 'pos' and commands[3] then
                    private.pos(commands[3], commands[4] or false)

                elseif (command == 'priority' or command == 'p') and commands[3] and windower.ffxi.get_mob_by_target('t') then
                    private.setPriority(tonumber(commands[3]), windower.ffxi.get_mob_by_target('t'))

                end

            elseif not commands[2] then
                self.enabled = self.enabled ~= true and true or false
                bp.helpers['popchat'].pop(string.format('AUTO-STATUS REMOVAL SET TO: %s.', tostring(self.enabled)))

            end
            self.writeSettings()

        end

    end)

    private.events.incoming = windower.register_event('incoming chunk', function(id, original, modified, injected, blocked)

        if id == 0x076 then
            private.parseParty(original)

        elseif id == 0x063 then
            private.parsePlayer(original)

        elseif id == 0x028 then

        end

    end)

    private.events.ipc = windower.register_event('ipc message', function(message)
            
        if message and message:sub(1,6) == 'STATUS' then
            private.receive(message)
        end
    
    end)

    return self

end
return status.new()
