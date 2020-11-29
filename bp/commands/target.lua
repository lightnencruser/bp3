local target = {}
function target.new()
    local self = {}

    self.capture = function(bp, commands)
        local bp        = bp or false
        local commands  = commands or false

        if bp and commands then
            local command = commands[2] or false
            local helpers = bp.helpers

            if command then
                command = command:lower()

                if command == 'set' and (commands[3] or windower.ffxi.get_mob_by_target('t')) then
                    local target = commands[3] or windower.ffxi.get_mob_by_target('t')

                    if type(target) == 'table' then
                        bp.helpers['target'].setTarget(bp, target)

                    elseif (type(target) == 'number' or tonumber(target) ~= nil) then
                        bp.helpers['target'].setTarget(bp, target)

                    elseif type(target) == 'string' then
                        bp.helpers['target'].setTarget(bp, target)

                    end

                elseif command == 't' then
                
                    do -- Reset Targets if pressed twice in succession.
                        bp.helpers['target'].resetTargets()
                    end
                    
                    if windower.ffxi.get_mob_by_target('t') then
                        local target = windower.ffxi.get_mob_by_target('t')

                        if type(target) == 'table' and helpers['target'].isEnemy(bp, target) then
                            bp.helpers['target'].targets.player = target

                        else
                            bp.helpers['target'].targets.player = false

                        end

                    end

                elseif command == 'pt' then

                    do -- Reset Targets if pressed twice in succession.
                        bp.helpers['target'].resetTargets()
                    end
                    
                    if windower.ffxi.get_mob_by_target('t') then
                        local target = windower.ffxi.get_mob_by_target('t')

                        if type(target) == 'table' and helpers['target'].isEnemy(bp, target) then
                            bp.helpers['target'].targets.party = target

                        else
                            bp.helpers['target'].targets.party = false

                        end

                    end

                elseif command == 'et' and (commands[3] or windower.ffxi.get_mob_by_target('t')) then
                    local target = commands[3] or windower.ffxi.get_mob_by_target('t')

                    if type(target) == 'table' then
                        bp.helpers['target'].setEntrust(bp, target)

                    elseif (type(target) == 'number' or tonumber(target) ~= nil) then
                        bp.helpers['target'].setEntrust(bp, target)

                    elseif type(target) == 'string' then
                        bp.helpers['target'].setEntrust(bp, target)

                    end

                elseif command == 'lt' and (commands[3] or windower.ffxi.get_mob_by_target('t')) then
                    local target = commands[3] or windower.ffxi.get_mob_by_target('t')

                    if type(target) == 'table' then
                        bp.helpers['target'].setLuopan(bp, target)

                    elseif (type(target) == 'number' or tonumber(target) ~= nil) then
                        bp.helpers['target'].setLuopan(bp, target)

                    elseif type(target) == 'string' then
                        bp.helpers['target'].setLuopan(bp, target)

                    end

                elseif command == 'pos' and commands[3] then
                    bp.helpers['target'].pos(bp, commands[3], commands[4] or false)

                end

            end

        end

    end

    return self

end
return target.new()
