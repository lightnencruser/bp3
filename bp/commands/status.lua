local status = {}
function status.new()
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
                    bp.helpers['status'].pos(commands[3], commands[4] or false)
                end

            elseif not command then
                bp.core.nextSetting('STATUS')

            end

        end

    end

    return self

end
return status.new()