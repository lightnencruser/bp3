local job = {}
function job.get()
    local self = {}
    local private = {}

    self.automate = function(bp)
        local player    = bp.player
        local helpers   = bp.helpers
        local isReady   = helpers['actions'].isReady
        local inQueue   = helpers['queue'].inQueue
        local buff      = helpers['buffs'].buffActive
        local add       = helpers['queue'].add
        local get       = bp.core.get
        local pet       = windower.ffxi.get_mob_by_target('pet') or false

        do
            private.items(bp, settings)
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
                        if get('repair').enabled and pet.hpp <= get('repair').pet_hpp and isReady('JA', "Repair") and oil and oil ~= 'Gil' and oil:sub(1, 13) == 'Automaton Oil' then
                            add(bp.JA["Repair"], player)

                        -- COOLDOWN.
                        elseif get('cooldown') and isReady('JA', "Cooldown") and private.getActive() > 2 then
                            add(bp.JA["Cooldown"], player)

                        end

                    else

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

                if get('buffs') and _act then
                    local current = {}
                    local active = private.getActive()
                    local buffs = bp.player.buffs
                    local max = 3
                        
                    -- MANEUVERS.
                    if get('maneuvers').enabled and active > 0 and active < max and bp.helpers['actions'].isReady('JA', "Fire Maneuver") then
                        
                        -- GET CURRENT ACTIVATED.
                        for _,v in ipairs(buffs) do
                            if T{300,301,302,303,304,305,306,307}:contains(v) then
                                table.insert(current, v)
                            end
                        end

                        for i=1, 4 do
                            local maneuver = get('maneuvers')[string.format('maneuver%s', i)]

                            if maneuver ~= nil then

                                if #current > 0 then

                                    for i, buff in ipairs(current) do

                                        if bp.BUFFS[maneuver] and bp.BUFFS[maneuver].id == buff then
                                            table.remove(current, i)
                                        end

                                    end

                                else

                                    if not private.maneuverInQueue() and isReady('JA', maneuver) then
                                        add(bp.JA[maneuver], player)
                                        break
                                        
                                    end

                                end

                            end

                        end

                    elseif get('maneuvers').enabled and active == 0 and isReady('JA', "Fire Maneuver") and not private.maneuverInQueue() then
                        add(bp.JA[get('maneuvers').maneuver1], player)

                    end
    
                end

            elseif bp and bp.player and bp.player.status == 0 then
                local target  = helpers['target'].getTarget() or false
                local _act    = bp.helpers['actions'].canAct()
                local _cast   = bp.helpers['actions'].canCast()

                if get('ja') and _act then

                    if pet then
                        local oil = bp.helpers['equipment'].ammo
                        
                        -- DEPLOY.
                        if target and get('deploy') and pet.status == 0 and isReady('JA', "Deploy") then
                            add(bp.JA["Deploy"], target)
                        end

                        -- REPAIR.
                        if get('repair').enabled and pet.hpp <= get('repair').pet_hpp and isReady('JA', "Repair") and oil and oil ~= 'Gil' and oil:sub(1, 13) == 'Automaton Oil' then
                            add(bp.JA["Repair"], player)

                        -- COOLDOWN.
                        elseif get('cooldown') and isReady('JA', "Cooldown") and private.getActive() > 2 then
                            add(bp.JA["Cooldown"], player)

                        end

                    else

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

                if get('buffs') and _act then
                    local current = {}
                    local active = private.getActive()
                    local buffs = bp.player.buffs
                    local max = 3
                     
                    -- MANEUVERS.
                    if get('maneuvers').enabled and active > 0 and active < max and bp.helpers['actions'].isReady('JA', "Fire Maneuver") then
                        
                        -- GET CURRENT ACTIVATED.
                        for _,v in ipairs(buffs) do
                            if T{300,301,302,303,304,305,306,307}:contains(v) then
                                table.insert(current, v)
                            end
                        end

                        for i=1, 4 do
                            local maneuver = get('maneuvers')[string.format('maneuver%s', i)]

                            if maneuver ~= nil then

                                if #current > 0 then

                                    for i, buff in ipairs(current) do

                                        if bp.BUFFS[maneuver] and bp.BUFFS[maneuver].id == buff then
                                            table.remove(current, i)
                                        end

                                    end

                                else

                                    if not private.maneuverInQueue() and isReady('JA', maneuver) then
                                        add(bp.JA[maneuver], player)
                                        break
                                        
                                    end

                                end

                            end

                        end

                    elseif target and get('maneuvers').enabled and active == 0 and isReady('JA', "Fire Maneuver") and not private.maneuverInQueue() then
                        add(bp.JA[get('maneuvers').maneuver1], player)

                    end
    
                end

            end

        end
        
    end

    private.items = function(bp)

    end

    private.getActive = function()
        local list = T{300,301,302,303,304,305,306,307}

        if bp and bp.player then
            local count = 0

            for _,v in ipairs(bp.player.buffs) do

                if list:contains(v) then
                    count = (count + 1)
                end

            end
            return count

        end
        return 0

    end

    private.maneuverInQueue = function()
        
        if bp and bp.helpers then
            local data = bp.helpers['queue'].queue.data

            for _,v in ipairs(data) do
                
                if v.action and v.action.type and v.action.type == 'PetCommand' and v.action.id >= 141 and v.action.id <= 148 then
                    return true
                end

            end

        end
        return false

    end

    return self

end
return job.get()