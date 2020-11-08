local commands = {}
commands.new = function()
    local self = {}

    self.captureCore = function(bp, commands)
        local bp    = bp or false
        local core  = bp.core or false
        local msg   = ''
        
        if core and commands and commands[1] then
            local command   = windower.convert_auto_trans(commands[1])
            local player    = windower.ffxi.get_player()
            
            if (command == 'on' or command == 'off' or command == 'toggle') then
                
                if bp.settings['Enabled'] then
                    bp.settings['Enabled'] = false
                    msg = ('BUDDYPAL AUTOMATION NOW DISABLED!')

                else
                    bp.settings['Enabled'] = true
                    msg = ('BUDDYPAL AUTOMATION NOW ENABLED!')

                end
            
            elseif command == 'am' then
                core.nextSetting(bp, 'AM')

            elseif command == 'amt' then
                core.nextSetting(bp, 'AM LEVEL')

            elseif command == '1hr' then
                core.nextSetting(bp, '1HR')

            elseif command == 'ja' then
                core.nextSetting(bp, 'JA')

            elseif command == 'buffs' then
                core.nextSetting(bp, 'BUFFS')

            elseif command == 'debuffs' then
                core.nextSetting(bp, 'DEBUFFS')

            elseif command == 'hate' then
                core.nextSetting(bp, 'HATE')

            elseif command == 'aoehate' then
                core.nextSetting(bp, 'AOEHATE')
            
            elseif command == 'ra' then
                core.nextSetting(bp, 'RA')

            elseif command == 'ws' then
                core.nextSetting(bp, 'WS')

            elseif command == 'sc' then
                core.nextSetting(bp, 'SC')

            elseif command == 'status' then
                core.nextSetting(bp, 'STATUS')

            elseif command == 'cures' then
                core.nextSetting(bp, 'CURES')

            elseif command == 'burst' then
                core.nextSetting(bp, 'BURST')

            elseif command == 'tier' then
                core.nextSetting(bp, 'TIER')

            elseif command == 'aoe' then
                core.nextSetting(bp, 'ALLOW-AOE')

            elseif command == 'drains' then
                core.nextSetting(bp, 'DRAINS')

            elseif command == 'stuns' then
                core.nextSetting(bp, 'STUNS')

            elseif command == 'spikes' then
                core.nextSetting(bp, 'SPIKES')

            elseif (command == 'dia' or command == 'bio') then
                core.nextSetting(bp, 'DIA')

            elseif (command == 'weather' or command == 'storm') then
                core.nextSetting(bp, 'WEATHER')

            elseif command == 'sub' then
                core.nextSetting(bp, 'SUBLIMATION')

            elseif command == 'composure' then
                core.nextSetting(bp, 'COMPOSURE')

            elseif command == 'convert' then
                core.nextSetting(bp, 'CONVERT')

            elseif command == 'arts' then
                core.nextSetting(bp, 'ARTS')

            elseif (command == 'white' or command == 'black') then
                core.nextSetting(bp, 'WHITE')

            elseif (command == 'misery' or command == 'solace' or command == 'afflatus') then
                core.nextSetting(bp, 'MISERY')

            elseif command == 'boost' then
                core.nextSetting(bp, 'BOOST')

            elseif command == 'steps' then
                core.nextSetting(bp, 'STEPS')

            elseif command == 'sambas' then
                core.nextSetting(bp, 'SAMBAS')

            elseif command == 'sanguine' then
                core.nextSetting(bp, 'SANGUINE')

            elseif command == 'pet' then
                core.nextSetting(bp, 'PET')

            elseif (command == 'sic' or command == 'assault') then
                core.nextSetting(bp, 'AUTO SIC')

            elseif command == 'rage' then
                core.nextSetting(bp, 'BPRAGE')

            elseif command == 'ward' then
                core.nextSetting(bp, 'BPWARD')

            elseif command == 'rotate' then
                core.nextSetting(bp, 'ROTATE')

            elseif command == 'summon' then
                core.nextSetting(bp, 'SUMMON')

            elseif command == 'utsu' then
                core.nextSetting(bp, 'SHADOWS')

            elseif command == 'skillup' then
                core.nextSetting(bp, 'SKILLUP')

            elseif command == 'skills' then
                core.nextSetting(bp, 'SKILLS')

            elseif command == 'food' then
                core.nextSetting(bp, 'FOOD')

            elseif command == 'tank' then
                core.nextSetting(bp, 'TANK MODE')

            elseif command == 'mg' then
                core.nextSetting(bp, 'MIGHTY GUARD')

            elseif command == 'blu' then
                core.nextSetting(bp, 'BLU MODE')

            elseif command == 'shots' then
                core.nextSetting(bp, 'COR SHOTS')

            elseif command == 'chiv' then
                core.nextSetting(bp, 'CHIVALRY')

            elseif command == 'sanghp' then
                local hpp = tonumber(commands[2])

                if hpp and hpp > 0 and hpp <= 100 then
                    core.setSetting(bp, 'SANGUINE HPP', hpp)

                else
                    msg = ('SANGUINE BLADE HP% MUST BE BETWEEN 1-100!')

                end

            elseif command == 'vpulsehp' then
                local hpp = tonumber(commands[2])

                if hpp and hpp > 0 and hpp <= 100 then
                    core.setSetting(bp, 'VPULSE HPP', hpp)

                else
                    msg = ('VIVACIOUS PULSE HP% MUST BE BETWEEN 1-100!')

                end

            elseif command == 'vpulsemp' then
                local mpp = tonumber(commands[2])

                if mpp and mpp > 0 and mpp <= 100 then
                    core.setSetting(bp, 'VPULSE MPP', mpp)

                else
                    msg = ('VIVACIOUS PULSE MP% MUST BE BETWEEN 1-100!')

                end
            
            elseif command == 'converthp' then
                local hpp = tonumber(commands[2])

                if hpp and hpp > 0 and hpp <= 100 then
                    core.setSetting(bp, 'CONVERT HPP', hpp)

                else
                    msg = ('CONVERT HP% MUST BE BETWEEN 1-100!')

                end

            elseif command == 'convertmp' then
                local mpp = tonumber(commands[2])

                if mpp and mpp > 0 and mpp <= 100 then
                    core.setSetting(bp, 'CONVERT MPP', mpp)

                else
                    msg = ('CONVERT MP% MUST BE BETWEEN 1-100!')

                end

            elseif command == 'wsn' then
                local weaponskill   = windower.convert_auto_trans(table.concat(commands, " "):sub(5))
                local weaponskills  = bp.res.weapon_skills
            
                for _,v in pairs(windower.ffxi.get_abilities().weapon_skills) do
                    
                    if v and weaponskills[v].en then
                        local match = (weaponskills[v].en):match(("[%a%s%'%:]+"))

                        if weaponskill:sub(1,8):lower() == match:sub(1,8):lower() then
                            core.setSetting(bp, 'WSNAME', weaponskills[v].en)
                            break
                            
                        end
                        
                    end
                    
                end

            elseif command == 'rws' then
                local weaponskill   = windower.convert_auto_trans(table.concat(commands, " "):sub(5))
                local weaponskills  = bp.res.weapon_skills

                for _,v in pairs(windower.ffxi.get_abilities().weapon_skills) do
                    
                    if v and weaponskills[v].en then
                        local match = (weaponskills[v].en):match(("[%a%s%'%:]+"))

                        if weaponskill:sub(1,8):lower() == match:sub(1,8):lower() then
                            core.setSetting(bp, 'RANGED WS', weaponskills[v].en)
                            break

                        end
                        
                    end
                    
                end

            elseif command == 'default' then
                local weaponskill   = windower.convert_auto_trans(table.concat(commands, " "):sub(7))
                local weaponskills  = bp.res.weapon_skills

                for _,v in pairs(windower.ffxi.get_abilities().weapon_skills) do
                    
                    if v and weaponskills[v].en then
                        local match = (weaponskills[v].en):match(("[%a%s%'%:]+"))
                        
                        if weaponskill:sub(1,8):lower() == match:sub(1,8):lower() then
                            core.setSetting(bp, 'DEFAULT WS', weaponskills[v].en)
                            break

                        end
                        
                    end
                    
                end

            elseif command == 'impetus' then
                local weaponskill   = windower.convert_auto_trans(table.concat(commands, " "):sub(7))
                local weaponskills  = bp.res.weapon_skills

                for _,v in pairs(windower.ffxi.get_abilities().weapon_skills) do
                    
                    if v and weaponskills[v].en then
                        local match = (weaponskills[v].en):match(("[%a%s%'%:]+"))
                        
                        if weaponskill:sub(1,8):lower() == match:sub(1,8):lower() then
                            core.setSetting(bp, 'IMPETUS WS', weaponskills[v].en)
                            break

                        end
                        
                    end
                    
                end
                
            elseif command == 'footwork' then
                local weaponskill   = windower.convert_auto_trans(table.concat(commands, " "):sub(7))
                local weaponskills  = bp.res.weapon_skills

                for _,v in pairs(windower.ffxi.get_abilities().weapon_skills) do
                    
                    if v and weaponskills[v].en then
                        local match = (weaponskills[v].en):match(("[%a%s%'%:]+"))
                        
                        if weaponskill:sub(1,8):lower() == match:sub(1,8):lower() then
                            core.setSetting(bp, 'FOOTWORK WS', weaponskills[v].en)
                            break

                        end
                        
                    end
                    
                end

            elseif command == 'sekka' then
                local weaponskill   = windower.convert_auto_trans(table.concat(commands, " "):sub(7))
                local weaponskills  = bp.res.weapon_skills

                for _,v in pairs(windower.ffxi.get_abilities().weapon_skills) do
                    
                    if v and weaponskills[v].en then
                        local match = (weaponskills[v].en):match(("[%a%s%'%:]+"))
                        
                        if weaponskill:sub(1,8):lower() == match:sub(1,8):lower() then
                            core.setSetting(bp, 'SEKKA', weaponskills[v].en)
                            break

                        end
                        
                    end
                    
                end

            elseif command == 'enspell' then
                local enspell = commands[2] or false
            
                if enspell then
                    local enspell   = windower.convert_auto_trans(enspell):sub(1,3):lower()
                    local list      = bp.core['ENSPELL'][1]
                    
                    for _,v in pairs(list) do

                        if v and type(v) == 'string' and enspell == v:sub(1,3):lower() then
                            core.setSetting(bp, 'ENSPELL', v)
                            break

                        end
                        
                    end
                    
                end

            elseif command == 'gains' then
                local gain = commands[2] or false
            
                if gain then
                    local gain = windower.convert_auto_trans(commands[2]):lower()
                    local list = bp.core['GAINS'][1]

                    for _,v in pairs(list) do
                        
                        if v and type(v) == 'string' and gain == v:lower() then
                            core.setSetting(bp, 'GAINS', v)
                            break

                        end
                        
                    end
                    
                end
            
            elseif command == 'element' then
                local element = commands[2] or false            
                
                if element then
                    local element   = windower.convert_auto_trans(element):lower() or false
                    local elements  = bp.res.elements
                    local fail      = true

                    for _,v in pairs(elements) do
                        
                        if v and element:sub(1, 6) == v.en:sub(1, 6):lower() then
                            core.setSetting(bp, 'ELEMENT', v.en)
                            fail = false
                            break

                        end
                        
                    end

                    if fail then
                        msg = ("THAT IS NOT A VALID ELEMENT!")
                    end

                end

            elseif command == 'tpt' then
                local number = tonumber(commands[2]) or false
            
                if number then
                    
                    if number > 999 and number <= 3000 then
                        core.setSetting(bp, 'TP THRESHOLD', number)
                        
                    else
                        msg = ("INVALID! - PLEASE PICK A NUMBER BETWEEN 1000 and 3000.")
                        
                    end
                
                end

            elseif command == 'hatedelay' then
                local number = tonumber(commands[2]) or false
            
                if number then
                    
                    if number > 0 and number <= 60 then
                        core.setSetting(bp, 'HATE DELAY', number)
                        
                    else
                        msg = ("INVALID! - PLEASE PICK A NUMBER BETWEEN 1 and 60.")
                        
                    end
                
                end

            end

            if msg ~= '' then
                bp.helpers['popchat'].pop(tostring(msg))
            end

        end

    end

    return self

end
return commands.new()