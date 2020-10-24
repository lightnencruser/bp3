local buffs = {}
function buffs.new()
    local self = {}

    self.buffActive = function(bp, id)
        local bp        = bp or false
        local player    = windower.ffxi.get_player() or false

        if player then

            for _,v in ipairs(player.buffs) do

                if v == id then
                    return true
                end

            end

        end
        return false

    end

    self.getFinishingMoves = function(bp)
        local bp        = bp or false
        local player    = windower.ffxi.get_player() or false

        if player then

            for _,v in ipairs(player.buffs) do

                if v == 381 then
                    return 1
                elseif v == 382 then
                    return 2
                elseif v == 382 then
                    return 3
                elseif v == 382 then
                    return 4
                elseif v == 382 then
                    return 5
                elseif v == 588 then
                    return 6
                end

            end

        end
        return 0

    end

    return self

end
return buffs.new()
