local core = {}
local player    = windower.ffxi.get_player()
local files     = require('files')
local texts     = require('texts')
local res       = require('resources')
local f         = files.new(string.format('bp/core/%s/settings/%s.lua', player.main_job, player.name))

if not f:exists() then
    f:write(string.format('return %s', T({}):tovstring()))
end

function core.get()
    local self = {}

    -- Static Variables
    self.settings   = dofile(string.format('%sbp/core/%s/settings/%s.lua', windower.addon_path, player.main_job, player.name))
    self.layout     = self.settings.layout or {pos={x=5, y=5}, colors={text={alpha=255, r=245, g=200, b=20}, bg={alpha=245, r=0, g=0, b=0}, stroke={alpha=255, r=0, g=0, b=0}}, font={name='Lucida Console', size=9}, padding=8, stroke_width=1, draggable=false}
    self.display    = texts.new('', {flags={draggable=self.layout.draggable}})
    self.config     = texts.new('', {flags={draggable=self.layout.draggable}})
    self.important  = string.format('%s,%s,%s', 25, 200, 200)

    -- Private Variables.
    local timers     = {hate=0, steps=0}

    -- Public Variables
    self["JOB POINTS"]          = windower.ffxi.get_player()["job_points"][windower.ffxi.get_player().main_job:lower()].jp_spent
    self["AM"]                  = self.settings["AM"] or {{false,true}, false}
    self["AM LEVEL"]            = self.settings["AM LEVEL"] or {{3,2,1}, 3}
    self["1HR"]                 = self.settings["1HR"] or {{false,true}, false}
    self["JA"]                  = self.settings["JA"] or {{false,true}, true}
    self["RA"]                  = self.settings["RA"] or {{false,true}, false}
    self["SUBLIMATION"]         = self.settings["SUBLIMATION"] or {{true,false}, true}
    self["HATE"]                = self.settings["HATE"] or {{false,true}, true}
    self["BUFFS"]               = self.settings["BUFFS"] or {{false,true}, true}
    self["DEBUFF"]             = self.settings["DEBUFF"] or {{false,true}, false}
    self["STATUS"]              = self.settings["STATUS"] or {{false,true}, false}
    self["WS"]                  = self.settings["WS"] or {{false,true}, false}
    self["WSNAME"]              = self.settings["WSNAME"] or "Evisceration"
    self["RANGED WS"]           = self.settings["RANGED WS"] or "Leaden Salute"
    self["TP THRESHOLD"]        = self.settings["TP THRESHOLD"] or 1000
    self["SC"]                  = self.settings["SC"] or {{false,true}, false}
    self["BURST"]               = self.settings["BURST"] or {{false,true}, false}
    self["ELEMENT"]             = self.settings["ELEMENT"] or {{"Fire","Ice","Wind","Earth","Lightning","Water","Light","Dark","Random"}, "Fire"}
    self["NUKE TIER"]           = self.settings["NUKE TIER"] or {{"I","II","III","IV","V","Random"}, "I"}
    self["ALLOW AOE"]           = self.settings["ALLOW AOE"] or {{false,true}, false}
    self["DRAINS"]              = self.settings["DRAINS"] or {{false,true}, false}
    self["STUNS"]               = self.settings["STUNS"] or {{false,true}, false}
    self["TANK MODE"]           = self.settings["TANK MODE"] or {{false,true}, false}
    self["SEKKA"]               = self.settings["SEKKA"] or "Evisceration"
    self["SHADOWS"]             = self.settings["SHADOWS"] or {{false,true}, false}
    self["FOOD"]                = self.settings["FOOD"] or {{"Sublime Sushi","Sublime Sushi +1"}, "Sublime Sushi"}
    self["SAMBAS"]              = self.settings["SAMBAS"] or {{"Drain Samba II","Haste Samba"}, "Haste Samba"}
    self["STEPS"]               = self.settings["STEPS"] or {{"Quickstep","Box Step","Stutter Step"}, "Quickstep"}
    self["SKILLUP"]             = self.settings["SKILLUP"] or {{false,true}, false}
    self["SKILLS"]              = self.settings["SKILLS"] or {{"Enhancing","Divine","Enfeebling","Elemental","Dark","Singing","Summoning","Blue","Geomancy"}, "Enhancing"}
    self["COMPOSURE"]           = self.settings["COMPOSURE"] or {{true,false}, true}
    self["CONVERT"]             = self.settings["CONVERT"] or {{true,false}, false}
    self["ENSPELL"]             = self.settings["ENSPELL"] or {{"Enfire","Enblizzard","Enaero","Enstone","Enthunder","Enwater"}, "Enfire"}
    self["GAINS"]               = self.settings["GAINS"] or {{"Gain-DEX","Gain-STR","Gain-MND","Gain-INT","Gain-AGI","Gain-VIT","Gain-CHR"}, "Gain-DEX"}
    self["SPIKES"]              = self.settings["SPIKES"] or {{"None","Blaze Spikes","Ice Spikes","Shock Spikes"}, "None"}
    self["DIA"]                 = self.settings["DIA"] or {{"Dia","Bio"}, "Dia"}
    self["SANGUINE"]            = self.settings["SANGUINE"] or {{false,true}, false}
    self["COR SHOTS"]           = self.settings["SHOTS"] or {{"Fire Shot","Ice Shot","Wind Shot","Earth Shot","Thunder Shot","Water Shot","Light Shot","Dark Shot"}, "Fire Shot"}
    self["BOOST"]               = self.settings["BOOST"] or {{false,true}, false}
    self["PET"]                 = self.settings["PET"] or {{false,true}, false}
    self["SUMMON"]              = self.settings["SUMMON"] or {{"Carbuncle","Cait Sith","Ifrit","Shiva","Garuda","Titan","Ramuh","Leviathan","Fenrir","Diabolos","Siren"}, "Ifrit"}
    self["BPRAGE"]              = self.settings["BPRAGE"] or {{false,true}, false}
    self["BPWARD"]              = self.settings["BPWARD"] or {{false,true}, false}
    self["AOEHATE"]             = self.settings["AOEHATE"] or {{false,true}, false}
    self["EMBOLDEN"]            = self.settings["EMBOLDEN"] or {{"Palanx","Temper","Regen IV"}, "Phalanx"}
    self["BLU MODE"]            = self.settings["BLU MODE"] or {{"DPS","NUKE"}, "DPS"}
    self["MIGHTY GUARD"]        = self.settings["MIGHTY GUARD"] or {{true,false}, true}
    self["CHIVALRY"]            = self.settings["CHIVALRY"] or {{1000,1500,2000,2500,3000}, 2000}
    self["WEATHER"]             = self.settings["WEATHER"] or {{"Firestorm","Hailstorm","Windstorm","Sandstorm","Thunderstorm","Rainstorm","Voidstorm","Aurorastorm"}, "Aurorastorm"}
    self["ARTS"]                = self.settings["ARTS"] or {{"Light Arts","Dark Arts"}, "Light Arts"}
    self["ADDENDUM"]            = self.settings["ADDENDUM"] or {{"Addendum: White","Addendum: Black"}, "Addendum: White"}
    self["MISERY"]              = self.settings["MISERY"] or {{false,true}, false}
    self["IMPETUS WS"]          = self.settings["IMPETUS WS"] or "Raging Fists"
    self["FOOTWORK WS"]         = self.settings["FOOTWORK WS"] or "Tornado Kick"
    self["DEFAULT WS"]          = self.settings["DEFAULT WS"] or "Howling Fist"
    self["SANGUINE HPP"]        = self.settings["SANGUINE HPP"] or 45
    self["MOONLIGHT MPP"]       = self.settings["MOONLIGHT MPP"] or 30
    self["MYRKR MPP"]           = self.settings["MYRKR MPP"] or 30
    self["VPULSE HPP"]          = self.settings["VPULSE HPP"] or 65
    self["VPULSE MPP"]          = self.settings["VPULSE MPP"] or 65
    self["HATE DELAY"]          = self.settings["HATE DELAY"] or 25
    self["STEPS DELAY"]         = self.settings["HATE DELAY"] or 20
    self["CONVERT HPP"]         = self.settings["CONVERT HPP"] or 40
    self["CONVERT MPP"]         = self.settings["CONVERT MPP"] or 35

    -- MAGIC BURST SPELLS.
    self.settings["MAGIC BURST"]={

        ["Transfixion"]   = {},
        ["Compression"]   = {},
        ["Liquefaction"]  = {},
        ["Scission"]      = {},
        ["Reverberation"] = {},
        ["Detonation"]    = {},
        ["Induration"]    = {},
        ["Impaction"]     = {},

    }

    -- Private Functions.
    local persist = function()

        if self.settings then
            self.settings.layout                = self.layout
            self.settings["AM"]                 = self["AM"]
            self.settings["AM LEVEL"]           = self["AM LEVEL"]
            self.settings["1HR"]                = self["1HR"]
            self.settings["JA"]                 = self["JA"]
            self.settings["RA"]                 = self["RA"]
            self.settings["CURES"]              = self["CURES"]
            self.settings["SUBLIMATION"]        = self["SUBLIMATION"]
            self.settings["HATE"]               = self["HATE"]
            self.settings["BUFFS"]              = self["BUFFS"]
            self.settings["DEBUFF"]            = self["DEBUFF"]
            self.settings["STATUS"]             = self["STATUS"]
            self.settings["WS"]                 = self["WS"]
            self.settings["WSNAME"]             = self["WSNAME"]
            self.settings["RANGED WS"]          = self["RANGED WS"]
            self.settings["TP THRESHOLD"]       = self["TP THRESHOLD"]
            self.settings["SC"]                 = self["SC"]
            self.settings["BURST"]              = self["BURST"]
            self.settings["ELEMENT"]            = self["ELEMENT"]
            self.settings["TIER"]               = self["TIER"]
            self.settings["ALLOW AOE"]          = self["ALLOW AOE"]
            self.settings["DRAINS"]             = self["DRAINS"]
            self.settings["STUNS"]              = self["STUNS"]
            self.settings["TANK MODE"]          = self["TANK MODE"]
            self.settings["SEKKA"]              = self["SEKKA"]
            self.settings["SHADOWS"]            = self["SHADOWS"]
            self.settings["FOOD"]               = self["FOOD"]
            self.settings["SAMBAS"]             = self["SAMBAS"]
            self.settings["STEPS"]              = self["STEPS"]
            self.settings["SKILLUP"]            = self["SKILLUP"]
            self.settings["SKILLS"]             = self["SKILLS"]
            self.settings["COMPOSURE"]          = self["COMPOSURE"]
            self.settings["CONVERT"]            = self["CONVERT"]
            self.settings["ENSPELL"]            = self["ENSPELL"]
            self.settings["GAINS"]              = self["GAINS"]
            self.settings["SPIKES"]             = self["SPIKES"]
            self.settings["DIA"]                = self["DIA"]
            self.settings["SANGUINE"]           = self["SANGUINE"]
            self.settings["COR SHOTS"]          = self["COR SHOTS"]
            self.settings["BOOST"]              = self["BOOST"]
            self.settings["PET"]                = self["PET"]
            self.settings["SPIRITS"]            = self["SPIRITS"]
            self.settings["SUMMON"]             = self["SUMMON"]
            self.settings["BPRAGE"]             = self["BPRAGE"]
            self.settings["BPWARD"]             = self["BPWARD"]
            self.settings["AOEHATE"]            = self["AOEHATE"]
            self.settings["EMBOLDEN"]           = self["EMBOLDEN"]
            self.settings["BLU MODE"]           = self["BLU MODE"]
            self.settings["MIGHTY GUARD"]       = self["MIGHTY GUARD"]
            self.settings["CHIVALRY"]           = self["CHIVALRY"]
            self.settings["WEATHER"]            = self["WEATHER"]
            self.settings["ARTS"]               = self["ARTS"]
            self.settings["ADDENDUM"]           = self["ADDENDUM"]
            self.settings["MISERY"]             = self["MISERY"]
            self.settings["IMPETUS WS"]         = self["IMPETUS WS"]
            self.settings["FOOTWORK WS"]        = self["FOOTWORK WS"]
            self.settings["DEFAULT WS"]         = self["DEFAULT WS"]
            self.settings["SANGUINE HPP"]       = self["SANGUINE HPP"]
            self.settings["VPULSE HPP"]         = self["VPULSE HPP"]
            self.settings["VPULSE MPP"]         = self["VPULSE MPP"]
            self.settings["HATE DELAY"]         = self["HATE DELAY"]
            self.settings["STEPS DELAY"]        = self["HATE DELAY"]
            self.settings["CONVERT HPP"]        = self["CONVERT HPP"]
            self.settings["CONVERT MPP"]        = self["CONVERT MPP"]

        end

    end
    persist()

    -- Static Functions
    local resetDisplay = function()
        self.display:pos(self.layout.pos.x, self.layout.pos.y)
        self.display:font(self.layout.font.name)
        self.display:color(self.layout.colors.text.r, self.layout.colors.text.g, self.layout.colors.text.b)
        self.display:alpha(self.layout.colors.text.alpha)
        self.display:size(self.layout.font.size)
        self.display:pad(self.layout.padding)
        self.display:bg_color(self.layout.colors.bg.r, self.layout.colors.bg.g, self.layout.colors.bg.b)
        self.display:bg_alpha(self.layout.colors.bg.alpha)
        self.display:stroke_width(self.layout.stroke_width)
        self.display:stroke_color(self.layout.colors.stroke.r, self.layout.colors.stroke.g, self.layout.colors.stroke.b)
        self.display:stroke_alpha(self.layout.colors.stroke.alpha)
        self.display:hide()
        self.display:update()

        self.config:pos(10, 10)
        self.config:font(self.layout.font.name)
        self.config:color(self.layout.colors.text.r, self.layout.colors.text.g, self.layout.colors.text.b)
        self.config:alpha(self.layout.colors.text.alpha)
        self.config:size(self.layout.font.size + 1)
        self.config:pad(self.layout.padding)
        self.config:bg_color(self.layout.colors.bg.r, self.layout.colors.bg.g, self.layout.colors.bg.b)
        self.config:bg_alpha(self.layout.colors.bg.alpha)
        self.config:stroke_width(self.layout.stroke_width)
        self.config:stroke_color(self.layout.colors.stroke.r, self.layout.colors.stroke.g, self.layout.colors.stroke.b)
        self.config:stroke_alpha(self.layout.colors.stroke.alpha)
        self.config:hide()
        self.config:update()

    end
    resetDisplay()

    self.writeSettings = function()
        persist()

        if f:exists() then
            f:write(string.format('return %s', T(self.settings):tovstring()))

        elseif not f:exists() then
            f:write(string.format('return %s', T({}):tovstring()))

        end

    end
    self.writeSettings()

    self.reload = function()
        self.writeSettings()
        self.display:destroy()
        self.config:destroy()

    end

    -- Public Functions.
    self.handleCommands = function(bp, commands)
        local bp = bp or false

        if commands and commands[1] then
            local command = commands[1]

            if command == 'config' then
                self.renderConfig()

            else
                bp.helpers['commands'].captureCore(bp, commands)
                persist()
                bp.core.writeSettings()

            end

        end

    end

    self.handleItems = function(bp)
        local bp = bp or false

        if bp then
            helpers = bp.helpers

            if helpers['actions'].canItem(bp) then

                if helpers['buffs'].buffActive(15) then

                    if helpers['inventory'].findItemByName("Holy Water") and not helpers['queue'].inQueue(bp, bp.IT["Holy Water"], 'me') then
                        helpers['queue'].add(bp, bp.IT["Holy Water"], 'me')

                    elseif helpers['inventory'].findItemByName("Hallowed Water") and not helpers["queue"].inQueue(bp, bp.IT["Hallowed Water"], 'me') then
                        helpers['queue'].add(bp, bp.IT["Hallowed Water"], 'me')

                    end

                elseif helpers['buffs'].buffActive(6) then

                    if helpers['inventory'].findItemByName("Echo Drops") and not helpers['queue'].inQueue(bp, bp.IT["Echo Drops"], 'me') then
                        helpers['queue'].add(bp, bp.IT["Echo Drops"], 'me')
                    end

                end

            end

        end

    end

    self.handleAutomation = function(bp)
        local bp = bp or false

        if bp then
            local helpers = bp.helpers
            local player = windower.ffxi.get_player()
            
            if helpers['queue'].ready and not helpers['actions'].moving and bp.settings['Enabled'] then
                self.handleItems(bp)

                -- PLAYER IS ENGAGED.
                if player.status == 1 then
                    local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target("t") or false
                    
                    -- SKILLUP LOGIC.
                    if self.getSetting('SKILLUP') then
                        
                        if helpers['inventory'].findItemByName("B.E.W. Pitaru") and not helpers['queue'].inQueue(bp, bp.IT["B.E.W. Pitaru"]) and not helpers['buffs'].buffActive(251) then
                            helpers['queue'].add(bp, bp.IT["B.E.W. Pitaru"], 'me')
                            
                        else
                            local skills = bp.skillup[self.getSetting('SKILLS')]
                                                        
                            if skills and skills.list then

                                for _,v in pairs(skills.list) do
                                    
                                    if helpers['actions'].isReady(bp, "MA", v) and not helpers['queue'].inQueue(bp, bp.MA[v]) then
                                        helpers['queue'].add(bp, bp.MA[v], bp.skillup[self.getSetting('SKILLS')].target)
                                    end
                                
                                end

                            end
                        
                        end
                        
                    end
                    
                    -- WEAPON SKILL LOGIC.
                    if self.getSetting('WS') and helpers['actions'].canAct() and target and (target.distance):sqrt() < 6 then
                        local current = {tp=player["vitals"].tp, hpp=player["vitals"].hpp, mpp=player["vitals"].mpp, main=helpers['equipment'].main.en, ranged=helpers['equipment'].ranged.en}

                        if self.getSetting('AM') then
                            local weaponskill = helpers["aftermath"].getWeaponskill(bp, current.main)
                            local aftermath   = helpers["aftermath"].getBuffByLevel(bp, self.getSetting('AM LEVEL'))
                            
                            if self.getSetting('SANGUINE') and current.hpp < self.getSetting('SANGUINE HPP') and helpers['actions'].isReady(bp, 'WS', "Sanguine Blade") then
                                helpers["queue"].addToFront(bp, bp.WS["Sanguine Blade"], target)

                            elseif not helpers['buffs'].buffActive(aftermath) and current.tp > (self.getSetting('AM LEVEL')*1000) and weaponskill and helpers['actions'].isReady(bp, 'WS', weaponskill) then
                                helpers["queue"].addToFront(bp, bp.WS[weaponskill], target)

                            elseif helpers['buffs'].buffActive(aftermath) and current.mpp < self.getSetting('MOONLIGHT MPP') and helpers['actions'].isReady(bp, 'WS', "Moonlight") then
                                helpers["queue"].addToFront(bp, bp.WS["Moonlight"], 'me')

                            elseif helpers['buffs'].buffActive(aftermath) and current.mpp < self.getSetting('MYRKR MPP') and helpers['actions'].isReady(bp, 'WS', "Myrkr") then
                                helpers["queue"].addToFront(bp, bp.WS["Myrkr"], 'me')
                                
                            elseif (helpers['buffs'].buffActive(aftermath) or not weaponskill) and current.tp >= self.getSetting('TP THRESHOLD') and helpers['actions'].isReady(bp, 'WS', self.getSetting('WSNAME')) then
                                helpers["queue"].addToFront(bp, bp.WS[self.getSetting('WSNAME')], target)
                                
                            end
                            
                        elseif not self.getSetting('AM') and target then
                            
                            if current.mpp < self.getSetting('MOONLIGHT MPP') and helpers['actions'].isReady(bp, 'WS', "Moonlight") then
                                helpers["queue"].addToFront(bp, bp.WS["Moonlight"], 'me')

                            elseif current.mpp < self.getSetting('MYRKR MPP') and helpers['actions'].isReady(bp, 'WS', "Myrkr") then
                                helpers["queue"].addToFront(bp, bp.WS["Myrkr"], 'me')

                            elseif current.tp >= self.getSetting('TP THRESHOLD') and helpers["actions"].isReady(bp, "WS", self.getSetting('WSNAME')) then
                                helpers["queue"].addToFront(bp, bp.WS[self.getSetting('WSNAME')], target)

                            end
                        
                        end

                    elseif self.getSetting('RA') and self.getSetting('WS') and helpers['actions'].canAct() and target and (target.distance):sqrt() > 6 and (target.distance):sqrt() < 21 then
                        local current = {tp=player["vitals"].tp, hpp=player["vitals"].hpp, mpp=player["vitals"].mpp, main=helpers['equipment'].main.en, ranged=helpers['equipment'].ranged.en}

                        if self.getSetting('AM') and weaponskill and aftermath then
                            local weaponskill = helpers["aftermath"].getWeaponskill(bp, current.ranged)
                            local aftermath   = helpers["aftermath"].getBuffByLevel(bp, self.getSetting('AM LEVEL'))

                            if not helpers['buffs'].buffActive(aftermath) and current.tp > (self.getSetting('AM LEVEL')*1000) and weaponskill and helpers['actions'].isReady(bp, 'WS', weaponskill) then
                                helpers["queue"].addToFront(bp, bp.WS[weaponskill], target)

                            elseif helpers['buffs'].buffActive(aftermath) and current.mpp < self.getSetting('MOONLIGHT MPP') and helpers['actions'].isReady(bp, 'WS', "Moonlight") then
                                helpers["queue"].addToFront(bp, bp.WS["Moonlight"], 'me')
    
                            elseif helpers['buffs'].buffActive(aftermath) and current.mpp < self.getSetting('MYRKR MPP') and helpers['actions'].isReady(bp, 'WS', "Myrkr") then
                                helpers["queue"].addToFront(bp, bp.WS["Myrkr"], 'me')
                                
                            elseif (helpers['buffs'].buffActive(aftermath) or not weaponskill) and current.tp >= self.getSetting('TP THRESHOLD') and helpers['actions'].isReady(bp, 'WS', self.getSetting('RANGED WS')) then
                                helpers["queue"].addToFront(bp, bp.WS[self.getSetting('RANGED WS')], target)
                                
                            end
                        
                        elseif not self.getSetting('AM') then
                            
                            if current.mpp < self.getSetting('MOONLIGHT MPP') and helpers['actions'].isReady(bp, 'WS', "Moonlight") then
                                helpers["queue"].addToFront(bp, bp.WS["Moonlight"], 'me')

                            elseif current.mpp < self.getSetting('MYRKR MPP') and helpers['actions'].isReady(bp, 'WS', "Myrkr") then
                                helpers["queue"].addToFront(bp, bp.WS["Myrkr"], 'me')

                            elseif current.tp >= self.getSetting('TP THRESHOLD') and helpers["actions"].isReady(bp, "WS", self.getSetting('RANGED WS')) then
                                helpers["queue"].addToFront(bp, bp.WS[self.getSetting('RANGED WS')], target)
                                
                            end
                        
                        end
                        
                    end

                    -- ABILITY LOGIC.
                    if self.getSetting('JA') and helpers['actions'].canAct() then
                        
                        -- SCH/.
                        if player.main_job == 'SCH' then
                           
                        end

                        -- /RDM.
                        if player.sub_job == "RDM" then
                            
                            -- CONVERT LOGIC.
                            if self.getSetting('CONVERT') and player["vitals"].hpp > self.getSetting('CONVERT HPP') and player["vitals"].mpp < self.getSetting('CONVERT MPP') then
                                
                                if helpers["actions"].isReady(bp, "JA", "Convert") then
                                    helpers["queue"].add(bp, bp.JA["Convert"], player)
                                    helpers["queue"].add(bp, bp.MA["Cure IV"], player)
                                    
                                end
                                
                            end
                        
                        elseif player.sub_job == "SCH" then
                            
                            -- SUBLIMATION LOGIC.
                            if self.getSetting('SUBLIMATION') then
                            
                                if not helpers['buffs'].buffActive(187) and not helpers['buffs'].buffActive(188) and helpers["actions"].isReady(bp, "JA", "Sublimation") then
                                    helpers["queue"].add(bp, bp.JA["Sublimation"], player)
                                
                                elseif not helpers['buffs'].buffActive(187) and helpers['buffs'].buffActive(188) and helpers["actions"].isReady(bp, "JA", "Sublimation") then
                                    helpers["queue"].add(bp, bp.JA["Sublimation"], player)

                                end
                                
                            end
                        
                        -- /DRG.
                        elseif player.sub_job == "DRG" then
                            
                            -- JUMP.
                            if target and helpers["actions"].isReady(bp, "JA", "Jump") then
                                helpers["queue"].add(bp, bp.JA["Jump"], target)
                                
                            -- HIGH JUMP.
                            elseif target and helpers["actions"].isReady(bp, "JA", "High Jump") then
                                helpers["queue"].add(bp, bp.JA["High Jump"], target)
                                
                            end
                            
                        -- /DNC.
                        elseif player.sub_job == "DNC" then
                            
                            -- REVERSE FLOURISH.
                            if target and helpers["actions"].isReady(bp, "JA", "Reverse Flourish") and helpers['buffs'].getFinishingMoves() > 4 then
                                helpers["queue"].add(bp, bp.JA["Reverse Flourish"], player)                            
                            end
                        
                        end
                        
                    end

                    -- HATE LOGIC.
                    if self.getSetting('HATE') and target then
                        
                        -- SCH/.
                        if player.main_job == 'SCH' then
                           
                        end
                        
                        -- /RDM.
                        if player.sub_job == "RDM" then
                        
                        -- /WAR.
                        elseif player.sub_job == "WAR" then
                            
                            -- PROVOKE.
                            if target and helpers['actions'].canAct() and helpers["actions"].isReady(bp, "JA", "Provoke") then
                                helpers["queue"].add(bp, bp.JA["Provoke"], target)
                            end
                        
                        -- /RUN.
                        elseif player.sub_job == "RUN" then
                            
                            -- FLASH.
                            if target and helpers['actions'].canCast() and helpers["actions"].isReady(bp, "MA", "Flash") then
                                helpers["queue"].addToFront(bp, bp.MA["Flash"], target)                            
                            end
                            
                            if helpers['actions'].canAct() and (os.clock()-timers.hate) > self.getSetting('HATE DELAY') then
                            
                                -- VALLATION.
                                if target and helpers["actions"].isReady(bp, "JA", "Vallation") and helpers["runes"].active:length() > 0 then
                                    helpers["queue"].addToFront(bp, bp.JA["Vallation"], player)
                                    timers.hate = os.clock()
                                    
                                -- PFLUG.
                                elseif target and helpers["actions"].isReady(bp, "JA", "Pflug") and helpers["runes"].active:length() > 0 then
                                    helpers["queue"].addToFront(bp, bp.JA["Pflug"], player)
                                    timers.hate = os.clock()
                                    
                                end
                                
                            end
                        
                        -- /DRK.
                        elseif player.sub_job == "DRK" then
                            
                            -- STUN.
                            if target and helpers['actions'].canCast() and helpers["actions"].isReady(bp, "MA", "Stun") then
                                helpers["queue"].addToFront(bp, bp.MA["Stun"], target)                            
                            end
                            
                            if helpers['actions'].canAct() and (os.clock()-timers.hate) > self.getSetting('HATE DELAY') then
                            
                                -- SOULEATER.
                                if target and not helpers['buffs'].buffActive(64) and helpers["actions"].isReady(bp, "JA", "Souleater") then
                                    helpers["queue"].addToFront(bp, bp.JA["Souleater"], player)
                                    timers.hate = os.clock()
                                    
                                    if self.getSetting('TANK MODE') then
                                        windower.send_command("wait 1; cancel 63")
                                    end
                                    
                                -- LAST RESORT.
                                elseif target and not helpers['buffs'].buffActive(64) and helpers["actions"].isReady(bp, "JA", "Last Resort") then
                                    helpers["queue"].addToFront(bp, bp.JA["Last Resort"], player)
                                    timers.hate = os.clock()
                                    
                                    if self.getSetting('TANK MODE') then
                                        windower.send_command("wait 1; cancel 64")
                                    end
                                    
                                end
                                
                            end
                        
                        -- /BLU.
                        elseif player.sub_job == "BLU" and helpers['actions'].canCast() then
                            
                            -- JETTATURA.
                            if target and helpers["actions"].isReady(bp, "MA", "Jettatura") then
                                helpers["queue"].add(bp, bp.MA["Jettatura"], target)
                                
                            -- BLANK GAZE.
                            elseif target and helpers["actions"].isReady(bp, "MA", "Blank Gaze") then
                                helpers["queue"].add(bp, bp.MA["Blank Gaze"], target)
                                
                            end
                            
                            if self.getSetting('AOEHATE') and (os.clock()-timers.hate) > self.getSetting('HATE DELAY') then
                                
                                -- SOPORIFIC.
                                if target and helpers["actions"].isReady(bp, "MA", "Soporific") then
                                    helpers["queue"].add(bp, bp.MA["Soporific"], target)
                                    timers.hate = os.clock()
                                
                                -- GEIST WALL.
                                elseif target and helpers["actions"].isReady(bp, "MA", "Geist Wall") then
                                    helpers["queue"].add(bp, bp.MA["Geist Wall"], target)
                                    timers.hate = os.clock()
                                
                                -- JETTATURA.
                                elseif target and helpers["actions"].isReady(bp, "MA", "Sheep Song") then
                                    helpers["queue"].add(bp, bp.MA["Sheep Song"], target)
                                    timers.hate = os.clock()
                                
                                end
                                
                            end
                        
                        -- /DNC.
                        elseif player.sub_job == "DNC" then
                            
                            -- ANIMATED FLOURISH.
                            if target and helpers['actions'].canAct() and helpers["actions"].isReady(bp, "JA", "Animated Flourish") and helpers['buffs'].getFinishingMoves() > 0 then
                                helpers["queue"].add(bp, bp.JA["Animated Flourish"], target)
                            end
                        
                        end
                        
                    end

                    -- BUFF LOGIC.
                    if self.getSetting('BUFFS') then
                        
                        -- SCH/.
                        if player.main_job == 'SCH' then

                            -- LIGHT ARTS.
                            if helpers['actions'].canAct() and helpers['actions'].isReady(bp, "JA", self.getSetting('ARTS')) and self.getSetting('ARTS') == "Light Arts" and (not helpers['buffs'].buffActive(358) and not helpers['buffs'].buffActive(401)) then
                                helpers['queue'].add(bp, bp.JA[self.getSetting('ARTS')], player)
                            
                            -- DARK ARTS.
                            elseif helpers['actions'].canAct() and helpers['actions'].isReady(bp, "JA", self.getSetting('ARTS')) and self.getSetting('ARTS') == "Dark Arts" and (not helpers['buffs'].buffActive(359) and not helpers['buffs'].buffActive(402)) then
                                helpers['queue'].add(bp, bp.JA[self.getSetting('ARTS')], player)
                                
                            -- ADDENDUM.
                            elseif helpers['actions'].canAct() and (helpers['buffs'].buffActive(358) or helpers['buffs'].buffActive(359)) and helpers['actions'].isReady(bp, "JA", self.getSetting('ADDENDUM')) and helpers["stratagems"].getStratagems().current > 0 then
                                            
                                if self.getSetting('ADDENDUM') == "Addendum: White" and not helpers['buffs'].buffActive(401) then
                                    helpers['queue'].add(bp, bp.JA[self.getSetting('ADDENDUM')], player)
                                    
                                elseif self.getSetting('ADDENDUM') == "Addendum: Black" and not helpers['buffs'].buffActive(402) then
                                    helpers['queue'].add(bp, bp.JA[self.getSetting('ADDENDUM')], player)
                                    
                                end
                                
                            -- STORMS.
                            elseif helpers['actions'].canCast() and helpers['actions'].isReady(bp, "MA", self.getSetting('WEATHER')) then
                                
                                if self.getSetting('WEATHER') == "Firestorm" and not helpers['buffs'].buffActive(178) then
                                    helpers['queue'].add(bp, bp.MA[self.getSetting('WEATHER')], player)
                                    
                                elseif self.getSetting('WEATHER') == "Hailstorm" and not helpers['buffs'].buffActive(179) then
                                    helpers['queue'].add(bp, bp.MA[self.getSetting('WEATHER')], player)
                                    
                                elseif self.getSetting('WEATHER') == "Windstorm" and not helpers['buffs'].buffActive(180) then
                                    helpers['queue'].add(bp, bp.MA[self.getSetting('WEATHER')], player)
                                    
                                elseif self.getSetting('WEATHER') == "Sandstorm" and not helpers['buffs'].buffActive(181) then
                                    helpers['queue'].add(bp, bp.MA[self.getSetting('WEATHER')], player)
                                    
                                elseif self.getSetting('WEATHER') == "Thunderstorm" and not helpers['buffs'].buffActive(182) then
                                    helpers['queue'].add(bp, bp.MA[self.getSetting('WEATHER')], player)
                                    
                                elseif self.getSetting('WEATHER') == "Rainstorm" and not helpers['buffs'].buffActive(183) then
                                    helpers['queue'].add(bp, bp.MA[self.getSetting('WEATHER')], player)
                                    
                                elseif self.getSetting('WEATHER') == "Aurorastorm" and not helpers['buffs'].buffActive(184) then
                                    helpers['queue'].add(bp, bp.MA[self.getSetting('WEATHER')], player)
                                    
                                elseif self.getSetting('WEATHER') == "Voidstorm" and not helpers['buffs'].buffActive(185) then
                                    helpers['queue'].add(bp, bp.MA[self.getSetting('WEATHER')], player)
                                    
                                end
                            
                            -- KLIMAFORM
                            elseif helpers['actions'].canCast() and self.getSetting('ARTS') == 'Dark Arts' and helpers['actions'].isReady(bp, "MA", "Klimaform") and not helpers['buffs'].buffActive(407) then
                                helpers['queue'].add(bp, bp.MA["Klimaform"], player)
                                
                            -- STONESKIN.
                            elseif helpers['actions'].canCast() and self.getSetting('ARTS') == 'Light Arts' and helpers['actions'].isReady(bp, "MA", "Stoneskin") and not helpers['buffs'].buffActive(37) then
                                helpers['queue'].add(bp, bp.MA["Stoneskin"], player)
                                
                            end
                           
                        end
                        
                        -- /SCH.
                        if player.sub_job == "SCH" then
                            
                            -- LIGHT ARTS.
                            if helpers['actions'].canAct() and helpers['actions'].isReady(bp, "JA", self.getSetting('ARTS')) and self.getSetting('ARTS') == "Light Arts" and (not helpers['buffs'].buffActive(358) and not helpers['buffs'].buffActive(401)) then
                                helpers['queue'].add(bp, bp.JA[self.getSetting('ARTS')], player)
                            
                            -- DARK ARTS.
                            elseif helpers['actions'].canAct() and helpers['actions'].isReady(bp, "JA", self.getSetting('ARTS')) and self.getSetting('ARTS') == "Dark Arts" and (not helpers['buffs'].buffActive(359) and not helpers['buffs'].buffActive(402)) then
                                helpers['queue'].add(bp, bp.JA[self.getSetting('ARTS')], player)
                                
                            -- ADDENDUM.
                            elseif helpers['actions'].canAct() and (helpers['buffs'].buffActive(358) or helpers['buffs'].buffActive(359)) and helpers['actions'].isReady(bp, "JA", self.getSetting('ADDENDUM')) and helpers["stratagems"].getStratagems().current > 0 then
                                            
                                if self.getSetting('ADDENDUM') == "Addendum: White" and not helpers['buffs'].buffActive(401) then
                                    helpers['queue'].add(bp, bp.JA[self.getSetting('ADDENDUM')], player)
                                    
                                elseif self.getSetting('ADDENDUM') == "Addendum: Black" and not helpers['buffs'].buffActive(402) then
                                    helpers['queue'].add(bp, bp.JA[self.getSetting('ADDENDUM')], player)
                                    
                                end
                                
                            -- STORMS.
                            elseif helpers['actions'].canCast() and helpers['actions'].isReady(bp, "MA", self.getSetting('WEATHER')) then
                                
                                if self.getSetting('WEATHER') == "Firestorm" and not helpers['buffs'].buffActive(178) then
                                    helpers['queue'].add(bp, bp.MA[self.getSetting('WEATHER')], player)
                                    
                                elseif self.getSetting('WEATHER') == "Hailstorm" and not helpers['buffs'].buffActive(179) then
                                    helpers['queue'].add(bp, bp.MA[self.getSetting('WEATHER')], player)
                                    
                                elseif self.getSetting('WEATHER') == "Windstorm" and not helpers['buffs'].buffActive(180) then
                                    helpers['queue'].add(bp, bp.MA[self.getSetting('WEATHER')], player)
                                    
                                elseif self.getSetting('WEATHER') == "Sandstorm" and not helpers['buffs'].buffActive(181) then
                                    helpers['queue'].add(bp, bp.MA[self.getSetting('WEATHER')], player)
                                    
                                elseif self.getSetting('WEATHER') == "Thunderstorm" and not helpers['buffs'].buffActive(182) then
                                    helpers['queue'].add(bp, bp.MA[self.getSetting('WEATHER')], player)
                                    
                                elseif self.getSetting('WEATHER') == "Rainstorm" and not helpers['buffs'].buffActive(183) then
                                    helpers['queue'].add(bp, bp.MA[self.getSetting('WEATHER')], player)
                                    
                                elseif self.getSetting('WEATHER') == "Aurorastorm" and not helpers['buffs'].buffActive(184) then
                                    helpers['queue'].add(bp, bp.MA[self.getSetting('WEATHER')], player)
                                    
                                elseif self.getSetting('WEATHER') == "Voidstorm" and not helpers['buffs'].buffActive(185) then
                                    helpers['queue'].add(bp, bp.MA[self.getSetting('WEATHER')], player)
                                    
                                end
                            
                            -- KLIMAFORM
                            elseif helpers['actions'].canCast() and self.getSetting('ARTS') == 'Dark Arts' and helpers['actions'].isReady(bp, "MA", "Klimaform") and not helpers['buffs'].buffActive(407) then
                                helpers['queue'].add(bp, bp.MA["Klimaform"], player)
                                
                            -- STONESKIN.
                            elseif helpers['actions'].canCast() and self.getSetting('ARTS') == 'Light Arts' and helpers['actions'].isReady(bp, "MA", "Stoneskin") and not helpers['buffs'].buffActive(37) then
                                helpers['queue'].add(bp, bp.MA["Stoneskin"], player)
                                
                            end
                        
                        -- /RDM.
                        elseif player.sub_job == "RDM" and helpers['actions'].canCast() then
                            
                            -- HASTE.
                            if helpers['actions'].isReady(bp, "MA", "Haste") and not helpers['buffs'].buffActive(33) then
                                helpers["queue"].addToFront(bp, bp.MA["Haste"], player)
                            
                            -- ENSPELLS.
                            elseif (not helpers['buffs'].buffActive(94) and not helpers['buffs'].buffActive(95) and not helpers['buffs'].buffActive(96) and not helpers['buffs'].buffActive(97) and not helpers['buffs'].buffActive(98) and not helpers['buffs'].buffActive(99)) then
                                
                                if helpers['actions'].isReady(bp, "MA", self.getSetting('ENSPELL')) then
                                    helpers["queue"].addToFront(bp, bp.MA[self.getSetting('ENSPELL')], player)
                                end
                            
                            -- PHALANX.
                            elseif helpers['actions'].isReady(bp, "MA", "Phalanx") and not helpers['buffs'].buffActive(116) then
                                helpers["queue"].addToFront(bp, bp.MA["Phalanx"], player)
                                
                            -- REFRESH.
                            elseif not self.getSetting('SUBLIMATION') and helpers['actions'].isReady(bp, "MA", "Refresh") and not helpers['buffs'].buffActive(43) then
                                helpers["queue"].addToFront(bp, bp.MA["Refresh"], player)
                                
                            -- STONESKIN.
                            elseif helpers['actions'].isReady(bp, "MA", "Stoneskin") and not helpers['buffs'].buffActive(37) then
                                helpers['queue'].add(bp, bp.MA["Stoneskin"], player)
                                
                            -- SPIKES.
                            elseif helpers['actions'].isReady(bp, "MA", self.getSetting('SPIKES')) and (not helpers['buffs'].buffActive(34) or not helpers['buffs'].buffActive(35) or not helpers['buffs'].buffActive(38)) then
                                helpers['queue'].add(bp, bp.MA[self.getSetting('SPIKES')], player)
                                
                            end                            
                                
                        -- /WAR.
                        elseif player.sub_job == "WAR" and helpers['actions'].canAct() then
                        
                            -- BERSERK.
                            if target and not self.getSetting('TANK MODE') and not helpers['buffs'].buffActive(56) and helpers['actions'].isReady(bp, "JA", "Berserk") then
                                helpers['queue'].add(bp, bp.JA["Berserk"], player)
                            
                            -- DEFENDER.
                            elseif self.getSetting('TANK MODE') and not helpers['buffs'].buffActive(57) and helpers['actions'].isReady(bp, "JA", "Defender") then
                                helpers['queue'].add(bp, bp.JA["Defender"], player)
                                
                            -- AGGRESSOR.
                            elseif target and not helpers['buffs'].buffActive(58) and helpers['actions'].isReady(bp, "JA", "Aggressor") then
                                helpers['queue'].add(bp, bp.JA["Aggressor"], player)
                            
                            -- WARCRY.
                            elseif target and not helpers['buffs'].buffActive(68) and not helpers['buffs'].buffActive(460) and helpers['actions'].isReady(bp, "JA", "Warcry") then
                                helpers['queue'].add(bp, bp.JA["Warcry"], player)
                            
                            end
                        
                        -- /SAM.
                        elseif player.sub_job == "SAM" and helpers['actions'].canAct() then
                            local slots = bp.helpers['equipment'].main.slots
                            
                            -- HASSO.
                            if not self.getSetting('TANK MODE') and not helpers['buffs'].buffActive(353) and helpers['actions'].isReady(bp, "JA", "Hasso") and slots and slots:contains(0) and not slots:contains(1) then
                                helpers['queue'].add(bp, bp.JA["Hasso"], player)
                            
                            -- SEIGAN.
                            elseif self.getSetting('TANK MODE') and not helpers['buffs'].buffActive(354) and helpers['actions'].isReady(bp, "JA", "Seigan") and slots and slots:contains(0) and not slots:contains(1) then
                                helpers['queue'].add(bp, bp.JA["Seigan"], player)
                            
                            -- MEDITATE.
                            elseif helpers['actions'].isReady(bp, "JA", "Meditate") then
                                helpers['queue'].addToFront(bp, bp.JA["Meditate"], player)
                            
                            -- THIRD EYE.
                            elseif not helpers['buffs'].buffActive(67) and helpers['actions'].isReady(bp, "JA", "Third Eye") then
                                helpers['queue'].add(bp, bp.JA["Third Eye"], player)
                            
                            end
                        
                        -- /DRK.
                        elseif player.sub_job == "DRK" and helpers['actions'].canAct() then
                            
                            -- LAST RESORT.
                            if target and not self.getSetting('TANK MODE') and not helpers['buffs'].buffActive(64) and helpers['actions'].isReady(bp, "JA", "Last Resort") then
                                helpers['queue'].add(bp, bp.JA["Last Resort"], player)
                            
                            -- SOULEATER.
                            elseif target and not self.getSetting('TANK MODE') and not helpers['buffs'].buffActive(63) and helpers['actions'].isReady(bp, "JA", "Souleater") then
                                helpers['queue'].add(bp, bp.JA["Souleater"], player)
                                
                            -- ARCANE CIRCLE.
                            elseif target and helpers['buffs'].buffActive(75) and helpers['actions'].isReady(bp, "JA", "Arcane Circle") then
                                helpers['queue'].add(bp, bp.JA["Arcane Circle"], player)
                            
                            end

                        -- RUN/.
                        elseif player.sub_job == "RUN" then
                            local runes  = helpers['runes'].runes
                            local active = helpers['runes'].getActive(bp)
                            
                            -- RUNE ENCHANMENTS.
                            if helpers['actions'].canAct() and active:length() > 0 and active:length() < 3 then
                                
                                if runes[active:length()] == 1 then
                                    
                                    if helpers['actions'].isReady(bp, "JA", runes[2].en) and not helpers['queue'].inQueue(bp, runes[2], player) then
                                        helpers['queue'].add(bp, runes[2] "me")
                                    end
                                    
                                elseif runes[active:length()] == 2 then
                                    
                                    if helpers['actions'].isReady(bp, "JA", runes[3].en) and not helpers['queue'].inQueue(bp, runes[3], player) then
                                        helpers['queue'].add(bp, runes[3], "me")
                                    end
                                    
                                elseif runes[active:length()] == 3 then
                                    
                                    if helpers['actions'].isReady(bp, "JA", runes[1].en) and not helpers['queue'].inQueue(bp, runes[1], player) then
                                        helpers['queue'].add(bp, runes[1], "me")
                                    end
                                    
                                end
                                
                            elseif active:length() == 0 then
                                
                                if helpers['actions'].isReady(bp, "JA", runes[1].en) and not helpers['queue'].inQueue(bp, runes[1], player) then
                                    helpers['queue'].add(bp, runes[1], "me")
                                end
                                
                            end
                            
                        -- /BLU.
                        elseif player.sub_job == "BLU" then
                        
                        -- /DRG.
                        elseif player.sub_job == "DRG" then
                            
                            -- ANCIENT CIRCLE.
                            if target and not helpers['buffs'].buffaActive(118) and helpers['actions'].isReady(bp, "JA", "Ancient Circle") then
                                helpers['queue'].add(bp, bp.JA["Ancient Circle"], player)                            
                            end
                            
                        -- /RNG.
                        elseif player.sub_job == "RNG" and helpers['actions'].canAct() then
                            
                            -- SHARPSHOT.
                            if target and not helpers['buffs'].buffActive(72) and helpers['actions'].isReady(bp, "JA", "Sharpshot") then
                                helpers["queue"].addToFront(JA["Sharpshot"], player)
                            
                            -- BARRAGE.
                            elseif target and not helpers['buffs'].buffActive(371) and helpers['actions'].isReady(bp, "JA", "Velocity Shot") then
                                helpers["queue"].addToFront(JA["Velocity Shot"], player)
                            
                            -- VELOCITY SHOT.
                            elseif not helpers['buffs'].buffActive(73) and helpers['actions'].isReady(bp, "JA", "Barrage") then
                                helpers['queue'].add(bp, bp.JA["Barrage"], player)
                            
                            end
                        
                        -- /COR.
                        elseif player.sub_job == "COR" and helpers['actions'].canAct() then
                            local rolls     = helpers['rolls'].rolls
                            local active    = helpers['rolls'].active
                            local buffs     = helpers['rolls'].getActive(bp)
                            
                            -- Make the initial roll.
                            if buffs <= 2 and not helpers['rolls'].rolling then
                                    
                                for i,roll in ipairs(rolls) do
                                    local buff = bp.res.buffs[helpers['rolls'].getBuff(bp, roll.en).id]
                                    
                                    if helpers['actions'].isReady(bp, "JA", roll.en) and not helpers['buffs'].buffActive(buff.id) and not helpers['queue'].typeInQueue(bp, roll) then

                                        -- Check to see if Crooked Cards is ready.
                                        if bp.helpers['rolls'].crooked and helpers['actions'].isReady(bp, "JA", 'Crooked Cards') and not helpers['buffs'].buffActive(601) then
                                            helpers["queue"].add(bp, bp.JA['Crooked Cards'], player)
                                        end
                                        helpers["queue"].add(bp, bp.JA[roll.en], player)
                                        break

                                    end

                                end

                            -- If in the middle of rolling the first roll.
                            elseif buffs > 0 and helpers['rolls'].rolling and helpers['actions'].isReady(bp, "JA", 'Double-Up') then
                                local double = active[active:length()]

                                if double then
                                    local buff  = bp.res.buffs[helpers['rolls'].getBuff(bp, double.roll.en).id]
                                    local lucky = helpers['rolls'].getLucky(bp, buff.en)
                                    local cap   = helpers['rolls'].cap
                                
                                    if buff and helpers['buffs'].buffActive(buff.id) and double.dice < cap and double.dice ~= lucky and double.dice <= 11 then
                                        helpers["queue"].addToFront(bp, bp.JA['Double-Up'], player)
                                    end

                                end

                            end
                        
                        -- /DNC.
                        elseif player.sub_job == "DNC" and helpers['actions'].canAct() then
                        
                            -- SAMBAS.
                            if target and (not helpers['buffs'].buffActive(368) and not helpers['buffs'].buffActive(370)) and helpers['actions'].isReady(bp, "JA", self.getSetting('SAMBAS')) then
                                helpers['queue'].add(bp, bp.JA[self.getSetting('SAMBAS')], player)                            
                            end
                        
                        -- /NIN.
                        elseif player.sub_job == "NIN" then
                        
                            -- UTSUSEMI
                            if helpers['actions'].canCast() and helpers['inventory'].findItemByName("Shihei", 0) then
                                
                                if not helpers['buffs'].buffActive(444) and not helpers['buffs'].buffActive(445) and not helpers['buffs'].buffActive(446) and not helpers['buffs'].buffActive(36) then
                                    
                                    if helpers['actions'].isReady(bp, "MA", "Utsusemi: Ni") then
                                        helpers["queue"].addToFront(bp, bp.MA["Utsusemi: Ni"], player)
                                        
                                    elseif helpers['actions'].isReady(bp, "MA", "Utsusemi: Ichi") then
                                        helpers["queue"].addToFront(bp, bp.MA["Utsusemi: Ichi"], player)
                                        
                                    end
                                
                                end
                            
                            end
                        
                        end
                        
                    end

                    -- DEBUFF LOGIC.
                    if self.getSetting('DEBUFF') and target then
                        
                        -- /DNC.
                        if (player.main_job == 'DNC' or player.sub_job == 'DNC') and helpers['actions'].canAct() then
                        
                            -- STEPS.
                            if helpers["actions"].isReady(bp, "JA", self.getSetting('STEPS')) and os.clock()-timers.steps > self.getSetting('STEPS DELAY') then
                                helpers['queue'].add(bp, bp.JA[self.getSetting('STEPS')], target)
                                timers.steps = os.clock()

                            end

                        elseif player.main_job == 'COR' and helpers['actions'].canAct() then
                            
                            -- QUICK DRAW.
                            if helpers["actions"].isReady(bp, "JA", self.getSetting('COR SHOTS')) then
                                helpers['queue'].add(bp, bp.JA[self.getSetting('COR SHOTS')], target)
                            end

                        end
                        
                    end
                
                    -- DRAINS LOGIC
                    if self.getSetting('DRAINS') and helpers['actions'].canCast() and target then
                        
                        if helpers["actions"].isReady(bp, "MA", "Drain III") and player["vitals"].mpp < self.getSetting('DRAIN THRESHOLD') then
                            helpers["queue"].add(bp, bp.MA["Drain III"], target)
                            
                        elseif helpers["actions"].isReady(bp, "MA", "Drain II") and player["vitals"].mpp < self.getSetting('DRAIN THRESHOLD') then
                            helpers["queue"].add(bp, bp.MA["Drain II"], target)
                            
                        elseif helpers["actions"].isReady(bp, "MA", "Drain") and player["vitals"].mpp < self.getSetting('DRAIN THRESHOLD') then
                            helpers["queue"].add(bp, bp.MA["Drain"], target)
                            
                        end
                        
                        if helpers["actions"].isReady(bp, "MA", "Aspir III") and player["vitals"].mpp < self.getSetting('ASPIR THRESHOLD') then
                            helpers["queue"].add(bp, bp.MA["Aspir III"], target)
                        
                        elseif helpers["actions"].isReady(bp, "MA", "Aspir II") and player["vitals"].mpp < self.getSetting('ASPIR THRESHOLD') then
                            helpers["queue"].add(bp, bp.MA["Aspir II"], target)
                            
                        elseif helpers["actions"].isReady(bp, "MA", "Aspir") and player["vitals"].mpp < self.getSetting('ASPIR THRESHOLD') then
                            helpers["queue"].add(bp, bp.MA["Aspir"], target)
                        
                        end
                        
                    end

                    -- HANDLE RANGED ATTACKS.
                    if self.getSetting('RA') and helpers['equipment'].ammo and helpers['equipment'].ammo.en ~= 'Gil' then
                        helpers['queue'].addToFront(bp, helpers['actions'].unique.ranged, target)
                    end

                -- PLAYER IS DISENGAGED LOGIC.
                elseif player.status == 0 then
                    local target = helpers['target'].getTarget() or false
                    
                    -- SKILLUP LOGIC.
                    if self.getSetting('SKILLUP') then
                        
                        if helpers['inventory'].findItemByName("B.E.W. Pitaru") and not helpers['queue'].inQueue(bp, bp.IT["B.E.W. Pitaru"]) and not helpers['buffs'].buffActive(251) then
                            helpers['queue'].add(bp, bp.IT["B.E.W. Pitaru"], 'me')
                            
                        else
                            local skills = bp.skillup[self.getSetting('SKILLS')]
                                                        
                            if skills and skills.list then

                                for _,v in pairs(skills.list) do
                                    
                                    if helpers['actions'].isReady(bp, "MA", v) and not helpers['queue'].inQueue(bp, bp.MA[v]) then
                                        helpers['queue'].add(bp, bp.MA[v], bp.skillup[self.getSetting('SKILLS')].target)
                                    end
                                
                                end

                            end
                        
                        end
                        
                    end
                    
                    -- WEAPON SKILL LOGIC.
                    if self.getSetting('WS') and helpers['actions'].canAct() and target and (target.distance):sqrt() < 6 then
                        local current = {tp=player["vitals"].tp, hpp=player["vitals"].hpp, mpp=player["vitals"].mpp, main=helpers['equipment'].main.en, ranged=helpers['equipment'].ranged.en}

                        if self.getSetting('AM') then
                            local weaponskill = helpers["aftermath"].getWeaponskill(bp, current.main)
                            local aftermath   = helpers["aftermath"].getBuffByLevel(bp, self.getSetting('AM LEVEL'))
                            
                            if self.getSetting('SANGUINE') and current.hpp < self.getSetting('SANGUINE HPP') and helpers['actions'].isReady(bp, 'WS', "Sanguine Blade") then
                                helpers["queue"].addToFront(bp, bp.WS["Sanguine Blade"], target)

                            elseif not helpers['buffs'].buffActive(aftermath) and current.tp > (self.getSetting('AM LEVEL')*1000) and weaponskill and helpers['actions'].isReady(bp, 'WS', weaponskill) then
                                helpers["queue"].addToFront(bp, bp.WS[weaponskill], target)

                            elseif helpers['buffs'].buffActive(aftermath) and current.mpp < self.getSetting('MOONLIGHT MPP') and helpers['actions'].isReady(bp, 'WS', "Moonlight") then
                                helpers["queue"].addToFront(bp, bp.WS["Moonlight"], 'me')

                            elseif helpers['buffs'].buffActive(aftermath) and current.mpp < self.getSetting('MYRKR MPP') and helpers['actions'].isReady(bp, 'WS', "Myrkr") then
                                helpers["queue"].addToFront(bp, bp.WS["Myrkr"], 'me')
                                
                            elseif (helpers['buffs'].buffActive(aftermath) or not weaponskill) and current.tp >= self.getSetting('TP THRESHOLD') and helpers['actions'].isReady(bp, 'WS', self.getSetting('WSNAME')) then
                                helpers["queue"].addToFront(bp, bp.WS[self.getSetting('WSNAME')], target)
                                
                            end
                            
                        elseif not self.getSetting('AM') and target then
                            
                            if current.mpp < self.getSetting('MOONLIGHT MPP') and helpers['actions'].isReady(bp, 'WS', "Moonlight") then
                                helpers["queue"].addToFront(bp, bp.WS["Moonlight"], 'me')

                            elseif current.mpp < self.getSetting('MYRKR MPP') and helpers['actions'].isReady(bp, 'WS', "Myrkr") then
                                helpers["queue"].addToFront(bp, bp.WS["Myrkr"], 'me')

                            elseif current.tp >= self.getSetting('TP THRESHOLD') and helpers["actions"].isReady(bp, "WS", self.getSetting('WSNAME')) then
                                helpers["queue"].addToFront(bp, bp.WS[self.getSetting('WSNAME')], target)

                            end
                        
                        end

                    elseif self.getSetting('RA') and self.getSetting('WS') and helpers['actions'].canAct() and target and (target.distance):sqrt() > 6 and (target.distance):sqrt() < 21 then
                        local current = {tp=player["vitals"].tp, hpp=player["vitals"].hpp, mpp=player["vitals"].mpp, main=helpers['equipment'].main.en, ranged=helpers['equipment'].ranged.en}

                        if self.getSetting('AM') and weaponskill and aftermath then
                            local weaponskill = helpers["aftermath"].getWeaponskill(bp, current.ranged)
                            local aftermath   = helpers["aftermath"].getBuffByLevel(bp, self.getSetting('AM LEVEL'))

                            if not helpers['buffs'].buffActive(aftermath) and current.tp > (self.getSetting('AM LEVEL')*1000) and weaponskill and helpers['actions'].isReady(bp, 'WS', weaponskill) then
                                helpers["queue"].addToFront(bp, bp.WS[weaponskill], target)

                            elseif helpers['buffs'].buffActive(aftermath) and current.mpp < self.getSetting('MOONLIGHT MPP') and helpers['actions'].isReady(bp, 'WS', "Moonlight") then
                                helpers["queue"].addToFront(bp, bp.WS["Moonlight"], 'me')
    
                            elseif helpers['buffs'].buffActive(aftermath) and current.mpp < self.getSetting('MYRKR MPP') and helpers['actions'].isReady(bp, 'WS', "Myrkr") then
                                helpers["queue"].addToFront(bp, bp.WS["Myrkr"], 'me')
                                
                            elseif (helpers['buffs'].buffActive(aftermath) or not weaponskill) and current.tp >= self.getSetting('TP THRESHOLD') and helpers['actions'].isReady(bp, 'WS', self.getSetting('RANGED WS')) then
                                helpers["queue"].addToFront(bp, bp.WS[self.getSetting('RANGED WS')], target)
                                
                            end
                        
                        elseif not self.getSetting('AM') then
                            
                            if current.mpp < self.getSetting('MOONLIGHT MPP') and helpers['actions'].isReady(bp, 'WS', "Moonlight") then
                                helpers["queue"].addToFront(bp, bp.WS["Moonlight"], 'me')

                            elseif current.mpp < self.getSetting('MYRKR MPP') and helpers['actions'].isReady(bp, 'WS', "Myrkr") then
                                helpers["queue"].addToFront(bp, bp.WS["Myrkr"], 'me')

                            elseif current.tp >= self.getSetting('TP THRESHOLD') and helpers["actions"].isReady(bp, "WS", self.getSetting('RANGED WS')) then
                                helpers["queue"].addToFront(bp, bp.WS[self.getSetting('RANGED WS')], target)

                            end
                        
                        end
                        
                    end

                    -- ABILITY LOGIC.
                    if self.getSetting('JA') and helpers['actions'].canAct() then
                        
                        -- SCH/.
                        if player.main_job == 'SCH' then
                           
                        end

                        -- /RDM.
                        if player.sub_job == "RDM" then
                            
                            -- CONVERT LOGIC.
                            if self.getSetting('CONVERT') and player["vitals"].hpp > self.getSetting('CONVERT HPP') and player["vitals"].mpp < self.getSetting('CONVERT MPP') then
                                
                                if helpers["actions"].isReady(bp, "JA", "Convert") then
                                    helpers["queue"].add(bp, bp.JA["Convert"], player)
                                    helpers["queue"].add(bp, bp.MA["Cure IV"], player)
                                    
                                end
                                
                            end
                        
                        elseif player.sub_job == "SCH" then
                            
                            -- SUBLIMATION LOGIC.
                            if self.getSetting('SUBLIMATION') then
                            
                                if not helpers['buffs'].buffActive(187) and not helpers['buffs'].buffActive(188) and helpers["actions"].isReady(bp, "JA", "Sublimation") then
                                    helpers["queue"].add(bp, bp.JA["Sublimation"], player)
                                
                                elseif not helpers['buffs'].buffActive(187) and helpers['buffs'].buffActive(188) and helpers["actions"].isReady(bp, "JA", "Sublimation") then
                                    helpers["queue"].add(bp, bp.JA["Sublimation"], player)

                                end
                                
                            end
                        
                        -- /DRG.
                        elseif player.sub_job == "DRG" then
                            
                            -- JUMP.
                            if target and helpers["actions"].isReady(bp, "JA", "Jump") then
                                helpers["queue"].add(bp, bp.JA["Jump"], target)
                                
                            -- HIGH JUMP.
                            elseif target and helpers["actions"].isReady(bp, "JA", "High Jump") then
                                helpers["queue"].add(bp, bp.JA["High Jump"], target)
                                
                            end
                            
                        -- /DNC.
                        elseif player.sub_job == "DNC" then
                            
                            -- REVERSE FLOURISH.
                            if target and helpers["actions"].isReady(bp, "JA", "Reverse Flourish") and helpers['buffs'].getFinishingMoves() > 4 then
                                helpers["queue"].add(bp, bp.JA["Reverse Flourish"], player)                            
                            end
                        
                        end
                        
                    end

                    -- HATE LOGIC.
                    if self.getSetting('HATE') and target then
                        
                        -- SCH/.
                        if player.main_job == 'SCH' then
                           
                        end
                        
                        -- /RDM.
                        if player.sub_job == "RDM" then
                        
                        -- /WAR.
                        elseif player.sub_job == "WAR" then
                            
                            -- PROVOKE.
                            if target and helpers['actions'].canAct() and helpers["actions"].isReady(bp, "JA", "Provoke") then
                                helpers["queue"].add(bp, bp.JA["Provoke"], target)
                            end
                        
                        -- /RUN.
                        elseif player.sub_job == "RUN" then
                            
                            -- FLASH.
                            if target and helpers['actions'].canCast() and helpers["actions"].isReady(bp, "MA", "Flash") then
                                helpers["queue"].addToFront(bp, bp.MA["Flash"], target)                            
                            end
                            
                            if helpers['actions'].canAct() and (os.clock()-timers.hate) > self.getSetting('HATE DELAY') then
                            
                                -- VALLATION.
                                if target and helpers["actions"].isReady(bp, "JA", "Vallation") and helpers["runes"].active:length() > 0 then
                                    helpers["queue"].addToFront(bp, bp.JA["Vallation"], player)
                                    timers.hate = os.clock()
                                    
                                -- PFLUG.
                                elseif target and helpers["actions"].isReady(bp, "JA", "Pflug") and helpers["runes"].active:length() > 0 then
                                    helpers["queue"].addToFront(bp, bp.JA["Pflug"], player)
                                    timers.hate = os.clock()
                                    
                                end
                                
                            end
                        
                        -- /DRK.
                        elseif player.sub_job == "DRK" then
                            
                            -- STUN.
                            if target and helpers['actions'].canCast() and helpers["actions"].isReady(bp, "MA", "Stun") then
                                helpers["queue"].addToFront(bp, bp.MA["Stun"], target)                            
                            end
                            
                            if helpers['actions'].canAct() and (os.clock()-timers.hate) > self.getSetting('HATE DELAY') then
                            
                                -- SOULEATER.
                                if target and not helpers['buffs'].buffActive(64) and helpers["actions"].isReady(bp, "JA", "Souleater") then
                                    helpers["queue"].addToFront(bp, bp.JA["Souleater"], player)
                                    timers.hate = os.clock()
                                    
                                    if self.getSetting('TANK MODE') then
                                        windower.send_command("wait 1; cancel 63")
                                    end
                                    
                                -- LAST RESORT.
                                elseif target and not helpers['buffs'].buffActive(64) and helpers["actions"].isReady(bp, "JA", "Last Resort") then
                                    helpers["queue"].addToFront(bp, bp.JA["Last Resort"], player)
                                    timers.hate = os.clock()
                                    
                                    if self.getSetting('TANK MODE') then
                                        windower.send_command("wait 1; cancel 64")
                                    end
                                    
                                end
                                
                            end
                        
                        -- /BLU.
                        elseif player.sub_job == "BLU" and helpers['actions'].canCast() then
                            
                            -- JETTATURA.
                            if target and helpers["actions"].isReady(bp, "MA", "Jettatura") then
                                helpers["queue"].add(bp, bp.MA["Jettatura"], target)
                                
                            -- BLANK GAZE.
                            elseif target and helpers["actions"].isReady(bp, "MA", "Blank Gaze") then
                                helpers["queue"].add(bp, bp.MA["Blank Gaze"], target)
                                
                            end
                            
                            if self.getSetting('AOEHATE') and (os.clock()-timers.hate) > self.getSetting('HATE DELAY') then
                                
                                -- SOPORIFIC.
                                if target and helpers["actions"].isReady(bp, "MA", "Soporific") then
                                    helpers["queue"].add(bp, bp.MA["Soporific"], target)
                                    timers.hate = os.clock()
                                
                                -- GEIST WALL.
                                elseif target and helpers["actions"].isReady(bp, "MA", "Geist Wall") then
                                    helpers["queue"].add(bp, bp.MA["Geist Wall"], target)
                                    timers.hate = os.clock()
                                
                                -- JETTATURA.
                                elseif target and helpers["actions"].isReady(bp, "MA", "Sheep Song") then
                                    helpers["queue"].add(bp, bp.MA["Sheep Song"], target)
                                    timers.hate = os.clock()
                                
                                end
                                
                            end
                        
                        -- /DNC.
                        elseif player.sub_job == "DNC" then
                            
                            -- ANIMATED FLOURISH.
                            if target and helpers['actions'].canAct() and helpers["actions"].isReady(bp, "JA", "Animated Flourish") and helpers['buffs'].getFinishingMoves() > 0 then
                                helpers["queue"].add(bp, bp.JA["Animated Flourish"], target)
                            end
                        
                        end
                        
                    end

                    -- BUFF LOGIC.
                    if self.getSetting('BUFFS') then
                        
                        -- SCH/.
                        if player.main_job == 'SCH' then

                            -- LIGHT ARTS.
                            if helpers['actions'].canAct() and helpers['actions'].isReady(bp, "JA", self.getSetting('ARTS')) and self.getSetting('ARTS') == "Light Arts" and (not helpers['buffs'].buffActive(358) and not helpers['buffs'].buffActive(401)) then
                                helpers['queue'].add(bp, bp.JA[self.getSetting('ARTS')], player)
                            
                            -- DARK ARTS.
                            elseif helpers['actions'].canAct() and helpers['actions'].isReady(bp, "JA", self.getSetting('ARTS')) and self.getSetting('ARTS') == "Dark Arts" and (not helpers['buffs'].buffActive(359) and not helpers['buffs'].buffActive(402)) then
                                helpers['queue'].add(bp, bp.JA[self.getSetting('ARTS')], player)
                                
                            -- ADDENDUM.
                            elseif helpers['actions'].canAct() and (helpers['buffs'].buffActive(358) or helpers['buffs'].buffActive(359)) and helpers['actions'].isReady(bp, "JA", self.getSetting('ADDENDUM')) and helpers["stratagems"].getStratagems().current > 0 then
                                            
                                if self.getSetting('ADDENDUM') == "Addendum: White" and not helpers['buffs'].buffActive(401) then
                                    helpers['queue'].add(bp, bp.JA[self.getSetting('ADDENDUM')], player)
                                    
                                elseif self.getSetting('ADDENDUM') == "Addendum: Black" and not helpers['buffs'].buffActive(402) then
                                    helpers['queue'].add(bp, bp.JA[self.getSetting('ADDENDUM')], player)
                                    
                                end
                                
                            -- STORMS.
                            elseif helpers['actions'].canCast() and helpers['actions'].isReady(bp, "MA", self.getSetting('WEATHER')) then
                                
                                if self.getSetting('WEATHER') == "Firestorm" and not helpers['buffs'].buffActive(178) then
                                    helpers['queue'].add(bp, bp.MA[self.getSetting('WEATHER')], player)
                                    
                                elseif self.getSetting('WEATHER') == "Hailstorm" and not helpers['buffs'].buffActive(179) then
                                    helpers['queue'].add(bp, bp.MA[self.getSetting('WEATHER')], player)
                                    
                                elseif self.getSetting('WEATHER') == "Windstorm" and not helpers['buffs'].buffActive(180) then
                                    helpers['queue'].add(bp, bp.MA[self.getSetting('WEATHER')], player)
                                    
                                elseif self.getSetting('WEATHER') == "Sandstorm" and not helpers['buffs'].buffActive(181) then
                                    helpers['queue'].add(bp, bp.MA[self.getSetting('WEATHER')], player)
                                    
                                elseif self.getSetting('WEATHER') == "Thunderstorm" and not helpers['buffs'].buffActive(182) then
                                    helpers['queue'].add(bp, bp.MA[self.getSetting('WEATHER')], player)
                                    
                                elseif self.getSetting('WEATHER') == "Rainstorm" and not helpers['buffs'].buffActive(183) then
                                    helpers['queue'].add(bp, bp.MA[self.getSetting('WEATHER')], player)
                                    
                                elseif self.getSetting('WEATHER') == "Aurorastorm" and not helpers['buffs'].buffActive(184) then
                                    helpers['queue'].add(bp, bp.MA[self.getSetting('WEATHER')], player)
                                    
                                elseif self.getSetting('WEATHER') == "Voidstorm" and not helpers['buffs'].buffActive(185) then
                                    helpers['queue'].add(bp, bp.MA[self.getSetting('WEATHER')], player)
                                    
                                end
                            
                            -- KLIMAFORM
                            elseif helpers['actions'].canCast() and self.getSetting('ARTS') == 'Dark Arts' and helpers['actions'].isReady(bp, "MA", "Klimaform") and not helpers['buffs'].buffActive(407) then
                                helpers['queue'].add(bp, bp.MA["Klimaform"], player)
                                
                            -- STONESKIN.
                            elseif helpers['actions'].canCast() and self.getSetting('ARTS') == 'Light Arts' and helpers['actions'].isReady(bp, "MA", "Stoneskin") and not helpers['buffs'].buffActive(37) then
                                helpers['queue'].add(bp, bp.MA["Stoneskin"], player)
                                
                            end
                           
                        end
                        
                        -- /SCH.
                        if player.sub_job == "SCH" then
                            
                            -- LIGHT ARTS.
                            if helpers['actions'].canAct() and helpers['actions'].isReady(bp, "JA", self.getSetting('ARTS')) and self.getSetting('ARTS') == "Light Arts" and (not helpers['buffs'].buffActive(358) and not helpers['buffs'].buffActive(401)) then
                                helpers['queue'].add(bp, bp.JA[self.getSetting('ARTS')], player)
                            
                            -- DARK ARTS.
                            elseif helpers['actions'].canAct() and helpers['actions'].isReady(bp, "JA", self.getSetting('ARTS')) and self.getSetting('ARTS') == "Dark Arts" and (not helpers['buffs'].buffActive(359) and not helpers['buffs'].buffActive(402)) then
                                helpers['queue'].add(bp, bp.JA[self.getSetting('ARTS')], player)
                                
                            -- ADDENDUM.
                            elseif helpers['actions'].canAct() and (helpers['buffs'].buffActive(358) or helpers['buffs'].buffActive(359)) and helpers['actions'].isReady(bp, "JA", self.getSetting('ADDENDUM')) and helpers["stratagems"].getStratagems().current > 0 then
                                            
                                if self.getSetting('ADDENDUM') == "Addendum: White" and not helpers['buffs'].buffActive(401) then
                                    helpers['queue'].add(bp, bp.JA[self.getSetting('ADDENDUM')], player)
                                    
                                elseif self.getSetting('ADDENDUM') == "Addendum: Black" and not helpers['buffs'].buffActive(402) then
                                    helpers['queue'].add(bp, bp.JA[self.getSetting('ADDENDUM')], player)
                                    
                                end
                                
                            -- STORMS.
                            elseif helpers['actions'].canCast() and helpers['actions'].isReady(bp, "MA", self.getSetting('WEATHER')) then
                                
                                if self.getSetting('WEATHER') == "Firestorm" and not helpers['buffs'].buffActive(178) then
                                    helpers['queue'].add(bp, bp.MA[self.getSetting('WEATHER')], player)
                                    
                                elseif self.getSetting('WEATHER') == "Hailstorm" and not helpers['buffs'].buffActive(179) then
                                    helpers['queue'].add(bp, bp.MA[self.getSetting('WEATHER')], player)
                                    
                                elseif self.getSetting('WEATHER') == "Windstorm" and not helpers['buffs'].buffActive(180) then
                                    helpers['queue'].add(bp, bp.MA[self.getSetting('WEATHER')], player)
                                    
                                elseif self.getSetting('WEATHER') == "Sandstorm" and not helpers['buffs'].buffActive(181) then
                                    helpers['queue'].add(bp, bp.MA[self.getSetting('WEATHER')], player)
                                    
                                elseif self.getSetting('WEATHER') == "Thunderstorm" and not helpers['buffs'].buffActive(182) then
                                    helpers['queue'].add(bp, bp.MA[self.getSetting('WEATHER')], player)
                                    
                                elseif self.getSetting('WEATHER') == "Rainstorm" and not helpers['buffs'].buffActive(183) then
                                    helpers['queue'].add(bp, bp.MA[self.getSetting('WEATHER')], player)
                                    
                                elseif self.getSetting('WEATHER') == "Aurorastorm" and not helpers['buffs'].buffActive(184) then
                                    helpers['queue'].add(bp, bp.MA[self.getSetting('WEATHER')], player)
                                    
                                elseif self.getSetting('WEATHER') == "Voidstorm" and not helpers['buffs'].buffActive(185) then
                                    helpers['queue'].add(bp, bp.MA[self.getSetting('WEATHER')], player)
                                    
                                end
                            
                            -- KLIMAFORM
                            elseif helpers['actions'].canCast() and self.getSetting('ARTS') == 'Dark Arts' and helpers['actions'].isReady(bp, "MA", "Klimaform") and not helpers['buffs'].buffActive(407) then
                                helpers['queue'].add(bp, bp.MA["Klimaform"], player)
                                
                            -- STONESKIN.
                            elseif helpers['actions'].canCast() and self.getSetting('ARTS') == 'Light Arts' and helpers['actions'].isReady(bp, "MA", "Stoneskin") and not helpers['buffs'].buffActive(37) then
                                helpers['queue'].add(bp, bp.MA["Stoneskin"], player)
                                
                            end
                        
                        -- /RDM.
                        elseif player.sub_job == "RDM" and helpers['actions'].canCast() then
                            
                            -- HASTE.
                            if helpers['actions'].isReady(bp, "MA", "Haste") and not helpers['buffs'].buffActive(33) then
                                helpers["queue"].addToFront(bp, bp.MA["Haste"], player)
                            
                            -- ENSPELLS.
                            elseif (not helpers['buffs'].buffActive(94) and not helpers['buffs'].buffActive(95) and not helpers['buffs'].buffActive(96) and not helpers['buffs'].buffActive(97) and not helpers['buffs'].buffActive(98) and not helpers['buffs'].buffActive(99)) then
                                
                                if helpers['actions'].isReady(bp, "MA", self.getSetting('ENSPELL')) then
                                    helpers["queue"].addToFront(bp, bp.MA[self.getSetting('ENSPELL')], player)
                                end
                            
                            -- PHALANX.
                            elseif helpers['actions'].isReady(bp, "MA", "Phalanx") and not helpers['buffs'].buffActive(116) then
                                helpers["queue"].addToFront(bp, bp.MA["Phalanx"], player)
                                
                            -- REFRESH.
                            elseif not self.getSetting('SUBLIMATION') and helpers['actions'].isReady(bp, "MA", "Refresh") and not helpers['buffs'].buffActive(43) then
                                helpers["queue"].addToFront(bp, bp.MA["Refresh"], player)
                                
                            -- STONESKIN.
                            elseif helpers['actions'].isReady(bp, "MA", "Stoneskin") and not helpers['buffs'].buffActive(37) then
                                helpers['queue'].add(bp, bp.MA["Stoneskin"], player)
                                
                            -- SPIKES.
                            elseif helpers['actions'].isReady(bp, "MA", self.getSetting('SPIKES')) and (not helpers['buffs'].buffActive(34) or not helpers['buffs'].buffActive(35) or not helpers['buffs'].buffActive(38)) then
                                helpers['queue'].add(bp, bp.MA[self.getSetting('SPIKES')], player)
                                
                            end                            
                                
                        -- /WAR.
                        elseif player.sub_job == "WAR" and helpers['actions'].canAct() then
                        
                            -- BERSERK.
                            if target and not self.getSetting('TANK MODE') and not helpers['buffs'].buffActive(56) and helpers['actions'].isReady(bp, "JA", "Berserk") then
                                helpers['queue'].add(bp, bp.JA["Berserk"], player)
                            
                            -- DEFENDER.
                            elseif self.getSetting('TANK MODE') and not helpers['buffs'].buffActive(57) and helpers['actions'].isReady(bp, "JA", "Defender") then
                                helpers['queue'].add(bp, bp.JA["Defender"], player)
                                
                            -- AGGRESSOR.
                            elseif target and not helpers['buffs'].buffActive(58) and helpers['actions'].isReady(bp, "JA", "Aggressor") then
                                helpers['queue'].add(bp, bp.JA["Aggressor"], player)
                            
                            -- WARCRY.
                            elseif target and not helpers['buffs'].buffActive(68) and not helpers['buffs'].buffActive(460) and helpers['actions'].isReady(bp, "JA", "Warcry") then
                                helpers['queue'].add(bp, bp.JA["Warcry"], player)
                            
                            end
                        
                        -- /SAM.
                        elseif player.sub_job == "SAM" and helpers['actions'].canAct() then
                            local slots = bp.helpers['equipment'].main.slots
                            
                            -- HASSO.
                            if not self.getSetting('TANK MODE') and not helpers['buffs'].buffActive(353) and helpers['actions'].isReady(bp, "JA", "Hasso") and slots and slots:contains(0) and not slots:contains(1) then
                                helpers['queue'].add(bp, bp.JA["Hasso"], player)
                            
                            -- SEIGAN.
                            elseif self.getSetting('TANK MODE') and not helpers['buffs'].buffActive(354) and helpers['actions'].isReady(bp, "JA", "Seigan") and slots and slots:contains(0) and not slots:contains(1) then
                                helpers['queue'].add(bp, bp.JA["Seigan"], player)
                            
                            -- MEDITATE.
                            elseif helpers['actions'].isReady(bp, "JA", "Meditate") then
                                helpers['queue'].addToFront(bp, bp.JA["Meditate"], player)
                            
                            -- THIRD EYE.
                            elseif not helpers['buffs'].buffActive(67) and helpers['actions'].isReady(bp, "JA", "Third Eye") then
                                helpers['queue'].add(bp, bp.JA["Third Eye"], player)
                            
                            end
                        
                        -- /DRK.
                        elseif player.sub_job == "DRK" and helpers['actions'].canAct() then
                            
                            -- LAST RESORT.
                            if target and not self.getSetting('TANK MODE') and not helpers['buffs'].buffActive(64) and helpers['actions'].isReady(bp, "JA", "Last Resort") then
                                helpers['queue'].add(bp, bp.JA["Last Resort"], player)
                            
                            -- SOULEATER.
                            elseif target and not self.getSetting('TANK MODE') and not helpers['buffs'].buffActive(63) and helpers['actions'].isReady(bp, "JA", "Souleater") then
                                helpers['queue'].add(bp, bp.JA["Souleater"], player)
                                
                            -- ARCANE CIRCLE.
                            elseif target and helpers['buffs'].buffActive(75) and helpers['actions'].isReady(bp, "JA", "Arcane Circle") then
                                helpers['queue'].add(bp, bp.JA["Arcane Circle"], player)
                            
                            end

                        -- RUN/.
                        elseif player.sub_job == "RUN" then
                            local runes  = helpers['runes'].runes
                            local active = helpers['runes'].getActive(bp)
                            
                            -- RUNE ENCHANMENTS.
                            if helpers['actions'].canAct() and active:length() > 0 and active:length() < 3 then
                                
                                if runes[active:length()] == 1 then
                                    
                                    if helpers['actions'].isReady(bp, "JA", runes[2].en) and not helpers['queue'].inQueue(bp, runes[2], player) then
                                        helpers['queue'].add(bp, runes[2] "me")
                                    end
                                    
                                elseif runes[active:length()] == 2 then
                                    
                                    if helpers['actions'].isReady(bp, "JA", runes[3].en) and not helpers['queue'].inQueue(bp, runes[3], player) then
                                        helpers['queue'].add(bp, runes[3], "me")
                                    end
                                    
                                elseif runes[active:length()] == 3 then
                                    
                                    if helpers['actions'].isReady(bp, "JA", runes[1].en) and not helpers['queue'].inQueue(bp, runes[1], player) then
                                        helpers['queue'].add(bp, runes[1], "me")
                                    end
                                    
                                end
                                
                            elseif active:length() == 0 then
                                
                                if helpers['actions'].isReady(bp, "JA", runes[1].en) and not helpers['queue'].inQueue(bp, runes[1], player) then
                                    helpers['queue'].add(bp, runes[1], "me")
                                end
                                
                            end
                            
                        -- /BLU.
                        elseif player.sub_job == "BLU" then
                        
                        -- /DRG.
                        elseif player.sub_job == "DRG" then
                            
                            -- ANCIENT CIRCLE.
                            if target and not helpers['buffs'].buffaActive(118) and helpers['actions'].isReady(bp, "JA", "Ancient Circle") then
                                helpers['queue'].add(bp, bp.JA["Ancient Circle"], player)                            
                            end
                            
                        -- /RNG.
                        elseif player.sub_job == "RNG" and helpers['actions'].canAct() then
                            
                            -- SHARPSHOT.
                            if target and not helpers['buffs'].buffActive(72) and helpers['actions'].isReady(bp, "JA", "Sharpshot") then
                                helpers["queue"].addToFront(JA["Sharpshot"], player)
                            
                            -- BARRAGE.
                            elseif target and not helpers['buffs'].buffActive(371) and helpers['actions'].isReady(bp, "JA", "Velocity Shot") then
                                helpers["queue"].addToFront(JA["Velocity Shot"], player)
                            
                            -- VELOCITY SHOT.
                            elseif not helpers['buffs'].buffActive(73) and helpers['actions'].isReady(bp, "JA", "Barrage") then
                                helpers['queue'].add(bp, bp.JA["Barrage"], player)
                            
                            end
                        
                        -- /COR.
                        elseif player.sub_job == "COR" and helpers['actions'].canAct() then
                            local rolls     = helpers['rolls'].rolls
                            local active    = helpers['rolls'].active
                            local buffs     = helpers['rolls'].getActive(bp)
                            
                            -- Make the initial roll.
                            if buffs <= 2 and not helpers['rolls'].rolling then
                                    
                                for i,roll in ipairs(rolls) do
                                    local buff = bp.res.buffs[helpers['rolls'].getBuff(bp, roll.en).id]
                                    
                                    if helpers['actions'].isReady(bp, "JA", roll.en) and not helpers['buffs'].buffActive(buff.id) and not helpers['queue'].typeInQueue(bp, roll) then

                                        -- Check to see if Crooked Cards is ready.
                                        if bp.helpers['rolls'].crooked and helpers['actions'].isReady(bp, "JA", 'Crooked Cards') and not helpers['buffs'].buffActive(601) then
                                            helpers["queue"].add(bp, bp.JA['Crooked Cards'], player)
                                        end
                                        helpers["queue"].add(bp, bp.JA[roll.en], player)
                                        break

                                    end

                                end

                            -- If in the middle of rolling the first roll.
                            elseif buffs > 0 and helpers['rolls'].rolling and helpers['actions'].isReady(bp, "JA", 'Double-Up') then
                                local double = active[active:length()]

                                if double then
                                    local buff  = bp.res.buffs[helpers['rolls'].getBuff(bp, double.roll.en).id]
                                    local lucky = helpers['rolls'].getLucky(bp, buff.en)
                                    local cap   = helpers['rolls'].cap
                                
                                    if buff and helpers['buffs'].buffActive(buff.id) and double.dice < cap and double.dice ~= lucky and double.dice <= 11 then
                                        helpers["queue"].addToFront(bp, bp.JA['Double-Up'], player)
                                    end

                                end

                            end
                        
                        -- /DNC.
                        elseif player.sub_job == "DNC" and helpers['actions'].canAct() then
                        
                            -- SAMBAS.
                            if target and (not helpers['buffs'].buffActive(368) and not helpers['buffs'].buffActive(370)) and helpers['actions'].isReady(bp, "JA", self.getSetting('SAMBAS')) then
                                helpers['queue'].add(bp, bp.JA[self.getSetting('SAMBAS')], player)                            
                            end
                        
                        -- /NIN.
                        elseif player.sub_job == "NIN" then
                        
                            -- UTSUSEMI
                            if helpers['actions'].canCast() and helpers['inventory'].findItemByName("Shihei", 0) then
                                
                                if not helpers['buffs'].buffActive(444) and not helpers['buffs'].buffActive(445) and not helpers['buffs'].buffActive(446) and not helpers['buffs'].buffActive(36) then
                                    
                                    if helpers['actions'].isReady(bp, "MA", "Utsusemi: Ni") then
                                        helpers["queue"].addToFront(bp, bp.MA["Utsusemi: Ni"], player)
                                        
                                    elseif helpers['actions'].isReady(bp, "MA", "Utsusemi: Ichi") then
                                        helpers["queue"].addToFront(bp, bp.MA["Utsusemi: Ichi"], player)
                                        
                                    end
                                
                                end
                            
                            end
                        
                        end
                        
                    end

                    -- DEBUFF LOGIC.
                    if self.getSetting('DEBUFF') and target then
                        
                        -- /DNC.
                        if (player.main_job == 'DNC' or player.sub_job == 'DNC') and helpers['actions'].canAct() then
                        
                            -- STEPS.
                            if helpers["actions"].isReady(bp, "JA", self.getSetting('STEPS')) and os.clock()-timers.steps > self.getSetting('STEPS DELAY') then
                                helpers['queue'].add(bp, bp.JA[self.getSetting('STEPS')], target)
                                timers.steps = os.clock()

                            end

                        elseif player.main_job == 'COR' and helpers['actions'].canAct() then
                            
                            -- QUICK DRAW.
                            if helpers["actions"].isReady(bp, "JA", self.getSetting('COR SHOTS')) then
                                helpers['queue'].add(bp, bp.JA[self.getSetting('COR SHOTS')], target)
                            end

                        end
                        
                    end
                
                    -- DRAINS LOGIC
                    if self.getSetting('DRAINS') and helpers['actions'].canCast() and target then
                        
                        if helpers["actions"].isReady(bp, "MA", "Drain III") and player["vitals"].mpp < self.getSetting('DRAIN THRESHOLD') then
                            helpers["queue"].add(bp, bp.MA["Drain III"], target)
                            
                        elseif helpers["actions"].isReady(bp, "MA", "Drain II") and player["vitals"].mpp < self.getSetting('DRAIN THRESHOLD') then
                            helpers["queue"].add(bp, bp.MA["Drain II"], target)
                            
                        elseif helpers["actions"].isReady(bp, "MA", "Drain") and player["vitals"].mpp < self.getSetting('DRAIN THRESHOLD') then
                            helpers["queue"].add(bp, bp.MA["Drain"], target)
                            
                        end
                        
                        if helpers["actions"].isReady(bp, "MA", "Aspir III") and player["vitals"].mpp < self.getSetting('ASPIR THRESHOLD') then
                            helpers["queue"].add(bp, bp.MA["Aspir III"], target)
                        
                        elseif helpers["actions"].isReady(bp, "MA", "Aspir II") and player["vitals"].mpp < self.getSetting('ASPIR THRESHOLD') then
                            helpers["queue"].add(bp, bp.MA["Aspir II"], target)
                            
                        elseif helpers["actions"].isReady(bp, "MA", "Aspir") and player["vitals"].mpp < self.getSetting('ASPIR THRESHOLD') then
                            helpers["queue"].add(bp, bp.MA["Aspir"], target)
                        
                        end
                        
                    end

                    -- HANDLE RANGED ATTACKS.
                    if self.getSetting('RA') and helpers['equipment'].ammo and helpers['equipment'].ammo.en ~= 'Gil' then
                        helpers['queue'].addToFront(bp, helpers['actions'].unique.ranged, target)
                    end

                end

                -- HANDLE EVERYTHING INSIDE THE QUEUE.
                helpers['queue'].handle(bp)

            end

        end

    end

    self.render = function(bp)
        local bp = bp or false

    end

    self.renderConfig = function()

        if not self.config:visible() then
            self.updateConfig()
            self.config:show()

        elseif self.config:visible() then
            self.config:hide()

        end

    end

    self.updateConfig = function()
        local color = self.important
        local s     = {}

        for name, settings in pairs(self) do

            if type(settings) == 'table' and name ~= 'important' then

                if settings[2] and (type(settings[2]) == 'string' or type(settings[2]) == 'number' or type(settings[2]) == 'boolean') and type(settings[2]) ~= 'function' then
                    table.insert(s, string.format('%s: \\cs(%s)%s\\cr\n', name:upper(), color, tostring(settings[2]):upper():lpad(' ', (25-#name))))

                elseif not settings[2] and type(settings[2]) == 'boolean' then
                    table.insert(s, string.format('%s: \\cs(%s)%s\\cr\n', name:upper(), color, tostring(settings[2]):upper():lpad(' ', (25-#name))))

                end

            elseif type(settings) ~= 'table' and name ~= 'important' then

                if (type(settings) == 'string' or type(settings) == 'number' or type(settings) == 'boolean') then
                    table.insert(s, string.format('%s: \\cs(%s)%s\\cr\n', name:upper(), color, tostring(settings):upper():lpad(' ', (25-#name))))

                elseif not settings and type(settings) == 'boolean' then
                    table.insert(s, string.format('%s: \\cs(%s)%s\\cr\n', name:upper(), color, tostring(settings[2]):upper():lpad(' ', (25-#name))))

                end


            end

        end
        self.config:text(table.concat(s, ''))
        self.config:update()

    end

    self.getSetting = function(name)
        local name  = name or false

        if name then
            local setting = self[name]
            
            if setting and type(setting) == 'table' then
                return setting[2]

            elseif setting then
                return setting

            end

        end
        return false

    end

    self.setSetting = function(bp, name, value)
        local bp    = bp or false
        local name  = name or false
        local value = value or false

        if bp and name and value then
            local helpers = bp.helpers
            local setting = self[name]

            if setting and type(self[name]) == 'table' then
                self[name][2] = value
                helpers['popchat'].pop(string.format('%s is now set to: %s', tostring(name), tostring(self[name][2])))
                self.updateConfig()

            elseif setting and (type(self[name]) == 'number' or type(self[name]) == 'string') then
                self[name] = value
                helpers['popchat'].pop(string.format('%s is now set to: %s', tostring(name), tostring(self[name])))
                self.updateConfig()

            end

        end

    end

    self.nextSetting = function(bp, name)
        local bp    = bp or false
        local name  = name or false

        if bp and name then
            local helpers = bp.helpers
            local setting = self[name]

            if setting then
                local options = setting[1]
                local current = setting[2]

                for i,v in ipairs(options) do
                    
                    if v == current and i < #options then
                        self[name][2] = self[name][1][i+1]
                        helpers['popchat'].pop(string.format('%s is now set to: %s', tostring(name), tostring(self[name][2])))
                        self.updateConfig()
                        break

                    elseif v == current and i == #options then
                        self[name][2] = self[name][1][1]
                        helpers['popchat'].pop(string.format('%s is now set to: %s', tostring(name), tostring(self[name][2])))
                        self.updateConfig()
                        break

                    end

                end

            end

        end

    end

    return self

end
return core.get()
