local buffer = {}
function buffer.new()
    local self = {}

    self.capture = function(bp, commands)
        local bp        = bp or false
        local commands  = commands or false

        if bp and commands then
            local command = commands[2] or false

            if command then
                command = command:lower()

                if command == '+' and commands[3] and windower.ffxi.get_mob_by_target('t') then
                    local spell = {}
                    local delay = commands[#commands]
                        
                    for i=3, #commands do

                        if #commands > 3 then

                            if tonumber(delay) == nil then
                                table.insert(spell, string.format('%s', commands[i]))

                            elseif tonumber(delay) ~= nil and i ~= #commands then
                                table.insert(spell, string.format('%s', commands[i]))

                            end

                        elseif #commands == 3 then
                            table.insert(spell, string.format('%s', commands[i]))

                        end

                    end
                    bp.helpers['buffer'].add(bp, windower.ffxi.get_mob_by_target('t'), table.concat(spell, ' '), tonumber(delay) or 2)
                
                elseif command == '-' and commands[3] and windower.ffxi.get_mob_by_target('t') then
                    local spell = {}

                    for i=3, #commands do
                        table.insert(spell, string.format('%s', commands[i]))
                    end
                    bp.helpers['buffer'].remove(bp, windower.ffxi.get_mob_by_target('t'), table.concat(spell, ' '))

                elseif command == 'pos' and commands[3] then
                    bp.helpers['buffer'].pos(bp, commands[3], commands[4] or false)

                end

            end

        end

    end

    return self

end
return buffer.new()
