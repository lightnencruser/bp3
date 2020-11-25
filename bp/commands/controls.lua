local controls = {}
function controls.new()
    local self = {}

    self.capture = function(bp, commands)
        local bp        = bp or false
        local commands  = commands or false

        if bp and commands then
            local command = commands[2] or false

            if command then
                bp.helpers['controls'].toggle(bp, command:lower())
            end

        end

    end

    return self

end
return controls.new()
