local noknock   = {}
local player    = windower.ffxi.get_player()

function noknock.new()
    local self = {}

    self.block = function(_, act)
        if act.category ~= 11 then
            return
        end

        for x = 1, act.target_count do

            for n = 1, act.targets[x].action_count do
                act.targets[x].actions[n].stagger = 0

            end

        end
        return act

    end

    return self

end
return noknock.new()
