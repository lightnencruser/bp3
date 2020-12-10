local popchat = {}
function popchat.new()
    local self = {}

    self.capture = function(bp, commands)
        local bp        = bp or false
        local commands  = commands or false

        if bp and commands then
            local message = {}

            for i=2, #commands do
                table.insert(message, commands[i])
            end
            bp.helpers['popchat'].pop(table.concat(message, ' '))

        end

    end

    return self

end
return popchat.new()
