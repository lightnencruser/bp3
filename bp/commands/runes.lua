local runes = {}
function runes.new()
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

            if command == 'pos' and commands[3] then
                bp.helpers['runes'].pos(commands[3], commands[4] or false)

            elseif command == 'mode' then
                bp.helpers['runes'].toggleMode(bp)

            elseif command then
                bp.helpers['runes'].setRune(commands[2] or false, commands[3] or false, commands[4] or false)

            end

        end

    end

    return self

end
return runes.new()
