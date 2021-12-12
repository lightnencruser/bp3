local target = {}
local files = require('files')
local texts = require('texts')
local res   = require('resources')
local f     = files.new('bp/helpers/settings/target_settings.lua')

if not f:exists() then
    f:write(string.format('return %s', T({}):tovstring()))
end

function target.new()
    local self = {}

    -- Static Variables.
    self.settings   = dofile(string.format('%sbp/helpers/settings/target_settings.lua', windower.addon_path))
    self.layout     = self.settings.layout or {pos={x=495, y=865}, colors={text={alpha=255, r=245, g=200, b=20}, bg={alpha=200, r=0, g=0, b=0}, stroke={alpha=255, r=0, g=0, b=0}}, font={name='Lucida Console', size=9}, padding=4, stroke_width=1, draggable=false}
    self.display    = texts.new('', {flags={draggable=self.layout.draggable}})
    self.important  = string.format('%s,%s,%s', 25, 165, 200)

    -- Private Variables.
    local bp        = false
    local private   = {events={}}
    local debug     = false
    local reset     = {last=0, delay=0.5}
    local modes     = {'PLAYER TARGETING','PARTY TARGETING'}

    -- Public Variables.
    self.targets    = {player=false, party=false, luopan=false, entrust=false}
    self.mode       = self.settings.mode or 1

    -- Private Functions.
    private.persist = function()
        local next = next

        if self.settings then
            self.settings.mode      = self.mode
            self.settings.layout    = self.layout
            self.settings.important = self.important

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
        self.display:update()

    end
    private.resetDisplay()

    private.render = function()
        local player = bp.player
        local update = {[1]='',[2]=''}

        if bp.hideUI then
            
            if self.display:visible() then
                self.display:hide()
            end
            return

        end

        -- Handle Player Target.
        if self.targets.player then
            update[1] = string.format('Player:  \\cs(%s)[ %s ]\\cr ', self.important, self.targets.player.name)

        elseif not self.targets.player then
            update[1] = ''

        end

        -- Handle Party Target.
        if self.targets.party then
            update[2] = string.format(' +  Party:  \\cs(%s)[ %s ]\\cr ', self.important, self.targets.party.name)

        elseif not self.targets.party then
            update[2] = ''

        end

        if (update[1] ~= '' or update[2] ~= '') then
            self.display:text(table.concat(update, ''))
            self.display:update()

            if not self.display:visible() then
                self.display:show()
            end
        
        else
            update[1] = string.format(' Targets:  \\cs(%s)[ %s ]\\cr ', self.important, ' None ')
            self.display:text(table.concat(update, ''))
            self.display:update()
            
            if not self.display:visible() then
                self.display:show()
            end

        end

    end

    private.updateTargets = function()
        
        if bp and bp.player and bp.player.status == 1 and not self.getTarget() and windower.ffxi.get_mob_by_target('t') then
            self.setTarget(windower.ffxi.get_mob_by_target('t'))

        elseif bp and bp.player and bp.player.status == 1 and self.getTarget() and windower.ffxi.get_mob_by_target('t') and self.getTarget().id ~= windower.ffxi.get_mob_by_target('t').id then
            self.setTarget(windower.ffxi.get_mob_by_target('t'))

        end

        if self.targets.player and (not self.allowed(self.targets.player) or (self.targets.player.distance):sqrt() > 35) then
            self.targets.player = false
        end

        if self.targets.party and (not self.allowed(self.targets.party) or (self.targets.party.distance):sqrt() > 35) then
            self.targets.party = false
        end

        if self.targets.entrust and (not self.allowed(self.targets.entrust) or (self.targets.entrust.distance):sqrt() > 35) then
            self.targets.entrust = false
        end

        if self.targets.luopan and (not self.allowed(self.targets.luopan) or (self.targets.luopan.distance):sqrt() > 35) then
            self.targets.luopan = false
        end

    end

    private.clear = function()
        self.targets.player     = false
        self.targets.party      = false
        self.targets.luopan     = false

    end

    -- Static Functions.
    self.writeSettings = function()
        private.persist()

        if f:exists() then
            f:write(string.format('return %s', T(self.settings):tovstring()))

        elseif not f:exists() then
            f:write(string.format('return %s', T({}):tovstring()))

        end

    end
    self.writeSettings()

    self.getTarget = function()

        if self.targets.player and type(self.targets.player) == 'table' and windower.ffxi.get_mob_by_id(self.targets.player.id) then
            return windower.ffxi.get_mob_by_id(self.targets.player.id)

        elseif self.targets.party and type(self.targets.party) == 'table' and windower.ffxi.get_mob_by_id(self.targets.party.id) then
            return windower.ffxi.get_mob_by_id(self.targets.party.id)

        end
        return false


    end

    self.resetTargets = function()

        if (os.clock()-reset.last) < reset.delay then
            self.targets.player     = false
            self.targets.party      = false
            self.targets.entrust    = false
            self.targets.luopan     = false
        end
        reset.last = os.clock()

    end

    self.clear = function()
        private.clear()

    end

    -- Public Functions.
    self.setSystem = function(buddypal)
        if buddypal then
            bp = buddypal
        end

    end
    
    self.setTarget = function(target)
        local target = target or false

        if bp and target then
            local helpers = bp.helpers

            if type(target) == 'table' and target.id and windower.ffxi.get_mob_by_id(target.id) then
                target = windower.ffxi.get_mob_by_id(target.id)

            elseif (type(target) == 'number' or type(target) == 'string') and tonumber(target) ~= nil and windower.ffxi.get_mob_by_id(target) then
                target = windower.ffxi.get_mob_by_id(target)

            elseif type(target) == 'string' and tonumber(target) == nil and windower.ffxi.get_mob_by_name(target) then
                target = windower.ffxi.get_mob_by_name(target)

            elseif windower.ffxi.get_mob_by_target('t') then
                target = windower.ffxi.get_mob_by_target('t')

            else
                target = false

            end

            if target then

                if not self.targets.player and windower.ffxi.get_mob_by_target('t') and self.allowed(windower.ffxi.get_mob_by_target('t')) and self.canEngage(windower.ffxi.get_mob_by_target('t')) then
                    self.targets.player = windower.ffxi.get_mob_by_target('t')
                end              

                if self.mode == 1 and self.allowed(target) and self.canEngage(target) and not self.targets.player then
                    self.targets.player = target
                    helpers['popchat'].pop(string.format('SETTING CURRENT PLAYER TARGET TO: %s.', target.name))

                elseif self.mode == 2 and self.allowed(target) and self.canEngage(target) and not self.targets.party then
                    self.targets.party = target
                    windower.send_command(string.format('ord r* bp target share %s', target.id))
                    helpers['popchat'].pop(string.format('SETTING CURRENT PARTY TARGET TO: %s.', target.name))

                end

            end

        end

    end

    self.setLuopan = function(target)
        local target = target or false

        if target then

            if type(target) == 'number' then
                local t = windower.ffxi.get_mob_by_id(target) or false

                if self.allowed(t) and self.canEngage(t) then
                    target = t
                end

            elseif type(target) == 'table' then
                local t = windower.ffxi.get_mob_by_id(target.id) or false

                if self.allowed(t) and self.canEngage(t) then
                    target = t
                end

            elseif type(target) == 'string' and windower.ffxi.get_mob_by_name(target) then
                local t = windower.ffxi.get_mob_by_name(target) or false

                if self.allowed(t) and self.canEngage(t) then
                    target = t
                end

            elseif windower.ffxi.get_mob_by_target('t') then
                local t = windower.ffxi.get_mob_by_target('t')

                if self.allowed(t) and self.canEngage(t) then
                    target = t
                end

            else
                target = false

            end

        end

        if target then

            if (target.distance):sqrt() < 22 then
                self.targets.luopan = target
            end

        end

    end

    self.setEntrust = function(target)
        local target = target or false
        local player = bp.player

        if target and target ~= '' then

            if type(target) == 'number' then
                target = windower.ffxi.get_mob_by_id(target) or false

            elseif type(target) == 'table' then
                target = windower.ffxi.get_mob_by_id(target.id) or false

            elseif type(target) == 'string' and windower.ffxi.get_mob_by_name(target) and not self.isEnemy(windower.ffxi.get_mob_by_name(target)) then
                target = windower.ffxi.get_mob_by_name(target) or false

            elseif windower.ffxi.get_mob_by_target('t') then
                target = windower.ffxi.get_mob_by_target('t')

            else
                target = false

            end

        end

        if target and target.id == player.id then
            self.targets.entrust = false

        else

            if (target.distance):sqrt() < 22 and target.name ~= player.name and bp.helpers['party'].isInParty(target, false) then
                self.targets.entrust = target
            end

        end

    end

    self.canEngage = function(mob)

        if bp and mob and mob.spawn_type == 16 and not mob.charmed and not self.isDead(mob) then
            local player    = bp.player or false
            local party     = bp.party or false

            if player and party then

                if (mob.claim_id == 0 or bp.helpers['party'].isInParty(mob.claim_id, true) or bp.helpers['buffs'].buffActive(603) or bp.helpers['buffs'].buffActive(511) or bp.helpers['buffs'].buffActive(257) or bp.helpers['buffs'].buffActive(267)) then
                    return true
                end

            end

        end
        return false

    end

    self.isEnemy = function(target)
        local target = target or false

        if bp and target then
            local helpers = bp.helpers

            if type(target) == 'table' and target.spawn_type == 16 then
                return true

            elseif type(target) == 'number' and tonumber(target) ~= nil then
                local target = windower.ffxi.get_mob_by_id(target)

                if type(target) == 'table' and target.spawn_type == 16 then
                    return true
                end

            elseif type(target) == 'string' then
                local target = windower.ffxi.get_mob_by_target(target) or windower.ffxi.get_mob_by_name(target) or false

                if type(target) == 'table' and target.spawn_type == 16 then
                    return true
                end

            end

        end
        return false

    end

    self.castable = function(target, spell)
        local targets = spell.targets

        if bp and target and targets then

            for i,v in pairs(targets) do

                if i == 'Self' and target.name == bp.player.name then
                    return v

                elseif i == 'Party' and bp.helpers['party'].isInParty(target, false) then
                    return v

                elseif i == 'Ally' and bp.helpers['party'].isInParty(target, true) then
                    return v

                elseif i == 'Player' and not target.is_npc then
                    return v

                elseif i == 'NPC' and target.is_npc then
                    return v

                elseif i == 'Enemy' and target.spawn_type == 16 then
                    return v

                end

            end

        end
        return false

    end

    self.onlySelf = function(spell)
        local spell = spell or false

        if spell then
            local targets = T(spell.targets)

            if #targets == 1 and targets[1] == 'Self' and spell.prefix ~= '/song' then
                return true
            end

        end
        return false

    end

    self.getValidTarget = function(target)
        
        if type(target) == 'string' then
            local types = T{'t','bt','st','me','ft','ht','pet'}

            if types:contains(target) and windower.ffxi.get_mob_by_target(target) then
                return windower.ffxi.get_mob_by_target(target)

            elseif windower.ffxi.get_mob_by_name(target) then
                return windower.ffxi.get_mob_by_name(target)

            elseif tonumber(target) ~= nil and windower.ffxi.get_mob_by_id(target) then
                return windower.ffxi.get_mob_by_id(target)

            end

        elseif type(target) == 'number' then

            if tonumber(target) ~= nil and windower.ffxi.get_mob_by_id(target) then
                return windower.ffxi.get_mob_by_id(target)
            end

        elseif type(target) == 'table' then

            if target.id and windower.ffxi.get_mob_by_id(target.id) then
                return windower.ffxi.get_mob_by_id(target.id)
            end

        end
        return false

    end

    self.validSpellTarget = function(id, target)
        local player    = bp.player or false
        local target    = target or false
        local id        = id or false
        
        if bp and player and id and target and res.spells[id] then
            local helpers   = bp.helpers
            local spell     = res.spells[id]

            if type(target) == 'table' then
                local target = windower.ffxi.get_mob_by_id(target.id) or false

                if target then

                    if (spell.targets):contains("Self") and player.name == target.name then
                        return target
                        
                    elseif (spell.targets):contains("Ally") and helpers['party'].isInParty(target, true) then
                        return target
                        
                    elseif (spell.targets):contains("Party") and helpers['party'].isInParty(target, false) then
                        return target
                            
                    elseif (spell.targets):contains("Self") and (spell.targets):contains("Party") and (spell.targets):contains("NPC") and (spell.targets):contains("Player") and (spell.targets):contains("Ally") and (spell.targets):contains("Enemy") then
                        return target
                            
                    end

                end

            elseif (type(target) == 'number' or tonumber(target) ~= nil) then
                local target = windower.ffxi.get_mob_by_id(target) or false

                if target then

                    if (spell.targets):contains("Self") and player.name == target.name then
                        return target
                        
                    elseif (spell.targets):contains("Ally") and helpers['party'].isInParty(target, true) then
                        return target
                        
                    elseif (spell.targets):contains("Party") and helpers['party'].isInParty(target, false) then
                        return target
                            
                    elseif (spell.targets):contains("Self") and (spell.targets):contains("Party") and (spell.targets):contains("NPC") and (spell.targets):contains("Player") and (spell.targets):contains("Ally") and (spell.targets):contains("Enemy") then
                        return target
                            
                    end

                end

            elseif type(target) == 'string' then
                local target = windower.ffxi.get_mob_by_name(target) or false

                if target then

                    if (spell.targets):contains("Self") and player.name == target.name then
                        return target
                        
                    elseif (spell.targets):contains("Ally") and helpers['party'].isInParty(target, true) then
                        return target
                        
                    elseif (spell.targets):contains("Party") and helpers['party'].isInParty(target, false) then
                        return target
                            
                    elseif (spell.targets):contains("Self") and (spell.targets):contains("Party") and (spell.targets):contains("NPC") and (spell.targets):contains("Player") and (spell.targets):contains("Ally") and (spell.targets):contains("Enemy") then
                        return target
                            
                    end

                end

            end
            
        elseif bp and player and id and target and res.job_abilities[id] then
            local spell = res.job_abilities[id]
            
            if type(target) == 'table' then
                local target = windower.ffxi.get_mob_by_id(target) or false

                if target then

                    if (spell.targets):contains("Self") and player.name == target.name then
                        return target
                        
                    elseif (spell.targets):contains("Ally") and helpers['party'].isInParty(target, true) then
                        return target
                        
                    elseif (spell.targets):contains("Party") and helpers['party'].isInParty(target, false) then
                        return target
                            
                    elseif (spell.targets):contains("Self") and (spell.targets):contains("Party") and (spell.targets):contains("NPC") and (spell.targets):contains("Player") and (spell.targets):contains("Ally") and (spell.targets):contains("Enemy") then
                        return target
                            
                    end

                end

            elseif (type(target) == 'number' or tonumber(target) ~= nil) then
                local target = windower.ffxi.get_mob_by_id(target) or false

                if target then

                    if (spell.targets):contains("Self") and player.name == target.name then
                        return target
                        
                    elseif (spell.targets):contains("Ally") and helpers['party'].isInParty(target, true) then
                        return target
                        
                    elseif (spell.targets):contains("Party") and helpers['party'].isInParty(target, false) then
                        return target
                            
                    elseif (spell.targets):contains("Self") and (spell.targets):contains("Party") and (spell.targets):contains("NPC") and (spell.targets):contains("Player") and (spell.targets):contains("Ally") and (spell.targets):contains("Enemy") then
                        return target
                            
                    end

                end

            elseif type(target) == 'string' then
                local target = windower.ffxi.get_mob_by_name(target) or false

                if target then

                    if (spell.targets):contains("Self") and player.name == target.name then
                        return target
                        
                    elseif (spell.targets):contains("Ally") and helpers['party'].isInParty(target, true) then
                        return target
                        
                    elseif (spell.targets):contains("Party") and helpers['party'].isInParty(target, false) then
                        return target
                            
                    elseif (spell.targets):contains("Self") and (spell.targets):contains("Party") and (spell.targets):contains("NPC") and (spell.targets):contains("Player") and (spell.targets):contains("Ally") and (spell.targets):contains("Enemy") then
                        return target
                            
                    end

                end

            end
            
        end
        return false
        
    end

    self.isDead = function(target)

        if target and target.status and T{2,3}:contains(target.status) then
            return true
        end
        return false

    end

    self.allowed = function(target)
        local target = bp.helpers['target'].getValidTarget(target)

        if target and type(target) == 'table' then
            local helpers   = bp.helpers
            local target    = windower.ffxi.get_mob_by_id(target.id) or false

            if target and type(target) == 'table' and target.distance ~= nil then
                local distance = (target.distance:sqrt())

                if (distance == 0.089004568755627 or distance > 35) and distance ~= 0 then
                    return false
                end

                if not target then
                    return false
                end

                if target.hpp == 0 then
                    return false
                end

                if not target.valid_target then
                    return false
                end

                if not self.isEnemy(target) and not helpers['party'].isInParty(target, true) then
                    return false
                end
                return true

            end

        end
        return false

    end

    self.inRange = function(target, r, flag)

        if target and target.x and target.y then
            local me    = bp.me
            local x     = target.x
            local y     = target.y
            local r     = r or 6
            
            if me and x and y then
                
                if (( (me.x-x)^2 + (me.y-y)^2) < r^2) and not flag then
                    return true
                    
                elseif (( (me.x-x)^2 + (me.y-y)^2) > r^2) and flag then
                    return true
                    
                end
            
            end

        end
        return false

    end

    self.distance = function(c1, c2)
        if c1 and c2 then
            return ( (c2.x-c1.x)^2 + (c2.y-c1.y)^2 ):sqrt()
        end
        return 0
    
    end

    self.findHomepoint = function(range)
        local mobs = windower.ffxi.get_mob_array()
        
        for _,v in pairs(mobs) do
            
            if type(v) == 'table' and (v.name):match("Home Point") then

                if range and (v.distance):sqrt() <= 6 then
                    return v

                elseif not range then
                    return v

                end
                
            end
    
        end
        return false
        
    end

    self.changeMode = function()
        self.mode = self.mode ~= 2 and 2 or 1
        bp.helpers['popchat'].pop(string.format('TARGETING MODE NOW SET TO: %s', modes[self.mode]))

    end

    self.pos = function(x, y)
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

    -- Private Events.
    private.events.prerender = windower.register_event('prerender', function()
        private.render()

        if bp and bp.player and (bp.player.status == 2 or bp.player.status == 3) and bp.player['vitals'].hp <= 0 and self.getTarget() then
            private.clear()
        end
        private.updateTargets()

    end)

    private.events.zonechange = windower.register_event('zone change', function(new, old)
        private.clear()
        self.writeSettings()

    end)

    return self

end
return target.new()
