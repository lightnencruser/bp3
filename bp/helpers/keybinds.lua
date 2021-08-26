local keybinds = {}
function keybinds.new()
    local self = {}

    -- Public Functions.
    self.register = function(list)

        if list and type(list) == 'table' then

            for _,v in ipairs(list) do
                windower.send_command(string.format('bind %s', v))

            end

        end

    end

    return self

end
return keybinds.new()
