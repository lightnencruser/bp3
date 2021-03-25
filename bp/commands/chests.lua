local chests = {}
function chests.new()
    local self = {}

    self.capture = function(bp, commands)
        local bp        = bp or false
        local commands  = commands or false

        if bp and commands then
            local command = commands[2] or false
            local options = {

                open    = bp.helpers['chests'].open,
                destroy = bp.helpers['chests'].destroy,

            }

            if command then
                command = command:lower()

                if command == 'open' and commands[3] and type(commands[3]) == 'string' then
                    local flags = options['open']

                    if flags and flags[commands[3]:lower()] then
                        flags[commands[3]:lower()] = false

                    else
                        flags[commands[3]:lower()] = true

                    end
                    bp.helpers['popchat'].pop(string.format('CHEST OPENING FLAG {{ %s }} - %s.', commands[3], tostring(flags[commands[3]:lower()])))

                elseif command == 'destroy' and commands[3] and type(commands[3]) == 'string' then
                    local flags = options['destroy']

                    if flags and flags[commands[3]:lower()] then
                        flags[commands[3]:lower()] = false

                    else
                        flags[commands[3]:lower()] = true

                    end
                    bp.helpers['popchat'].pop(string.format('CHEST DESTROY FLAG {{ %s }} - %s.', commands[3], tostring(flags[commands[3]:lower()])))

                end

            elseif not command then
                bp.helpers['chests'].openChest(bp)
                
            end

        end

    end

    return self

end
return chests.new()