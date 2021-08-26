local keybinds = {}
function keybinds.new()
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

                if command == 'add' then
                    bp.helpers['keybinds'].add(table.concat(commands, ' '))
                end

            end

        end

    end

    return self

end
return keybinds.new()
