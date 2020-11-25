local cures = {}
function cures.new()
    local self = {}

    self.capture = function(bp, commands)
        local bp        = bp or false
        local commands  = commands or false

        if bp and commands then
            local command = commands[2] or false

            if command then
                command = command:lower()

                if command == 'save' then
                    bp.helpers['cures'].writeSettings()

                elseif command == 'power' and commands[3] and tonumber(commands[3]) ~= nil then
                    local power = tonumber(commands[3])

                    if power > 0 and power < 100 then
                        bp.helpers['cures'].power = power
                        bp.helpers['cures'].writeSettings()
                        bp.helpers['popchat'].pop(string.format('CURE POWER MULTIPLIER NOW SET TO: %d%%', bp.helpers['cures'].power))

                    else
                        bp.helpers['popchat'].pop('PLEASE ENTER A NUMBER BETWEEN 1 & 100!')

                    end

                
                elseif command == 'pos' and commands[3] then
                    bp.helpers['cures'].pos(bp, commands[3], commands[4] or false)

                end

            else
                bp.helpers['cures'].changeMode(bp)

            end

        else
            bp.helpers['cures'].changeMode(bp)

        end

    end

    return self

end
return cures.new()
