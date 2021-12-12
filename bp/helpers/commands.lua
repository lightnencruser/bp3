local commands = {}
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

    self.captureChat = function(message, sender, mode, gm)

        if bp and message and sender then
            local allowed = bp.helpers['controllers'].isAllowed(sender)
            
            if gm then
                return
            end
        
            if allowed then
                self[bp.player.main_job:lower()](message, sender)
            end
            
        end
        
    end
        
    self.war = function(message, sender)
    
        if bp and message and sender then
            local player  = bp.player
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
        
        if bp and message and sender then
            local target  = windower.ffxi.get_mob_by_name(sender)
            local player  = bp.player
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
                    bp.helpers['queue'].hardAdd(bp.MA["Teleport-Holla"], player)
                    
                elseif command == "dem" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].hardAdd(bp.MA["Teleport-Dem"], player)
                    
                elseif command == "mea" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].hardAdd(bp.MA["Teleport-Mea"], player)
                    
                elseif command == "yhoat" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].hardAdd(bp.MA["Teleport-Yhoat"], player)
                    
                elseif command == "altepa" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].hardAdd(bp.MA["Teleport-Altepa"], player)
                    
                elseif command == "vazhl" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].hardAdd(bp.MA["Teleport-Vahzl"], player)
                    
                elseif command == "jugner" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].ahardAdddd(bp.MA["Recall-Jugner"], player)
                    
                elseif command == "pash" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].hardAdd(bp.MA["Recall-Pashh"], player)
                    
                elseif command == "meriph" and bp.helpers["party"].isInParty(target, false) then
                    bp.helpers['queue'].hardAdd(bp.MA["Recall-Meriph"], player)
                
                end
                
            end
            
        end
        
    end
        
    self.blm = function(message, sender)
        
        if bp and message and sender then
            local target  = windower.ffxi.get_mob_by_name(sender)
            local player  = bp.player
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

                elseif command == "speed" then
                    windower.send_command('input /ma "Chocobo Mazurka" <me>')
                
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
                
                if command == "speed" then
                    windower.send_command('input /ma "Bolter\'s Roll" <me>')
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