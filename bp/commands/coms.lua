local coms = {}
function coms.new()
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

                if command == 'pos' and commands[3] then
                    bp.helpers['coms'].pos(commands[3], commands[4] or false)

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
