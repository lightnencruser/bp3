local alias = {}
function alias.new()
    local self = {}

    self.capture = function(bp, commands)
        local bp        = bp or false
        local commands  = commands or false
        
        if bp and commands then
            local command = commands[2] or false

            if command then
                command = command:lower()

                if command == 'add' and commands[3] and commands[4] then
                    bp.helpers['autoload'].add(bp, commands[3], commands[4])
                end

            end

        end

    end

    return self

end
return alias.new()
