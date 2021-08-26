local rolls = {}
function rolls.new()
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
                
                if bp.helpers['rolls'].getRoll(command) or (commands[3] and bp.helpers['rolls'].getRoll(commands[3]))  then
                    local rolls = T{roll1=bp.helpers['rolls'].getRoll(command), roll2=bp.helpers['rolls'].getRoll(commands[3] or false)}
                    
                    if (rolls.roll1 or rolls.roll2) then
                        bp.helpers['rolls'].setRoll(rolls.roll1, rolls.roll2)
                    end

                elseif command == 'cap' and commands[3] then
                    local cap = tonumber(commands[3])

                    if cap and cap >= 1 and cap <= 11 then
                        bp.helpers['rolls'].setCap(cap)
                    end

                elseif (command == 'crooked' or command == 'crook') then
                    bp.helpers['rolls'].toggleCrooked(bp)

                elseif command == 'pos' and commands[3] then
                    bp.helpers['rolls'].pos(commands[3], commands[4] or false)

                end

            else
                bp.helpers['rolls'].toggle(bp)

            end

        end

    end

    return self

end
return rolls.new()
