local job = {}
function job.get()
    local self = {}

    -- Private Variables.
    local private   = {events={}}
    local timers    = {}

    self.automate = function(bp)
        local player    = bp.player
        local helpers   = bp.helpers
        local isReady   = helpers['actions'].isReady
        local inQueue   = helpers['queue'].inQueue
        local buff      = helpers['buffs'].buffActive
        local add       = helpers['queue'].add
        local get       = bp.core.get
        local pet       = windower.ffxi.get_mob_by_target('pet') or false

        if not private.bp then
            private.bp = bp
        end

        do
            private.items()
            if bp and bp.player and bp.player.status == 1 then
                local target  = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
                local _act    = bp.helpers['actions'].canAct()
                local _cast   = bp.helpers['actions'].canCast()

                if get('ja') and _act then

                    if pet then
                        local oil = bp.helpers['equipment'].ammo

                        -- DEPLOY.
                        if get('deploy') and pet.status == 0 and isReady('JA', "Deploy") then
                            add(bp.JA["Deploy"], target)
                        end

                        -- REPAIR.
                        if get('repair').enabled and pet.hpp <= get('repair').pet_hpp and isReady('JA', "Repair") and oil and oil.en ~= 'Gil' and oil.en:sub(1, 13) == 'Automaton Oil' then
                            add(bp.JA["Repair"], player)
                        end

                        -- COOLDOWN.
                        if get('cooldown') and isReady('JA', "Cooldown") and private.getActive() > 2 then
                            add(bp.JA["Cooldown"], player)
                        end

                    elseif (not pet or not T{2,3}:contains(pet.status)) then

                        -- ACTIVATE.
                        if get('activate') then
                            
                            if isReady('JA', "Activate") then
                                add(bp.JA["Activate"], player)

                            elseif isReady('JA', "Deus Ex Automata") then
                                add(bp.JA["Deus Ex Automata"], player)

                            end

                        end

                    end

                end

                if get('buffs') and _act and not buff(299) then
                    local active = private.getActive()
                     
                    -- MANEUVERS.
                    if get('maneuvers').enabled and active > 0 and active < 3 and isReady('JA', "Fire Maneuver") then
                        local current = {}
                        local needed = {}

                        -- BUILD MANEUVERS NEEDED.
                        for i,v in pairs(get('maneuvers')) do
                            if i:sub(1,8) == 'maneuver' then
                                table.insert(needed, v)
                            end
                        end

                        -- GET CURRENT MANEUVERS.
                        for _,v in ipairs(player.buffs) do
                            for i,vv in ipairs(needed) do
                                if bp.res.buffs[v] and bp.res.buffs[v].en == vv then
                                    table.remove(needed, i)
                                    break
                                end
                            end
                        end

                        if #needed > 0 then
                            add(bp.JA[needed[1]], player)
                        end                        

                    elseif get('maneuvers').enabled and active == 0 and isReady('JA', "Fire Maneuver") then
                        add(bp.JA[get('maneuvers').maneuver1], player)

                    end
    
                end

            elseif bp and bp.player and bp.player.status == 0 then
                local target  = helpers['target'].getTarget() or false
                local _act    = bp.helpers['actions'].canAct()
                local _cast   = bp.helpers['actions'].canCast()

                if get('ja') and _act then

                    if pet and not T{2,3}:contains(pet.status) then
                        local oil = bp.helpers['equipment'].ammo

                        -- DEPLOY.
                        if get('deploy') and pet.status == 0 and isReady('JA', "Deploy") then
                            add(bp.JA["Deploy"], target)
                        end

                        -- REPAIR.
                        if get('repair').enabled and pet.hpp <= get('repair').pet_hpp and isReady('JA', "Repair") and oil and oil.en ~= 'Gil' and oil.en:sub(1, 13) == 'Automaton Oil' then
                            add(bp.JA["Repair"], player)
                        end

                        -- COOLDOWN.
                        if get('cooldown') and isReady('JA', "Cooldown") and private.getActive() > 2 then
                            add(bp.JA["Cooldown"], player)
                        end

                    elseif (not pet or not T{2,3}:contains(pet.status)) then

                        -- ACTIVATE.
                        if get('activate') then
                            
                            if isReady('JA', "Activate") then
                                add(bp.JA["Activate"], player)

                            elseif isReady('JA', "Deus Ex Automata") then
                                add(bp.JA["Deus Ex Automata"], player)

                            end

                        end

                    end

                end

                if target and get('buffs') and _act and not buff(299) then
                    local active = private.getActive()
                     
                    -- MANEUVERS.
                    if get('maneuvers').enabled and active > 0 and active < 3 and isReady('JA', "Fire Maneuver") then
                        local current = {}
                        local needed = {}

                        -- BUILD MANEUVERS NEEDED.
                        for i,v in pairs(get('maneuvers')) do
                            if i:sub(1,8) == 'maneuver' then
                                table.insert(needed, v)
                            end
                        end

                        -- GET CURRENT MANEUVERS.
                        for _,v in ipairs(player.buffs) do
                            for i,vv in ipairs(needed) do
                                if bp.res.buffs[v] and bp.res.buffs[v].en == vv then
                                    table.remove(needed, i)
                                    break
                                end
                            end
                        end

                        if #needed > 0 then
                            add(bp.JA[needed[1]], player)
                        end
                        

                    elseif target and get('maneuvers').enabled and active == 0 and isReady('JA', "Fire Maneuver") then
                        add(bp.JA[get('maneuvers').maneuver1], player)

                    end
    
                end

            end

        end
        
    end

    private.items = function()

    end

    private.getActive = function()
        local list = T{300,301,302,303,304,305,306,307}

        if private.bp and private.bp.player then
            local count = 0

            for _,v in ipairs(private.bp.player.buffs) do

                if list:contains(v) then
                    count = (count + 1)
                end

            end
            return count

        end
        return 0

    end

    return self

end
return job.get()