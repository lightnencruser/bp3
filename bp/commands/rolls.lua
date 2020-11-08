local rolls = {}
function rolls.new()
    local self = {}

    self.capture = function(bp, commands)
        local bp        = bp or false
        local commands  = commands or false

        if bp and commands then
            local command = commands[2] or false

            if command then
                command = command:lower()
                
                if command == 'set' and commands[3] then
                    local roll1 = commands[3] or false
                    local roll2 = commands[4] or false

                    if roll1 and roll2 then
                        local roll1     = windower.convert_auto_trans(roll1) or false
                        local roll2     = windower.convert_auto_trans(roll2) or false
                        local short1    = bp.helpers['rolls'].getShort(bp, roll1)
                        local short2    = bp.helpers['rolls'].getShort(bp, roll2)
                        
                        if short1 and short2 then
                            bp.helpers['rolls'].setRoll(bp, roll1:lower(), roll2:lower())

                        elseif not short1 and not short2 and bp.JA[roll1] and bp.JA[roll2] then
                            bp.helpers['rolls'].setRoll(bp, roll1, roll2)

                        end

                    elseif roll1 and not roll2 then
                        local roll1     = windower.convert_auto_trans(roll1) or false
                        local short1    = bp.helpers['rolls'].getShort(bp, roll1:lower())
                        
                        if short1 and not short2 then
                            bp.helpers['rolls'].setRoll(bp, roll1:lower())

                        elseif not short1 and not short2 and bp.JA[roll1] and not roll2 then
                            bp.helpers['rolls'].setRoll(bp, roll1)

                        end
                        
                    end

                elseif command == 'cap' and commands[3] then
                    local cap = tonumber(commands[3])

                    if cap then
                        bp.helpers['rolls'].setCap(bp, cap)
                    end

                elseif command == 'crooked' then
                    bp.helpers['rolls'].toggleCrooked(bp)

                elseif command == 'pos' and commands[3] and commands[4] then
                    local x = tonumber(commands[3]) or false
                    local y = tonumber(commands[4]) or false

                    if x and y then
                        bp.helpers['debuffs'].pos(bp, x, y)
                    
                    elseif bp and (not x or not y) then
                        bp.helpers['popchat'].pop('PLEASE ENTER AN "X" AND "Y" COORDINATE!')

                    end

                end

            end

        end

    end

    return self

end
return rolls.new()
