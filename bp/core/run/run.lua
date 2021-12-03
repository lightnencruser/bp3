local job = {}
function job.get()
    local self = {}

    local private = {}

    self.automate = function(bp)
        local get = bp.core.get

        do
            private.items(bp, settings)
            if bp and bp.player and bp.player.status == 1 then
                

            elseif bp and bp.player and bp.player.status == 0 then
                

            end

        end
        
    end

    private.items = function(bp)

    end

    return self

end
return job.get()