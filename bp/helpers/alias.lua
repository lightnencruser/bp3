local alias = {}
function alias.new()
    local self = {}

    -- Public Functions.
    self.register = function(list)

        if list and type(list) == 'table' then

            for _,v in ipairs(list) do
                windower.send_command(string.format('alias %s %s', v[1], v[2]))
            end

        end

    end

    return self

end
return alias.new()
