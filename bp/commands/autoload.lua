local autoload = {}
function autoload.new()
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

                if (command == 'install' or command == 'add') and commands[3] then
                    bp.helpers['autoload'].install(commands[3])
                end

            end

        end

    end

    return self

end
return autoload.new()
