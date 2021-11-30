local pup = {}
function pup.get()
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
    
        if bp and bp.helpers['actions'].canItem() then

            if bp.helpers['buffs'].buffActive(15) then

                if bp.helpers['inventory'].findItemByName("Holy Water") and not bp.helpers['queue'].inQueue(bp.IT["Holy Water"]) then
                    helpers['queue'].add(bp.IT["Holy Water"], 'me')

                elseif bp.helpers['inventory'].findItemByName("Hallowed Water") and not bp.helpers['queue'].inQueue(bp.IT["Hallowed Water"]) then
                    helpers['queue'].add(bp.IT["Hallowed Water"], 'me')

                end

            elseif bp.helpers['buffs'].buffActive(6) then

                if bp.helpers['inventory'].findItemByName("Echo Drops") and not bp.helpers['queue'].inQueue(bp.IT["Echo Drops"]) then
                    bp.helpers['queue'].add(bp.IT["Echo Drops"], 'me')
                end

            end

        end

    end

    return self

end
return pup.get()