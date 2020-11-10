local bubbles = {}
function bubbles.new()
    local self = {}

    self.capture = function(bp, commands)
        local bp        = bp or false
        local commands  = commands or false

        if bp and commands then
            local command = commands[2] or false

            if command then
                command = command:lower()

                if command == 'set' and commands[3] then
                    bp.helpers['bubbles'].setBubbles(bp, commands[3], commands[4] or false, commands[5] or false)

                elseif command == 'display' then
                    bp.helpers['bubbles'].toggleDisplay()
                
                elseif command == 'place' then
                    bp.helpers['bubbles'].togglePlacement(bp)

                elseif command == 'pos' and commands[3] then
                    bp.helpers['bubbles'].pos(bp, commands[3], commands[4] or false)

                end

            end

        end

    end

    return self

end
return bubbles.new()
