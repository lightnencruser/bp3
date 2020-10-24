local debuffs = {}
function debuffs.new()
    local self = {}

    self.capture = function(bp, commands)
        local bp        = bp or false
        local commands  = commands or false

        if bp and commands then
            local command = commands[2] or false

            if command then
                command = command:lower()

                if command == '+' and commands[3] then
                    bp.helpers['debuffs'].add(bp, table.concat(commands, ' '):sub(11))

                elseif command == '-' and commands[3] then
                    bp.helpers['debuffs'].remove(bp, table.concat(commands, ' '):sub(11))

                elseif command == 'clear' then
                    bp.helpers['debuffs'].clear()

                elseif command == 'show' then
                    bp.helpers['debuffs'].show()

                elseif command == 'hide' then
                    bp.helpers['debuffs'].hide()

                elseif command == 'pos' then
                    local x = tonumber(commands[3]) or false
                    local y = tonumber(commands[4]) or false

                    if x and y then
                        bp.helpers['debuffs'].pos(bp, x, y)

                    else
                        bp.helpers['popchat'].pop('PLEASE ENTER AN "X" AND "Y" COORDINATE!')

                    end                    

                end

            end

        end

    end

    return self

end
return debuffs.new()
