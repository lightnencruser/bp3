local autoload = {}
function autoload.new()
    local self = {}

    -- Public Functions.
    self.load = function(list)

        if list and type(list) == 'table' then

            for _,v in ipairs(list) do
                windower.send_command(string.format('lua load %s', v))
            end

        end

    end

    return self

end
return autoload.new()
