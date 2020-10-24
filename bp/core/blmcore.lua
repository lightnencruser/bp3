--------------------------------------------------------------------------------
-- BLM Core: Handle all job automation for Black Mage.
--------------------------------------------------------------------------------
local core = {}

-- CORE AUTOMATED FUNCTION FOR THIS JOB.
function core.get()
    local self = {}
    
    -- MASTER SETTINGS.
    local settings = {}
    settings["AM"]                                 = I{false,true}
    settings["AM LEVEL"]                           = I{3,2,1}
    settings["AM THRESHOLD"]                       = 3000
    settings["1HR"]                                = I{false,true}
    settings["JA"]                                 = I{false,true}
    settings["RA"]                                 = I{false,true}
    settings["CURES"]                              = I{1,2,3}
    settings["SUBLIMATION"]                        = I{true,false}
    settings["HATE"]                               = I{false,true}
    settings["BUFFS"]                              = I{false,true}
    settings["DEBUFFS"]                            = I{false,true}
    settings["STATUS"]                             = I{false,true}
    settings["WS"]                                 = I{false,true}
    settings["WSNAME"]                             = "Myrkr"
    settings["RANGED WS"]                          = "Myrkr"
    settings["TP THRESHOLD"]                       = 1000
    settings["SC"]                                 = I{false,true}
    settings["BURST"]                              = I{false,true}
    settings["ELEMENT"]                            = I{"Fire","Ice","Wind","Earth","Lightning","Water","Light","Dark","Random"}
    settings["TIER"]                               = I{"I","II","III","IV","V","Random"}
    settings["ALLOW-AOE"]                          = I{false,true}
    settings["DRAINS"]                             = I{false,true}
    settings["STUNS"]                              = I{false,true}
    settings["TANK MODE"]                          = I{false,true}
    settings["SEKKA"]                              = "Cataclysm"
    settings["SHADOWS"]                            = I{false,true}
    settings["FOOD"]                               = I{"Sublime Sushi","Sublime Sushi +1"}
    settings["SAMBAS"]                             = I{"Drain Samba II","Haste Samba"}
    settings["STEPS"]                              = I{"Quickstep","Box Step","Stutter Step"}
    settings["RUNES"]                              = {rune1="",rune2="",rune3=""}
    settings["RUNE1"]                              = I{"Lux","Tenebrae","Unda","Ignis","Gelus","Flabra","Tellus","Sulpor"}
    settings["RUNE2"]                              = I{"Lux","Tenebrae","Unda","Ignis","Gelus","Flabra","Tellus","Sulpor"}
    settings["RUNE3"]                              = I{"Lux","Tenebrae","Unda","Ignis","Gelus","Flabra","Tellus","Sulpor"}
    settings["SKILLUP"]                            = I{false,true}
    settings["SKILLS"]                             = I{"Elemental","Enhancing"}
    settings["COMPOSURE"]                          = I{true,false}
    settings["CONVERT"]                            = I{true,false}
    settings["ENSPELL"]                            = I{"Enfire","Enblizzard","Enaero","Enstone","Enthunder","Enwater"}
    settings["GAINS"]                              = I{"Gain-DEX","Gain-STR","Gain-MND","Gain-INT","Gain-AGI","Gain-VIT","Gain-CHR"}
    settings["SPIKES"]                             = I{"None","Blaze Spikes","Ice Spikes","Shock Spikes"}
    settings["DIA"]                                = I{"Dia","Bio"}
    settings["SANGUINE"]                           = I{false,true}
    settings["REPEAT"]                             = I{false,true}
    settings["LAST REPEAT"]                        = os.clock()
    settings["THRENODY"]                           = I{"Fire Threnody II","Ice Threnody II","Wind Threnody II","Earth Threnody II","Lightning Threnody II","Water Threnody II","Light Threnody II","Dark Threnody II"}
    settings["ROLL"]                               = I{false,true}
    settings["QD"]                                 = I{false,true}
    settings["SHOTS"]                              = I{"Fire Shot","Ice Shot","Wind Shot","Earth Shot","Thunder Shot","Water Shot","Light Shot","Dark Shot"}
    settings["ROLL1"]                              = false
    settings["ROLL2"]                              = false
    settings["INDI"]                               = I{false,true}
    settings["GEO"]                                = I{false,true}
    settings["ENTRUST"]                            = I{false,true}
    settings["ISPELL"]                             = ""
    settings["GSPELL"]                             = ""
    settings["ESPELL"]                             = ""
    settings["ETARGET"]                            = system["Main Character"]
    settings["BUBBLE BUFF"]                        = I{"Ecliptic Attrition","Lasting Emanation"}
    settings["BOOST"]                              = I{false,true}
    settings["PET"]                                = I{false,true}
    settings["SPIRITS"]                            = T{"Light Spirit","Fire Spirirt","Ice Spirit","Air Spirit","Earth Spirit","Thunder Spirit","Water Spirit","Dark Spirit"}
    settings["SUMMON"]                             = I{"Carbuncle","Cait Sith","Ifrit","Shiva","Garuda","Titan","Ramuh","Leviathan","Fenrir","Diabolos","Siren"}
    settings["BPRAGE"]                             = I{false,true}
    settings["BPWARD"]                             = I{false,true}
    settings["ROTATE"]                             = I{false,true}
    settings["AOEHATE"]                            = I{false,true}
    settings["EMBOLDEN"]                           = I{"Palanx","Temper","Regen IV"}
    settings["BLU MODE"]                           = I{"DPS","NUKE"}
    settings["MIGHTY GUARD"]                       = I{true,false}
    settings["CHIVALRY"]                           = I{1000,1500,2000,2500,3000}
    settings["WEATHER"]                            = I{"Firestorm","Hailstorm","Windstorm","Sandstorm","Thunderstorm","Rainstorm","Voidstorm","Aurorastorm"}
    settings["ARTS"]                               = I{"Light Arts","Dark Arts"}
    settings["WHITE"]                              = I{"Addendum: White","Addendum: Black"}
    settings["MISERY"]                             = I{false,true}
    settings["IMPETUS WS"]                         = "Raging Fists"
    settings["FOORWORK WS"]                        = "Tornado Kick"
    settings["DEFAULT WS"]                         = "Howling Fist"
    
    settings["MAGIC BURST"]={
        
        ["Transfixion"]   = T{},
        ["Compression"]   = T{"Bio II","Aspir","Drain","Impact"},
        ["Liquefaction"]  = T{"Fire","Fire II","Fire III","Fire IV","Fire V","Fire VI","Flare","Flare II"},
        ["Scission"]      = T{"Stone","Stone II","Stone III","Stone IV","Stone V","Stone VI","Quake","Quake II","Slow"},
        ["Reverberation"] = T{"Water","Water II","Water III","Water IV","Water V","Water VI","Flood","Flood II","Poison II"},
        ["Detonation"]    = T{"Aero","Aero II","Aero III","Aero IV","Aero V","Aero VI","Tornado","Tornado II","Silence"},
        ["Induration"]    = T{"Blizzard","Blizzard II","Blizzard III","Blizzard IV","Blizzard V","Blizzard VI","Freeze","Freeze II"},
        ["Impaction"]     = T{"Thunder","Thunder II","Thunder III","Thunder IV","Thunder V","Thunder VI","Burst","Burst II"},
        
    }
    
    -- JOB POINTS AVAILABLE.
    settings["JOB POINTS"] = windower.ffxi.get_player()["job_points"][windower.ffxi.get_player().main_job:lower()].jp_spent
    
    -- DISPLAY SETTINGS
    local display          = I{false, true}
    local display_settings = {
        ["pos"]={["x"]=system["Target Window X"],['y']=(system["Target Window Y"]-30)},
        ['bg']={['alpha']=200,['red']=0,['green']=0,['blue']=0,['visible']=false},
        ['flags']={['right']=false,['bottom']=false,['bold']=false,['draggable']=system["Job Draggable"],['italic']=false},
        ['padding']=system["Job Padding"],
        ['text']={['size']=system["Job Font"].size,['font']=system["Job Font"].font,['fonts']={},['alpha']=system["Job Font"].alpha,['red']=system["Job Font"].r,['green']=system["Job Font"].g,['blue']=system["Job Font"].b,
            ['stroke']={['width']=system["Job Stroke"].width,['alpha']=system["Job Stroke"].alpha,['red']=system["Job Stroke"].r,['green']=system["Job Stroke"].g,['blue']=system["Job Stroke"].b}
        },
    }
    
    local window = texts.new(windower.ffxi.get_player().main_job_full, display_settings)
    
    -- HANDLE PARTY CHAT COMMANDS.
    self.handleChat = function(message, sender, mode, gm)
        
        if (mode == 3 or mode == 4) then
            local player   = windower.ffxi.get_player() or false
            local accounts = T(system["Controllers"])
            
            if (accounts):contains(sender) then
                local commands = message:split(" ")
                
                if commands[1] and player and player.name:lower():match(commands[1]) then
                    
                end
                
            else
                
            end
            
        end
        
    end
    
    -- HANDLE CORE JOB COMMANDS.
    self.handleCommands = function(commands)
        local command = commands[1] or false
        
        if command and type(command) == "string" then
            local player  = windower.ffxi.get_player()
            local command = command:lower()
            local message = ""
            
            if command == "reset" then
                system["BP Enabled"]:setTo(true)
                settings["HATE"]:setTo(false)
                settings["BUFFS"]:setTo(false)
                settings["JA"]:setTo(false)
                settings["WS"]:setTo(false)
                settings["ROLL"]:setTo(false)
                settings["PET"]:setTo(false)
                settings["INDI"]:setTo(false)
                settings["GEO"]:setTo(false)
                settings["ENTRUST"]:setTo(false)
                settings["REPEAT"]:setTo(false)
                settings["CURES"]:setTo(1)
                settings["STATUS"]:setTo(false)
                helpers["controls"].setControls(true)
                helpers["controls"].setAutoAssist(false)
                helpers["controls"].setAutoDistance(false)
                helpers["controls"].setAutoFacing(true)
                helpers["trust"].setEnabled(false)
                helpers["queue"].clear()
                windower.send_command("bp clear")
                message = ("DISABLING ALL SETTINGS!")
                
            elseif command == "trash" then
                system["BP Enabled"]:setTo(true)
                settings["HATE"]:setTo(false)
                settings["BUFFS"]:setTo(true)
                settings["JA"]:setTo(true)
                settings["WS"]:setTo(true)
                settings["WSNAME"] = "Myrkr"
                settings["ROLL"]:setTo(false)
                settings["PET"]:setTo(false)
                settings["INDI"]:setTo(false)
                settings["GEO"]:setTo(false)
                settings["ENTRUST"]:setTo(false)
                settings["REPEAT"]:setTo(false)
                settings["CURES"]:setTo(1)
                settings["STATUS"]:setTo(false)
                helpers["controls"].setControls(true)
                helpers["controls"].setAutoAssist(false)
                helpers["controls"].setAutoDistance(false)
                helpers["controls"].setAutoFacing(true)
                helpers["trust"].setEnabled(false)
                helpers["queue"].clear()
                windower.send_command("bp clear")
                message = ("TRASH SETTINGS ENABLED!")
                
            elseif command == "cp" then
                system["BP Enabled"]:setTo(true)
                settings["HATE"]:setTo(false)
                settings["BUFFS"]:setTo(true)
                settings["JA"]:setTo(true)
                settings["WS"]:setTo(true)
                settings["WSNAME"] = "Myrkr"
                settings["ROLL"]:setTo(false)
                settings["PET"]:setTo(false)
                settings["INDI"]:setTo(false)
                settings["GEO"]:setTo(false)
                settings["ENTRUST"]:setTo(false)
                settings["REPEAT"]:setTo(false)
                settings["CURES"]:setTo(1)
                settings["STATUS"]:setTo(false)
                helpers["controls"].setControls(true)
                helpers["controls"].setAutoAssist(false)
                helpers["controls"].setAutoDistance(false)
                helpers["controls"].setAutoFacing(true)
                helpers["trust"].setEnabled(false)
                helpers["queue"].clear()
                windower.send_command("bp clear")
                message = ("CP FARM SETTINGS ENABLED!")
                
            end
            
            if message ~= "" then
                helpers['popchat']:pop(message:upper() or ("INVALID COMANDS"):upper(), system["Popchat Window"])
            end
            
        end
        
        -- HANDLE GLOBAL COMMANDS.
        helpers["corecommands"].handle(commands)
        
    end
    
    -- HANDLE ITEM LOGIC.
    self.handleItems = function()
        
        if bpcore:canItem() and bpcore:checkReady() and not system["Midaction"] then
            
            if bpcore:buffActive(15) then
                
                if bpcore:findItemByName("Holy Water") and not helpers["queue"].inQueue(IT["Holy Water"], "me") then
                    helpers["queue"].add(IT["Holy Water"], "me")
                
                elseif bpcore:findItemByName("Hallowed Water") and not helpers["queue"].inQueue(IT["Hallowed Water"], "me") then
                    helpers["queue"].add(IT["Hallowed Water"], "me")
                    
                end
            
            elseif bpcore:buffActive(6) then
                
                if bpcore:findItemByName("Echo Drops") and not helpers["queue"].inQueue(IT["Echo Drops"], "me") then
                    helpers["queue"].add(IT["Echo Drops"], "me")
                end
                
            end
        
        end
        
    end
    
    self.handleAutomation = function()
        
        -- Handle items.
        system["Core"].handleItems()
        
        if bpcore:checkReady() and not helpers["actions"].getMoving() and system["BP Enabled"]:current() then
            local player  = windower.ffxi.get_player() or false
            local current = helpers["queue"].getNextAction() or false
            
            -- Determine how to handle status debuffs.
            if settings["STATUS"]:current() then
                helpers["status"].manangeStatuses()
            end
            
            -- PLAYER IS ENGAGED.
            if player.status == 1 then
                local target = helpers["target"].getTarget() or windower.ffxi.get_mob_by_target("t") or false
                
                -- SKILLUP LOGIC.
                if settings["SKILLUP"]:current() then
                    
                    if bpcore:findItemByName("B.E.W. Pitaru") and not helpers["queue"].inQueue(IT["B.E.W. Pitaru"], player) and not bpcore:buffActive(251) then
                        helpers["queue"].add(IT["B.E.W. Pitaru"], "me")
                        
                    else
                    
                        for i,v in pairs(system["Skillup"][settings["SKILLS"]:current()].list) do
    
                            if helpers["actions"].isReady("MA", v) then
                                helpers["queue"].add(MA[v], system["Skillup"][settings["SKILLS"]:current()].target)
                            end
                            
                        end
                    
                    end
                    
                end
                
                -- WEAPON SKILL LOGIC.
                if settings["WS"]:current() and bpcore:canAct() then
                    local current = {tp=player["vitals"].tp, hpp=player["vitals"].hpp, mpp=player["vitals"].mpp, main=system["Weapon"].en, ranged=system["Ranged"].en}
                    
                    if settings["AM"]:current() and target and (target.distance):sqrt() < 6 then
                        local weaponskill = helpers["aftermath"].getWeaponskill(current.main)
                        local aftermath   = helpers["aftermath"].getBuffByLevel(settings["AM LEVEL"]:current())
                        
                        if settings["SANGUINE"]:current() and player["vitals"].hpp < system[player.main_job]["Sanguine Threshold"] and helpers["actions"].isReady("WS", "Sanguine Blade") then
                            helpers["queue"].addToFront(WS["Sanguine Blade"], target)
                            
                        elseif not bpcore:buffActive(aftermath) and current.tp > settings["AM THRESHOLD"] and weaponskill and helpers["actions"].isReady("WS", weaponskill) then
                            helpers["queue"].addToFront(WS[weaponskill], target)
                            
                        elseif (bpcore:buffActive(aftermath) or not weaponskill) and current.tp > settings["TP THRESHOLD"] and helpers["actions"].isReady("WS", settings["WSNAME"]) then
                            helpers["queue"].addToFront(WS[settings["WSNAME"]], target)
                            
                        end
                        
                    elseif not settings["AM"]:current() and target and (target.distance):sqrt() < 6 then
                            
                        if current.tp > settings["TP THRESHOLD"] and helpers["actions"].isReady("WS", settings["WSNAME"]) then
                            helpers["queue"].addToFront(WS[settings["WSNAME"]], target)                            
                        end
                    
                    elseif not settings["AM"]:current() and target and (target.distance):sqrt() > 6 then
                        
                        if current.tp > settings["TP THRESHOLD"] and helpers["actions"].isReady("WS", settings["RANGED WS"]) then
                            helpers["queue"].addToFront(WS[settings["RANGED WS"]], target)                            
                        end
                    
                    end
                    
                end
                
                -- ABILITY LOGIC.
                if settings["JA"]:current() and bpcore:canAct() then
                    
                    -- BLM/.
                    if player.main_job == "BLM" then
                        
                    end
                    
                    -- /RDM.
                    if player.sub_job == "RDM" then
                        
                        -- CONVERT LOGIC.
                        if settings["CONVERT"]:current() and player["vitals"].hpp > system[player.main_job]["Convert Threshold"].hpp and player["vitals"].mpp < system[player.main_job]["Convert Threshold"].mpp then
                            
                            if helpers["actions"].isReady("JA", "Convert") then
                                helpers["queue"].add(JA["Convert"], player)
                                helpers["queue"].add(MA["Cure IV"], player)
                                
                            end
                            
                        end
                    
                    -- /SCH.
                    elseif player.sub_job == "SCH" then
                        
                        -- SUBLIMATION LOGIC.
                        if bpcore:canAct() and settings["SUBLIMATION"]:current() and not bpcore:buffActive(187) and not bpcore:buffActive(188) and helpers["actions"].isReady("JA", "Sublimation") then
                            helpers["queue"].add(JA["Sublimation"], player)
                            
                        elseif bpcore:canAct() and settings["SUBLIMATION"]:current() and not bpcore:buffActive(187) and bpcore:buffActive(188) and helpers["actions"].isReady("JA", "Sublimation") then
                            helpers["queue"].add(JA["Sublimation"], player)
                            
                        end
                    
                    -- /DRG.
                    elseif player.sub_job == "DRG" then
                        
                        -- JUMP.
                        if target and helpers["actions"].isReady("JA", "Jump") then
                            helpers["queue"].add(JA["Jump"], target)
                            
                        -- HIGH JUMP.
                        elseif target and helpers["actions"].isReady("JA", "High Jump") then
                            helpers["queue"].add(JA["High Jump"], target)
                            
                        end
                        
                    -- /DNC.
                    elseif player.sub_job == "DNC" then
                        
                        -- REVERSE FLOURISH.
                        if target and helpers["actions"].isReady("JA", "Reverse Flourish") and bpcore:getFinishingMoves() > 4 then
                            helpers["queue"].add(JA["Reverse Flourish"], player)                            
                        end
                    
                    end
                    
                end
                
                -- HATE LOGIC.
                if settings["HATE"]:current() then
                    
                    -- BLM/.
                    if player.main_job == "BLM" then
                    
                    end
                    
                    -- /RDM.
                    if player.sub_job == "RDM" then
                    
                    -- /WAR.
                    elseif player.sub_job == "WAR" then
                        
                        -- PROVOKE.
                        if target and bpcore:canAct() and helpers["actions"].isReady("JA", "Provoke") then
                            helpers["queue"].add(JA["Provoke"], target)
                        end
                    
                    -- /RUN.
                    elseif player.sub_job == "RUN" then
                        
                        -- FLASH.
                        if target and bpcore:canCast() and helpers["actions"].isReady("MA", "Flash") then
                            helpers["queue"].addToFront(MA["Flash"], target)                            
                        end
                        
                        if bpcore:canAct() and system[player.main_job] and (os.clock()-system[player.main_job]["Hate Timer"]) > system[player.main_job]["Hate Delay"] then
                        
                            -- VALLATION.
                            if target and helpers["actions"].isReady("JA", "Vallation") and helpers["runes"].getActive() > 0 then
                                helpers["queue"].addToFront(JA["Vallation"], player)
                                system[player.main_job]["Hate Timer"] = os.clock()
                                
                            -- PFLUG.
                            elseif target and helpers["actions"].isReady("JA", "Pflug") and helpers["runes"].getActive() > 0 then
                                helpers["queue"].addToFront(JA["Pflug"], player)
                                system[player.main_job]["Hate Timer"] = os.clock()
                                
                            end
                            
                        end
                    
                    -- /DRK.
                    elseif player.sub_job == "DRK" then
                        
                        -- STUN.
                        if target and bpcore:canCast() and helpers["actions"].isReady("MA", "Stun") then
                            helpers["queue"].addToFront(MA["Stun"], target)                            
                        end
                        
                        if bpcore:canAct() and system[player.main_job] and (os.clock()-system[player.main_job]["Hate Timer"]) > system[player.main_job]["Hate Delay"] then
                        
                            -- SOULEATER.
                            if target and not bpcore:buffActive(64) and helpers["actions"].isReady("JA", "Souleater") then
                                helpers["queue"].addToFront(JA["Souleater"], player)
                                system[player.main_job]["Hate Timer"] = os.clock()
                                
                                if settings["TANK MODE"]:current() then
                                    windower.send_command("wait 1; cancel 63")
                                end
                                
                            -- LAST RESORT.
                            elseif target and not bpcore:buffActive(64) and helpers["actions"].isReady("JA", "Last Resort") then
                                helpers["queue"].addToFront(JA["Last Resort"], player)
                                system[player.main_job]["Hate Timer"] = os.clock()
                                
                                if settings["TANK MODE"]:current() then
                                    windower.send_command("wait 1; cancel 64")
                                end
                                
                            end
                            
                        end
                    
                    -- /BLU.
                    elseif player.sub_job == "BLU" and bpcore:canCast() then
                        
                        -- JETTATURA.
                        if target and helpers["actions"].isReady("MA", "Jettatura") then
                            helpers["queue"].add(MA["Jettatura"], target)
                            
                        -- BLANK GAZE.
                        elseif target and helpers["actions"].isReady("MA", "Blank Gaze") then
                            helpers["queue"].add(MA["Blank Gaze"], target)
                            
                        end
                        
                        if settings["AOEHATE"]:current() and system[player.main_job]["Hate Timer"] and (os.clock()-system[player.main_job]["Hate Timer"]) > system[player.main_job]["Hate Delay"] then
                            
                            -- SOPORIFIC.
                            if target and helpers["actions"].isReady("MA", "Soporific") then
                                helpers["queue"].add(MA["Soporific"], target)
                                system[player.main_job]["Hate Timer"] = os.clock()
                            
                            -- GEIST WALL.
                            elseif target and helpers["actions"].isReady("MA", "Geist Wall") then
                                helpers["queue"].add(MA["Geist Wall"], target)
                                system[player.main_job]["Hate Timer"] = os.clock()
                            
                            -- JETTATURA.
                            elseif target and helpers["actions"].isReady("MA", "Sheep Song") then
                                helpers["queue"].add(MA["Sheep Song"], target)
                                system["THF"]["Hate Timer"] = os.clock()
                            
                            end
                            
                        end
                    
                    -- /DNC.
                    elseif player.sub_job == "DNC" then
                        
                        -- ANIMATED FLOURISH.
                        if target and bpcore:canAct() and helpers["actions"].isReady("JA", "Animated Flourish") and bpcore:getFinishingMoves() > 0 then
                            helpers["queue"].add(JA["Animated Flourish"], target)
                        end
                    
                    end
                    
                end
                
                -- BUFF LOGIC.
                if settings["BUFFS"]:current() then
                    
                    -- BLM/.
                    if player.main_job == "BLM" then
                    
                    end
                    
                    -- /SCH.
                    if player.sub_job == "SCH" then
                        
                        -- LIGHT ARTS.
                        if bpcore:canAct() and helpers["actions"].isReady("JA", settings["ARTS"]:current()) and settings["ARTS"]:current() == "Light Arts" and (not bpcore:buffActive(358) and not bpcore:buffActive(401)) then
                            helpers["queue"].add(JA[settings["ARTS"]:current()], player)
                        
                        -- DARK ARTS.
                        elseif bpcore:canAct() and helpers["actions"].isReady("JA", settings["ARTS"]:current()) and settings["ARTS"]:current() == "Dark Arts" and (not bpcore:buffActive(359) and not bpcore:buffActive(402)) then
                            helpers["queue"].add(JA[settings["ARTS"]:current()], player)
                            
                        -- ADDENDUM.
                        elseif bpcore:canAct() and (bpcore:buffActive(358) or bpcore:buffActive(359)) and helpers["actions"].isReady("JA", settings["WHITE"]:current()) and helpers["stratagems"].getStratagems().current > 0 then
                                        
                            if settings["WHITE"]:current() == "Addendum: White" and not bpcore:buffActive(401) then
                                helpers["queue"].add(JA[settings["WHITE"]:current()], player)
                                
                            elseif settings["WHITE"]:current() == "Addendum: Black" and not bpcore:buffActive(402) then
                                helpers["queue"].add(JA[settings["WHITE"]:current()], player)
                                
                            end
                            
                        -- STORMS.
                        elseif bpcore:canCast() and helpers["actions"].isReady("MA", settings["WEATHER"]:current()) then
                            
                            if settings["WEATHER"]:current() == "Firestorm" and not bpcore:buffActive(178) then
                                helpers["queue"].add(MA[settings["WEATHER"]:current()], player)
                                
                            elseif settings["WEATHER"]:current() == "Hailstorm" and not bpcore:buffActive(179) then
                                helpers["queue"].add(MA[settings["WEATHER"]:current()], player)
                                
                            elseif settings["WEATHER"]:current() == "Windstorm" and not bpcore:buffActive(180) then
                                helpers["queue"].add(MA[settings["WEATHER"]:current()], player)
                                
                            elseif settings["WEATHER"]:current() == "Sandstorm" and not bpcore:buffActive(181) then
                                helpers["queue"].add(MA[settings["WEATHER"]:current()], player)
                                
                            elseif settings["WEATHER"]:current() == "Thunderstorm" and not bpcore:buffActive(182) then
                                helpers["queue"].add(MA[settings["WEATHER"]:current()], player)
                                
                            elseif settings["WEATHER"]:current() == "Rainstorm" and not bpcore:buffActive(183) then
                                helpers["queue"].add(MA[settings["WEATHER"]:current()], player)
                                
                            elseif settings["WEATHER"]:current() == "Aurorastorm" and not bpcore:buffActive(184) then
                                helpers["queue"].add(MA[settings["WEATHER"]:current()], player)
                                
                            elseif settings["WEATHER"]:current() == "Voidstorm" and not bpcore:buffActive(185) then
                                helpers["queue"].add(MA[settings["WEATHER"]:current()], player)
                                
                            end
                        
                        -- KLIMAFORM
                        elseif bpcore:canCast() and helpers["actions"].isReady("MA", "Klimaform") and not bpcore:buffActive(407) then
                            helpers["queue"].add(MA["Klimaform"], player)
                            
                        -- STONESKIN.
                        elseif bpcore:canCast() and helpers["actions"].isReady("MA", "Stoneskin") and not bpcore:buffActive(37) then
                            helpers["queue"].add(MA["Stoneskin"], player)
                            
                        end
                    
                    -- /RDM.
                    elseif player.sub_job == "RDM" and bpcore:canCast() then
                        
                        -- HASTE.
                        if helpers["actions"].isReady("MA", "Haste") and not bpcore:buffActive(33) then
                            helpers["queue"].addToFront(MA["Haste"], player)
                        
                        -- ENSPELLS.
                        elseif (not bpcore:buffActive(94) or not bpcore:buffActive(95) or not bpcore:buffActive(96) or not bpcore:buffActive(97) or not bpcore:buffActive(98) or not bpcore:buffActive(99)) then
                            
                            if helpers["actions"].isReady("MA", settings["ENSPELL"]:current()) then
                                helpers["queue"].addToFront(MA[settings["ENSPELL"]:current()], player)
                            end
                        
                        -- PHALANX.
                        elseif helpers["actions"].isReady("MA", "Phalanx") and not bpcore:buffActive(116) then
                            helpers["queue"].addToFront(MA["Phalanx"], player)
                            
                        -- REFRESH.
                        elseif not settings["SUBLIMATION"]:current() and helpers["actions"].isReady("MA", "Refresh") and not bpcore:buffActive(43) then
                            helpers["queue"].addToFront(MA["Refresh"], player)
                            
                        -- STONESKIN.
                        elseif helpers["actions"].isReady("MA", "Stoneskin") and not bpcore:buffActive(37) then
                            helpers["queue"].add(MA["Stoneskin"], player)
                            
                        -- SPIKES.
                        elseif helpers["actions"].isReady("MA", settings["SPIKES"]:current()) and (not bpcore:buffActive(34) or not bpcore:buffActive(35) or not bpcore:buffActive(38)) then
                            helpers["queue"].add(MA[settings["SPIKES"]:current()], player)
                            
                        end                            
                            
                    -- /WAR.
                    elseif player.sub_job == "WAR" and bpcore:canAct() then
                    
                        -- BERSERK.
                        if target and not settings["TANK MODE"]:current() and not bpcore:buffActive(56) and helpers["actions"].isReady("JA", "Berserk") then
                            helpers["queue"].add(JA["Berserk"], player)
                        
                        -- DEFENDER.
                        elseif settings["TANK MODE"]:current() and not bpcore:buffActive(57) and helpers["actions"].isReady("JA", "Defender") then
                            helpers["queue"].add(JA["Defender"], player)
                            
                        -- AGGRESSOR.
                        elseif target and not bpcore:buffActive(58) and helpers["actions"].isReady("JA", "Aggressor") then
                            helpers["queue"].add(JA["Aggressor"], player)
                        
                        -- WARCRY.
                        elseif target and not bpcore:buffActive(68) and not bpcore:buffActive(460) and helpers["actions"].isReady("JA", "Warcry") then
                            helpers["queue"].add(JA["Warcry"], player)
                        
                        end
                    
                    -- /SAM.
                    elseif player.sub_job == "SAM" and bpcore:canAct() then
                        
                        -- HASSO.
                        if not settings["TANK MODE"]:current() and not bpcore:buffActive(353) and helpers["actions"].isReady("JA", "Hasso") then
                            helpers["queue"].add(JA["Hasso"], player)
                        
                        -- SEIGAN.
                        elseif settings["TANK MODE"]:current() and not bpcore:buffActive(354) and helpers["actions"].isReady("JA", "Seigan") then
                            helpers["queue"].add(JA["Seigan"], player)
                        
                        -- MEDITATE.
                        elseif helpers["actions"].isReady("JA", "Meditate") then
                            helpers["queue"].addToFront(JA["Meditate"], player)
                        
                        -- THIRD EYE.
                        elseif not bpcore:buffActive(67) and helpers["actions"].isReady("JA", "Third Eye") then
                            helpers["queue"].add(JA["Third Eye"], player)
                        
                        end
                    
                    -- /DRK.
                    elseif player.sub_job == "DRK" and bpcore:canAct() then
                        
                        -- LAST RESORT.
                        if target and not settings["TANK MODE"]:current() and not bpcore:buffActive(64) and helpers["actions"].isReady("JA", "Last Resort") then
                            helpers["queue"].add(JA["Last Resort"], player)
                        
                        -- SOULEATER.
                        elseif target and not settings["TANK MODE"]:current() and not bpcore:buffActive(63) and helpers["actions"].isReady("JA", "Souleater") then
                            helpers["queue"].add(JA["Souleater"], player)
                            
                        -- ARCANE CIRCLE.
                        elseif target and bpcore:buffActive(75) and helpers["actions"].isReady("JA", "Arcane Circle") then
                            helpers["queue"].add(JA["Arcan Circle"], player)
                        
                        end
                    
                    -- /RUN
                    elseif player.sub_job == "RUN" then
                        local runes  = helpers["runes"].getRunes()
                        local active = helpers["runes"].getActive()
                        
                        if runes:length() > active then
                            helpers["runes"].remove()
                        end
                        
                        -- RUNE ENCHANMENTS.
                        if runes:length() > 0 and runes:length() < 3 then
                            
                            if bpcore:canAct() and runes[runes:length()].position == 1 then
                                
                                if helpers["actions"].isReady("JA", settings["RUNE2"]:current()) and not helpers["queue"].inQueue(JA[settings["RUNE2"]:current()], player) then
                                    helpers["queue"].add(JA[settings["RUNE2"]:current()], "me")
                                end
                                
                            elseif bpcore:canAct() and runes[runes:length()].position == 2 then
                                
                                if helpers["actions"].isReady("JA", settings["RUNE3"]:current()) and not helpers["queue"].inQueue(JA[settings["RUNE3"]:current()], player) then
                                    helpers["queue"].add(JA[settings["RUNE3"]:current()], "me")
                                end
                                
                            elseif bpcore:canAct() and runes[runes:length()].position == 3 then
                                
                                if helpers["actions"].isReady("JA", settings["RUNE1"]:current()) and not helpers["queue"].inQueue(JA[settings["RUNE1"]:current()], player) then
                                    helpers["queue"].add(JA[settings["RUNE1"]:current()], "me")
                                end
                                
                            end
                            
                        elseif runes:length() == 0 then
                            
                            if helpers["actions"].isReady("JA", settings["RUNE1"]:current()) and not helpers["queue"].inQueue(JA[settings["RUNE1"]:current()], player) then
                                helpers["queue"].add(JA[settings["RUNE1"]:current()], "me")
                            end
                            
                        end
                    
                    -- /BLU.
                    elseif player.sub_job == "BLU" then
                    
                    -- /DRG.
                    elseif player.sub_job == "DRG" then
                        
                        -- ANCIENT CIRCLE.
                        if target and not bpcore:buffaActive(118) and helpers["actions"].isReady("JA", "Ancient Circle") then
                            helpers["queue"].add(JA["Ancient Circle"], player)                        
                        end
                        
                    -- /RNG.
                    elseif player.sub_job == "RNG" and bpcore:canAct() then
                        
                        -- SHARPSHOT.
                        if target and not bpcore:buffActive(72) and helpers["actions"].isReady("JA", "Sharpshot") then
                            helpers["queue"].addToFront(JA["Sharpshot"], player)
                        
                        -- BARRAGE.
                        elseif target and not bpcore:buffActive(371) and helpers["actions"].isReady("JA", "Velocity Shot") then
                            helpers["queue"].addToFront(JA["Velocity Shot"], player)
                        
                        -- VELOCITY SHOT.
                        elseif not bpcore:buffActive(73) and helpers["actions"].isReady("JA", "Barrage") then
                            helpers["queue"].add(JA["Barrage"], player)
                        
                        end
                        
                    -- /DNC.
                    elseif player.sub_job == "DNC" and bpcore:canAct() then
                    
                        -- SAMBAS.
                        if target and (not bpcore:buffActive(368) and not bpcore:buffActive(370)) and helpers["actions"].isReady("JA", settings["SAMBAS"]:current()) then
                            helpers["queue"].add(JA[settings["SAMBAS"]:current()], player)                            
                        end
                    
                    -- /NIN.
                    elseif player.sub_job == "NIN" then
                    
                        -- UTSUSEMI
                        if bpcore:canCast() and bpcore:findItemByName("Shihei", 0) then
                            
                            if not bpcore:buffActive(444) and not bpcore:buffActive(445) and not bpcore:buffActive(446) and not bpcore:buffActive(36) then
                                
                                if helpers["actions"].isReady("MA", "Utsusemi: Ni") then
                                    helpers["queue"].addToFront(MA["Utsusemi: Ni"], player)
                                    
                                elseif helpers["actions"].isReady("MA", "Utsusemi: Ichi") then
                                    helpers["queue"].addToFront(MA["Utsusemi: Ichi"], player)
                                    
                                end
                            
                            end
                        
                        end
                    
                    end
                    
                end
                
                -- DEBUFF LOGIC.
                if settings["DEBUFFS"]:current() and target then
                    
                    -- BLM/.
                    if player.main_job == "BLM" and system[player.main_job]["Debuffs"] then
                        
                        -- CYCLE DEBUFFS.
                        for i,v in ipairs(system[player.main_job]["Debuffs"]) do
                            local debuff = MA[v.name] or JA[v.name] or WS[v.name] or false
                            
                            if debuff and (debuff.prefix == "/magic" or debuff.prefix == "/song" or debuff.prefix == "/ninjutsu") and v.cast then
                                
                                if helpers["actions"].isReady("MA", debuff.name) and (os.clock()-v.allowed) > v.delay then
                                    helpers["queue"].add(MA[debuff.name], target)
                                    system[player.main_job]["Debuffs"][i].allowed = os.clock()
                                    
                                end
                            
                            elseif debuff and debuff.prefix == "/jobability" and debuff.act then
                                
                                if helpers["actions"].isReady("JA", debuff.name) and (os.clock()-v.allowed) > v.delay then
                                    helpers["queue"].add(JA[debuff.name], target)
                                    system[player.main_job]["Debuffs"][i].allowed = os.clock()
                                    
                                end
                            
                            end
                        
                        end
                        
                    end
                    
                    -- /DNC.
                    if player.sub_job == "DNC" and target then
                    
                        -- STEPS.
                        if helpers["actions"].isReady("JA", settings["STEPS"]:current()) and os.clock()-system[player.main_job]["Steps Timer"] > system[player.main_job]["Steps Delay"] then
                            helpers["queue"].add(JA[settings["STEPS"]:current()], target)                            
                        end
                    
                    end
                    
                end
                
                -- DRAINS LOGIC
                if settings["DRAINS"]:current() and bpcore:canCast() and target then
                    
                    if helpers["actions"].isReady("MA", "Drain III") and player["vitals"].mpp < system[player.main_job]["Drain Threshold"] then
                        helpers["queue"].add(MA["Drain III"], target)
                        
                    elseif helpers["actions"].isReady("MA", "Drain II") and player["vitals"].mpp < system[player.main_job]["Drain Threshold"] then
                        helpers["queue"].add(MA["Drain II"], target)
                        
                    elseif helpers["actions"].isReady("MA", "Drain") and player["vitals"].mpp < system[player.main_job]["Drain Threshold"] then
                        helpers["queue"].add(MA["Drain"], target)
                        
                    end
                    
                    if helpers["actions"].isReady("MA", "Aspir III") and player["vitals"].mpp < system[player.main_job]["Aspir Threshold"] then
                        helpers["queue"].add(MA["Aspir III"], target)
                    
                    elseif helpers["actions"].isReady("MA", "Aspir II") and player["vitals"].mpp < system[player.main_job]["Aspir Threshold"] then
                        helpers["queue"].add(MA["Aspir II"], target)
                        
                    elseif helpers["actions"].isReady("MA", "Aspir") and player["vitals"].mpp < system[player.main_job]["Aspir Threshold"] then
                        helpers["queue"].add(MA["Aspir"], target)
                    
                    end
                    
                end
            
            -- PLAYER IS DISENGAGED LOGIC.
            elseif player.status == 0 then
                local target = helpers["target"].getTarget()
                
                -- SKILLUP LOGIC.
                if settings["SKILLUP"]:current() then
                    
                    if bpcore:findItemByName("B.E.W. Pitaru") and not helpers["queue"].inQueue(IT["B.E.W. Pitaru"], player) and not bpcore:buffActive(251) then
                        helpers["queue"].add(IT["B.E.W. Pitaru"], "me")
                        
                    else
                    
                        for i,v in pairs(system["Skillup"][settings["SKILLS"]:current()].list) do
    
                            if helpers["actions"].isReady("MA", v) then
                                helpers["queue"].add(MA[v], system["Skillup"][settings["SKILLS"]:current()].target)
                            end
                            
                        end
                    
                    end
                    
                end
                
                -- WEAPON SKILL LOGIC.
                if settings["WS"]:current() and bpcore:canAct() then
                    local current = {tp=player["vitals"].tp, hpp=player["vitals"].hpp, mpp=player["vitals"].mpp, main=system["Weapon"].en, ranged=system["Ranged"].en}
                    
                    if settings["AM"]:current() and target and (target.distance):sqrt() < 6 then
                        local weaponskill = helpers["aftermath"].getWeaponskill(current.main)
                        local aftermath   = helpers["aftermath"].getBuffByLevel(settings["AM LEVEL"]:current())
                        
                        if settings["SANGUINE"]:current() and player["vitals"].hpp < system[player.main_job]["Sanguine Threshold"] and helpers["actions"].isReady("WS", "Sanguine Blade") then
                            helpers["queue"].addToFront(WS["Sanguine Blade"], target)
                            
                        elseif not bpcore:buffActive(aftermath) and current.tp > settings["AM THRESHOLD"] and weaponskill and helpers["actions"].isReady("WS", weaponskill) then
                            helpers["queue"].addToFront(WS[weaponskill], target)
                            
                        elseif (bpcore:buffActive(aftermath) or not weaponskill) and current.tp > settings["TP THRESHOLD"] and helpers["actions"].isReady("WS", settings["WSNAME"]) then
                            helpers["queue"].addToFront(WS[settings["WSNAME"]], target)
                            
                        end
                        
                    elseif not settings["AM"]:current() and target and (target.distance):sqrt() < 6 then
                            
                        if current.tp > settings["TP THRESHOLD"] and helpers["actions"].isReady("WS", settings["WSNAME"]) then
                            helpers["queue"].addToFront(WS[settings["WSNAME"]], target)                            
                        end
                    
                    elseif not settings["AM"]:current() and target and (target.distance):sqrt() > 6 then
                        
                        if current.tp > settings["TP THRESHOLD"] and helpers["actions"].isReady("WS", settings["RANGED WS"]) then
                            helpers["queue"].addToFront(WS[settings["RANGED WS"]], target)                            
                        end
                    
                    end
                    
                end
                
                -- ABILITY LOGIC.
                if settings["JA"]:current() and bpcore:canAct() then
                    
                    -- BLM/.
                    if player.main_job == "BLM" then
                        
                    end
                    
                    -- /RDM.
                    if player.sub_job == "RDM" then
                        
                        -- CONVERT LOGIC.
                        if settings["CONVERT"]:current() and player["vitals"].hpp > system[player.main_job]["Convert Threshold"].hpp and player["vitals"].mpp < system[player.main_job]["Convert Threshold"].mpp then
                            
                            if helpers["actions"].isReady("JA", "Convert") then
                                helpers["queue"].add(JA["Convert"], player)
                                helpers["queue"].add(MA["Cure IV"], player)
                                
                            end
                            
                        end
                    
                    -- /SCH.
                    elseif player.sub_job == "SCH" then
                        
                        -- SUBLIMATION LOGIC.
                        if bpcore:canAct() and settings["SUBLIMATION"]:current() and not bpcore:buffActive(187) and not bpcore:buffActive(188) and helpers["actions"].isReady("JA", "Sublimation") then
                            helpers["queue"].add(JA["Sublimation"], player)
                            
                        elseif bpcore:canAct() and settings["SUBLIMATION"]:current() and not bpcore:buffActive(187) and bpcore:buffActive(188) and helpers["actions"].isReady("JA", "Sublimation") then
                            helpers["queue"].add(JA["Sublimation"], player)
                            
                        end
                    
                    -- /DRG.
                    elseif player.sub_job == "DRG" then
                        
                        -- JUMP.
                        if target and helpers["actions"].isReady("JA", "Jump") then
                            helpers["queue"].add(JA["Jump"], target)
                            
                        -- HIGH JUMP.
                        elseif target and helpers["actions"].isReady("JA", "High Jump") then
                            helpers["queue"].add(JA["High Jump"], target)
                            
                        end
                        
                    -- /DNC.
                    elseif player.sub_job == "DNC" then
                        
                        -- REVERSE FLOURISH.
                        if target and helpers["actions"].isReady("JA", "Reverse Flourish") and bpcore:getFinishingMoves() > 4 then
                            helpers["queue"].add(JA["Reverse Flourish"], player)                            
                        end
                    
                    end
                    
                end
                
                -- HATE LOGIC.
                if settings["HATE"]:current() then
                    
                    -- BLM/.
                    if player.main_job == "BLM" then
                    
                    end
                    
                    -- /RDM.
                    if player.sub_job == "RDM" then
                    
                    -- /WAR.
                    elseif player.sub_job == "WAR" then
                        
                        -- PROVOKE.
                        if target and bpcore:canAct() and helpers["actions"].isReady("JA", "Provoke") then
                            helpers["queue"].add(JA["Provoke"], target)
                        end
                    
                    -- /RUN.
                    elseif player.sub_job == "RUN" then
                        
                        -- FLASH.
                        if target and bpcore:canCast() and helpers["actions"].isReady("MA", "Flash") then
                            helpers["queue"].addToFront(MA["Flash"], target)                            
                        end
                        
                        if bpcore:canAct() and system[player.main_job] and (os.clock()-system[player.main_job]["Hate Timer"]) > system[player.main_job]["Hate Delay"] then
                        
                            -- VALLATION.
                            if target and helpers["actions"].isReady("JA", "Vallation") and helpers["runes"].getActive() > 0 then
                                helpers["queue"].addToFront(JA["Vallation"], player)
                                system[player.main_job]["Hate Timer"] = os.clock()
                                
                            -- PFLUG.
                            elseif target and helpers["actions"].isReady("JA", "Pflug") and helpers["runes"].getActive() > 0 then
                                helpers["queue"].addToFront(JA["Pflug"], player)
                                system[player.main_job]["Hate Timer"] = os.clock()
                                
                            end
                            
                        end
                    
                    -- /DRK.
                    elseif player.sub_job == "DRK" then
                        
                        -- STUN.
                        if target and bpcore:canCast() and helpers["actions"].isReady("MA", "Stun") then
                            helpers["queue"].addToFront(MA["Stun"], target)                            
                        end
                        
                        if bpcore:canAct() and system[player.main_job] and (os.clock()-system[player.main_job]["Hate Timer"]) > system[player.main_job]["Hate Delay"] then
                        
                            -- SOULEATER.
                            if target and not bpcore:buffActive(64) and helpers["actions"].isReady("JA", "Souleater") then
                                helpers["queue"].addToFront(JA["Souleater"], player)
                                system[player.main_job]["Hate Timer"] = os.clock()
                                
                                if settings["TANK MODE"]:current() then
                                    windower.send_command("wait 1; cancel 63")
                                end
                                
                            -- LAST RESORT.
                            elseif target and not bpcore:buffActive(64) and helpers["actions"].isReady("JA", "Last Resort") then
                                helpers["queue"].addToFront(JA["Last Resort"], player)
                                system[player.main_job]["Hate Timer"] = os.clock()
                                
                                if settings["TANK MODE"]:current() then
                                    windower.send_command("wait 1; cancel 64")
                                end
                                
                            end
                            
                        end
                    
                    -- /BLU.
                    elseif player.sub_job == "BLU" and bpcore:canCast() then
                        
                        -- JETTATURA.
                        if target and helpers["actions"].isReady("MA", "Jettatura") then
                            helpers["queue"].add(MA["Jettatura"], target)
                            
                        -- BLANK GAZE.
                        elseif target and helpers["actions"].isReady("MA", "Blank Gaze") then
                            helpers["queue"].add(MA["Blank Gaze"], target)
                            
                        end
                        
                        if settings["AOEHATE"]:current() and system[player.main_job]["Hate Timer"] and (os.clock()-system[player.main_job]["Hate Timer"]) > system[player.main_job]["Hate Delay"] then
                            
                            -- SOPORIFIC.
                            if target and helpers["actions"].isReady("MA", "Soporific") then
                                helpers["queue"].add(MA["Soporific"], target)
                                system[player.main_job]["Hate Timer"] = os.clock()
                            
                            -- GEIST WALL.
                            elseif target and helpers["actions"].isReady("MA", "Geist Wall") then
                                helpers["queue"].add(MA["Geist Wall"], target)
                                system[player.main_job]["Hate Timer"] = os.clock()
                            
                            -- JETTATURA.
                            elseif target and helpers["actions"].isReady("MA", "Sheep Song") then
                                helpers["queue"].add(MA["Sheep Song"], target)
                                system["THF"]["Hate Timer"] = os.clock()
                            
                            end
                            
                        end
                    
                    -- /DNC.
                    elseif player.sub_job == "DNC" then
                        
                        -- ANIMATED FLOURISH.
                        if target and bpcore:canAct() and helpers["actions"].isReady("JA", "Animated Flourish") and bpcore:getFinishingMoves() > 0 then
                            helpers["queue"].add(JA["Animated Flourish"], target)
                        end
                    
                    end
                    
                end
                
                -- BUFF LOGIC.
                if settings["BUFFS"]:current() then
                    
                    -- BLM/.
                    if player.main_job == "BLM" then
                    
                    end
                    
                    -- /SCH.
                    if player.sub_job == "SCH" then
                        
                        -- LIGHT ARTS.
                        if bpcore:canAct() and helpers["actions"].isReady("JA", settings["ARTS"]:current()) and settings["ARTS"]:current() == "Light Arts" and (not bpcore:buffActive(358) and not bpcore:buffActive(401)) then
                            helpers["queue"].add(JA[settings["ARTS"]:current()], player)
                        
                        -- DARK ARTS.
                        elseif bpcore:canAct() and helpers["actions"].isReady("JA", settings["ARTS"]:current()) and settings["ARTS"]:current() == "Dark Arts" and (not bpcore:buffActive(359) and not bpcore:buffActive(402)) then
                            helpers["queue"].add(JA[settings["ARTS"]:current()], player)
                            
                        -- ADDENDUM.
                        elseif bpcore:canAct() and (bpcore:buffActive(358) or bpcore:buffActive(359)) and helpers["actions"].isReady("JA", settings["WHITE"]:current()) and helpers["stratagems"].getStratagems().current > 0 then
                                        
                            if settings["WHITE"]:current() == "Addendum: White" and not bpcore:buffActive(401) then
                                helpers["queue"].add(JA[settings["WHITE"]:current()], player)
                                
                            elseif settings["WHITE"]:current() == "Addendum: Black" and not bpcore:buffActive(402) then
                                helpers["queue"].add(JA[settings["WHITE"]:current()], player)
                                
                            end
                            
                        -- STORMS.
                        elseif bpcore:canCast() and helpers["actions"].isReady("MA", settings["WEATHER"]:current()) then
                            
                            if settings["WEATHER"]:current() == "Firestorm" and not bpcore:buffActive(178) then
                                helpers["queue"].add(MA[settings["WEATHER"]:current()], player)
                                
                            elseif settings["WEATHER"]:current() == "Hailstorm" and not bpcore:buffActive(179) then
                                helpers["queue"].add(MA[settings["WEATHER"]:current()], player)
                                
                            elseif settings["WEATHER"]:current() == "Windstorm" and not bpcore:buffActive(180) then
                                helpers["queue"].add(MA[settings["WEATHER"]:current()], player)
                                
                            elseif settings["WEATHER"]:current() == "Sandstorm" and not bpcore:buffActive(181) then
                                helpers["queue"].add(MA[settings["WEATHER"]:current()], player)
                                
                            elseif settings["WEATHER"]:current() == "Thunderstorm" and not bpcore:buffActive(182) then
                                helpers["queue"].add(MA[settings["WEATHER"]:current()], player)
                                
                            elseif settings["WEATHER"]:current() == "Rainstorm" and not bpcore:buffActive(183) then
                                helpers["queue"].add(MA[settings["WEATHER"]:current()], player)
                                
                            elseif settings["WEATHER"]:current() == "Aurorastorm" and not bpcore:buffActive(184) then
                                helpers["queue"].add(MA[settings["WEATHER"]:current()], player)
                                
                            elseif settings["WEATHER"]:current() == "Voidstorm" and not bpcore:buffActive(185) then
                                helpers["queue"].add(MA[settings["WEATHER"]:current()], player)
                                
                            end
                        
                        -- KLIMAFORM
                        elseif bpcore:canCast() and helpers["actions"].isReady("MA", "Klimaform") and not bpcore:buffActive(407) then
                            helpers["queue"].add(MA["Klimaform"], player)
                            
                        -- STONESKIN.
                        elseif bpcore:canCast() and helpers["actions"].isReady("MA", "Stoneskin") and not bpcore:buffActive(37) then
                            helpers["queue"].add(MA["Stoneskin"], player)
                            
                        end
                    
                    -- /RDM.
                    elseif player.sub_job == "RDM" and bpcore:canCast() then
                        
                        -- HASTE.
                        if helpers["actions"].isReady("MA", "Haste") and not bpcore:buffActive(33) then
                            helpers["queue"].addToFront(MA["Haste"], player)
                        
                        -- ENSPELLS.
                        elseif (not bpcore:buffActive(94) or not bpcore:buffActive(95) or not bpcore:buffActive(96) or not bpcore:buffActive(97) or not bpcore:buffActive(98) or not bpcore:buffActive(99)) then
                            
                            if helpers["actions"].isReady("MA", settings["ENSPELL"]:current()) then
                                helpers["queue"].addToFront(MA[settings["ENSPELL"]:current()], player)
                            end
                        
                        -- PHALANX.
                        elseif helpers["actions"].isReady("MA", "Phalanx") and not bpcore:buffActive(116) then
                            helpers["queue"].addToFront(MA["Phalanx"], player)
                            
                        -- REFRESH.
                        elseif not settings["SUBLIMATION"]:current() and helpers["actions"].isReady("MA", "Refresh") and not bpcore:buffActive(43) then
                            helpers["queue"].addToFront(MA["Refresh"], player)
                            
                        -- STONESKIN.
                        elseif helpers["actions"].isReady("MA", "Stoneskin") and not bpcore:buffActive(37) then
                            helpers["queue"].add(MA["Stoneskin"], player)
                            
                        -- SPIKES.
                        elseif helpers["actions"].isReady("MA", settings["SPIKES"]:current()) and (not bpcore:buffActive(34) or not bpcore:buffActive(35) or not bpcore:buffActive(38)) then
                            helpers["queue"].add(MA[settings["SPIKES"]:current()], player)
                            
                        end                            
                            
                    -- /WAR.
                    elseif player.sub_job == "WAR" and bpcore:canAct() then
                    
                        -- BERSERK.
                        if target and not settings["TANK MODE"]:current() and not bpcore:buffActive(56) and helpers["actions"].isReady("JA", "Berserk") then
                            helpers["queue"].add(JA["Berserk"], player)
                        
                        -- DEFENDER.
                        elseif settings["TANK MODE"]:current() and not bpcore:buffActive(57) and helpers["actions"].isReady("JA", "Defender") then
                            helpers["queue"].add(JA["Defender"], player)
                            
                        -- AGGRESSOR.
                        elseif target and not bpcore:buffActive(58) and helpers["actions"].isReady("JA", "Aggressor") then
                            helpers["queue"].add(JA["Aggressor"], player)
                        
                        -- WARCRY.
                        elseif target and not bpcore:buffActive(68) and not bpcore:buffActive(460) and helpers["actions"].isReady("JA", "Warcry") then
                            helpers["queue"].add(JA["Warcry"], player)
                        
                        end
                    
                    -- /SAM.
                    elseif player.sub_job == "SAM" and bpcore:canAct() then
                        
                        -- HASSO.
                        if not settings["TANK MODE"]:current() and not bpcore:buffActive(353) and helpers["actions"].isReady("JA", "Hasso") then
                            helpers["queue"].add(JA["Hasso"], player)
                        
                        -- SEIGAN.
                        elseif settings["TANK MODE"]:current() and not bpcore:buffActive(354) and helpers["actions"].isReady("JA", "Seigan") then
                            helpers["queue"].add(JA["Seigan"], player)
                        
                        -- MEDITATE.
                        elseif helpers["actions"].isReady("JA", "Meditate") then
                            helpers["queue"].addToFront(JA["Meditate"], player)
                        
                        -- THIRD EYE.
                        elseif not bpcore:buffActive(67) and helpers["actions"].isReady("JA", "Third Eye") then
                            helpers["queue"].add(JA["Third Eye"], player)
                        
                        end
                    
                    -- /DRK.
                    elseif player.sub_job == "DRK" and bpcore:canAct() then
                        
                        -- LAST RESORT.
                        if target and not settings["TANK MODE"]:current() and not bpcore:buffActive(64) and helpers["actions"].isReady("JA", "Last Resort") then
                            helpers["queue"].add(JA["Last Resort"], player)
                        
                        -- SOULEATER.
                        elseif target and not settings["TANK MODE"]:current() and not bpcore:buffActive(63) and helpers["actions"].isReady("JA", "Souleater") then
                            helpers["queue"].add(JA["Souleater"], player)
                            
                        -- ARCANE CIRCLE.
                        elseif target and bpcore:buffActive(75) and helpers["actions"].isReady("JA", "Arcane Circle") then
                            helpers["queue"].add(JA["Arcan Circle"], player)
                        
                        end
                    
                    -- /RUN
                    elseif player.sub_job == "RUN" then
                        local runes  = helpers["runes"].getRunes()
                        local active = helpers["runes"].getActive()
                        
                        if runes:length() > active then
                            helpers["runes"].remove()
                        end
                        
                        -- RUNE ENCHANMENTS.
                        if runes:length() > 0 and runes:length() < 3 then
                            
                            if bpcore:canAct() and runes[runes:length()].position == 1 then
                                
                                if helpers["actions"].isReady("JA", settings["RUNE2"]:current()) and not helpers["queue"].inQueue(JA[settings["RUNE2"]:current()], player) then
                                    helpers["queue"].add(JA[settings["RUNE2"]:current()], "me")
                                end
                                
                            elseif bpcore:canAct() and runes[runes:length()].position == 2 then
                                
                                if helpers["actions"].isReady("JA", settings["RUNE3"]:current()) and not helpers["queue"].inQueue(JA[settings["RUNE3"]:current()], player) then
                                    helpers["queue"].add(JA[settings["RUNE3"]:current()], "me")
                                end
                                
                            elseif bpcore:canAct() and runes[runes:length()].position == 3 then
                                
                                if helpers["actions"].isReady("JA", settings["RUNE1"]:current()) and not helpers["queue"].inQueue(JA[settings["RUNE1"]:current()], player) then
                                    helpers["queue"].add(JA[settings["RUNE1"]:current()], "me")
                                end
                                
                            end
                            
                        elseif runes:length() == 0 then
                            
                            if helpers["actions"].isReady("JA", settings["RUNE1"]:current()) and not helpers["queue"].inQueue(JA[settings["RUNE1"]:current()], player) then
                                helpers["queue"].add(JA[settings["RUNE1"]:current()], "me")
                            end
                            
                        end
                    
                    -- /BLU.
                    elseif player.sub_job == "BLU" then
                    
                    -- /DRG.
                    elseif player.sub_job == "DRG" then
                        
                        -- ANCIENT CIRCLE.
                        if target and not bpcore:buffaActive(118) and helpers["actions"].isReady("JA", "Ancient Circle") then
                            helpers["queue"].add(JA["Ancient Circle"], player)                        
                        end
                        
                    -- /RNG.
                    elseif player.sub_job == "RNG" and bpcore:canAct() then
                        
                        -- SHARPSHOT.
                        if target and not bpcore:buffActive(72) and helpers["actions"].isReady("JA", "Sharpshot") then
                            helpers["queue"].addToFront(JA["Sharpshot"], player)
                        
                        -- BARRAGE.
                        elseif target and not bpcore:buffActive(371) and helpers["actions"].isReady("JA", "Velocity Shot") then
                            helpers["queue"].addToFront(JA["Velocity Shot"], player)
                        
                        -- VELOCITY SHOT.
                        elseif not bpcore:buffActive(73) and helpers["actions"].isReady("JA", "Barrage") then
                            helpers["queue"].add(JA["Barrage"], player)
                        
                        end
                    
                    -- /COR.
                    elseif player.sub_job == "COR" then
                        local rolling = helpers["rolls"].getRolling()
                        
                        -- CORSAIR ROLLS.
                        if settings["ROLL"]:current() and bpcore:canAct() and settings["ROLL1"] and not bpcore:buffActive(308) and helpers["actions"].isReady("JA", "Phantom Roll") then
                            local lucky1 = helpers["rolls"].getLucky(settings["ROLL1"].en)
                            
                            -- CHECK IF YOU NEED TO FOLD BEFOR ATTEMPTING TO ROLL, AND RESET ROLL NUMBER.
                            if bpcore:buffActive(309) and helpers["actions"].isReady("JA", "Fold") then
                                helpers["queue"].add(JA["Fold"], "me")
                                helpers["rolls"].setRolling("", 0)
                                
                            end
                            
                            -- MAKE SURE THAT THIS IS THE FIRST ROLL WHEN USING PHANTOM ROLL.
                            if rolling.dice == 0 then
                                
                                if not helpers["rolls"].findBuff(settings["ROLL1"].en:sub(1, 4)) then
                                    
                                    -- IF CROOKED IS READY USE ONLY ON THE FIRST ROLL SLOT.
                                    if bpcore:isJAReady(JA["Crooked Cards"].recast_id) and not bpcore:buffActive(601) and bpcore:getAvailable("JA", "Crooked Cards") then
                                        helpers["queue"].add(JA["Crooked Cards"], player)
                                        helpers["queue"].add(JA[settings["ROLL1"].en], player)
                                        
                                    else
                                        helpers["queue"].add(JA[settings["ROLL1"].en], player)
                                        
                                    end
                                    
                                end
                                
                            end
                            
                        elseif settings["ROLL"]:current() and bpcore:canAct() and bpcore:buffActive(308) and helpers["actions"].isReady("JA", "Double-Up") then
                            local lucky1 = helpers["rolls"].getLucky(settings["ROLL1"].en)
                            
                            -- CHECK IF YOU NEED TO FOLD BEFOR ATTEMPTING TO ROLL, AND RESET ROLL NUMBER.
                            if bpcore:buffActive(309) and helpers["actions"].isReady("JA", "Fold") then
                                helpers["queue"].add(JA["Fold"], player)
                                helpers["rolls"].setRolling("", 0)
                                
                            end
                            
                            -- ONLY DOUBLE-UP IF THIS ISNT THE FIRST ROLL, AND THE ROLL IS LESS THAN 7.
                            if rolling.dice > 0 and rolling.dice < 7 then
                                
                                -- DONT ROLL IF ON A LUCKY!
                                if rolling.dice ~= lucky1 and settings["ROLL1"].en == rolling.name then
                                    helpers["queue"].add(JA["Double-Up"], player)
                                end
                            
                            -- ONLY SNAKE EYE IF THIS ISNT THE FIRST ROLL, AND THE ROLL IS GREATER THAN 6.
                            elseif rolling.dice > 6 and not bpcore:buffActive(357) and helpers["actions"].isReady("JA", "Snake Eye") then
                                
                                -- DONT ROLL IF ON A LUCKY!
                                if rolling.dice ~= lucky1 and settings["ROLL1"].en == rolling.name then
                                    helpers["queue"].add(JA["Snake Eye"], player)
                                    helpers["queue"].add(JA["Double-Up"], player)                                    
                                end
                                
                            end
                            
                        end
                    
                    -- /DNC.
                    elseif player.sub_job == "DNC" and bpcore:canAct() then
                    
                        -- SAMBAS.
                        if target and (not bpcore:buffActive(368) and not bpcore:buffActive(370)) and helpers["actions"].isReady("JA", settings["SAMBAS"]:current()) then
                            helpers["queue"].add(JA[settings["SAMBAS"]:current()], player)                            
                        end
                    
                    -- /NIN.
                    elseif player.sub_job == "NIN" then
                    
                        -- UTSUSEMI
                        if bpcore:canCast() and bpcore:findItemByName("Shihei", 0) then
                            
                            if not bpcore:buffActive(444) and not bpcore:buffActive(445) and not bpcore:buffActive(446) and not bpcore:buffActive(36) then
                                
                                if helpers["actions"].isReady("MA", "Utsusemi: Ni") then
                                    helpers["queue"].addToFront(MA["Utsusemi: Ni"], player)
                                    
                                elseif helpers["actions"].isReady("MA", "Utsusemi: Ichi") then
                                    helpers["queue"].addToFront(MA["Utsusemi: Ichi"], player)
                                    
                                end
                            
                            end
                        
                        end
                    
                    end
                    
                end
                
                -- DEBUFF LOGIC.
                if settings["DEBUFFS"]:current() and target then
                    
                    -- BLM/.
                    if player.main_job == "BLM" and system[player.main_job]["Debuffs"] then
                        
                        -- CYCLE DEBUFFS.
                        for i,v in ipairs(system[player.main_job]["Debuffs"]) do
                            local debuff = MA[v.name] or JA[v.name] or WS[v.name] or false
                            
                            if debuff and (debuff.prefix == "/magic" or debuff.prefix == "/song" or debuff.prefix == "/ninjutsu") and v.cast then
                                
                                if helpers["actions"].isReady("MA", debuff.name) and (os.clock()-v.allowed) > v.delay then
                                    helpers["queue"].add(MA[debuff.name], target)
                                    system[player.main_job]["Debuffs"][i].allowed = os.clock()
                                    
                                end
                            
                            elseif debuff and debuff.prefix == "/jobability" and debuff.act then
                                
                                if helpers["actions"].isReady("JA", debuff.name) and (os.clock()-v.allowed) > v.delay then
                                    helpers["queue"].add(JA[debuff.name], target)
                                    system[player.main_job]["Debuffs"][i].allowed = os.clock()
                                    
                                end
                            
                            end
                        
                        end
                        
                    end
                    
                    -- /DNC.
                    if player.sub_job == "DNC" and target then
                    
                        -- STEPS.
                        if helpers["actions"].isReady("JA", settings["STEPS"]:current()) and os.clock()-system[player.main_job]["Steps Timer"] > system[player.main_job]["Steps Delay"] then
                            helpers["queue"].add(JA[settings["STEPS"]:current()], target)                            
                        end
                    
                    end
                    
                end
                
                -- DRAINS LOGIC
                if settings["DRAINS"]:current() and bpcore:canCast() and target then
                    
                    if helpers["actions"].isReady("MA", "Drain III") and player["vitals"].mpp < system[player.main_job]["Drain Threshold"] then
                        helpers["queue"].add(MA["Drain III"], target)
                        
                    elseif helpers["actions"].isReady("MA", "Drain II") and player["vitals"].mpp < system[player.main_job]["Drain Threshold"] then
                        helpers["queue"].add(MA["Drain II"], target)
                        
                    elseif helpers["actions"].isReady("MA", "Drain") and player["vitals"].mpp < system[player.main_job]["Drain Threshold"] then
                        helpers["queue"].add(MA["Drain"], target)
                        
                    end
                    
                    if helpers["actions"].isReady("MA", "Aspir III") and player["vitals"].mpp < system[player.main_job]["Aspir Threshold"] then
                        helpers["queue"].add(MA["Aspir III"], target)
                    
                    elseif helpers["actions"].isReady("MA", "Aspir II") and player["vitals"].mpp < system[player.main_job]["Aspir Threshold"] then
                        helpers["queue"].add(MA["Aspir II"], target)
                        
                    elseif helpers["actions"].isReady("MA", "Aspir") and player["vitals"].mpp < system[player.main_job]["Aspir Threshold"] then
                        helpers["queue"].add(MA["Aspir"], target)
                    
                    end
                    
                end
            
            end
            
            -- HANDLE EVERYTHING INSIDE THE QUEUE.
            helpers["cures"].handleCuring()
            helpers["queue"].handleQueue()
        
        end
        
    end
    
    self.handleWindow = function()
        
    end
    
    self.toggleDisplay = function()
        display:next()
    end
    
    self.getDisplay = function()
        return display:current()
    end
    
    self.next = function(name)
        local name = name or false
        
        if name then
            settings[name]:next()
        end
        
    end
    
    self.current = function(name)
        local name = name or false
        
        if name then        
            return settings[name]:current()
        end
        
    end
    
    self.set = function(name, value)
        local name, value = name or false, value or false
        
        if name and value then
            settings[name]:setTo(value)
        end
        
    end
    
    self.value = function(name, value)
        local name, value = name or false, value or false
        
        if name and value then
            settings[name] = (value)
        end
        
    end
    
    self.get = function(name)
        local name = name or false
        
        if name then        
            return settings[name]
        end
        
    end
    
    self.getSettings = function()
        return settings
    end
    
    return self
    
end

return core.get()