local pup = {}
function pup.get()
    local self = {}

    local private = {}

    self.automate = function(bp, settings)
        private.items(bp, settings)

        if bp and bp.player and bp.player.status == 1 then
            print('engaged status')

        elseif bp and bp.player and bp.player.status == 0 then
            print('disengaged status')

        end
        
    end

    private.items = function(bp, settings)

    end

    return self

end
return pup.get()