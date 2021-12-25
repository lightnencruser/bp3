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

                    -- QUICK DRAW.
                    if get('quick draw').enabled and isReady('JA', get('quick draw').name) then
                        add(bp.JA[get('quick draw').name], target)
    
                    -- RANDOM DEAL.
                    elseif get('random deal') and isReady('JA', "Random Deal") then
                        add(bp.JA["Random Deal"], player)
    
                    end
    
                end
    
                if get('buffs') and _act then
                    local active = bp.helpers['rolls'].getActive()
    
                    -- ROLLS.
                    if get('rolls') and active < 2 then
                        bp.helpers['rolls'].roll()
    
                    -- TRIPLE SHOT.
                    elseif get('ra').enabled and isReady('JA', "Triple Shot") and not buff(467) then
                        add(bp.JA["Triple Shot"], player)
    
                    end
    
                end

            elseif bp and bp.player and bp.player.status == 0 then
                local target  = helpers['target'].getTarget() or false
                local _act    = bp.helpers['actions'].canAct()
                local _cast   = bp.helpers['actions'].canCast()

                if get('ja') and _act then

                    -- QUICK DRAW.
                    if target and get('quick draw').enabled and isReady('JA', get('quick draw').name) then
                        add(bp.JA[get('quick draw').name], target)
    
                    -- RANDOM DEAL.
                    elseif get('random deal') and isReady('JA', "Random Deal") then
                        add(bp.JA["Random Deal"], player)
    
                    end
    
                end
    
                if get('buffs') and _act then
                    local active = bp.helpers['rolls'].getActive()
    
                    -- ROLLS.
                    if get('rolls') and active < 2 then
                        bp.helpers['rolls'].roll()
    
                    -- TRIPLE SHOT.
                    elseif target and get('ra').enabled and isReady('JA', "Triple Shot") and not buff(467) then
                        add(bp.JA["Triple Shot"], player)
    
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