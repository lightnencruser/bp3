local dax = {}
function dax.new()
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

                if command == 'list' then
                    bp.helpers['dax'].list(bp)

                elseif command == '+' and commands[3] then
                    local name = {}

                    for i=3, #commands do
                        table.insert(name, string.format('%s', commands[i]))
                    end
                    bp.helpers['dax'].add(table.concat(name, ' '))
                
                elseif command == '-' and commands[3] then
                    local name = {}

                    for i=3, #commands do
                        table.insert(name, string.format('%s', commands[i]))
                    end
                    bp.helpers['dax'].remove(table.concat(name, ' '))

                elseif command == 'pos' and commands[3] then
                    bp.helpers['dax'].pos(commands[3], commands[4] or false)

                end

            else
                bp.helpers['dax'].toggle(bp)

            end

        else
            bp.helpers['dax'].toggle(bp)

        end

    end

    return self

end
return dax.new()
