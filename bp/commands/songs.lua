local songs = {}
function songs.new()
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
                
                if command == 'dummy' then
                    bp.helpers['songs'].changeDummy(bp)

                elseif command == 'delay' and commands[3] then
                    local delay = tonumber(commands[3]) or false

                    if delay and delay > 0 and delay < 1000 then
                        bp.helpers['songs'].delay = delay
                        bp.helpers['popchat'].pop(string.format('SONGS RECAST DELAY NOW SET TO: %03d', delay))

                    else
                        bp.helpers['popchat'].pop(string.format('PLEASE ENTER A DELAY BETWEEN 1 AND 999!', delay))

                    end

                elseif (command == 'warn' or command == 'warning' or command == 'msg') then
                    bp.helpers['songs'].toggleWarning(bp)

                elseif (command == 'timers' or command == 'reset') and commands[3] then
                    bp.helpers['songs'].resetTimers(commands[3])

                elseif command == 'clear' then
                    bp.helpers['songs'].clearJukebox()

                elseif command == 'pos' and commands[3] then
                    bp.helpers['songs'].pos(commands[3], commands[4] or false)

                else
                    bp.helpers['songs'].sing(commands)

                end

            end

        end

    end

    return self

end
return songs.new()
