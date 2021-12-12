local job = {}
function job.get()
    local self = {}

    -- Private Variables.
    local private   = {}
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
    
                if get('buffs') and _cast then
                    helpers['songs'].playJukebox()
                end

            elseif bp and bp.player and bp.player.status == 0 then
                local target  = helpers['target'].getTarget() or false
                local _act    = bp.helpers['actions'].canAct()
                local _cast   = bp.helpers['actions'].canCast()
    
                if get('buffs') and _cast then
                    helpers['songs'].playJukebox()    
                end

            end

        end
        
    end

    private.items = function()

    end

    return self

end
return job.get()