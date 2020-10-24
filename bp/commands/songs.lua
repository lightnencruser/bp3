local songs = {}
function songs.new()
    local self = {}

    self.capture = function(bp, commands)
        local bp        = bp or false
        local commands  = commands or false

        if bp and commands then
            local command = commands[2] or false

            if command then
                command = command:lower()

                if command == 'dummy' then
                    bp.helpers['songs'].change(bp)
                end

            end

        end

    end

    return self

end
return songs.new()
