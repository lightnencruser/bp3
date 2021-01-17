local keybinds = {}
function keybinds.new()
    local self = {}

    self.capture = function(bp, commands)
        local bp        = bp or false
        local commands  = commands or false
        
        if bp and commands then
            local command = commands[2] or false

            if command then
                command = command:lower()

                if command == 'add' then
                    bp.helpers['keybinds'].add(bp, table.concat(commands, ' '))
                end

            end

        end

    end

    return self

end
return keybinds.new()
