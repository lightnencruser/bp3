local popchat = {}
function popchat.new()
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
            local message = {}

            for i=2, #commands do
                table.insert(message, commands[i])
            end
            bp.helpers['popchat'].pop(table.concat(message, ' '))

        end

    end

    return self

end
return popchat.new()
