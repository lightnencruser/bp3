local empyrean = {}
function empyrean.new()
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
                    bp.helpers['empyrean'].set(tonumber(commands[3]))

                end

            else
                bp.helpers['empyrean'].toggle(bp)

            end

        end

    end

    return self

end
return empyrean.new()
