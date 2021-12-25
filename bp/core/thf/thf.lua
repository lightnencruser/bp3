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

                    -- FEINT.
                    if get('feint') and isReady('JA', "Feint") then
                        add(bp.JA["Feint"], target)
                    end
                
                    -- STEAL.
                    if get('steal') and isReady('JA', "Steal") then
                        add(bp.JA["Steal"], target)
    
                    -- MUG.
                    elseif get('mug') and isReady('JA', "Mug") then
                        add(bp.JA["Mug"], target)

                    -- DESPOIL
                    elseif get('despoil') and isReady('JA', "Despoil") then
                        add(bp.JA["Despoil"], target)
    
                    end
    
                end
    
                if get('buffs') and _act then
                    local behind = helpers['actions'].isBehind(target)
                    local facing = helpers['actions'].isFacing(target)
                    
                    -- SNEAK ATTACK.
                    if get('sneak attack') and isReady('JA', 'Sneak Attack') and not buff(65) and player['vitals'].tp < get('ws').tp and (not get('am') or bp.core.hasAftermath()) then
                        
                        if isReady('JA', 'Hide') then
                            add(bp.JA["Hide"], player)
                            add(bp.MA["Sneak Attack"], player)
    
                        elseif behind then
                            add(bp.JA["Sneak Attack"], player)
    
                        end
    
                    -- TRICK ATTACK.
                    elseif get('trick attack') and isReady('JA', 'Trick Attack') and not buff(87) and player['vitals'].tp < get('ws').tp and (not get('am') or bp.core.hasAftermath()) then
    
                        if behind then
                            add(bp.JA["Trick Attack"], player)
                        end
    
                    end

                    -- ASSASSINS CHARGE.
                    if get("assassin's charge") and isReady('JA', "Assassin's Charge") and not buff(342) and player['vitals'].tp < get('ws').tp and (not get('am') or bp.core.hasAftermath()) then
                        add(bp.JA["Assassin's Charge"], player)

                    -- CONSPIRATOR.
                    elseif get('conspirator') and isReady('JA', "Conspirator") and not buff(462) then
                        add(bp.JA["Conspirator"], player)

                    -- BULLY.
                    elseif get('bully') and isReady('JA', "Bully") and not buff(22) then
                        add(bp.JA["Bully"], player)

                    end
    
                end

            elseif bp and bp.player and bp.player.status == 0 then
                local target  = helpers['target'].getTarget() or false
                local _act    = bp.helpers['actions'].canAct()
                local _cast   = bp.helpers['actions'].canCast()

                if get('ja') and _act then

                    -- FLEE.
                    if not target and get('flee') and isReady('JA', "Flee") and not buff(32) then
                        add(bp.JA["Flee"], player)
                    end
    
                end
    
                if get('buffs') and _act then
                    local behind = helpers['actions'].isBehind(target)
                    local facing = helpers['actions'].isFacing(target)

                    -- BULLY.
                    if get('bully') and isReady('JA', "Bully") and not buff(22) then
                        add(bp.JA["Bully"], player)

                    end
    
                end

            end

        end
        
    end

    private.items = function()

    end

    return self

end
return job.get()