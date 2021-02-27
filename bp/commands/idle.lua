local idle = {}
function idle.new()
    local self = {}

    self.capture = function(bp, commands)
        local bp        = bp or false
        local commands  = commands or false

        if bp and commands then
            local command = commands[2] or false

            if command then
                command = command:lower()

                if command == 'time' and commands[3] then
                    bp.helpers['idle'].setTimeout(bp, commands[3] or 1800)

                end

            else
                bp.helpers['idle'].toggle(bp)

            end

        end

    end

    return self

end
return idle.new()
