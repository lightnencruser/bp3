local sparks = {}
function sparks.new()
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
        
        if bp and commands and commands[2] then
            local item, count = {}, commands[#commands] or false

            for i=2, #commands do
                
                if tonumber(commands[i]) == nil then
                    table.insert(item, commands[i])
                end

            end
            
            if item and item ~= '' then
                bp.helpers['sparks'].poke(table.concat(item, ' '), count)
            end

        end

    end

    return self

end
return sparks.new()
