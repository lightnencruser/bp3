local controls = {}
function controls.new()
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

            if command and command ~= 'range' then
                bp.helpers['controls'].toggle(command:lower())

            elseif command == 'range' and commands[3] and tonumber(commands[3]) ~= nil then
                bp.helpers['controls'].range = tonumber(commands[3])
                bp.helpers['popchat'].pop(string.format('ASSIST RANGE NOW SET TO: %s.', bp.helpers['controls'].range))

            end

        end

    end

    return self

end
return controls.new()
