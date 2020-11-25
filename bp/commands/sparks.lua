local sparks = {}
function sparks.new()
    local self = {}

    self.capture = function(bp, commands)
        local bp        = bp or false
        local commands  = commands or false
        
        if bp and commands and commands[2] and commands[3] then
            local item  = windower.convert_auto_trans(table.concat(commands, ' ')):sub(8, (#(table.concat(commands, ' '))-#commands[#commands]-1))
            local count = windower.convert_auto_trans(table.concat(commands, ' ')):sub((#(table.concat(commands, ' '))-#commands[#commands]), #(table.concat(commands, ' ')))

            do -- Attempt to purchase sparks items.
                bp.helpers['sparks'].poke(bp, item, count)
            end

        end

    end

    return self

end
return sparks.new()
