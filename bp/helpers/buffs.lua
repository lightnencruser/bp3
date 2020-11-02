local buffs = {}
function buffs.new()
    local self = {}

    self.buffActive = function(id)
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

    self.count = function()
        local player    = windower.ffxi.get_player() or false
        local count     = 0

        if player then

            for i=0, 32 do

                if player.buffs[i] ~= 255 then
                    count = (count + 1)
                end

            end

        end
        return count

    end

    self.getFinishingMoves = function()
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
