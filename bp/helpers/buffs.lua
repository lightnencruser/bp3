local buffs = {}
function buffs.new()
    local self = {}

    -- Private Variables.
    local bp    = false

    -- Public Variables
    self.buffs  = {}
    self.count  = 0

    -- Private Functions.
    local buildBuffs = function()
        local player = windower.ffxi.get_player() or false

        if player then
            local buffs = player.buffs

            for i=1, 32 do
                    
                if buffs[i] ~= 255 then
                    self.count = (self.count + 1)
                end

            end

        end

    end
    buildBuffs()

    -- Public Functions.
    self.setSystem = function(buddypal)
        if buddypal then
            bp = buddypal
        end

    end
    
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
