local empyrean = {}
function empyrean.new()
    local self = {}

    self.capture = function(bp, commands)
        local bp        = bp or false
        local commands  = commands or false

        if bp and commands then
            local command = commands[2] or false

            if command then
                command = command:lower()

                if command == 'set' and commands[3] then
                    bp.helpers['empyrean'].set(bp, tonumber(commands[3]))

                end

            else
                bp.helpers['empyrean'].toggle(bp)

            end

        end

    end

    return self

end
return empyrean.new()
