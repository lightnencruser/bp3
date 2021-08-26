local debuffs = {}
function debuffs.new()
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

                if command == '+' and commands[3] then
                    local spell = {}
                    local delay = tonumber(commands[#commands]) or 180
                    
                    for i=3, #commands do

                        if commands[i] and tonumber(commands[i]) == nil then
                            table.insert(spell, commands[i])
                        end

                    end
                    bp.helpers['debuffs'].add(table.concat(spell, ' '), delay)

                elseif command == '-' and commands[3] then
                    bp.helpers['debuffs'].remove(table.concat(commands, ' '):sub(11))

                elseif command == 'reset' then
                    bp.helpers['debuffs'].reset()

                elseif command == 'clear' then
                    bp.helpers['debuffs'].clear()

                elseif command == 'show' then
                    bp.helpers['debuffs'].display:show()

                elseif command == 'hide' then
                    bp.helpers['debuffs'].display:hide()

                elseif command == 'pos' and commands[3] then
                    bp.helpers['debuffs'].pos(commands[3], commands[4] or false)

                end

            end

        end

    end

    return self

end
return debuffs.new()
