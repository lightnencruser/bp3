local coms = {}
function coms.new()
    local self = {}

    self.capture = function(bp, commands)
        local bp        = bp or false
        local commands  = commands or false

        if bp and commands then
            local command = commands[2] or false

            if command then
                command = command:lower()

                if command == 'pos' and commands[3] then
                    bp.helpers['coms'].pos(bp, commands[3], commands[4] or false)

                end

            else
                bp.helpers['coms'].toggle(bp)

            end

        else
            bp.helpers['coms'].toggle(bp)

        end

    end

    return self

end
return coms.new()
