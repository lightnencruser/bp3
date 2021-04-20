local commands  = {}
local files     = require('files')
local money     = false

if files.new('bp/helpers/moneyteam/moneyteam.lua'):exists() then
    money = dofile(string.format('%sbp/helpers/moneyteam/moneyteam.lua', windower.addon_path))
end

commands.new = function()
    local self = {}

    self.captureCore = function(bp, commands)
        local bp    = bp or false
        local core  = bp.core or false
        local msg   = ''
        
        if core and commands and commands[1] then
            local command   = windower.convert_auto_trans(commands[1])
            local player    = windower.ffxi.get_player()
            
            if command == 'toggle' then
                
                if bp.settings['Enabled'] then
                    bp.settings['Enabled'] = false
                    bp.helpers['queue'].clear()
                    msg = ('BUDDYPAL AUTOMATION NOW DISABLED!')

                else
                    bp.settings['Enabled'] = true
                    msg = ('BUDDYPAL AUTOMATION NOW ENABLED!')

                end
            
            elseif command == 'on' then
                bp.settings['Enabled'] = true
                msg = ('BUDDYPAL AUTOMATION NOW ENABLED!')

            elseif command == 'off' then
                bp.settings['Enabled'] = false
                bp.helpers['queue'].clear()
                msg = ('BUDDYPAL AUTOMATION NOW DISABLED!')

            elseif command == 'wring' then
                bp.pinger = os.clock() + 15

                do -- Equip Warp Ring then delay the command for 12 seconds.
                    windower.send_command("equip L.Ring 'Warp Ring'; wait 12; input /item 'Warp Ring' <me>")
                    msg = ('ATTEMPTING TO USE WARP RING...')
                end

            elseif command == 'demring' then
                bp.pinger = os.clock() + 15

                do -- Equip Dem Ring then delay the command for 12 seconds.
                    windower.send_command("equip L.Ring 'Dimensional Ring (Dem)'; wait 12; input /item 'Dimensional Ring (Dem)' <me>")
                    msg = ('ATTEMPTING TO USE DIMENSIONAL RING...')
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

            elseif command == 'debuff' then
                core.nextSetting(bp, 'DEBUFF')

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

            elseif command == 'status' and not commands[2] then
                core.nextSetting(bp, 'STATUS')

            elseif command == 'status' and commands[2] and commands[2] == 'pos' and commands[3] then
                bp.helpers['status'].pos(bp, commands[3], commands[4] or false)

            elseif command == 'burst' then
                core.nextSetting(bp, 'BURST')

            elseif command == 'tier' then
                core.nextSetting(bp, 'NUKE TIER')

            elseif command == 'aoe' then
                core.nextSetting(bp, 'ALLOW AOE')

            elseif command == 'nukeonly' then
                core.nextSetting(bp, 'NUKE ONLY')

            elseif command == 'multinuke' then
                core.nextSetting(bp, 'MULTINUKE')

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

            elseif (command == 'skin' or command == 'stoneskin') then
                core.nextSetting(bp, 'STONESKIN')

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

            elseif command == 'rage' then
                core.nextSetting(bp, 'BPRAGE')

            elseif command == 'ward' then
                core.nextSetting(bp, 'BPWARD')

            elseif command == 'tools' then
                core.nextSetting(bp, 'NIN TOOLS')

            elseif command == 'rotate' then
                core.nextSetting(bp, 'ROTATE WARDS')

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

            elseif command == 'myrkr' then
                local mpp = tonumber(commands[2])

                if hpp and hpp > 0 and hpp <= 100 then
                    core.setSetting(bp, 'MYRKR MPP', mpp)

                else
                    msg = ('MYRKR MP% MUST BE BETWEEN 1-100!')

                end

            elseif command == 'moonlight' then
                local mpp = tonumber(commands[2])

                if hpp and hpp > 0 and hpp <= 100 then
                    core.setSetting(bp, 'MOONLIGHT MPP', mpp)

                else
                    msg = ('MOONLIGHT MP% MUST BE BETWEEN 1-100!')

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

                        if weaponskill:sub(1,9):lower() == match:sub(1,9):lower() then
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
                    local elements  = bp.core['ELEMENT'][1]
                    local fail      = true

                    for _,v in pairs(elements) do
                        
                        if v and element:sub(1, 6) == v:sub(1, 6):lower() then
                            core.setSetting(bp, 'ELEMENT', v)
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

            elseif money then
                money.capture(bp, commands)

            end

            if msg ~= '' then
                bp.helpers['popchat'].pop(tostring(msg))
            end

        end

    end

    self.captureChat = function(bp, message, sender, mode, gm)
        local bp        = bp or false
        local message   = message or false
        local sender    = sender or false
        local allowed   = false

        if gm then
            return
        end

        for _,v in pairs(bp.settings.Controllers) do
            if v == sender then
                allowed = true
            end
        end
        
        if bp and message and sender and allowed then
            local player  = windower.ffxi.get_player()
            
            do -- Run Jobs based chat commands.
                bp.helpers['commands'][player.main_job:lower()](bp, message, sender)
            end
            
        end
        
    end
        
    self.war = function(bp, message, sender)
        local message = message or false
        local sender  = sender or false
    
        if message and sender then
            local player  = windower.ffxi.get_player()
            local count   = #message:split(" ")
            local message = message:split(" ")
            
        end
        
    end
    
    self.mnk = function(bp, message, sender)
        local message = message or false
        local sender  = sender or false
        
        if message and sender then
            
        end
        
    end
        
    self.whm = function(bp, message, sender)
        local message = message or false
        local sender  = sender or false
        
        if bp and message and sender then
            local target  = windower.ffxi.get_mob_by_name(sender)
            local player  = windower.ffxi.get_player()
            local count   = #message:split(" ")
            local message = message:split(" ")
            
            -- Only one command was detected.
            if count == 1 and message[1] then
                local command = message[1]:lower()
                
                if command == "haste" and bp.helpers["target"].castable(bp, target, bp.MA["Haste"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Haste"], target)
                    
                elseif command == "protect" and bp.helpers["target"].castable(bp, target, bp.MA["Protect"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Protect V"], target)
                    
                elseif command == "protectra" and bp.helpers["target"].castable(bp, player, bp.MA["Protectra"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Protectra V"], player)
                
                elseif command == "shell" and bp.helpers["target"].castable(bp, target, bp.MA["Shell"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Shell V"], target)
                    
                elseif command == "shellra" and bp.helpers["target"].castable(bp, player, bp.MA["Shellra"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Shellra V"], player)
                    
                elseif command == "auspice" and bp.helpers["target"].castable(bp, player, bp.MA["Auspice"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Auspice"], player)
                    
                elseif command == "regen" and bp.helpers["target"].castable(bp, target, bp.MA["Regen"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Regen IV"], target)
                    
                elseif command == "erase" and bp.helpers["target"].castable(bp, target, bp.MA["Erase"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Erase"], target)
                    
                elseif command == "para" and bp.helpers["target"].castable(bp, target, bp.MA["Paralyna"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Paralyna"], target)
                    
                elseif (command == "stoned" or command == "stona") and bp.helpers["target"].castable(bp, target, bp.MA["Stona"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Stona"], target)
                    
                elseif (command == "curse" or command == "doom") and bp.helpers["target"].castable(bp, target, bp.MA["Cursna"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Cursna"], target)

                elseif command == "earth+" and bp.helpers["target"].castable(bp, target, bp.MA["Sandstorm"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Sandstorm"], target)

                elseif command == "water+" and bp.helpers["target"].castable(bp, target, bp.MA["Rainstorm"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Rainstorm"], target)

                elseif command == "wind+" and bp.helpers["target"].castable(bp, target, bp.MA["Windstorm"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Windstorm"], target)

                elseif command == "fire+" and bp.helpers["target"].castable(bp, target, bp.MA["Firestorm"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Firestorm"], target)

                elseif command == "ice+" and bp.helpers["target"].castable(bp, target, bp.MA["Hailstorm"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Hailstorm"], target)

                elseif command == "thunder+" and bp.helpers["target"].castable(bp, target, bp.MA["Thunderstorm"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Thunderstorm"], target)

                elseif command == "dark+" and bp.helpers["target"].castable(bp, target, bp.MA["Voidstorm"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Voidstorm"], target)

                elseif command == "light+" and bp.helpers["target"].castable(bp, target, bp.MA["Aurorastorm"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Aurorastorm"], target)
                        
                elseif command == "zzz" then
                    
                    if bp.helpers["target"].castable(bp, target, bp.MA["Curaga"]) and bp.helpers['party'].isInParty(target, false) then
                        bp.helpers['queue'].add(bp, bp.MA["Curaga"], target)
                        
                    elseif bp.helpers["target"].castable(bp, target, bp.MA["Cure"]) and bp.helpers['party'].isInParty(target, true) then
                        bp.helpers['queue'].add(bp, bp.MA["Cure"], target)
                    
                    end
                    
                elseif command == "firebuff" and bp.helpers["target"].castable(bp, player, bp.MA["Auspice"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Protectra V"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Shellra V"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Boost-STR"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Barfira"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Baramnesra"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Auspice"], player)
                    
                elseif command == "waterbuff" and bp.helpers["target"].castable(bp, player, bp.MA["Auspice"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Protectra V"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Shellra V"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Boost-DEX"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Barwatera"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Barpoisonra"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Auspice"], player)
                    
                elseif command == "icebuff" and bp.helpers["target"].castable(bp, player, bp.MA["Auspice"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Protectra V"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Shellra V"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Boost-DEX"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Barblizzara"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Barparalyzra"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Auspice"], player)
                    
                elseif command == "windbuff" and bp.helpers["target"].castable(bp, player, bp.MA["Auspice"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Protectra V"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Shellra V"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Boost-DEX"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Baraera"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Barsilencera"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Auspice"], player)
                    
                elseif command == "stonebuff" and bp.helpers["target"].castable(bp, player, bp.MA["Auspice"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Protectra V"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Shellra V"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Boost-DEX"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Barstonera"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Barpetra"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Auspice"], player)
                    
                elseif command == "thunderbuff" and bp.helpers["target"].castable(bp, player, bp.MA["Auspice"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Protectra V"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Shellra V"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Boost-DEX"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Barthundra"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Barsilencera"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Auspice"], player)
                        
                elseif (command == "raise" or command == "arise") and bp.helpers['target'].isDead(bp, target) then
                        
                    if bp.helpers['actions'].isReady(bp, 'MA', "Arise") then
                        bp.helpers['queue'].add(bp, bp.MA["Arise"], target)
                        
                    elseif bp.helpers['actions'].isReady(bp, 'MA', "Raise III") then
                        bp.helpers['queue'].add(bp, bp.MA["Raise III"], target)
                        
                    elseif bp.helpers['actions'].isReady(bp, 'MA', "Raise II") then
                        bp.helpers['queue'].add(bp, bp.MA["Raise II"], target)
                        
                    elseif bp.helpers['actions'].isReady(bp, 'MA', "Raise") then
                        bp.helpers['queue'].add(bp, bp.MA["Raise"], target)
                        
                    end
                    
                elseif command == "aoeregen" and bp.helpers["target"].castable(bp, target, bp.MA["Regen"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    
                    if bp.helpers['actions'].isReady(bp, 'MA', "Regen IV") and bp.helpers['actions'].isReady(bp, 'JA', "Accession") and player.sub_job == "SCH" then
                        bp.helpers['queue'].add(bp, bp.JA["Accession"], "me")
                        bp.helpers['queue'].add(bp, bp.MA["Regen IV"], target)
                        
                    end
                
                elseif command == "holla" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Holla"], player)
                    
                elseif command == "dem" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Dem"], player)
                    
                elseif command == "mea" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Mea"], player)
                    
                elseif command == "yhoat" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Yhoat"], player)
                    
                elseif command == "altepa" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Altepa"], player)
                    
                elseif command == "vazhl" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Vahzl"], player)
                    
                elseif command == "jugner" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Recall-Jugner"], player)
                    
                elseif command == "pash" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Recall-Pashh"], player)
                    
                elseif command == "meriph" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Recall-Meriph"], player)
                
                end
                
            end
            
        end
        
    end
        
    self.blm = function(bp, message, sender)
        local message = message or false
        local sender  = sender or false
        
        if message and sender then
            local target  = windower.ffxi.get_mob_by_name(sender)
            local player  = windower.ffxi.get_player()
            local count   = #message:split(" ")
            local message = message:split(" ")
                
            -- Only one command was detected.
            if count == 1 and message[1] then
                local command = message[1]:lower()
                
                if command == "haste" and bp.helpers["target"].castable(bp, target, bp.MA["Haste"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Haste"], target)
                    
                elseif command == "protect" and bp.helpers["target"].castable(bp, target, bp.MA["Protect"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Protect V"], target)
                    
                elseif command == "protectra" and bp.helpers["target"].castable(bp, player, bp.MA["Protectra"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Protectra V"], player)
                
                elseif command == "shell" and bp.helpers["target"].castable(bp, target, bp.MA["Shell"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Shell V"], target)
                    
                elseif command == "shellra" and bp.helpers["target"].castable(bp, player, bp.MA["Shellra"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Shellra V"], player)
                    
                elseif command == "auspice" and bp.helpers["target"].castable(bp, player, bp.MA["Auspice"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Auspice"], player)
                    
                elseif command == "regen" and bp.helpers["target"].castable(bp, target, bp.MA["Regen"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Regen IV"], target)
                    
                elseif command == "erase" and bp.helpers["target"].castable(bp, target, bp.MA["Erase"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Erase"], target)
                    
                elseif command == "para" and bp.helpers["target"].castable(bp, target, bp.MA["Paralyna"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Paralyna"], target)
                    
                elseif (command == "stoned" or command == "stona") and bp.helpers["target"].castable(bp, target, bp.MA["Stona"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Stona"], target)
                    
                elseif (command == "curse" or command == "doom") and bp.helpers["target"].castable(bp, target, bp.MA["Cursna"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Cursna"], target)

                elseif command == "earth+" and bp.helpers["target"].castable(bp, target, bp.MA["Sandstorm"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Sandstorm"], target)

                elseif command == "water+" and bp.helpers["target"].castable(bp, target, bp.MA["Rainstorm"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Rainstorm"], target)

                elseif command == "wind+" and bp.helpers["target"].castable(bp, target, bp.MA["Windstorm"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Windstorm"], target)

                elseif command == "fire+" and bp.helpers["target"].castable(bp, target, bp.MA["Firestorm"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Firestorm"], target)

                elseif command == "ice+" and bp.helpers["target"].castable(bp, target, bp.MA["Hailstorm"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Hailstorm"], target)

                elseif command == "thunder+" and bp.helpers["target"].castable(bp, target, bp.MA["Thunderstorm"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Thunderstorm"], target)

                elseif command == "dark+" and bp.helpers["target"].castable(bp, target, bp.MA["Voidstorm"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Voidstorm"], target)

                elseif command == "light+" and bp.helpers["target"].castable(bp, target, bp.MA["Aurorastorm"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Aurorastorm"], target)
                        
                elseif command == "zzz" then
                    
                    if bp.helpers["target"].castable(bp, target, bp.MA["Curaga"]) and bp.helpers['party'].isInParty(target, false) then
                        bp.helpers['queue'].add(bp, bp.MA["Curaga"], target)
                        
                    elseif bp.helpers["target"].castable(bp, target, bp.MA["Cure"]) and bp.helpers['party'].isInParty(target, true) then
                        bp.helpers['queue'].add(bp, bp.MA["Cure"], target)
                    
                    end
                        
                elseif (command == "raise" or command == "arise") and bp.helpers['target'].isDead(bp, target) then
                        
                    if bp.helpers['actions'].isReady(bp, 'MA', "Arise") then
                        bp.helpers['queue'].add(bp, bp.MA["Arise"], player)
                        
                    elseif bp.helpers['actions'].isReady(bp, 'MA', "Raise III") then
                        bp.helpers['queue'].add(bp, bp.MA["Raise III"], player)
                        
                    elseif bp.helpers['actions'].isReady(bp, 'MA', "Raise II") then
                        bp.helpers['queue'].add(bp, bp.MA["Raise II"], player)
                        
                    elseif bp.helpers['actions'].isReady(bp, 'MA', "Raise") then
                        bp.helpers['queue'].add(bp, bp.MA["Raise"], player)
                        
                    end
                
                elseif command == "holla" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Holla"], player)
                    
                elseif command == "dem" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Dem"], player)
                    
                elseif command == "mea" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Mea"], player)
                    
                elseif command == "yhoat" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Yhoat"], player)
                    
                elseif command == "altepa" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Altepa"], player)
                    
                elseif command == "vazhl" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Vahzl"], player)
                    
                elseif command == "jugner" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Recall-Jugner"], player)
                    
                elseif command == "pash" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Recall-Pashh"], player)
                    
                elseif command == "meriph" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Recall-Meriph"], player)
                
                end
            
            -- Multiple Commands were sent.
            elseif count > 1 then
                
                for i=1, count do
                    
                    if message[1] and message[i+1] and (message[1]):sub(1, #message[1]):lower() == (player.name):sub(1, #message[1]):lower() then
                        local command = message[i+1]:lower()
                        
                        if command == "nopeeee" and bp.helpers["target"].castable(bp, target, bp.MA["Haste"]) then
                            bp.helpers['queue'].add(bp, bp.MA["Haste"], target)                            
                        end
                        
                    end
                
                end
                
            end
            
        end
        
    end
        
    self.rdm = function(bp, message, sender)
        local message = message or false
        local sender  = sender or false
        
        if message and sender then
            local target  = windower.ffxi.get_mob_by_name(sender)
            local player  = windower.ffxi.get_player()
            local count   = #message:split(" ")
            local message = message:split(" ")
                
            -- Only one command was detected.
            if count == 1 and message[1] then
                local command = message[1]:lower()
                
                if command == "haste" and bp.helpers["target"].castable(bp, target, bp.MA["Haste"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Haste"], target)
                    
                elseif command == "protect" and bp.helpers["target"].castable(bp, target, bp.MA["Protect"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Protect V"], target)
                    
                elseif command == "protectra" and bp.helpers["target"].castable(bp, player, bp.MA["Protectra"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Protectra V"], player)
                
                elseif command == "shell" and bp.helpers["target"].castable(bp, target, bp.MA["Shell"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Shell V"], target)
                    
                elseif command == "shellra" and bp.helpers["target"].castable(bp, player, bp.MA["Shellra"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Shellra V"], player)
                    
                elseif command == "auspice" and bp.helpers["target"].castable(bp, player, bp.MA["Auspice"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Auspice"], player)
                    
                elseif command == "regen" and bp.helpers["target"].castable(bp, target, bp.MA["Regen"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Regen IV"], target)
                    
                elseif command == "erase" and bp.helpers["target"].castable(bp, target, bp.MA["Erase"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Erase"], target)
                    
                elseif command == "para" and bp.helpers["target"].castable(bp, target, bp.MA["Paralyna"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Paralyna"], target)
                    
                elseif (command == "stoned" or command == "stona") and bp.helpers["target"].castable(bp, target, bp.MA["Stona"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Stona"], target)
                    
                elseif (command == "curse" or command == "doom") and bp.helpers["target"].castable(bp, target, bp.MA["Cursna"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Cursna"], target)

                elseif command == "earth+" and bp.helpers["target"].castable(bp, target, bp.MA["Sandstorm"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Sandstorm"], target)

                elseif command == "water+" and bp.helpers["target"].castable(bp, target, bp.MA["Rainstorm"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Rainstorm"], target)

                elseif command == "wind+" and bp.helpers["target"].castable(bp, target, bp.MA["Windstorm"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Windstorm"], target)

                elseif command == "fire+" and bp.helpers["target"].castable(bp, target, bp.MA["Firestorm"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Firestorm"], target)

                elseif command == "ice+" and bp.helpers["target"].castable(bp, target, bp.MA["Hailstorm"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Hailstorm"], target)

                elseif command == "thunder+" and bp.helpers["target"].castable(bp, target, bp.MA["Thunderstorm"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Thunderstorm"], target)

                elseif command == "dark+" and bp.helpers["target"].castable(bp, target, bp.MA["Voidstorm"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Voidstorm"], target)

                elseif command == "light+" and bp.helpers["target"].castable(bp, target, bp.MA["Aurorastorm"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Aurorastorm"], target)
                        
                elseif command == "zzz" then
                    
                    if bp.helpers["target"].castable(bp, target, bp.MA["Curaga"]) and bp.helpers['party'].isInParty(target, false) then
                        bp.helpers['queue'].add(bp, bp.MA["Curaga"], target)
                        
                    elseif bp.helpers["target"].castable(bp, target, bp.MA["Cure"]) and bp.helpers['party'].isInParty(target, true) then
                        bp.helpers['queue'].add(bp, bp.MA["Cure"], target)
                    
                    end
                        
                elseif (command == "raise" or command == "arise") and bp.helpers['target'].isDead(bp, target) then
                        
                    if bp.helpers['actions'].isReady(bp, 'MA', "Arise") then
                        bp.helpers['queue'].add(bp, bp.MA["Arise"], player)
                        
                    elseif bp.helpers['actions'].isReady(bp, 'MA', "Raise III") then
                        bp.helpers['queue'].add(bp, bp.MA["Raise III"], player)
                        
                    elseif bp.helpers['actions'].isReady(bp, 'MA', "Raise II") then
                        bp.helpers['queue'].add(bp, bp.MA["Raise II"], player)
                        
                    elseif bp.helpers['actions'].isReady(bp, 'MA', "Raise") then
                        bp.helpers['queue'].add(bp, bp.MA["Raise"], player)
                        
                    end
                
                elseif command == "holla" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Holla"], player)
                    
                elseif command == "dem" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Dem"], player)
                    
                elseif command == "mea" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Mea"], player)
                    
                elseif command == "yhoat" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Yhoat"], player)
                    
                elseif command == "altepa" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Altepa"], player)
                    
                elseif command == "vazhl" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Vahzl"], player)
                    
                elseif command == "jugner" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Recall-Jugner"], player)
                    
                elseif command == "pash" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Recall-Pashh"], player)
                    
                elseif command == "meriph" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Recall-Meriph"], player)
                
                end
            
            -- Multiple Commands were sent.
            elseif count > 1 then
                
                for i=1, count do
                    
                    if message[1] and message[i+1] and (message[1]):sub(1, #message[1]):lower() == (player.name):sub(1, #message[1]):lower() then
                        local command = message[i+1]:lower()
                        
                    end
                
                end
                
            end
            
        end
        
    end
        
    self.thf = function(bp, message, sender)
        local message = message or false
        local sender  = sender or false
        
        if message and sender then
            local target  = windower.ffxi.get_mob_by_name(sender)
            local player  = windower.ffxi.get_player()
            local count   = #message:split(" ")
            local message = message:split(" ")
                
            -- Only one command was detected.
            if count == 1 and message[1] then
                local command = message[1]:lower()
                
                if command == "nopeeee" and bp.helpers["target"].castable(bp, target, bp.MA["Haste"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Haste"], target)
                end
            
            -- Multiple Commands were sent.
            elseif count > 1 then
                
                for i=1, count do
                    
                    if message[1] and message[i+1] and (message[1]):sub(1, #message[1]):lower() == (player.name):sub(1, #message[1]):lower() then
                        local command = message[i+1]:lower()
                        
                        if command == "nopeeee" and bp.helpers["target"].castable(bp, target, bp.MA["Haste"]) then
                            bp.helpers['queue'].add(bp, bp.MA["Haste"], target)                            
                        end
                        
                    end
                
                end
                
            end
            
        end
        
    end
        
    self.pld = function(bp, message, sender)
        local message = message or false
        local sender  = sender or false
        
        if message and sender then
            local target  = windower.ffxi.get_mob_by_name(sender)
            local player  = windower.ffxi.get_player()
            local count   = #message:split(" ")
            local message = message:split(" ")
                
            -- Only one command was detected.
            if count == 1 and message[1] then
                local command = message[1]:lower()
                
                if command == "cover" and bp.helpers["target"].castable(bp, target, bp.JA["Cover"]) then
                    bp.helpers['queue'].add(bp, bp.JA["Cover"], target)                            
                end
            
            -- Multiple Commands were sent.
            elseif count > 1 then
                
                for i=1, count do
                    
                    if message[1] and message[i+1] and (message[1]):sub(1, #message[1]):lower() == (player.name):sub(1, #message[1]):lower() then
                        local command = message[i+1]:lower()
                        
                        if command == "cover" and bp.helpers["target"].castable(bp, target, bp.JA["Cover"]) then
                            bp.helpers['queue'].add(bp, bp.JA["Cover"], target)                            
                        end
                        
                    end
                
                end
                
            end
            
        end
        
    end
        
    self.drk = function(bp, message, sender)
        local message = message or false
        local sender  = sender or false
        
        if message and sender then
            local target  = windower.ffxi.get_mob_by_name(sender)
            local player  = windower.ffxi.get_player()
            local count   = #message:split(" ")
            local message = message:split(" ")
                
            -- Only one command was detected.
            if count == 1 and message[1] then
                local command = message[1]:lower()
                
                if command == "stun" and bp.helpers["target"].castable(bp, target, bp.MA["Stun"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Stun"], target)
                end
            
            -- Multiple Commands were sent.
            elseif count > 1 then
                
                for i=1, count do
                    
                    if message[1] and message[i+1] and (message[1]):sub(1, #message[1]):lower() == (player.name):sub(1, #message[1]):lower() then
                        local command = message[i+1]:lower()
                        
                        if command == "stun" and bp.helpers["target"].castable(bp, target, bp.MA["Stun"]) then
                            bp.helpers['queue'].add(bp, bp.MA["Stun"], target)                            
                        end
                        
                    end
                
                end
                
            end
            
        end
        
    end
        
    self.bst = function(bp, message, sender)
        local message = message or false
        local sender  = sender or false
        
        if message and sender then
            local target  = windower.ffxi.get_mob_by_name(sender)
            local player  = windower.ffxi.get_player()
            local count   = #message:split(" ")
            local message = message:split(" ")
                
            -- Only one command was detected.
            if count == 1 and message[1] then
                local command = message[1]:lower()
                
                if command == "nopeeee" and bp.helpers["target"].castable(bp, target, bp.MA["Haste"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Haste"], target)
                end
            
            -- Multiple Commands were sent.
            elseif count > 1 then
                
                for i=1, count do
                    
                    if message[1] and message[i+1] and (message[1]):sub(1, #message[1]):lower() == (player.name):sub(1, #message[1]):lower() then
                        local command = message[i+1]:lower()
                        
                        if command == "nopeeee" and bp.helpers["target"].castable(bp, target, bp.MA["Haste"]) then
                            bp.helpers['queue'].add(bp, bp.MA["Haste"], target)                            
                        end
                        
                    end
                
                end
                
            end
            
        end
        
    end
        
    self.brd = function(bp, message, sender)
        local message = message or false
        local sender  = sender or false
        
        if message and sender then
            local target  = windower.ffxi.get_mob_by_name(sender)
            local player  = windower.ffxi.get_player()
            local count   = #message:split(" ")
            local message = message:split(" ")
                
            -- Only one command was detected.
            if count == 1 and message[1] then
                local command = message[1]:lower()
                
                if command == "haste" and bp.helpers["target"].castable(bp, target, bp.MA["Haste"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Haste"], target)
                    
                elseif command == "protect" and bp.helpers["target"].castable(bp, target, bp.MA["Protect"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Protect V"], target)
                    
                elseif command == "protectra" and bp.helpers["target"].castable(bp, player, bp.MA["Protectra"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Protectra V"], player)
                
                elseif command == "shell" and bp.helpers["target"].castable(bp, target, bp.MA["Shell"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Shell V"], target)
                    
                elseif command == "shellra" and bp.helpers["target"].castable(bp, player, bp.MA["Shellra"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Shellra V"], player)
                    
                elseif command == "auspice" and bp.helpers["target"].castable(bp, player, bp.MA["Auspice"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Auspice"], player)
                    
                elseif command == "regen" and bp.helpers["target"].castable(bp, target, bp.MA["Regen"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Regen IV"], target)
                    
                elseif command == "erase" and bp.helpers["target"].castable(bp, target, bp.MA["Erase"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Erase"], target)
                    
                elseif command == "para" and bp.helpers["target"].castable(bp, target, bp.MA["Paralyna"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Paralyna"], target)
                    
                elseif (command == "stoned" or command == "stona") and bp.helpers["target"].castable(bp, target, bp.MA["Stona"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Stona"], target)
                    
                elseif (command == "curse" or command == "doom") and bp.helpers["target"].castable(bp, target, bp.MA["Cursna"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Cursna"], target)
                        
                elseif command == "zzz" then
                    
                    if bp.helpers["target"].castable(bp, target, bp.MA["Curaga"]) and bp.helpers['party'].isInParty(target, false) then
                        bp.helpers['queue'].add(bp, bp.MA["Curaga"], target)
                        
                    elseif bp.helpers["target"].castable(bp, target, bp.MA["Cure"]) and bp.helpers['party'].isInParty(target, true) then
                        bp.helpers['queue'].add(bp, bp.MA["Cure"], target)
                    
                    end
                        
                elseif (command == "raise" or command == "arise") and bp.helpers['target'].isDead(bp, target) then
                        
                    if bp.helpers['actions'].isReady(bp, 'MA', "Arise") then
                        bp.helpers['queue'].add(bp, bp.MA["Arise"], player)
                        
                    elseif bp.helpers['actions'].isReady(bp, 'MA', "Raise III") then
                        bp.helpers['queue'].add(bp, bp.MA["Raise III"], player)
                        
                    elseif bp.helpers['actions'].isReady(bp, 'MA', "Raise II") then
                        bp.helpers['queue'].add(bp, bp.MA["Raise II"], player)
                        
                    elseif bp.helpers['actions'].isReady(bp, 'MA', "Raise") then
                        bp.helpers['queue'].add(bp, bp.MA["Raise"], player)
                        
                    end
                
                elseif command == "holla" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Holla"], player)
                    
                elseif command == "dem" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Dem"], player)
                    
                elseif command == "mea" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Mea"], player)
                    
                elseif command == "yhoat" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Yhoat"], player)
                    
                elseif command == "altepa" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Altepa"], player)
                    
                elseif command == "vazhl" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Vahzl"], player)
                    
                elseif command == "jugner" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Recall-Jugner"], player)
                    
                elseif command == "pash" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Recall-Pashh"], player)
                    
                elseif command == "meriph" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Recall-Meriph"], player)
                
                end
            
            -- Multiple Commands were sent.
            elseif count > 1 then
                
                for i=1, count do
                    
                    if message[1] and message[i+1] and (message[1]):sub(1, #message[1]):lower() == (player.name):sub(1, #message[1]):lower() then
                        local command = message[i+1]:lower()
                        
                        if command == "nopeeee" and bp.helpers["target"].castable(bp, target, bp.MA["Haste"]) then
                            bp.helpers['queue'].add(bp, bp.MA["Haste"], target)                            
                        end
                        
                    end
                
                end
                
            end
            
        end
        
    end
        
    self.rng = function(bp, message, sender)
        local message = message or false
        local sender  = sender or false
        
        if message and sender then
            local target  = windower.ffxi.get_mob_by_name(sender)
            local player  = windower.ffxi.get_player()
            local count   = #message:split(" ")
            local message = message:split(" ")
                
            -- Only one command was detected.
            if count == 1 and message[1] then
                local command = message[1]:lower()
                
                if command == "nnnnnnnnnn" and bp.helpers["target"].castable(bp, target, bp.JA["Haste"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Haste"], target)
                end
            
            -- Multiple Commands were sent.
            elseif count > 1 then
                
                for i=1, count do
                    
                    if message[1] and message[i+1] and (message[1]):sub(1, #message[1]):lower() == (player.name):sub(1, #message[1]):lower() then
                        local command = message[i+1]:lower()
                        
                        if command == "nopeeee" and bp.helpers["target"].castable(bp, target, bp.MA["Haste"]) then
                            bp.helpers['queue'].add(bp, bp.MA["Haste"], target)                            
                        end
                        
                    end
                
                end
                
            end
            
        end
        
    end
        
    self.smn = function(bp, message, sender)
        local message = message or false
        local sender  = sender or false
        
        if message and sender then
            local target  = windower.ffxi.get_mob_by_name(sender)
            local player  = windower.ffxi.get_player()
            local count   = #message:split(" ")
            local message = message:split(" ")
                
            -- Only one command was detected.
            if count == 1 and message[1] then
                local command = message[1]:lower()
                
                if command == "haste" and bp.helpers["target"].castable(bp, target, bp.MA["Haste"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Haste"], target)
                    
                elseif command == "protect" and bp.helpers["target"].castable(bp, target, bp.MA["Protect"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Protect V"], target)
                    
                elseif command == "protectra" and bp.helpers["target"].castable(bp, player, bp.MA["Protectra"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Protectra V"], player)
                
                elseif command == "shell" and bp.helpers["target"].castable(bp, target, bp.MA["Shell"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Shell V"], target)
                    
                elseif command == "shellra" and bp.helpers["target"].castable(bp, player, bp.MA["Shellra"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Shellra V"], player)
                    
                elseif command == "auspice" and bp.helpers["target"].castable(bp, player, bp.MA["Auspice"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Auspice"], player)
                    
                elseif command == "regen" and bp.helpers["target"].castable(bp, target, bp.MA["Regen"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Regen IV"], target)
                    
                elseif command == "erase" and bp.helpers["target"].castable(bp, target, bp.MA["Erase"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Erase"], target)
                    
                elseif command == "para" and bp.helpers["target"].castable(bp, target, bp.MA["Paralyna"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Paralyna"], target)
                    
                elseif (command == "stoned" or command == "stona") and bp.helpers["target"].castable(bp, target, bp.MA["Stona"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Stona"], target)
                    
                elseif (command == "curse" or command == "doom") and bp.helpers["target"].castable(bp, target, bp.MA["Cursna"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Cursna"], target)

                elseif command == "earth+" and bp.helpers["target"].castable(bp, target, bp.MA["Sandstorm"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Sandstorm"], target)

                elseif command == "water+" and bp.helpers["target"].castable(bp, target, bp.MA["Rainstorm"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Rainstorm"], target)

                elseif command == "wind+" and bp.helpers["target"].castable(bp, target, bp.MA["Windstorm"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Windstorm"], target)

                elseif command == "fire+" and bp.helpers["target"].castable(bp, target, bp.MA["Firestorm"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Firestorm"], target)

                elseif command == "ice+" and bp.helpers["target"].castable(bp, target, bp.MA["Hailstorm"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Hailstorm"], target)

                elseif command == "thunder+" and bp.helpers["target"].castable(bp, target, bp.MA["Thunderstorm"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Thunderstorm"], target)

                elseif command == "dark+" and bp.helpers["target"].castable(bp, target, bp.MA["Voidstorm"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Voidstorm"], target)

                elseif command == "light+" and bp.helpers["target"].castable(bp, target, bp.MA["Aurorastorm"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Aurorastorm"], target)
                        
                elseif command == "zzz" then
                    
                    if bp.helpers["target"].castable(bp, target, bp.MA["Curaga"]) and bp.helpers['party'].isInParty(target, false) then
                        bp.helpers['queue'].add(bp, bp.MA["Curaga"], target)
                        
                    elseif bp.helpers["target"].castable(bp, target, bp.MA["Cure"]) and bp.helpers['party'].isInParty(target, true) then
                        bp.helpers['queue'].add(bp, bp.MA["Cure"], target)
                    
                    end
                        
                elseif (command == "raise" or command == "arise") and bp.helpers['target'].isDead(bp, target) then
                        
                    if bp.helpers['actions'].isReady(bp, 'MA', "Arise") then
                        bp.helpers['queue'].add(bp, bp.MA["Arise"], player)
                        
                    elseif bp.helpers['actions'].isReady(bp, 'MA', "Raise III") then
                        bp.helpers['queue'].add(bp, bp.MA["Raise III"], player)
                        
                    elseif bp.helpers['actions'].isReady(bp, 'MA', "Raise II") then
                        bp.helpers['queue'].add(bp, bp.MA["Raise II"], player)
                        
                    elseif bp.helpers['actions'].isReady(bp, 'MA', "Raise") then
                        bp.helpers['queue'].add(bp, bp.MA["Raise"], player)
                        
                    end
                
                elseif command == "holla" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Holla"], player)
                    
                elseif command == "dem" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Dem"], player)
                    
                elseif command == "mea" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Mea"], player)
                    
                elseif command == "yhoat" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Yhoat"], player)
                    
                elseif command == "altepa" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Altepa"], player)
                    
                elseif command == "vazhl" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Vahzl"], player)
                    
                elseif command == "jugner" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Recall-Jugner"], player)
                    
                elseif command == "pash" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Recall-Pashh"], player)
                    
                elseif command == "meriph" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Recall-Meriph"], player)
                
                end
            
            -- Multiple Commands were sent.
            elseif count > 1 then
                
                for i=1, count do
                    
                    if message[1] and message[i+1] and (message[1]):sub(1, #message[1]):lower() == (player.name):sub(1, #message[1]):lower() then
                        local command = message[i+1]:lower()
                        
                        if command == "nopeeee" and bp.helpers["target"].castable(bp, target, bp.MA["Haste"]) then
                            bp.helpers['queue'].add(bp, bp.MA["Haste"], target)                            
                        end
                        
                    end
                
                end
                
            end
            
        end
        
    end
        
    self.sam = function(bp, message, sender)
        local message = message or false
        local sender  = sender or false
        
        if message and sender then
            local target  = windower.ffxi.get_mob_by_name(sender)
            local player  = windower.ffxi.get_player()
            local count   = #message:split(" ")
            local message = message:split(" ")
                
            -- Only one command was detected.
            if count == 1 and message[1] then
                local command = message[1]:lower()
                
                if command == "nopeeee" and bp.helpers["target"].castable(bp, target, bp.MA["Haste"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Haste"], target)
                end
            
            -- Multiple Commands were sent.
            elseif count > 1 then
                
                for i=1, count do
                    
                    if message[1] and message[i+1] and (message[1]):sub(1, #message[1]):lower() == (player.name):sub(1, #message[1]):lower() then
                        local command = message[i+1]:lower()
                        
                        if command == "nopeeee" and bp.helpers["target"].castable(bp, target, bp.MA["Haste"]) then
                            bp.helpers['queue'].add(bp, bp.MA["Haste"], target)                            
                        end
                        
                    end
                
                end
                
            end
            
        end
        
    end
        
    self.nin = function(bp, message, sender)
        local message = message or false
        local sender  = sender or false
        
        if message and sender then
            local target  = windower.ffxi.get_mob_by_name(sender)
            local player  = windower.ffxi.get_player()
            local count   = #message:split(" ")
            local message = message:split(" ")
                
            -- Only one command was detected.
            if count == 1 and message[1] then
                local command = message[1]:lower()
                
                if command == "nopeeee" and bp.helpers["target"].castable(bp, target, bp.MA["Haste"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Haste"], target)
                end
            
            -- Multiple Commands were sent.
            elseif count > 1 then
                
                for i=1, count do
                    
                    if message[1] and message[i+1] and (message[1]):sub(1, #message[1]):lower() == (player.name):sub(1, #message[1]):lower() then
                        local command = message[i+1]:lower()
                        
                        if command == "nopeeee" and bp.helpers["target"].castable(bp, target, bp.MA["Haste"]) then
                            bp.helpers['queue'].add(bp, bp.MA["Haste"], target)                            
                        end
                        
                    end
                
                end
                
            end
            
        end
        
    end
        
    self.drg = function(bp, message, sender)
        local message = message or false
        local sender  = sender or false
        
        if message and sender then
            local target  = windower.ffxi.get_mob_by_name(sender)
            local player  = windower.ffxi.get_player()
            local count   = #message:split(" ")
            local message = message:split(" ")
                
            -- Only one command was detected.
            if count == 1 and message[1] then
                local command = message[1]:lower()
                
                if command == "nopeeee" and bp.helpers["target"].castable(bp, target, bp.MA["Haste"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Haste"], target)
                end
            
            -- Multiple Commands were sent.
            elseif count > 1 then
                
                for i=1, count do
                    
                    if message[1] and message[i+1] and (message[1]):sub(1, #message[1]):lower() == (player.name):sub(1, #message[1]):lower() then
                        local command = message[i+1]:lower()
                        
                        if command == "nopeeee" and bp.helpers["target"].castable(bp, target, bp.MA["Haste"]) then
                            bp.helpers['queue'].add(bp, bp.MA["Haste"], target)                            
                        end
                        
                    end
                
                end
                
            end
            
        end
        
    end
        
    self.blu = function(bp, message, sender)
        local message = message or false
        local sender  = sender or false
        local job     = windower.ffxi.get_player().main_job
        
        if message and sender then
            local target  = windower.ffxi.get_mob_by_name(sender)
            local player  = windower.ffxi.get_player()
            local count   = #message:split(" ")
            local message = message:split(" ")
                
            -- Only one command was detected.
            if count == 1 and message[1] then
                local command = message[1]:lower()
                
                if command == "nopeeee" and bp.helpers["target"].castable(bp, target, bp.MA["Haste"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Haste"], target)
                end
            
            -- Multiple Commands were sent.
            elseif count > 1 then
                
                for i=1, count do
                    
                    if message[1] and message[i+1] and (message[1]):sub(1, #message[1]):lower() == (player.name):sub(1, #message[1]):lower() then
                        local command = message[i+1]:lower()
                        
                        if command == "nopeeee" and bp.helpers["target"].castable(bp, target, bp.MA["Haste"]) then
                            bp.helpers['queue'].add(bp, bp.MA["Haste"], target)                            
                        end
                        
                    end
                
                end
                
            end
            
        end
        
    end
        
    self.cor = function(bp, message, sender)
        local message = message or false
        local sender  = sender or false
        
        if message and sender then
            local target  = windower.ffxi.get_mob_by_name(sender)
            local player  = windower.ffxi.get_player()
            local count   = #message:split(" ")
            local message = message:split(" ")
                
            -- Only one command was detected.
            if count == 1 and message[1] then
                local command = message[1]:lower()
                
                if command == "nopeeee" and bp.helpers["target"].castable(bp, target, bp.MA["Haste"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Haste"], target)
                end
            
            -- Multiple Commands were sent.
            elseif count > 1 then
                
                for i=1, count do
                    
                    if message[1] and message[i+1] and (message[1]):sub(1, #message[1]):lower() == (player.name):sub(1, #message[1]):lower() then
                        local command = message[i+1]:lower()
                        
                        if command == "nopeeee" and bp.helpers["target"].castable(bp, target, bp.MA["Haste"]) then
                            bp.helpers['queue'].add(bp, bp.MA["Haste"], target)                            
                        end
                        
                    end
                
                end
                
            end
            
        end
        
    end
        
    self.pup = function(bp, message, sender)
        local message = message or false
        local sender  = sender or false
        
        if message and sender then
            local target  = windower.ffxi.get_mob_by_name(sender)
            local player  = windower.ffxi.get_player()
            local count   = #message:split(" ")
            local message = message:split(" ")
                
            -- Only one command was detected.
            if count == 1 and message[1] then
                local command = message[1]:lower()
                
                if command == "nopeeee" and bp.helpers["target"].castable(bp, target, bp.MA["Haste"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Haste"], target)
                end
            
            -- Multiple Commands were sent.
            elseif count > 1 then
                
                for i=1, count do
                    
                    if message[1] and message[i+1] and (message[1]):sub(1, #message[1]):lower() == (player.name):sub(1, #message[1]):lower() then
                        local command = message[i+1]:lower()
                        
                        if command == "nopeeee" and bp.helpers["target"].castable(bp, target, bp.MA["Haste"]) then
                            bp.helpers['queue'].add(bp, bp.MA["Haste"], target)                            
                        end
                        
                    end
                
                end
                
            end
            
        end
        
    end
        
    self.dnc = function(bp, message, sender)
        local message = message or false
        local sender  = sender or false
        
        if message and sender then
            local target  = windower.ffxi.get_mob_by_name(sender)
            local player  = windower.ffxi.get_player()
            local count   = #message:split(" ")
            local message = message:split(" ")
                
            -- Only one command was detected.
            if count == 1 and message[1] then
                local command = message[1]:lower()
                
                if command == "nopeeee" and bp.helpers["target"].castable(bp, target, bp.MA["Haste"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Haste"], target)
                end
            
            -- Multiple Commands were sent.
            elseif count > 1 then
                
                for i=1, count do
                    
                    if message[1] and message[i+1] and (message[1]):sub(1, #message[1]):lower() == (player.name):sub(1, #message[1]):lower() then
                        local command = message[i+1]:lower()
                        
                        if command == "nopeeee" and bp.helpers["target"].castable(bp, target, bp.MA["Haste"]) then
                            bp.helpers['queue'].add(bp, bp.MA["Haste"], target)                            
                        end
                        
                    end
                
                end
                
            end
            
        end
        
    end
        
    self.sch = function(bp, message, sender)
        local message = message or false
        local sender  = sender or false
        
        if message and sender then
            local target  = windower.ffxi.get_mob_by_name(sender)
            local player  = windower.ffxi.get_player()
            local count   = #message:split(" ")
            local message = message:split(" ")
                
            -- Only one command was detected.
            if count == 1 and message[1] then
                local command = message[1]:lower()
                
                if command == "haste" and bp.helpers["target"].castable(bp, target, bp.MA["Haste"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Haste"], target)
                    
                elseif command == "protect" and bp.helpers["target"].castable(bp, target, bp.MA["Protect"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Protect V"], target)
                    
                elseif command == "protectra" and bp.helpers["target"].castable(bp, player, bp.MA["Protectra"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Protectra V"], player)
                
                elseif command == "shell" and bp.helpers["target"].castable(bp, target, bp.MA["Shell"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Shell V"], target)
                    
                elseif command == "shellra" and bp.helpers["target"].castable(bp, player, bp.MA["Shellra"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Shellra V"], player)
                    
                elseif command == "auspice" and bp.helpers["target"].castable(bp, player, bp.MA["Auspice"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Auspice"], player)
                    
                elseif command == "regen" and bp.helpers["target"].castable(bp, target, bp.MA["Regen"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Regen IV"], target)
                    
                elseif command == "erase" and bp.helpers["target"].castable(bp, target, bp.MA["Erase"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Erase"], target)
                    
                elseif command == "para" and bp.helpers["target"].castable(bp, target, bp.MA["Paralyna"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Paralyna"], target)
                    
                elseif (command == "stoned" or command == "stona") and bp.helpers["target"].castable(bp, target, bp.MA["Stona"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Stona"], target)
                    
                elseif (command == "curse" or command == "doom") and bp.helpers["target"].castable(bp, target, bp.MA["Cursna"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Cursna"], target)

                elseif command == "earth+" and bp.helpers["target"].castable(bp, target, bp.MA["Sandstorm II"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Sandstorm II"], target)

                elseif command == "water+" and bp.helpers["target"].castable(bp, target, bp.MA["Rainstorm II"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Rainstorm II"], target)

                elseif command == "wind+" and bp.helpers["target"].castable(bp, target, bp.MA["Windstorm II"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Windstorm II"], target)

                elseif command == "fire+" and bp.helpers["target"].castable(bp, target, bp.MA["Firestorm II"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Firestorm II"], target)

                elseif command == "ice+" and bp.helpers["target"].castable(bp, target, bp.MA["Hailstorm II"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Hailstorm II"], target)

                elseif command == "thunder+" and bp.helpers["target"].castable(bp, target, bp.MA["Thunderstorm II"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Thunderstorm II"], target)

                elseif command == "dark+" and bp.helpers["target"].castable(bp, target, bp.MA["Voidstorm II"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Voidstorm II"], target)

                elseif command == "light+" and bp.helpers["target"].castable(bp, target, bp.MA["Aurorastorm II"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Aurorastorm II"], target)
                        
                elseif command == "zzz" then
                    
                    if bp.helpers["target"].castable(bp, target, bp.MA["Curaga"]) and bp.helpers['party'].isInParty(target, false) then
                        bp.helpers['queue'].add(bp, bp.MA["Curaga"], target)
                        
                    elseif bp.helpers["target"].castable(bp, target, bp.MA["Cure"]) and bp.helpers['party'].isInParty(target, true) then
                        bp.helpers['queue'].add(bp, bp.MA["Cure"], target)
                    
                    end
                    
                elseif command == "firebuff" and bp.helpers["target"].castable(bp, player, bp.MA["Auspice"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Protectra V"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Shellra V"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Boost-STR"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Barfira"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Baramnesra"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Auspice"], player)
                    
                elseif command == "waterbuff" and bp.helpers["target"].castable(bp, player, bp.MA["Auspice"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Protectra V"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Shellra V"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Boost-DEX"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Barwatera"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Barpoisonra"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Auspice"], player)
                    
                elseif command == "icebuff" and bp.helpers["target"].castable(bp, player, bp.MA["Auspice"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Protectra V"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Shellra V"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Boost-DEX"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Barblizzara"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Barparalyzra"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Auspice"], player)
                    
                elseif command == "windbuff" and bp.helpers["target"].castable(bp, player, bp.MA["Auspice"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Protectra V"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Shellra V"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Boost-DEX"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Baraera"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Barsilencera"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Auspice"], player)
                    
                elseif command == "stonebuff" and bp.helpers["target"].castable(bp, player, bp.MA["Auspice"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Protectra V"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Shellra V"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Boost-DEX"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Barstonera"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Barpetra"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Auspice"], player)
                    
                elseif command == "thunderbuff" and bp.helpers["target"].castable(bp, player, bp.MA["Auspice"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Protectra V"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Shellra V"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Boost-DEX"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Barthundra"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Barsilencera"], player)
                    bp.helpers['queue'].add(bp, bp.MA["Auspice"], player)
                        
                elseif (command == "raise" or command == "arise") and bp.helpers['target'].isDead(bp, target) then
                        
                    if bp.helpers['actions'].isReady(bp, 'MA', "Arise") then
                        bp.helpers['queue'].add(bp, bp.MA["Arise"], player)
                        
                    elseif bp.helpers['actions'].isReady(bp, 'MA', "Raise III") then
                        bp.helpers['queue'].add(bp, bp.MA["Raise III"], player)
                        
                    elseif bp.helpers['actions'].isReady(bp, 'MA', "Raise II") then
                        bp.helpers['queue'].add(bp, bp.MA["Raise II"], player)
                        
                    elseif bp.helpers['actions'].isReady(bp, 'MA', "Raise") then
                        bp.helpers['queue'].add(bp, bp.MA["Raise"], player)
                        
                    end
                    
                elseif command == "aoeregen" and bp.helpers["target"].castable(bp, target, bp.MA["Regen"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    
                    if bp.helpers['actions'].isReady(bp, 'MA', "Regen IV") and bp.helpers['actions'].isReady(bp, 'JA', "Accession") and player.sub_job == "SCH" then
                        bp.helpers['queue'].add(bp, bp.JA["Accession"], "me")
                        bp.helpers['queue'].add(bp, bp.MA["Regen IV"], player)
                        
                    end
                
                elseif command == "holla" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Holla"], player)
                    
                elseif command == "dem" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Dem"], player)
                    
                elseif command == "mea" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Mea"], player)
                    
                elseif command == "yhoat" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Yhoat"], player)
                    
                elseif command == "altepa" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Altepa"], player)
                    
                elseif command == "vazhl" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Vahzl"], player)
                    
                elseif command == "jugner" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Recall-Jugner"], player)
                    
                elseif command == "pash" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Recall-Pashh"], player)
                    
                elseif command == "meriph" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Recall-Meriph"], player)
                
                end
            
            -- Multiple Commands were sent.
            elseif count > 1 then
                
                for i=1, count do
                    
                    if message[1] and message[i+1] and (message[1]):sub(1, #message[1]):lower() == (player.name):sub(1, #message[1]):lower() then
                        local command = message[i+1]:lower()
                        
                    end
                
                end
                
            end
            
        end
        
    end
        
    self.geo = function(bp, message, sender)
        local message = message or false
        local sender  = sender or false
        
        if message and sender then
            local target  = windower.ffxi.get_mob_by_name(sender)
            local player  = windower.ffxi.get_player()
            local count   = #message:split(" ")
            local message = message:split(" ")
                
            -- Only one command was detected.
            if count == 1 and message[1] then
                local command = message[1]:lower()
                
                if command == "haste" and bp.helpers["target"].castable(bp, target, bp.MA["Haste"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Haste"], target)
                    
                elseif command == "protect" and bp.helpers["target"].castable(bp, target, bp.MA["Protect"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Protect V"], target)
                    
                elseif command == "protectra" and bp.helpers["target"].castable(bp, player, bp.MA["Protectra"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Protectra V"], player)
                
                elseif command == "shell" and bp.helpers["target"].castable(bp, target, bp.MA["Shell"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Shell V"], target)
                    
                elseif command == "shellra" and bp.helpers["target"].castable(bp, player, bp.MA["Shellra"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Shellra V"], player)
                    
                elseif command == "auspice" and bp.helpers["target"].castable(bp, player, bp.MA["Auspice"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Auspice"], player)
                    
                elseif command == "regen" and bp.helpers["target"].castable(bp, target, bp.MA["Regen"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Regen IV"], target)
                    
                elseif command == "erase" and bp.helpers["target"].castable(bp, target, bp.MA["Erase"]) and bp.helpers['party'].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Erase"], target)
                    
                elseif command == "para" and bp.helpers["target"].castable(bp, target, bp.MA["Paralyna"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Paralyna"], target)
                    
                elseif (command == "stoned" or command == "stona") and bp.helpers["target"].castable(bp, target, bp.MA["Stona"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Stona"], target)
                    
                elseif (command == "curse" or command == "doom") and bp.helpers["target"].castable(bp, target, bp.MA["Cursna"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Cursna"], target)

                elseif command == "earth+" and bp.helpers["target"].castable(bp, target, bp.MA["Sandstorm"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Sandstorm"], target)

                elseif command == "water+" and bp.helpers["target"].castable(bp, target, bp.MA["Rainstorm"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Rainstorm"], target)

                elseif command == "wind+" and bp.helpers["target"].castable(bp, target, bp.MA["Windstorm"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Windstorm"], target)

                elseif command == "fire+" and bp.helpers["target"].castable(bp, target, bp.MA["Firestorm"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Firestorm"], target)

                elseif command == "ice+" and bp.helpers["target"].castable(bp, target, bp.MA["Hailstorm"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Hailstorm"], target)

                elseif command == "thunder+" and bp.helpers["target"].castable(bp, target, bp.MA["Thunderstorm"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Thunderstorm"], target)

                elseif command == "dark+" and bp.helpers["target"].castable(bp, target, bp.MA["Voidstorm"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Voidstorm"], target)

                elseif command == "light+" and bp.helpers["target"].castable(bp, target, bp.MA["Aurorastorm"]) then
                    bp.helpers['queue'].add(bp, bp.MA["Aurorastorm"], target)
                        
                elseif command == "zzz" then
                    
                    if bp.helpers["target"].castable(bp, target, bp.MA["Curaga"]) and bp.helpers['party'].isInParty(target, false) then
                        bp.helpers['queue'].add(bp, bp.MA["Curaga"], target)
                        
                    elseif bp.helpers["target"].castable(bp, target, bp.MA["Cure"]) and bp.helpers['party'].isInParty(target, true) then
                        bp.helpers['queue'].add(bp, bp.MA["Cure"], target)
                    
                    end
                        
                elseif (command == "raise" or command == "arise") and bp.helpers['target'].isDead(bp, target) then
                        
                    if bp.helpers['actions'].isReady(bp, 'MA', "Arise") then
                        bp.helpers['queue'].add(bp, bp.MA["Arise"], player)
                        
                    elseif bp.helpers['actions'].isReady(bp, 'MA', "Raise III") then
                        bp.helpers['queue'].add(bp, bp.MA["Raise III"], player)
                        
                    elseif bp.helpers['actions'].isReady(bp, 'MA', "Raise II") then
                        bp.helpers['queue'].add(bp, bp.MA["Raise II"], player)
                        
                    elseif bp.helpers['actions'].isReady(bp, 'MA', "Raise") then
                        bp.helpers['queue'].add(bp, bp.MA["Raise"], player)
                        
                    end
                
                elseif command == "holla" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Holla"], player)
                    
                elseif command == "dem" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Dem"], player)
                    
                elseif command == "mea" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Mea"], player)
                    
                elseif command == "yhoat" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Yhoat"], player)
                    
                elseif command == "altepa" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Altepa"], player)
                    
                elseif command == "vazhl" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Teleport-Vahzl"], player)
                    
                elseif command == "jugner" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Recall-Jugner"], player)
                    
                elseif command == "pash" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Recall-Pashh"], player)
                    
                elseif command == "meriph" and bp.helpers["party"].isInParty(bp, target, false) then
                    bp.helpers['queue'].add(bp, bp.MA["Recall-Meriph"], player)
                
                elseif command == "fcircle" and bp.helpers['actions'].isReady(bp, 'JA', 'Full Circle') then
                    bp.helpers['queue'].add(bp, bp.JA["Full Circle"], 'me')                            
                end
            
            -- Multiple Commands were sent.
            elseif count > 1 then
                
                for i=1, count do
                    
                    if message[1] and message[i+1] and (message[1]):sub(1, #message[1]):lower() == (player.name):sub(1, #message[1]):lower() then
                        local command = message[i+1]:lower()
                        
                    end
                
                end
                
            end
            
        end
        
    end

    self.run = function(bp, message, sender)
        local message = message or false
        local sender  = sender or false
        
        if message and sender then
            local target  = windower.ffxi.get_mob_by_name(sender)
            local player  = windower.ffxi.get_player()
            local count   = #message:split(" ")
            local message = message:split(" ")
                
            -- Only one command was detected.
            if count == 1 and message[1] then
                local command = message[1]:lower()
                
                if command == "ofa" and bp.helpers['actions'].isReady(bp, 'JA', 'One For All') then
                    bp.helpers['queue'].addToFront(bp, bp.JA["One For All"], target)                            
                end
            
            -- Multiple Commands were sent.
            elseif count > 1 then
                
                for i=1, count do
                    
                    if message[1] and message[i+1] and (message[1]):sub(1, #message[1]):lower() == (player.name):sub(1, #message[1]):lower() then
                        local command = message[i+1]:lower()
                        
                    end
                
                end
                
            end
            
        end
        
    end

    return self

end
return commands.new()