local autoload = {}
function autoload.new()
    local self = {}

    self.capture = function(bp, commands)
        local bp        = bp or false
        local commands  = commands or false
        
        if bp and commands then
            local command = commands[2] or false

            if command then
                command = command:lower()

                if (command == 'install' or command == 'add') and commands[3] then
                    bp.helpers['autoload'].install(bp, commands[3])
                end

            end

        end

    end

    return self

end
return autoload.new()
