local stunner = {}
function stunner.new()
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

            if command == '+' and commands[3] then
                local action = {}

                for i=3, #commands do
                    table.insert(action, string.format('%s', commands[i]))
                end
                bp.helpers['stunner'].add(table.concat(action, ' '))

            elseif command == '-' and commands[3] then
                local action = {}

                for i=3, #commands do
                    table.insert(action, string.format('%s', commands[i]))
                end
                bp.helpers['stunner'].remove(table.concat(action, ' '))

            end

        end

    end

    return self

end
return stunner.new()
