local console = {}
function console.new()
    local self = {}

    self.handle = function(bp, command, args)
        local bp        = bp or false
        local command   = command or false
        local args      = args or false
        
        if bp and command and command:sub(1,1) == '/' then
            local send = {}

            for i=1, #args do

                if args[1] then
                    table.insert(send, args[i])
                end

            end
            windower.send_command(string.format('bp %s %s', command:sub(2), table.concat(send, ' ')))

        end

    end

    return self

end
return console.new()