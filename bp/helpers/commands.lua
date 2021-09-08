local commands  = {}
local files     = require('files')
local money     = false

if files.new('bp/helpers/moneyteam/moneyteam.lua'):exists() then
    money = dofile(string.format('%sbp/helpers/moneyteam/moneyteam.lua', windower.addon_path))
end

commands.new = function()
    local self = {}

    -- Private Variables.
    local bp = false

    -- Public Functions.
    self.setSystem = function(buddypal)
        if buddypal then
            bp = buddypal
        end

    end

    self.captureCore = function(commands)
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
                core.nextSetting('AM')

            elseif command == 'amt' then
                core.nextSetting('AM LEVEL')

            elseif command == '1hr' then
                core.nextSetting('1HR')

            elseif command == 'ja' then
                core.nextSetting('JA')

            elseif command == 'buffs' then
                core.nextSetting('BUFFS')

            elseif command == 'debuff' then
                core.nextSetting('DEBUFF')

            elseif command == 'hate' then
                core.nextSetting('HATE')

            elseif command == 'aoehate' then
                core.nextSetting('AOEHATE')
            
            elseif command == 'ra' then
                core.nextSetting('RA')

            elseif command == 'ws' then
                core.nextSetting('WS')

            elseif command == 'sc' then
                core.nextSetting('SC')

            elseif command == 'status' and not commands[2] then
                core.nextSetting('STATUS')

            elseif command == 'status' and commands[2] and commands[2] == 'pos' and commands[3] then
                bp.helpers['status'].pos(commands[3], commands[4] or false)

            elseif command == 'burst' then
                core.nextSetting('BURST')

            elseif command == 'tier' then
                core.nextSetting('NUKE TIER')

            elseif command == 'aoe' then
                core.nextSetting('ALLOW AOE')

            elseif command == 'nukeonly' then
                core.nextSetting('NUKE ONLY')

            elseif command == 'multinuke' then
                core.nextSetting('MULTINUKE')

            elseif command == 'drains' then
                core.nextSetting('DRAINS')

            elseif command == 'stuns' then
                core.nextSetting('STUNS')

            elseif command == 'spikes' then
                core.nextSetting('SPIKES')

            elseif (command == 'dia' or command == 'bio') then
                core.nextSetting('DIA')

            elseif (command == 'weather' or command == 'storm') then
                core.nextSetting('WEATHER')

            elseif command == 'sub' then
                core.nextSetting('SUBLIMATION')

            elseif (command == 'skin' or command == 'stoneskin') then
                core.nextSetting('STONESKIN')

            elseif command == 'composure' then
                core.nextSetting('COMPOSURE')

            elseif command == 'convert' then
                core.nextSetting('CONVERT')

            elseif command == 'arts' then
                core.nextSetting('ARTS')

            elseif (command == 'white' or command == 'black') then
                core.nextSetting('WHITE')

            elseif (command == 'misery' or command == 'solace' or command == 'afflatus') then
                core.nextSetting('MISERY')

            elseif command == 'boost' then
                core.nextSetting('BOOST')

            elseif command == 'steps' then
                core.nextSetting('STEPS')

            elseif command == 'sambas' then
                core.nextSetting('SAMBAS')

            elseif command == 'sanguine' then
                core.nextSetting('SANGUINE')

            elseif command == 'pet' then
                core.nextSetting('PET')

            elseif command == 'rage' then
                core.nextSetting('BPRAGE')

            elseif command == 'ward' then
                core.nextSetting('BPWARD')

            elseif command == 'tools' then
                core.nextSetting('NIN TOOLS')

            elseif command == 'rotate' then
                core.nextSetting('ROTATE WARDS')

            elseif command == 'summon' then
                core.nextSetting('SUMMON')

            elseif command == 'utsu' then
                core.nextSetting('SHADOWS')

            elseif command == 'skillup' then
                core.nextSetting('SKILLUP')

            elseif command == 'skills' then
                core.nextSetting('SKILLS')

            elseif command == 'food' then
                core.nextSetting('FOOD')

            elseif command == 'tank' then
                core.nextSetting('TANK MODE')

            elseif command == 'mg' then
                core.nextSetting('MIGHTY GUARD')

            elseif command == 'blu' then
                core.nextSetting('BLU MODE')

            elseif command == 'shots' then
                core.nextSetting('COR SHOTS')

            elseif command == 'chiv' then
                core.nextSetting('CHIVALRY')

            elseif command == 'sanghp' then
                local hpp = tonumber(commands[2])

                if hpp and hpp > 0 and hpp <= 100 then
                    core.setSetting('SANGUINE HPP', hpp)

                else
                    msg = ('SANGUINE BLADE HP% MUST BE BETWEEN 1-100!')

                end

            elseif command == 'myrkr' then
                local mpp = tonumber(commands[2])

                if hpp and hpp > 0 and hpp <= 100 then
                    core.setSetting('MYRKR MPP', mpp)

                else
                    msg = ('MYRKR MP% MUST BE BETWEEN 1-100!')

                end

            elseif command == 'moonlight' then
                local mpp = tonumber(commands[2])

                if hpp and hpp > 0 and hpp <= 100 then
                    core.setSetting('MOONLIGHT MPP', mpp)

                else
                    msg = ('MOONLIGHT MP% MUST BE BETWEEN 1-100!')

                end

            elseif command == 'vpulsehp' then
                local hpp = tonumber(commands[2])

                if hpp and hpp > 0 and hpp <= 100 then
                    core.setSetting('VPULSE HPP', hpp)

                else
                    msg = ('VIVACIOUS PULSE HP% MUST BE BETWEEN 1-100!')

                end

            elseif command == 'vpulsemp' then
                local mpp = tonumber(commands[2])

                if mpp and mpp > 0 and mpp <= 100 then
                    core.setSetting('VPULSE MPP', mpp)

                else
                    msg = ('VIVACIOUS PULSE MP% MUST BE BETWEEN 1-100!')

                end
            
            elseif command == 'converthp' then
                local hpp = tonumber(commands[2])

                if hpp and hpp > 0 and hpp <= 100 then
                    core.setSetting('CONVERT HPP', hpp)

                else
                    msg = ('CONVERT HP% MUST BE BETWEEN 1-100!')

                end

            elseif command == 'convertmp' then
                local mpp = tonumber(commands[2])

                if mpp and mpp > 0 and mpp <= 100 then
                    core.setSetting('CONVERT MPP', mpp)

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
                            core.setSetting('WSNAME', weaponskills[v].en)
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
                            core.setSetting('RANGED WS', weaponskills[v].en)
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
                            core.setSetting('DEFAULT WS', weaponskills[v].en)
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
                            core.setSetting('IMPETUS WS', weaponskills[v].en)
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
                            core.setSetting('FOOTWORK WS', weaponskills[v].en)
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
                            core.setSetting('SEKKA', weaponskills[v].en)
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

                            core.setSetting('ENSPELL', v)
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
                            core.setSetting('GAINS', v)
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
                            core.setSetting('ELEMENT', v)
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
                        core.setSetting('TP THRESHOLD', number)
                        
                    else
                        msg = ("INVALID! - PLEASE PICK A NUMBER BETWEEN 1000 and 3000.")
                        
                    end
                
                end

            elseif command == 'aspir%' then
                local number = tonumber(commands[2]) or false
            
                if number then
                    
                    if number > 0 and number <= 100 then
                        core.setSetting('ASPIR THRESHOLD', number)
                        
                    else
                        msg = ("INVALID! - PLEASE PICK A NUMBER BETWEEN 1 and 100.")
                        
                    end
                
                end

            elseif command == 'hatedelay' then
                local number = tonumber(commands[2]) or false
            
                if number then
                    
                    if number > 0 and number <= 60 then
                        core.setSetting('HATE DELAY', number)
                        
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

    self.captureChat = function(message, sender, mode, gm)
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
                bp.helpers['commands'][player.main_job:lower()](message, sender)
            end
            
        end
        
    end
        
    self.war = function(message, sender)
        local message = message or false
        local sender  = sender or false
    
        if message and sender then
            local player  = windower.ffxi.get_player()
            local count   = #message:split(" ")
            local message = message:split(" ")
            
        end
        
    end
    
    self.mnk = function(message, sender)
        local message = message or false
        local sender  = sender or false
        
        if message and sender then
            
        end
        
    end
        
    self.whm = function(message, sender)
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
                
                if command == "haste" and bp.helpers["target"].castable(target, bp.MA["Haste"]) then
                    bp.helpers['queue'].add(bp.MA["Haste"], target)
                    
                elseif command == "protect" and bp.helpers["target"].castable(target, bp.MA["Protect"]) then
                    bp.helpers['queue'].add(bp.MA["Protect V"], target)
                    
                elseif command == "protectra" and bp.helpers["target"].castable(player, bp.MA["Protectra"]) and bp.helpers['party'].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Protectra V"], player)
                
                elseif command == "shell" and bp.helpers["target"].castable(target, bp.MA["Shell"]) then
                    bp.helpers['queue'].add(bp.MA["Shell V"], target)
                    
                elseif command == "shellra" and bp.helpers["target"].castable(player, bp.MA["Shellra"]) and bp.helpers['party'].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Shellra V"], player)
                    
                elseif command == "auspice" and bp.helpers["target"].castable(player, bp.MA["Auspice"]) and bp.helpers['party'].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Auspice"], player)
                    
                elseif command == "regen" and bp.helpers["target"].castable(target, bp.MA["Regen"]) then
                    bp.helpers['queue'].add(bp.MA["Regen IV"], target)
                    
                elseif command == "erase" and bp.helpers["target"].castable(target, bp.MA["Erase"]) and bp.helpers['party'].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Erase"], target)
                    
                elseif command == "para" and bp.helpers["target"].castable(target, bp.MA["Paralyna"]) then
                    bp.helpers['queue'].add(bp.MA["Paralyna"], target)
                    
                elseif (command == "stoned" or command == "stona") and bp.helpers["target"].castable(target, bp.MA["Stona"]) then
                    bp.helpers['queue'].add(bp.MA["Stona"], target)
                    
                elseif (command == "curse" or command == "doom") and bp.helpers["target"].castable(target, bp.MA["Cursna"]) then
                    bp.helpers['queue'].add(bp.MA["Cursna"], target)

                elseif command == "earth+" and bp.helpers["target"].castable(target, bp.MA["Sandstorm"]) then
                    bp.helpers['queue'].add(bp.MA["Sandstorm"], target)

                elseif command == "water+" and bp.helpers["target"].castable(target, bp.MA["Rainstorm"]) then
                    bp.helpers['queue'].add(bp.MA["Rainstorm"], target)

                elseif command == "wind+" and bp.helpers["target"].castable(target, bp.MA["Windstorm"]) then
                    bp.helpers['queue'].add(bp.MA["Windstorm"], target)

                elseif command == "fire+" and bp.helpers["target"].castable(target, bp.MA["Firestorm"]) then
                    bp.helpers['queue'].add(bp.MA["Firestorm"], target)

                elseif command == "ice+" and bp.helpers["target"].castable(target, bp.MA["Hailstorm"]) then
                    bp.helpers['queue'].add(bp.MA["Hailstorm"], target)

                elseif command == "thunder+" and bp.helpers["target"].castable(target, bp.MA["Thunderstorm"]) then
                    bp.helpers['queue'].add(bp.MA["Thunderstorm"], target)

                elseif command == "dark+" and bp.helpers["target"].castable(target, bp.MA["Voidstorm"]) then
                    bp.helpers['queue'].add(bp.MA["Voidstorm"], target)

                elseif command == "light+" and bp.helpers["target"].castable(target, bp.MA["Aurorastorm"]) then
                    bp.helpers['queue'].add(bp.MA["Aurorastorm"], target)
                        
                elseif command == "zzz" then
                    
                    if bp.helpers["target"].castable(target, bp.MA["Curaga"]) and bp.helpers['party'].isInParty(target, false) then
                        bp.helpers['queue'].add(bp.MA["Curaga"], target)
                        
                    elseif bp.helpers["target"].castable(target, bp.MA["Cure"]) and bp.helpers['party'].isInParty(target, true) then
                        bp.helpers['queue'].add(bp.MA["Cure"], target)
                    
                    end
                    
                elseif command == "firebuff" and bp.helpers["target"].castable(player, bp.MA["Auspice"]) and bp.helpers['party'].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Protectra V"], player)
                    bp.helpers['queue'].add(bp.MA["Shellra V"], player)
                    bp.helpers['queue'].add(bp.MA["Boost-STR"], player)
                    bp.helpers['queue'].add(bp.MA["Barfira"], player)
                    bp.helpers['queue'].add(bp.MA["Baramnesra"], player)
                    bp.helpers['queue'].add(bp.MA["Auspice"], player)
                    
                elseif command == "waterbuff" and bp.helpers["target"].castable(player, bp.MA["Auspice"]) and bp.helpers['party'].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Protectra V"], player)
                    bp.helpers['queue'].add(bp.MA["Shellra V"], player)
                    bp.helpers['queue'].add(bp.MA["Boost-DEX"], player)
                    bp.helpers['queue'].add(bp.MA["Barwatera"], player)
                    bp.helpers['queue'].add(bp.MA["Barpoisonra"], player)
                    bp.helpers['queue'].add(bp.MA["Auspice"], player)
                    
                elseif command == "icebuff" and bp.helpers["target"].castable(player, bp.MA["Auspice"]) and bp.helpers['party'].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Protectra V"], player)
                    bp.helpers['queue'].add(bp.MA["Shellra V"], player)
                    bp.helpers['queue'].add(bp.MA["Boost-DEX"], player)
                    bp.helpers['queue'].add(bp.MA["Barblizzara"], player)
                    bp.helpers['queue'].add(bp.MA["Barparalyzra"], player)
                    bp.helpers['queue'].add(bp.MA["Auspice"], player)
                    
                elseif command == "windbuff" and bp.helpers["target"].castable(player, bp.MA["Auspice"]) and bp.helpers['party'].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Protectra V"], player)
                    bp.helpers['queue'].add(bp.MA["Shellra V"], player)
                    bp.helpers['queue'].add(bp.MA["Boost-DEX"], player)
                    bp.helpers['queue'].add(bp.MA["Baraera"], player)
                    bp.helpers['queue'].add(bp.MA["Barsilencera"], player)
                    bp.helpers['queue'].add(bp.MA["Auspice"], player)
                    
                elseif command == "stonebuff" and bp.helpers["target"].castable(player, bp.MA["Auspice"]) and bp.helpers['party'].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Protectra V"], player)
                    bp.helpers['queue'].add(bp.MA["Shellra V"], player)
                    bp.helpers['queue'].add(bp.MA["Boost-DEX"], player)
                    bp.helpers['queue'].add(bp.MA["Barstonera"], player)
                    bp.helpers['queue'].add(bp.MA["Barpetra"], player)
                    bp.helpers['queue'].add(bp.MA["Auspice"], player)
                    
                elseif command == "thunderbuff" and bp.helpers["target"].castable(player, bp.MA["Auspice"]) and bp.helpers['party'].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Protectra V"], player)
                    bp.helpers['queue'].add(bp.MA["Shellra V"], player)
                    bp.helpers['queue'].add(bp.MA["Boost-DEX"], player)
                    bp.helpers['queue'].add(bp.MA["Barthundra"], player)
                    bp.helpers['queue'].add(bp.MA["Barsilencera"], player)
                    bp.helpers['queue'].add(bp.MA["Auspice"], player)
                        
                elseif (command == "raise" or command == "arise") and bp.helpers['target'].isDead(target) then
                        
                    if bp.helpers['actions'].isReady('MA', "Arise") then
                        bp.helpers['queue'].add(bp.MA["Arise"], target)
                        
                    elseif bp.helpers['actions'].isReady('MA', "Raise III") then
                        bp.helpers['queue'].add(bp.MA["Raise III"], target)
                        
                    elseif bp.helpers['actions'].isReady('MA', "Raise II") then
                        bp.helpers['queue'].add(bp.MA["Raise II"], target)
                        
                    elseif bp.helpers['actions'].isReady('MA', "Raise") then
                        bp.helpers['queue'].add(bp.MA["Raise"], target)
                        
                    end
                    
                elseif command == "aoeregen" and bp.helpers["target"].castable(target, bp.MA["Regen"]) and bp.helpers['party'].isInParty(target, false) then
                    
                    if bp.helpers['actions'].isReady('MA', "Regen IV") and bp.helpers['actions'].isReady('JA', "Accession") and player.sub_job == "SCH" then
                        bp.helpers['queue'].add(bp.JA["Accession"], "me")
                        bp.helpers['queue'].add(bp.MA["Regen IV"], target)
                        
                    end
                
                elseif command == "holla" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Holla"], player)
                    
                elseif command == "dem" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Dem"], player)
                    
                elseif command == "mea" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Mea"], player)
                    
                elseif command == "yhoat" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Yhoat"], player)
                    
                elseif command == "altepa" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Altepa"], player)
                    
                elseif command == "vazhl" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Vahzl"], player)
                    
                elseif command == "jugner" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Recall-Jugner"], player)
                    
                elseif command == "pash" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Recall-Pashh"], player)
                    
                elseif command == "meriph" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Recall-Meriph"], player)
                
                end
                
            end
            
        end
        
    end
        
    self.blm = function(message, sender)
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
                
                if command == "haste" and bp.helpers["target"].castable(target, bp.MA["Haste"]) then
                    bp.helpers['queue'].add(bp.MA["Haste"], target)
                    
                elseif command == "protect" and bp.helpers["target"].castable(target, bp.MA["Protect"]) then
                    bp.helpers['queue'].add(bp.MA["Protect V"], target)
                    
                elseif command == "protectra" and bp.helpers["target"].castable(player, bp.MA["Protectra"]) and bp.helpers['party'].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Protectra V"], player)
                
                elseif command == "shell" and bp.helpers["target"].castable(target, bp.MA["Shell"]) then
                    bp.helpers['queue'].add(bp.MA["Shell V"], target)
                    
                elseif command == "shellra" and bp.helpers["target"].castable(player, bp.MA["Shellra"]) and bp.helpers['party'].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Shellra V"], player)
                    
                elseif command == "auspice" and bp.helpers["target"].castable(player, bp.MA["Auspice"]) and bp.helpers['party'].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Auspice"], player)
                    
                elseif command == "regen" and bp.helpers["target"].castable(target, bp.MA["Regen"]) then
                    bp.helpers['queue'].add(bp.MA["Regen IV"], target)
                    
                elseif command == "erase" and bp.helpers["target"].castable(target, bp.MA["Erase"]) and bp.helpers['party'].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Erase"], target)
                    
                elseif command == "para" and bp.helpers["target"].castable(target, bp.MA["Paralyna"]) then
                    bp.helpers['queue'].add(bp.MA["Paralyna"], target)
                    
                elseif (command == "stoned" or command == "stona") and bp.helpers["target"].castable(target, bp.MA["Stona"]) then
                    bp.helpers['queue'].add(bp.MA["Stona"], target)
                    
                elseif (command == "curse" or command == "doom") and bp.helpers["target"].castable(target, bp.MA["Cursna"]) then
                    bp.helpers['queue'].add(bp.MA["Cursna"], target)

                elseif command == "earth+" and bp.helpers["target"].castable(target, bp.MA["Sandstorm"]) then
                    bp.helpers['queue'].add(bp.MA["Sandstorm"], target)

                elseif command == "water+" and bp.helpers["target"].castable(target, bp.MA["Rainstorm"]) then
                    bp.helpers['queue'].add(bp.MA["Rainstorm"], target)

                elseif command == "wind+" and bp.helpers["target"].castable(target, bp.MA["Windstorm"]) then
                    bp.helpers['queue'].add(bp.MA["Windstorm"], target)

                elseif command == "fire+" and bp.helpers["target"].castable(target, bp.MA["Firestorm"]) then
                    bp.helpers['queue'].add(bp.MA["Firestorm"], target)

                elseif command == "ice+" and bp.helpers["target"].castable(target, bp.MA["Hailstorm"]) then
                    bp.helpers['queue'].add(bp.MA["Hailstorm"], target)

                elseif command == "thunder+" and bp.helpers["target"].castable(target, bp.MA["Thunderstorm"]) then
                    bp.helpers['queue'].add(bp.MA["Thunderstorm"], target)

                elseif command == "dark+" and bp.helpers["target"].castable(target, bp.MA["Voidstorm"]) then
                    bp.helpers['queue'].add(bp.MA["Voidstorm"], target)

                elseif command == "light+" and bp.helpers["target"].castable(target, bp.MA["Aurorastorm"]) then
                    bp.helpers['queue'].add(bp.MA["Aurorastorm"], target)
                        
                elseif command == "zzz" then
                    
                    if bp.helpers["target"].castable(target, bp.MA["Curaga"]) and bp.helpers['party'].isInParty(target, false) then
                        bp.helpers['queue'].add(bp.MA["Curaga"], target)
                        
                    elseif bp.helpers["target"].castable(target, bp.MA["Cure"]) and bp.helpers['party'].isInParty(target, true) then
                        bp.helpers['queue'].add(bp.MA["Cure"], target)
                    
                    end
                        
                elseif (command == "raise" or command == "arise") and bp.helpers['target'].isDead(target) then
                        
                    if bp.helpers['actions'].isReady('MA', "Arise") then
                        bp.helpers['queue'].add(bp.MA["Arise"], player)
                        
                    elseif bp.helpers['actions'].isReady('MA', "Raise III") then
                        bp.helpers['queue'].add(bp.MA["Raise III"], player)
                        
                    elseif bp.helpers['actions'].isReady('MA', "Raise II") then
                        bp.helpers['queue'].add(bp.MA["Raise II"], player)
                        
                    elseif bp.helpers['actions'].isReady('MA', "Raise") then
                        bp.helpers['queue'].add(bp.MA["Raise"], player)
                        
                    end
                
                elseif command == "holla" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Holla"], player)
                    
                elseif command == "dem" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Dem"], player)
                    
                elseif command == "mea" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Mea"], player)
                    
                elseif command == "yhoat" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Yhoat"], player)
                    
                elseif command == "altepa" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Altepa"], player)
                    
                elseif command == "vazhl" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Vahzl"], player)
                    
                elseif command == "jugner" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Recall-Jugner"], player)
                    
                elseif command == "pash" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Recall-Pashh"], player)
                    
                elseif command == "meriph" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Recall-Meriph"], player)
                
                end
            
            -- Multiple Commands were sent.
            elseif count > 1 then
                
                for i=1, count do
                    
                    if message[1] and message[i+1] and (message[1]):sub(1, #message[1]):lower() == (player.name):sub(1, #message[1]):lower() then
                        local command = message[i+1]:lower()
                        
                        if command == "nopeeee" and bp.helpers["target"].castable(target, bp.MA["Haste"]) then
                            bp.helpers['queue'].add(bp.MA["Haste"], target)                            
                        end
                        
                    end
                
                end
                
            end
            
        end
        
    end
        
    self.rdm = function(message, sender)
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
                
                if command == "haste" and bp.helpers["target"].castable(target, bp.MA["Haste"]) then
                    bp.helpers['queue'].add(bp.MA["Haste"], target)
                    
                elseif command == "protect" and bp.helpers["target"].castable(target, bp.MA["Protect"]) then
                    bp.helpers['queue'].add(bp.MA["Protect V"], target)
                    
                elseif command == "protectra" and bp.helpers["target"].castable(player, bp.MA["Protectra"]) and bp.helpers['party'].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Protectra V"], player)
                
                elseif command == "shell" and bp.helpers["target"].castable(target, bp.MA["Shell"]) then
                    bp.helpers['queue'].add(bp.MA["Shell V"], target)
                    
                elseif command == "shellra" and bp.helpers["target"].castable(player, bp.MA["Shellra"]) and bp.helpers['party'].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Shellra V"], player)
                    
                elseif command == "auspice" and bp.helpers["target"].castable(player, bp.MA["Auspice"]) and bp.helpers['party'].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Auspice"], player)
                    
                elseif command == "regen" and bp.helpers["target"].castable(target, bp.MA["Regen"]) then
                    bp.helpers['queue'].add(bp.MA["Regen IV"], target)
                    
                elseif command == "erase" and bp.helpers["target"].castable(target, bp.MA["Erase"]) and bp.helpers['party'].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Erase"], target)
                    
                elseif command == "para" and bp.helpers["target"].castable(target, bp.MA["Paralyna"]) then
                    bp.helpers['queue'].add(bp.MA["Paralyna"], target)
                    
                elseif (command == "stoned" or command == "stona") and bp.helpers["target"].castable(target, bp.MA["Stona"]) then
                    bp.helpers['queue'].add(bp.MA["Stona"], target)
                    
                elseif (command == "curse" or command == "doom") and bp.helpers["target"].castable(target, bp.MA["Cursna"]) then
                    bp.helpers['queue'].add(bp.MA["Cursna"], target)

                elseif command == "earth+" and bp.helpers["target"].castable(target, bp.MA["Sandstorm"]) then
                    bp.helpers['queue'].add(bp.MA["Sandstorm"], target)

                elseif command == "water+" and bp.helpers["target"].castable(target, bp.MA["Rainstorm"]) then
                    bp.helpers['queue'].add(bp.MA["Rainstorm"], target)

                elseif command == "wind+" and bp.helpers["target"].castable(target, bp.MA["Windstorm"]) then
                    bp.helpers['queue'].add(bp.MA["Windstorm"], target)

                elseif command == "fire+" and bp.helpers["target"].castable(target, bp.MA["Firestorm"]) then
                    bp.helpers['queue'].add(bp.MA["Firestorm"], target)

                elseif command == "ice+" and bp.helpers["target"].castable(target, bp.MA["Hailstorm"]) then
                    bp.helpers['queue'].add(bp.MA["Hailstorm"], target)

                elseif command == "thunder+" and bp.helpers["target"].castable(target, bp.MA["Thunderstorm"]) then
                    bp.helpers['queue'].add(bp.MA["Thunderstorm"], target)

                elseif command == "dark+" and bp.helpers["target"].castable(target, bp.MA["Voidstorm"]) then
                    bp.helpers['queue'].add(bp.MA["Voidstorm"], target)

                elseif command == "light+" and bp.helpers["target"].castable(target, bp.MA["Aurorastorm"]) then
                    bp.helpers['queue'].add(bp.MA["Aurorastorm"], target)
                        
                elseif command == "zzz" then
                    
                    if bp.helpers["target"].castable(target, bp.MA["Curaga"]) and bp.helpers['party'].isInParty(target, false) then
                        bp.helpers['queue'].add(bp.MA["Curaga"], target)
                        
                    elseif bp.helpers["target"].castable(target, bp.MA["Cure"]) and bp.helpers['party'].isInParty(target, true) then
                        bp.helpers['queue'].add(bp.MA["Cure"], target)
                    
                    end
                        
                elseif (command == "raise" or command == "arise") and bp.helpers['target'].isDead(target) then
                        
                    if bp.helpers['actions'].isReady('MA', "Arise") then
                        bp.helpers['queue'].add(bp.MA["Arise"], player)
                        
                    elseif bp.helpers['actions'].isReady('MA', "Raise III") then
                        bp.helpers['queue'].add(bp.MA["Raise III"], player)
                        
                    elseif bp.helpers['actions'].isReady('MA', "Raise II") then
                        bp.helpers['queue'].add(bp.MA["Raise II"], player)
                        
                    elseif bp.helpers['actions'].isReady('MA', "Raise") then
                        bp.helpers['queue'].add(bp.MA["Raise"], player)
                        
                    end
                
                elseif command == "holla" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Holla"], player)
                    
                elseif command == "dem" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Dem"], player)
                    
                elseif command == "mea" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Mea"], player)
                    
                elseif command == "yhoat" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Yhoat"], player)
                    
                elseif command == "altepa" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Altepa"], player)
                    
                elseif command == "vazhl" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Vahzl"], player)
                    
                elseif command == "jugner" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Recall-Jugner"], player)
                    
                elseif command == "pash" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Recall-Pashh"], player)
                    
                elseif command == "meriph" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Recall-Meriph"], player)
                
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
        
    self.thf = function(message, sender)
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
                
                if command == "nopeeee" and bp.helpers["target"].castable(target, bp.MA["Haste"]) then
                    bp.helpers['queue'].add(bp.MA["Haste"], target)
                end
            
            -- Multiple Commands were sent.
            elseif count > 1 then
                
                for i=1, count do
                    
                    if message[1] and message[i+1] and (message[1]):sub(1, #message[1]):lower() == (player.name):sub(1, #message[1]):lower() then
                        local command = message[i+1]:lower()
                        
                        if command == "nopeeee" and bp.helpers["target"].castable(target, bp.MA["Haste"]) then
                            bp.helpers['queue'].add(bp.MA["Haste"], target)                            
                        end
                        
                    end
                
                end
                
            end
            
        end
        
    end
        
    self.pld = function(message, sender)
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
                
                if command == "cover" and bp.helpers["target"].castable(target, bp.JA["Cover"]) then
                    bp.helpers['queue'].add(bp.JA["Cover"], target)                            
                end
            
            -- Multiple Commands were sent.
            elseif count > 1 then
                
                for i=1, count do
                    
                    if message[1] and message[i+1] and (message[1]):sub(1, #message[1]):lower() == (player.name):sub(1, #message[1]):lower() then
                        local command = message[i+1]:lower()
                        
                        if command == "cover" and bp.helpers["target"].castable(target, bp.JA["Cover"]) then
                            bp.helpers['queue'].add(bp.JA["Cover"], target)                            
                        end
                        
                    end
                
                end
                
            end
            
        end
        
    end
        
    self.drk = function(message, sender)
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
                
                if command == "stun" and bp.helpers["target"].castable(target, bp.MA["Stun"]) then
                    bp.helpers['queue'].add(bp.MA["Stun"], target)
                end
            
            -- Multiple Commands were sent.
            elseif count > 1 then
                
                for i=1, count do
                    
                    if message[1] and message[i+1] and (message[1]):sub(1, #message[1]):lower() == (player.name):sub(1, #message[1]):lower() then
                        local command = message[i+1]:lower()
                        
                        if command == "stun" and bp.helpers["target"].castable(target, bp.MA["Stun"]) then
                            bp.helpers['queue'].add(bp.MA["Stun"], target)                            
                        end
                        
                    end
                
                end
                
            end
            
        end
        
    end
        
    self.bst = function(message, sender)
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
                
                if command == "nopeeee" and bp.helpers["target"].castable(target, bp.MA["Haste"]) then
                    bp.helpers['queue'].add(bp.MA["Haste"], target)
                end
            
            -- Multiple Commands were sent.
            elseif count > 1 then
                
                for i=1, count do
                    
                    if message[1] and message[i+1] and (message[1]):sub(1, #message[1]):lower() == (player.name):sub(1, #message[1]):lower() then
                        local command = message[i+1]:lower()
                        
                        if command == "nopeeee" and bp.helpers["target"].castable(target, bp.MA["Haste"]) then
                            bp.helpers['queue'].add(bp.MA["Haste"], target)                            
                        end
                        
                    end
                
                end
                
            end
            
        end
        
    end
        
    self.brd = function(message, sender)
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
                
                if command == "haste" and bp.helpers["target"].castable(target, bp.MA["Haste"]) then
                    bp.helpers['queue'].add(bp.MA["Haste"], target)
                    
                elseif command == "protect" and bp.helpers["target"].castable(target, bp.MA["Protect"]) then
                    bp.helpers['queue'].add(bp.MA["Protect V"], target)
                    
                elseif command == "protectra" and bp.helpers["target"].castable(player, bp.MA["Protectra"]) and bp.helpers['party'].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Protectra V"], player)
                
                elseif command == "shell" and bp.helpers["target"].castable(target, bp.MA["Shell"]) then
                    bp.helpers['queue'].add(bp.MA["Shell V"], target)
                    
                elseif command == "shellra" and bp.helpers["target"].castable(player, bp.MA["Shellra"]) and bp.helpers['party'].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Shellra V"], player)
                    
                elseif command == "auspice" and bp.helpers["target"].castable(player, bp.MA["Auspice"]) and bp.helpers['party'].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Auspice"], player)
                    
                elseif command == "regen" and bp.helpers["target"].castable(target, bp.MA["Regen"]) then
                    bp.helpers['queue'].add(bp.MA["Regen IV"], target)
                    
                elseif command == "erase" and bp.helpers["target"].castable(target, bp.MA["Erase"]) and bp.helpers['party'].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Erase"], target)
                    
                elseif command == "para" and bp.helpers["target"].castable(target, bp.MA["Paralyna"]) then
                    bp.helpers['queue'].add(bp.MA["Paralyna"], target)
                    
                elseif (command == "stoned" or command == "stona") and bp.helpers["target"].castable(target, bp.MA["Stona"]) then
                    bp.helpers['queue'].add(bp.MA["Stona"], target)
                    
                elseif (command == "curse" or command == "doom") and bp.helpers["target"].castable(target, bp.MA["Cursna"]) then
                    bp.helpers['queue'].add(bp.MA["Cursna"], target)
                        
                elseif command == "zzz" then
                    
                    if bp.helpers["target"].castable(target, bp.MA["Curaga"]) and bp.helpers['party'].isInParty(target, false) then
                        bp.helpers['queue'].add(bp.MA["Curaga"], target)
                        
                    elseif bp.helpers["target"].castable(target, bp.MA["Cure"]) and bp.helpers['party'].isInParty(target, true) then
                        bp.helpers['queue'].add(bp.MA["Cure"], target)
                    
                    end
                        
                elseif (command == "raise" or command == "arise") and bp.helpers['target'].isDead(target) then
                        
                    if bp.helpers['actions'].isReady('MA', "Arise") then
                        bp.helpers['queue'].add(bp.MA["Arise"], player)
                        
                    elseif bp.helpers['actions'].isReady('MA', "Raise III") then
                        bp.helpers['queue'].add(bp.MA["Raise III"], player)
                        
                    elseif bp.helpers['actions'].isReady('MA', "Raise II") then
                        bp.helpers['queue'].add(bp.MA["Raise II"], player)
                        
                    elseif bp.helpers['actions'].isReady('MA', "Raise") then
                        bp.helpers['queue'].add(bp.MA["Raise"], player)
                        
                    end
                
                elseif command == "holla" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Holla"], player)
                    
                elseif command == "dem" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Dem"], player)
                    
                elseif command == "mea" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Mea"], player)
                    
                elseif command == "yhoat" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Yhoat"], player)
                    
                elseif command == "altepa" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Altepa"], player)
                    
                elseif command == "vazhl" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Vahzl"], player)
                    
                elseif command == "jugner" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Recall-Jugner"], player)
                    
                elseif command == "pash" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Recall-Pashh"], player)
                    
                elseif command == "meriph" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Recall-Meriph"], player)
                
                end
            
            -- Multiple Commands were sent.
            elseif count > 1 then
                
                for i=1, count do
                    
                    if message[1] and message[i+1] and (message[1]):sub(1, #message[1]):lower() == (player.name):sub(1, #message[1]):lower() then
                        local command = message[i+1]:lower()
                        
                        if command == "nopeeee" and bp.helpers["target"].castable(target, bp.MA["Haste"]) then
                            bp.helpers['queue'].add(bp.MA["Haste"], target)                            
                        end
                        
                    end
                
                end
                
            end
            
        end
        
    end
        
    self.rng = function(message, sender)
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
                
                if command == "nnnnnnnnnn" and bp.helpers["target"].castable(target, bp.JA["Haste"]) then
                    bp.helpers['queue'].add(bp.MA["Haste"], target)
                end
            
            -- Multiple Commands were sent.
            elseif count > 1 then
                
                for i=1, count do
                    
                    if message[1] and message[i+1] and (message[1]):sub(1, #message[1]):lower() == (player.name):sub(1, #message[1]):lower() then
                        local command = message[i+1]:lower()
                        
                        if command == "nopeeee" and bp.helpers["target"].castable(target, bp.MA["Haste"]) then
                            bp.helpers['queue'].add(bp.MA["Haste"], target)                            
                        end
                        
                    end
                
                end
                
            end
            
        end
        
    end
        
    self.smn = function(message, sender)
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
                
                if command == "haste" and bp.helpers["target"].castable(target, bp.MA["Haste"]) then
                    bp.helpers['queue'].add(bp.MA["Haste"], target)
                    
                elseif command == "protect" and bp.helpers["target"].castable(target, bp.MA["Protect"]) then
                    bp.helpers['queue'].add(bp.MA["Protect V"], target)
                    
                elseif command == "protectra" and bp.helpers["target"].castable(player, bp.MA["Protectra"]) and bp.helpers['party'].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Protectra V"], player)
                
                elseif command == "shell" and bp.helpers["target"].castable(target, bp.MA["Shell"]) then
                    bp.helpers['queue'].add(bp.MA["Shell V"], target)
                    
                elseif command == "shellra" and bp.helpers["target"].castable(player, bp.MA["Shellra"]) and bp.helpers['party'].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Shellra V"], player)
                    
                elseif command == "auspice" and bp.helpers["target"].castable(player, bp.MA["Auspice"]) and bp.helpers['party'].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Auspice"], player)
                    
                elseif command == "regen" and bp.helpers["target"].castable(target, bp.MA["Regen"]) then
                    bp.helpers['queue'].add(bp.MA["Regen IV"], target)
                    
                elseif command == "erase" and bp.helpers["target"].castable(target, bp.MA["Erase"]) and bp.helpers['party'].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Erase"], target)
                    
                elseif command == "para" and bp.helpers["target"].castable(target, bp.MA["Paralyna"]) then
                    bp.helpers['queue'].add(bp.MA["Paralyna"], target)
                    
                elseif (command == "stoned" or command == "stona") and bp.helpers["target"].castable(target, bp.MA["Stona"]) then
                    bp.helpers['queue'].add(bp.MA["Stona"], target)
                    
                elseif (command == "curse" or command == "doom") and bp.helpers["target"].castable(target, bp.MA["Cursna"]) then
                    bp.helpers['queue'].add(bp.MA["Cursna"], target)

                elseif command == "earth+" and bp.helpers["target"].castable(target, bp.MA["Sandstorm"]) then
                    bp.helpers['queue'].add(bp.MA["Sandstorm"], target)

                elseif command == "water+" and bp.helpers["target"].castable(target, bp.MA["Rainstorm"]) then
                    bp.helpers['queue'].add(bp.MA["Rainstorm"], target)

                elseif command == "wind+" and bp.helpers["target"].castable(target, bp.MA["Windstorm"]) then
                    bp.helpers['queue'].add(bp.MA["Windstorm"], target)

                elseif command == "fire+" and bp.helpers["target"].castable(target, bp.MA["Firestorm"]) then
                    bp.helpers['queue'].add(bp.MA["Firestorm"], target)

                elseif command == "ice+" and bp.helpers["target"].castable(target, bp.MA["Hailstorm"]) then
                    bp.helpers['queue'].add(bp.MA["Hailstorm"], target)

                elseif command == "thunder+" and bp.helpers["target"].castable(target, bp.MA["Thunderstorm"]) then
                    bp.helpers['queue'].add(bp.MA["Thunderstorm"], target)

                elseif command == "dark+" and bp.helpers["target"].castable(target, bp.MA["Voidstorm"]) then
                    bp.helpers['queue'].add(bp.MA["Voidstorm"], target)

                elseif command == "light+" and bp.helpers["target"].castable(target, bp.MA["Aurorastorm"]) then
                    bp.helpers['queue'].add(bp.MA["Aurorastorm"], target)
                        
                elseif command == "zzz" then
                    
                    if bp.helpers["target"].castable(target, bp.MA["Curaga"]) and bp.helpers['party'].isInParty(target, false) then
                        bp.helpers['queue'].add(bp.MA["Curaga"], target)
                        
                    elseif bp.helpers["target"].castable(target, bp.MA["Cure"]) and bp.helpers['party'].isInParty(target, true) then
                        bp.helpers['queue'].add(bp.MA["Cure"], target)
                    
                    end
                        
                elseif (command == "raise" or command == "arise") and bp.helpers['target'].isDead(target) then
                        
                    if bp.helpers['actions'].isReady('MA', "Arise") then
                        bp.helpers['queue'].add(bp.MA["Arise"], player)
                        
                    elseif bp.helpers['actions'].isReady('MA', "Raise III") then
                        bp.helpers['queue'].add(bp.MA["Raise III"], player)
                        
                    elseif bp.helpers['actions'].isReady('MA', "Raise II") then
                        bp.helpers['queue'].add(bp.MA["Raise II"], player)
                        
                    elseif bp.helpers['actions'].isReady('MA', "Raise") then
                        bp.helpers['queue'].add(bp.MA["Raise"], player)
                        
                    end
                
                elseif command == "holla" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Holla"], player)
                    
                elseif command == "dem" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Dem"], player)
                    
                elseif command == "mea" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Mea"], player)
                    
                elseif command == "yhoat" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Yhoat"], player)
                    
                elseif command == "altepa" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Altepa"], player)
                    
                elseif command == "vazhl" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Vahzl"], player)
                    
                elseif command == "jugner" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Recall-Jugner"], player)
                    
                elseif command == "pash" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Recall-Pashh"], player)
                    
                elseif command == "meriph" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Recall-Meriph"], player)
                
                end
            
            -- Multiple Commands were sent.
            elseif count > 1 then
                
                for i=1, count do
                    
                    if message[1] and message[i+1] and (message[1]):sub(1, #message[1]):lower() == (player.name):sub(1, #message[1]):lower() then
                        local command = message[i+1]:lower()
                        
                        if command == "nopeeee" and bp.helpers["target"].castable(target, bp.MA["Haste"]) then
                            bp.helpers['queue'].add(bp.MA["Haste"], target)                            
                        end
                        
                    end
                
                end
                
            end
            
        end
        
    end
        
    self.sam = function(message, sender)
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
                
                if command == "nopeeee" and bp.helpers["target"].castable(target, bp.MA["Haste"]) then
                    bp.helpers['queue'].add(bp.MA["Haste"], target)
                end
            
            -- Multiple Commands were sent.
            elseif count > 1 then
                
                for i=1, count do
                    
                    if message[1] and message[i+1] and (message[1]):sub(1, #message[1]):lower() == (player.name):sub(1, #message[1]):lower() then
                        local command = message[i+1]:lower()
                        
                        if command == "nopeeee" and bp.helpers["target"].castable(target, bp.MA["Haste"]) then
                            bp.helpers['queue'].add(bp.MA["Haste"], target)                            
                        end
                        
                    end
                
                end
                
            end
            
        end
        
    end
        
    self.nin = function(message, sender)
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
                
                if command == "nopeeee" and bp.helpers["target"].castable(target, bp.MA["Haste"]) then
                    bp.helpers['queue'].add(bp.MA["Haste"], target)
                end
            
            -- Multiple Commands were sent.
            elseif count > 1 then
                
                for i=1, count do
                    
                    if message[1] and message[i+1] and (message[1]):sub(1, #message[1]):lower() == (player.name):sub(1, #message[1]):lower() then
                        local command = message[i+1]:lower()
                        
                        if command == "nopeeee" and bp.helpers["target"].castable(target, bp.MA["Haste"]) then
                            bp.helpers['queue'].add(bp.MA["Haste"], target)                            
                        end
                        
                    end
                
                end
                
            end
            
        end
        
    end
        
    self.drg = function(message, sender)
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
                
                if command == "nopeeee" and bp.helpers["target"].castable(target, bp.MA["Haste"]) then
                    bp.helpers['queue'].add(bp.MA["Haste"], target)
                end
            
            -- Multiple Commands were sent.
            elseif count > 1 then
                
                for i=1, count do
                    
                    if message[1] and message[i+1] and (message[1]):sub(1, #message[1]):lower() == (player.name):sub(1, #message[1]):lower() then
                        local command = message[i+1]:lower()
                        
                        if command == "nopeeee" and bp.helpers["target"].castable(target, bp.MA["Haste"]) then
                            bp.helpers['queue'].add(bp.MA["Haste"], target)                            
                        end
                        
                    end
                
                end
                
            end
            
        end
        
    end
        
    self.blu = function(message, sender)
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
                
                if command == "nopeeee" and bp.helpers["target"].castable(target, bp.MA["Haste"]) then
                    bp.helpers['queue'].add(bp.MA["Haste"], target)
                end
            
            -- Multiple Commands were sent.
            elseif count > 1 then
                
                for i=1, count do
                    
                    if message[1] and message[i+1] and (message[1]):sub(1, #message[1]):lower() == (player.name):sub(1, #message[1]):lower() then
                        local command = message[i+1]:lower()
                        
                        if command == "nopeeee" and bp.helpers["target"].castable(target, bp.MA["Haste"]) then
                            bp.helpers['queue'].add(bp.MA["Haste"], target)                            
                        end
                        
                    end
                
                end
                
            end
            
        end
        
    end
        
    self.cor = function(message, sender)
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
                
                if command == "nopeeee" and bp.helpers["target"].castable(target, bp.MA["Haste"]) then
                    bp.helpers['queue'].add(bp.MA["Haste"], target)
                end
            
            -- Multiple Commands were sent.
            elseif count > 1 then
                
                for i=1, count do
                    
                    if message[1] and message[i+1] and (message[1]):sub(1, #message[1]):lower() == (player.name):sub(1, #message[1]):lower() then
                        local command = message[i+1]:lower()
                        
                        if command == "nopeeee" and bp.helpers["target"].castable(target, bp.MA["Haste"]) then
                            bp.helpers['queue'].add(bp.MA["Haste"], target)                            
                        end
                        
                    end
                
                end
                
            end
            
        end
        
    end
        
    self.pup = function(message, sender)
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
                
                if command == "nopeeee" and bp.helpers["target"].castable(target, bp.MA["Haste"]) then
                    bp.helpers['queue'].add(bp.MA["Haste"], target)
                end
            
            -- Multiple Commands were sent.
            elseif count > 1 then
                
                for i=1, count do
                    
                    if message[1] and message[i+1] and (message[1]):sub(1, #message[1]):lower() == (player.name):sub(1, #message[1]):lower() then
                        local command = message[i+1]:lower()
                        
                        if command == "nopeeee" and bp.helpers["target"].castable(target, bp.MA["Haste"]) then
                            bp.helpers['queue'].add(bp.MA["Haste"], target)                            
                        end
                        
                    end
                
                end
                
            end
            
        end
        
    end
        
    self.dnc = function(message, sender)
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
                
                if command == "nopeeee" and bp.helpers["target"].castable(target, bp.MA["Haste"]) then
                    bp.helpers['queue'].add(bp.MA["Haste"], target)
                end
            
            -- Multiple Commands were sent.
            elseif count > 1 then
                
                for i=1, count do
                    
                    if message[1] and message[i+1] and (message[1]):sub(1, #message[1]):lower() == (player.name):sub(1, #message[1]):lower() then
                        local command = message[i+1]:lower()
                        
                        if command == "nopeeee" and bp.helpers["target"].castable(target, bp.MA["Haste"]) then
                            bp.helpers['queue'].add(bp.MA["Haste"], target)                            
                        end
                        
                    end
                
                end
                
            end
            
        end
        
    end
        
    self.sch = function(message, sender)
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
                
                if command == "haste" and bp.helpers["target"].castable(target, bp.MA["Haste"]) then
                    bp.helpers['queue'].add(bp.MA["Haste"], target)
                    
                elseif command == "protect" and bp.helpers["target"].castable(target, bp.MA["Protect"]) then
                    bp.helpers['queue'].add(bp.MA["Protect V"], target)
                    
                elseif command == "protectra" and bp.helpers["target"].castable(player, bp.MA["Protectra"]) and bp.helpers['party'].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Protectra V"], player)
                
                elseif command == "shell" and bp.helpers["target"].castable(target, bp.MA["Shell"]) then
                    bp.helpers['queue'].add(bp.MA["Shell V"], target)
                    
                elseif command == "shellra" and bp.helpers["target"].castable(player, bp.MA["Shellra"]) and bp.helpers['party'].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Shellra V"], player)
                    
                elseif command == "auspice" and bp.helpers["target"].castable(player, bp.MA["Auspice"]) and bp.helpers['party'].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Auspice"], player)
                    
                elseif command == "regen" and bp.helpers["target"].castable(target, bp.MA["Regen"]) then
                    bp.helpers['queue'].add(bp.MA["Regen IV"], target)
                    
                elseif command == "erase" and bp.helpers["target"].castable(target, bp.MA["Erase"]) and bp.helpers['party'].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Erase"], target)
                    
                elseif command == "para" and bp.helpers["target"].castable(target, bp.MA["Paralyna"]) then
                    bp.helpers['queue'].add(bp.MA["Paralyna"], target)
                    
                elseif (command == "stoned" or command == "stona") and bp.helpers["target"].castable(target, bp.MA["Stona"]) then
                    bp.helpers['queue'].add(bp.MA["Stona"], target)
                    
                elseif (command == "curse" or command == "doom") and bp.helpers["target"].castable(target, bp.MA["Cursna"]) then
                    bp.helpers['queue'].add(bp.MA["Cursna"], target)

                elseif command == "earth+" and bp.helpers["target"].castable(target, bp.MA["Sandstorm II"]) then
                    bp.helpers['queue'].add(bp.MA["Sandstorm II"], target)

                elseif command == "water+" and bp.helpers["target"].castable(target, bp.MA["Rainstorm II"]) then
                    bp.helpers['queue'].add(bp.MA["Rainstorm II"], target)

                elseif command == "wind+" and bp.helpers["target"].castable(target, bp.MA["Windstorm II"]) then
                    bp.helpers['queue'].add(bp.MA["Windstorm II"], target)

                elseif command == "fire+" and bp.helpers["target"].castable(target, bp.MA["Firestorm II"]) then
                    bp.helpers['queue'].add(bp.MA["Firestorm II"], target)

                elseif command == "ice+" and bp.helpers["target"].castable(target, bp.MA["Hailstorm II"]) then
                    bp.helpers['queue'].add(bp.MA["Hailstorm II"], target)

                elseif command == "thunder+" and bp.helpers["target"].castable(target, bp.MA["Thunderstorm II"]) then
                    bp.helpers['queue'].add(bp.MA["Thunderstorm II"], target)

                elseif command == "dark+" and bp.helpers["target"].castable(target, bp.MA["Voidstorm II"]) then
                    bp.helpers['queue'].add(bp.MA["Voidstorm II"], target)

                elseif command == "light+" and bp.helpers["target"].castable(target, bp.MA["Aurorastorm II"]) then
                    bp.helpers['queue'].add(bp.MA["Aurorastorm II"], target)
                        
                elseif command == "zzz" then
                    
                    if bp.helpers["target"].castable(target, bp.MA["Curaga"]) and bp.helpers['party'].isInParty(target, false) then
                        bp.helpers['queue'].add(bp.MA["Curaga"], target)
                        
                    elseif bp.helpers["target"].castable(target, bp.MA["Cure"]) and bp.helpers['party'].isInParty(target, true) then
                        bp.helpers['queue'].add(bp.MA["Cure"], target)
                    
                    end
                    
                elseif command == "firebuff" and bp.helpers["target"].castable(player, bp.MA["Auspice"]) and bp.helpers['party'].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Protectra V"], player)
                    bp.helpers['queue'].add(bp.MA["Shellra V"], player)
                    bp.helpers['queue'].add(bp.MA["Boost-STR"], player)
                    bp.helpers['queue'].add(bp.MA["Barfira"], player)
                    bp.helpers['queue'].add(bp.MA["Baramnesra"], player)
                    bp.helpers['queue'].add(bp.MA["Auspice"], player)
                    
                elseif command == "waterbuff" and bp.helpers["target"].castable(player, bp.MA["Auspice"]) and bp.helpers['party'].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Protectra V"], player)
                    bp.helpers['queue'].add(bp.MA["Shellra V"], player)
                    bp.helpers['queue'].add(bp.MA["Boost-DEX"], player)
                    bp.helpers['queue'].add(bp.MA["Barwatera"], player)
                    bp.helpers['queue'].add(bp.MA["Barpoisonra"], player)
                    bp.helpers['queue'].add(bp.MA["Auspice"], player)
                    
                elseif command == "icebuff" and bp.helpers["target"].castable(player, bp.MA["Auspice"]) and bp.helpers['party'].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Protectra V"], player)
                    bp.helpers['queue'].add(bp.MA["Shellra V"], player)
                    bp.helpers['queue'].add(bp.MA["Boost-DEX"], player)
                    bp.helpers['queue'].add(bp.MA["Barblizzara"], player)
                    bp.helpers['queue'].add(bp.MA["Barparalyzra"], player)
                    bp.helpers['queue'].add(bp.MA["Auspice"], player)
                    
                elseif command == "windbuff" and bp.helpers["target"].castable(player, bp.MA["Auspice"]) and bp.helpers['party'].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Protectra V"], player)
                    bp.helpers['queue'].add(bp.MA["Shellra V"], player)
                    bp.helpers['queue'].add(bp.MA["Boost-DEX"], player)
                    bp.helpers['queue'].add(bp.MA["Baraera"], player)
                    bp.helpers['queue'].add(bp.MA["Barsilencera"], player)
                    bp.helpers['queue'].add(bp.MA["Auspice"], player)
                    
                elseif command == "stonebuff" and bp.helpers["target"].castable(player, bp.MA["Auspice"]) and bp.helpers['party'].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Protectra V"], player)
                    bp.helpers['queue'].add(bp.MA["Shellra V"], player)
                    bp.helpers['queue'].add(bp.MA["Boost-DEX"], player)
                    bp.helpers['queue'].add(bp.MA["Barstonera"], player)
                    bp.helpers['queue'].add(bp.MA["Barpetra"], player)
                    bp.helpers['queue'].add(bp.MA["Auspice"], player)
                    
                elseif command == "thunderbuff" and bp.helpers["target"].castable(player, bp.MA["Auspice"]) and bp.helpers['party'].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Protectra V"], player)
                    bp.helpers['queue'].add(bp.MA["Shellra V"], player)
                    bp.helpers['queue'].add(bp.MA["Boost-DEX"], player)
                    bp.helpers['queue'].add(bp.MA["Barthundra"], player)
                    bp.helpers['queue'].add(bp.MA["Barsilencera"], player)
                    bp.helpers['queue'].add(bp.MA["Auspice"], player)
                        
                elseif (command == "raise" or command == "arise") and bp.helpers['target'].isDead(target) then
                        
                    if bp.helpers['actions'].isReady('MA', "Arise") then
                        bp.helpers['queue'].add(bp.MA["Arise"], player)
                        
                    elseif bp.helpers['actions'].isReady('MA', "Raise III") then
                        bp.helpers['queue'].add(bp.MA["Raise III"], player)
                        
                    elseif bp.helpers['actions'].isReady('MA', "Raise II") then
                        bp.helpers['queue'].add(bp.MA["Raise II"], player)
                        
                    elseif bp.helpers['actions'].isReady('MA', "Raise") then
                        bp.helpers['queue'].add(bp.MA["Raise"], player)
                        
                    end
                    
                elseif command == "aoeregen" and bp.helpers["target"].castable(target, bp.MA["Regen"]) and bp.helpers['party'].isInParty(target, false) then
                    
                    if bp.helpers['actions'].isReady('MA', "Regen IV") and bp.helpers['actions'].isReady('JA', "Accession") and player.sub_job == "SCH" then
                        bp.helpers['queue'].add(bp.JA["Accession"], "me")
                        bp.helpers['queue'].add(bp.MA["Regen IV"], player)
                        
                    end
                
                elseif command == "holla" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Holla"], player)
                    
                elseif command == "dem" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Dem"], player)
                    
                elseif command == "mea" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Mea"], player)
                    
                elseif command == "yhoat" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Yhoat"], player)
                    
                elseif command == "altepa" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Altepa"], player)
                    
                elseif command == "vazhl" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Vahzl"], player)
                    
                elseif command == "jugner" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Recall-Jugner"], player)
                    
                elseif command == "pash" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Recall-Pashh"], player)
                    
                elseif command == "meriph" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Recall-Meriph"], player)
                
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
        
    self.geo = function(message, sender)
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
                
                if command == "haste" and bp.helpers["target"].castable(target, bp.MA["Haste"]) then
                    bp.helpers['queue'].add(bp.MA["Haste"], target)
                    
                elseif command == "protect" and bp.helpers["target"].castable(target, bp.MA["Protect"]) then
                    bp.helpers['queue'].add(bp.MA["Protect V"], target)
                    
                elseif command == "protectra" and bp.helpers["target"].castable(player, bp.MA["Protectra"]) and bp.helpers['party'].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Protectra V"], player)
                
                elseif command == "shell" and bp.helpers["target"].castable(target, bp.MA["Shell"]) then
                    bp.helpers['queue'].add(bp.MA["Shell V"], target)
                    
                elseif command == "shellra" and bp.helpers["target"].castable(player, bp.MA["Shellra"]) and bp.helpers['party'].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Shellra V"], player)
                    
                elseif command == "auspice" and bp.helpers["target"].castable(player, bp.MA["Auspice"]) and bp.helpers['party'].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Auspice"], player)
                    
                elseif command == "regen" and bp.helpers["target"].castable(target, bp.MA["Regen"]) then
                    bp.helpers['queue'].add(bp.MA["Regen IV"], target)
                    
                elseif command == "erase" and bp.helpers["target"].castable(target, bp.MA["Erase"]) and bp.helpers['party'].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Erase"], target)
                    
                elseif command == "para" and bp.helpers["target"].castable(target, bp.MA["Paralyna"]) then
                    bp.helpers['queue'].add(bp.MA["Paralyna"], target)
                    
                elseif (command == "stoned" or command == "stona") and bp.helpers["target"].castable(target, bp.MA["Stona"]) then
                    bp.helpers['queue'].add(bp.MA["Stona"], target)
                    
                elseif (command == "curse" or command == "doom") and bp.helpers["target"].castable(target, bp.MA["Cursna"]) then
                    bp.helpers['queue'].add(bp.MA["Cursna"], target)

                elseif command == "earth+" and bp.helpers["target"].castable(target, bp.MA["Sandstorm"]) then
                    bp.helpers['queue'].add(bp.MA["Sandstorm"], target)

                elseif command == "water+" and bp.helpers["target"].castable(target, bp.MA["Rainstorm"]) then
                    bp.helpers['queue'].add(bp.MA["Rainstorm"], target)

                elseif command == "wind+" and bp.helpers["target"].castable(target, bp.MA["Windstorm"]) then
                    bp.helpers['queue'].add(bp.MA["Windstorm"], target)

                elseif command == "fire+" and bp.helpers["target"].castable(target, bp.MA["Firestorm"]) then
                    bp.helpers['queue'].add(bp.MA["Firestorm"], target)

                elseif command == "ice+" and bp.helpers["target"].castable(target, bp.MA["Hailstorm"]) then
                    bp.helpers['queue'].add(bp.MA["Hailstorm"], target)

                elseif command == "thunder+" and bp.helpers["target"].castable(target, bp.MA["Thunderstorm"]) then
                    bp.helpers['queue'].add(bp.MA["Thunderstorm"], target)

                elseif command == "dark+" and bp.helpers["target"].castable(target, bp.MA["Voidstorm"]) then
                    bp.helpers['queue'].add(bp.MA["Voidstorm"], target)

                elseif command == "light+" and bp.helpers["target"].castable(target, bp.MA["Aurorastorm"]) then
                    bp.helpers['queue'].add(bp.MA["Aurorastorm"], target)
                        
                elseif command == "zzz" then
                    
                    if bp.helpers["target"].castable(target, bp.MA["Curaga"]) and bp.helpers['party'].isInParty(target, false) then
                        bp.helpers['queue'].add(bp.MA["Curaga"], target)
                        
                    elseif bp.helpers["target"].castable(target, bp.MA["Cure"]) and bp.helpers['party'].isInParty(target, true) then
                        bp.helpers['queue'].add(bp.MA["Cure"], target)
                    
                    end
                        
                elseif (command == "raise" or command == "arise") and bp.helpers['target'].isDead(target) then
                        
                    if bp.helpers['actions'].isReady('MA', "Arise") then
                        bp.helpers['queue'].add(bp.MA["Arise"], player)
                        
                    elseif bp.helpers['actions'].isReady('MA', "Raise III") then
                        bp.helpers['queue'].add(bp.MA["Raise III"], player)
                        
                    elseif bp.helpers['actions'].isReady('MA', "Raise II") then
                        bp.helpers['queue'].add(bp.MA["Raise II"], player)
                        
                    elseif bp.helpers['actions'].isReady('MA', "Raise") then
                        bp.helpers['queue'].add(bp.MA["Raise"], player)
                        
                    end
                
                elseif command == "holla" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Holla"], player)
                    
                elseif command == "dem" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Dem"], player)
                    
                elseif command == "mea" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Mea"], player)
                    
                elseif command == "yhoat" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Yhoat"], player)
                    
                elseif command == "altepa" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Altepa"], player)
                    
                elseif command == "vazhl" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Teleport-Vahzl"], player)
                    
                elseif command == "jugner" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Recall-Jugner"], player)
                    
                elseif command == "pash" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Recall-Pashh"], player)
                    
                elseif command == "meriph" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].add(bp.MA["Recall-Meriph"], player)
                
                elseif command == "fcircle" and bp.helpers['actions'].isReady('JA', 'Full Circle') then
                    bp.helpers['queue'].add(bp.JA["Full Circle"], 'me')                            
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

    self.run = function(message, sender)
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
                
                if command == "ofa" and bp.helpers['actions'].isReady('JA', 'One For All') then
                    bp.helpers['queue'].addToFront(bp.JA["One For All"], target)                            
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