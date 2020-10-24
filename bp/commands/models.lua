local models = {}
function models.new()
    local self = {}

    self.capture = function(bp, commands)
        local bp        = bp or false
        local commands  = commands or false
        local target    = windower.ffxi.get_mob_by_target('t') or false

        if bp and commands and commands[2] and commands[3] and commands[2] == 'remove' then
            local length    = (#commands[1] + #commands[2] + 3)
            local name      = table.concat(commands, ' '):sub(length) or false

            if name then
                bp.helpers['models'].remove(bp, name)

            elseif not name or name == '' then
                bp.helpers['popchat'].pop('Please enter a model name!')
            end

        elseif bp and commands and commands[2] and (commands[2] == 'on' or commands[2] == 'off' or commands[2] == 'toggle') then

            if bp.helpers['models'].enabled then
                bp.helpers['models'].enabled = false
                bp.helpers['models'].writeSettings()
                bp.helpers['popchat'].pop(string.format('Model Adjustments are now: %s.', tostring(bp.helpers['models'].enabled)))

            elseif not bp.helpers['models'].enabled then
                bp.helpers['models'].enabled = true
                bp.helpers['models'].writeSettings()
                bp.helpers['popchat'].pop(string.format('Model Adjustments are now: %s.', tostring(bp.helpers['models'].enabled)))

            end

        elseif bp and commands and commands[2] and target and tonumber(commands[2]) ~= nil then
            bp.helpers['models'].setModel(bp, target, commands[2])

        elseif not target and commands[2] then
            bp.helpers['popchat'].pop('Please select a target!')

        elseif target and not commands[2] then
            bp.helpers['popchat'].pop('Please enter a new model!')

        end

    end

    return self

end
return models.new()
