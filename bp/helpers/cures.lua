local cures     = {}
local player    = windower.ffxi.get_player()
local files     = require('files')
local res       = require('resources')
local f = files.new(string.format('bp/helpers/settings/cures/%s_settings.lua', player.name))

if not f:exists() then
    f:write(string.format('return %s', T({}):tovstring()))
end

function cures.new()
    local self = {}

    -- Static Variables.
    self.settings       = dofile(string.format('%sbp/helpers/settings/cures/%s_settings.lua', windower.addon_path, player.name))

    -- Private Variables.
    local bp            = false
    local private       = {events={}}
    local spells        = {1,2,3,4,5,6,7,8,9,10,11}
    local abilities     = {190,191,192,193,311,195,262}
    local jobs          = {3,4,5,7,10,15,19,20,21}
    local modes         = {'OFF','PARTY','ALLIANCE'}
    local priorities    = {}
    local allowed       = {
        
        ['Cure'] = {

            {id=1,      priority=false, min=50},
            {id=2,      priority=false, min=150},
            {id=3,      priority=false, min=475},
            {id=4,      priority=true,  min=775},
            {id=5,      priority=true,  min=975},
            {id=6,      priority=true,  min=1375}

        },
        
        ['Curaga'] = {
            
            {id=7,      priority=false, min=90},
            {id=8,      priority=false, min=200},
            {id=9,      priority=true,  min=475},
            {id=10,     priority=true,  min=775},
            {id=11,     priority=true,  min=975}

        },
        
        ['Waltz'] = {

            {id=190,    priority=false, min=200},
            {id=191,    priority=false, min=400},
            {id=192,    priority=false, min=700},
            {id=193,    priority=true,  min=900},
            {id=311,    priority=true,  min=1200},

        },
        
        ['Waltzga'] = {

            {id=195,    priority=false, min=100},
            {id=262,    priority=true,  min=400},

        },
        
    }

    -- Public Variables.
    self.mode       = self.settings.mode or 1
    self.power      = self.settings.power or 15
    self.party      = {}
    self.alliance   = {}

    -- Private Functions.
    private.persist = function()
        local next = next

        if self.settings then
            self.settings.mode      = self.mode
            self.settings.power     = self.power

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

    private.buildParty = function()
        self.party      = {}
        self.alliance   = {}

        if bp and bp.party then
            
            for i,v in pairs(bp.party) do
                
                if i:sub(1,1) == 'p' and tonumber(i:sub(2)) ~= nil and type(v) == 'table' and v.mob then
                    table.insert(self.party, {id=v.mob.id, name=v.mob.name, distance=v.mob.distance, priority=1, hp=v.hp, hpp=v.hpp, missing=math.floor(v.hp/(v.hpp / 100)-v.hp)})
                
                elseif i:sub(1,1) == 'a' and tonumber(i:sub(2)) ~= nil and type(v) == 'table' and v.mob then
                    table.insert(self.alliance, {id=v.mob.id, name=v.mob.name, distance=v.mob.distance, priority=1, hp=v.hp, hpp=v.hpp, missing=math.floor(v.hp/(v.hpp / 100)-v.hp)})                        
                
                end
                
            end

        end
        
    end

    private.getCuragaWeight = function()
        local selected = {target=false, weight=0, missing=0, count=0}
        local r = 10
                
        private.sort(self.party)
        for _,t in ipairs(self.party) do
            local target = windower.ffxi.get_mob_by_id(t.id) or false

            if target and (target.distance):sqrt() <= 21 then
                local temp = 0
                local n = 0

                for _,m in ipairs(self.party) do
                    local member = windower.ffxi.get_mob_by_id(m.id) or false
                    
                    if member and (((target.x-member.x)^2 + (target.y-member.y)^2) <= r^2) and member.hpp < 90 then
                        temp = (temp + m.missing)
                        n = (n + 1)

                        if selected.missing < m.missing then
                            selected.missing = m.missing
                        end


                    end

                end

                if temp > selected.weight then
                    selected = {target=target, weight=temp, missing=selected.missing, count=n}
                end
                
            end

        end
        return selected

    end

    private.estimateCure = function(missing)
        local estimate = false
        
        if bp and bp.player and missing then
            local player = bp.player
            
            if bp.player.main_job_level == 99 then
            
                for _,cure in ipairs(allowed['Cure']) do
                    local spell = bp.res.spells[cure.id]
                                
                    if spell and bp.helpers['actions'].isReady('MA', spell.en) and cure.id and cure.min and not T{1,2}:contains(cure.id) and player['vitals'].mp >= spell.mp_cost and (cure.min + (cure.min * (self.power / 100))) <= missing then
                        estimate = spell
                    end

                end

            elseif bp.player.main_job_level < 99 and bp.player.main_job_level > 50 then

                for _,cure in ipairs(allowed['Cure']) do
                    local spell = bp.res.spells[cure.id]

                    if spell and bp.helpers['actions'].isReady('MA', spell.en) and cure.id and cure.min and not T{1}:contains(cure.id) and player['vitals'].mp >= spell.mp_cost and (cure.min + (cure.min * (self.power / 100))) <= missing then
                        estimate = spell
                    end

                end

            elseif bp.player.main_job_level < 50 then

                for _,cure in ipairs(allowed['Cure']) do
                    local spell = bp.res.spells[cure.id]

                    if spell and bp.helpers['actions'].isReady('MA', spell.en) and cure.id and cure.min and player['vitals'].mp >= spell.mp_cost and (cure.min + (cure.min * (self.power / 100))) <= missing then
                        estimate = spell
                    end

                end

            end
            
        end
        return estimate
        
    end

    private.estimateCuraga = function(missing)
        local estimate = false
        
        if bp and bp.player and missing then
            local player = bp.player

            if bp.player.main_job_level == 99 then
            
                for _,cure in ipairs(allowed['Curaga']) do
                    local spell = bp.res.spells[cure.id]

                    if spell and bp.helpers['actions'].isReady('MA', spell.en) and cure.min and not T{11}:contains(cure.id) and player['vitals'].mp >= spell.mp_cost and (cure.min + (cure.min * (self.power / 100))) <= missing then
                        estimate = bp.res.spells[cure.id]
                    end

                end

            elseif bp.player.main_job_level < 50 then

                for _,cure in ipairs(allowed['Curaga']) do
                    local spell = bp.res.spells[cure.id]

                    if spell and bp.helpers['actions'].isReady('MA', spell.en) and cure.min and player['vitals'].mp >= spell.mp_cost and (cure.min + (cure.min * (self.power / 100))) <= missing then
                        estimate = bp.res.spells[cure.id]
                    end

                end

            end
            
        end
        return estimate
        
    end

    private.updateCure = function(action, target, priority)
        local action_type   = bp.helpers['queue'].getType(action) or false
        local data          = bp.helpers['queue'].queue.data
        local priority      = T{'Cure IV','Cure V','Cure VI','Curaga III','Curaga IV','Curaga V','Curing Waltz IV','Curing Waltz V','Divine Waltz II'}
            
        if action and action_type and target and data then
            local update = false

            for i,v in ipairs(data) do
                    
                if type(v) == 'table' and type(action) == 'table' and type(target) == 'table' and v.action and v.target and (v.action.type == 'WhiteMagic' or v.action.type == 'Waltz') then
                    
                    if v.target.id == target.id and v.action.en ~= action.en and ((v.action.en):match('Cure') or (v.action.en):match('Cura')) and not bp.helpers['queue'].inQueue(bp.MA[action.en], target) then
                        
                        if i > 2 and priority:contains(action.en) then
                            bp.helpers['queue'].addToFront(bp.MA[action.en], target)
                            bp.helpers['queue'].queue:remove(i)
                            update = true

                        else
                            bp.helpers['queue'].queue.data[i].action = bp.MA[action.en]
                            update = true

                        end

                    elseif v.target.id == target.id and v.action.en ~= action.en and (v.action.en):match('Waltz') and not bp.helpers['queue'].inQueue(bp.JA[action.en], target) then

                        if i > 2 and priority:contains(action.en) then
                            bp.helpers['queue'].addToFront(bp.JA[action.en], target)
                            bp.helpers['queue'].queue:remove(i)
                            update = true

                        else
                            bp.helpers['queue'].queue.data[i].action = bp.JA[action.en]
                            update = true

                        end

                    end

                end

            end

            if not update and priority:contains(action.en) then
                bp.helpers['queue'].addToFront(action, target)

            elseif not update then
                bp.helpers['queue'].add(action, target)

            end

        end

    end

    private.validSpell = function(id)
        local id = id or false

        if bp and id then

            for _,v in ipairs(spells) do

                if v == id then
                    return true
                end

            end

        end

    end

    private.validAbility = function(id)
        local id = id or false

        if bp and id then

            for _,v in ipairs(abilities) do

                if v == id then
                    return true
                end

            end

        end

    end

    private.sort = function(t)
        table.sort(t, function(a, b)
            return a.missing > b.missing
        end)
    end
    
    -- Public Functions.
    self.setSystem = function(buddypal)
        if buddypal then
            bp = buddypal
        end

    end

    self.handleCuring = function()

        if bp and self.party and self.alliance and self.mode ~= 1 and bp.helpers['queue'].checkReady() and not bp.helpers['actions'].moving then
            local player = bp.player
            local selected = private.getCuragaWeight()
            local cure_only = S{'RDM','SCH','PLD'}:contains(player.main_job) or S{'RDM','SCH','PLD'}:contains(player.sub_job) and true or false
            local is_whm = (player.main_job == 'WHM' or player.sub_job) and true or false
            local is_dancer = player.main_job == 'DNC' and true or false
            
            if (is_whm or cure_only) and not is_dancer then
                
                for _,v in ipairs(self.party) do
                    local cure = private.estimateCure(v.missing) or false
                    local target = windower.ffxi.get_mob_by_id(v.id) or false
                    local dead = T{2,3}

                    if cure and target and not bp.helpers['queue'].inQueue(bp.MA[cure.en], target) then

                        if (target.distance):sqrt() <= 20 and not dead:contains(target.status) then
                            private.updateCure(cure, target)
                        end
                    
                    end

                end

            end

            if selected.count > 2 and is_whm and not is_dancer then

                if selected and selected.target and selected.count and selected.missing and selected.count > 2 then
                    local cure = private.estimateCuraga(selected.missing)
                    
                    if cure and not bp.helpers['queue'].inQueue(bp.MA[cure.en]) then
                        private.updateCure(cure, selected.target)         
                    end
                    
                end

            end

            if self.mode == 3 and (is_whm or cure_only) and not is_dancer then
                private.sort(self.alliance)

                for _,v in ipairs(self.alliance) do
                    local cure = private.estimateCure(v.missing) or false
                    local target = windower.ffxi.get_mob_by_id(v.id) or false
                    local dead = T{2,3}
                    
                    if cure and target and not bp.helpers['queue'].inQueue(bp.MA[cure.en], target) then

                        if (target.distance):sqrt() <= 20 and not dead:contains(target.status) then
                            private.updateCure(cure, target)
                        end
                    
                    end

                end

            end

        end

    end

    self.setPriority = function(target, urgency)

        if bp then

            if target and target.id then
                            
                if urgency ~= nil and urgency >= 0 and urgency <= 100 then
                    priorities[target.id] = urgency
                    bp.helpers['popchat'].pop(string.format('PRIORITY FOR %s SET TO: %03d.', target.name or 'TARGET', urgency))

                else
                    bp.helpers['popchat'].pop('PLEASE ENTER A VALID NUMBER BETWEEN 1 & 100!')

                end

            else
                bp.helpers['popchat'].pop('INVALID TARGET SELECTED!')

            end

        end

        if target and urgency then

            if tonumber(urgency) ~= nil and tonumber(urgency) >= 0 and tonumber(urgency) <= 100 then
                priorities[target.id] = tonumber(urgency)
            end

        end

    end

    self.getPriority = function(target)

        if target then

            if type(target) == 'table' and target.id then
                return priorities[target.id] or 0

            elseif type(target) == 'number' or tonumber(target) ~= nil then
                return priorities[tonumber(target)] or 0

            elseif type(target) == 'string' and tonumber(target) == nil then
                return priorities[windower.ffxi.get_mob_by_name(target).id] or 0

            end

        end
        return 0

    end

    -- Private Events.
    private.events.commands = windower.register_event('addon command', function(...)
        local commands = T{...}
        local helper = commands[1] or false

        if helper and helper == 'cures' then
            table.remove(commands, 1)
            
            if commands[1] then
                local command = commands[1]:lower()

                if T{'p','!','priority'}:contains(command) and commands[2] then
                    local target = windower.ffxi.get_mob_by_target('t') or false
                    local value = tonumber(commands[2])

                    if target then
                        
                        if value ~= nil then
                            self.setPriority(windower.ffxi.get_mob_by_target('t'), value)

                        else
                            bp.helpers['popchat'].pop('PLEASE ENTER A VALID NUMBER VALUE FOR TARGETS PRIORITY!')

                        end

                    else
                        bp.helpers['popchat'].pop('INVALID TARGET SELECTED!')

                    end

                elseif command == 'power' and commands[2] and tonumber(commands[2]) ~= nil then
                    local power = tonumber(commands[2])

                    if power >= 1 and power <= 100 then
                        self.power = power
                        bp.helpers['popchat'].pop(string.format('CURE POWER MULTIPLIER NOW SET TO: %d%%', self.power))

                    else
                        bp.helpers['popchat'].pop('PLEASE ENTER A NUMBER BETWEEN 1 & 100!')

                    end

                end
    
            else
                self.mode = self.mode < #modes and (self.mode + 1) or 1
                bp.helpers['popchat'].pop(string.format('CURE MODE: %s', modes[self.mode]))
    
            end
            private.writeSettings()

        end

    end)

    private.events.prerender = windower.register_event('prerender', function()
        private.buildParty()
    
    end)

    private.events.zonechange = windower.register_event('zone change', function(new, old)
        private.writeSettings()
    end)
    
    return self

end
return cures.new()