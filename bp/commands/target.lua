local target = {}
function target.new()
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
            local helpers = bp.helpers

            if command then
                command = command:lower()

                if command == 'set' and (commands[3] or windower.ffxi.get_mob_by_target('t')) then
                    local target = commands[3] or windower.ffxi.get_mob_by_target('t')

                    if type(target) == 'table' then
                        bp.helpers['target'].setTarget(target)

                    elseif (type(target) == 'number' or tonumber(target) ~= nil) then
                        bp.helpers['target'].setTarget(target)

                    elseif type(target) == 'string' then
                        bp.helpers['target'].setTarget(target)

                    end

                elseif command == 't' then
                    
                    if windower.ffxi.get_mob_by_target('t') then
                        local target = windower.ffxi.get_mob_by_target('t')

                        if type(target) == 'table' and helpers['target'].isEnemy(target) then
                            bp.helpers['target'].targets.player = target

                        else
                            bp.helpers['target'].targets.player = false

                        end

                    end
                    bp.helpers['target'].resetTargets()

                elseif command == 'pt' then
                    
                    if windower.ffxi.get_mob_by_target('t') then
                        local target = windower.ffxi.get_mob_by_target('t')

                        if type(target) == 'table' and helpers['target'].isEnemy(target) then
                            bp.helpers['target'].targets.party = target
                            windower.send_command(string.format('ord r* bp target share %s', target.id))

                        else
                            bp.helpers['target'].targets.party = false

                        end

                    end
                    bp.helpers['target'].resetTargets()

                elseif command == 'et' and (commands[3] or windower.ffxi.get_mob_by_target('t')) then
                    local target = commands[3] or windower.ffxi.get_mob_by_target('t')

                    if type(target) == 'table' then
                        bp.helpers['target'].setEntrust(target)

                    elseif (type(target) == 'number' or tonumber(target) ~= nil) then
                        bp.helpers['target'].setEntrust(target)

                    elseif type(target) == 'string' then
                        bp.helpers['target'].setEntrust(target)

                    end
                    bp.helpers['target'].resetTargets()

                elseif command == 'lt' and (commands[3] or windower.ffxi.get_mob_by_target('t')) then
                    local target = commands[3] or windower.ffxi.get_mob_by_target('t')

                    if type(target) == 'table' then
                        bp.helpers['target'].setLuopan(target)

                    elseif (type(target) == 'number' or tonumber(target) ~= nil) then
                        bp.helpers['target'].setLuopan(target)

                    elseif type(target) == 'string' then
                        bp.helpers['target'].setLuopan(target)

                    end
                    bp.helpers['target'].resetTargets()

                elseif command == 'share' and commands[3] and tonumber(commands[3]) ~= nil then
                    local target = windower.ffxi.get_mob_by_id(tonumber(commands[3])) or false

                    if type(target) == 'table' and helpers['target'].isEnemy(target) then
                        bp.helpers['target'].targets.party = target
                    end

                elseif command == 'mode' then
                    bp.helpers['target'].changeMode(bp)

                elseif command == 'pos' and commands[3] then
                    bp.helpers['target'].pos(commands[3], commands[4] or false)

                end

            end

        end

    end

    return self

end
return target.new()
