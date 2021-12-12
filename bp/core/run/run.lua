local job = {}
function job.get()
    local self = {}

    -- Private Variables.
    local bp        = false
    local private   = {events={}}

    self.automate = function(bp)
        if buddypal and not bp then
            bp = bp
        end

        local get = bp.core.get

        do
            private.items()
            if bp and bp.player and bp.player.status == 1 then
                

            elseif bp and bp.player and bp.player.status == 0 then
                

            end

        end
        
    end

    private.items = function()

    end

    return self

end
return job.get()