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
                    bp.helpers['songs'].changeDummy(bp)

                elseif command == 'nitro' then
                    bp.helpers['songs'].toggleNitro(bp)

                elseif (command == 'warn' or command == 'warning' or command == 'msg') then
                    bp.helpers['songs'].toggleWarning(bp)

                elseif (command == 'timers' or command == 'reset') and commands[3] then
                    bp.helpers['songs'].resetTimers(commands[3])

                elseif command == 'clear' then
                    bp.helpers['songs'].clearJukebox()

                elseif command == '1hr' then
                    bp.helpers['songs'].toggle1HR(bp)

                elseif (command == 'loop' or command == 'repeat') then
                    bp.helpers['songs'].sing(bp, commands)

                elseif #commands > 3 then
                    bp.helpers['songs'].sing(bp, commands)

                end

            end

        end

    end

    return self

end
return songs.new()
