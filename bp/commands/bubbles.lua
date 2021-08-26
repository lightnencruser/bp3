local bubbles = {}
function bubbles.new()
    local self = {}

    -- Private Variables.
    local bp = false

    -- Public Functions.
    self.setSystem = function(buddypal)
        if buddypal then
            bp = buddypal
        end

    end

    self.capture = function(commands)
        local commands = commands or false

        if bp and commands then
            local command = commands[2] or false

            if command then
                command = command:lower()

                if command == 'set' and commands[3] then
                    bp.helpers['bubbles'].setBubbles(commands[3], commands[4] or false, commands[5] or false)

                elseif command == 'display' then
                    bp.helpers['bubbles'].toggleDisplay()
                
                elseif command == 'place' then
                    bp.helpers['bubbles'].togglePlacement(bp)

                elseif command == 'indi' then
                    bp.helpers['bubbles'].toggleIndi(bp)

                elseif command == 'geo' then
                    bp.helpers['bubbles'].toggleGeo(bp)

                elseif command == 'entrust' then
                    bp.helpers['bubbles'].toggleEntrust(bp)

                elseif command == 'dema' then
                    bp.helpers['bubbles'].toggleDematerialize(bp)

                elseif (command == 'eclip' or command == 'lasting' or command == '*') then
                    bp.helpers['bubbles'].toggleBuff(bp)

                elseif (command == 'glory' or command == 'bog') then
                    bp.helpers['bubbles'].toggleBOG(bp)

                elseif command == 'buff' then
                    bp.helpers['bubbles'].toggleEnhancements(bp)

                elseif command == 'life' then
                    bp.helpers['bubbles'].togglePlacement(bp)

                elseif command == 'circle' then
                    bp.helpers['bubbles'].togglePlacement(bp)

                elseif command == 'distance' then
                    bp.helpers['bubbles'].setDistance(commands[3])

                elseif command == 'pos' and commands[3] then
                    bp.helpers['bubbles'].pos(commands[3], commands[4] or false)

                end

            end

        end

    end

    return self

end
return bubbles.new()
