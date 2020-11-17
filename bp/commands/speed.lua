local speed = {}
function speed.new()
    local self = {}

    self.capture = function(bp, commands)
        local bp        = bp or false
        local commands  = commands or false

        if bp and commands then
            local command = commands[2] or false

            if command == 'pos' and commands[3] then
                bp.helpers['speed'].pos(bp, commands[3], commands[4] or false)

            elseif command == 'save' then
                bp.helpers['speed'].writeSettings()

            elseif command and tonumber(command) ~= nil then
                bp.helpers['speed'].setSpeed(bp, command or 50)

            else
                bp.helpers['speed'].toggle(bp)

            end
        
        else
            bp.helpers['speed'].toggle(bp)

        end

    end

    return self

end
return speed.new()
