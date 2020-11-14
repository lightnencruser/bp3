local cures = {}
function cures.new()
    local self = {}

    self.capture = function(bp, commands)
        local bp        = bp or false
        local commands  = commands or false

        if bp and commands then
            local command = commands[2] or false

            if command then
                command = command:lower()

                if command == 'save' then
                    bp.helpers['cures'].writeSettings()
                end

            else
                bp.helpers['cures'].changeMode(bp)

            end

        else
            bp.helpers['cures'].changeMode(bp)

        end

    end

    return self

end
return cures.new()
