local enmity = {}
function enmity.new()
    local self = {}

    self.capture = function(bp, commands)
        local bp        = bp or false
        local commands  = commands or false

        if bp and commands then
            local command = commands[2] or false

            if command then
                command = command:lower()

                if command == 'pos' and commands[3] then
                    bp.helpers['enmity'].pos(bp, commands[3], commands[4] or false)
                end

            end

        end

    end

    return self

end
return enmity.new()