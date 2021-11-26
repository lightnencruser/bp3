local core = {}
local player = windower.ffxi.get_player()
function core.get()
    local self = {}

    -- Private Variables.
    local bp        = false
    local private   = {events={}, settings=dofile(string.format('%sbp/core/core.lua', windower.addon_path, player.name))}
    local timers    = {hate=0, steps=0}

    -- Public Variables.
    self.settings   = private.settings.getFlags()

    -- Public Functions.
    self.setSystem = function(buddypal)
        if buddypal then
            bp = buddypal
            private.settings.setSystem(bp)            
        end

    end

    --[[
    self.handleItems = function()
        local bp = bp or false

        if bp then
            helpers = bp.helpers

            if helpers['actions'].canItem(bp) then

                if helpers['buffs'].buffActive(15) then

                    if helpers['inventory'].findItemByName("Holy Water") and not helpers['queue'].inQueue(bp.IT["Holy Water"]) then
                        helpers['queue'].add(bp.IT["Holy Water"], 'me')

                    elseif helpers['inventory'].findItemByName("Hallowed Water") and not helpers['queue'].inQueue(bp.IT["Hallowed Water"]) then
                        helpers['queue'].add(bp.IT["Hallowed Water"], 'me')

                    end

                elseif helpers['buffs'].buffActive(6) then

                    if helpers['inventory'].findItemByName("Echo Drops") and not helpers['queue'].inQueue(bp.IT["Echo Drops"]) then
                        helpers['queue'].add(bp.IT["Echo Drops"], 'me')
                    end

                end

            end

        end

    end

    self.handleAutomation = function()
        local bp = bp or false

        if bp then
            local helpers = bp.helpers
            local player = windower.ffxi.get_player()
            
            if helpers['queue'].ready and not helpers['actions'].moving and bp.settings['Enabled'] then
                bp.helpers['cures'].handleCuring(bp)
                self.handleItems(bp)

                -- HANDLES ALL STATUS DEBUFFS.
                if bp.helpers['status'].enabled then
                    bp.helpers['status'].fixStatus()
                end

                -- PLAYER IS ENGAGED.
                if player.status == 1 then
                    local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target("t") or false
                    
                    -- SKILLUP LOGIC.
                    if self.getSetting('SKILLUP') then
                        
                        if helpers['inventory'].findItemByName("B.E.W. Pitaru") and not helpers['queue'].inQueue(bp.IT["B.E.W. Pitaru"]) and not helpers['buffs'].buffActive(251) then
                            helpers['queue'].add(bp.IT["B.E.W. Pitaru"], 'me')
                            
                        else
                            local skills = bp.skillup[self.getSetting('SKILLS')]
                                                        
                            if skills and skills.list then

                                for _,v in pairs(skills.list) do
                                    
                                    if helpers['actions'].isReady('MA', v) and not helpers['queue'].inQueue(bp.MA[v]) then

                                        if bp.skillup[self.getSetting('SKILLS')].target == 't' and target then
                                            helpers['queue'].add(bp.MA[v], target)

                                        elseif bp.skillup[self.getSetting('SKILLS')].target == 'me' then
                                            helpers['queue'].add(bp.MA[v], player)

                                        end

                                    end
                                
                                end

                            end
                        
                        end
                        
                    end
                    
                    -- WEAPON SKILL LOGIC.
                    if self.getSetting('WS') and helpers['actions'].canAct() and target and (target.distance):sqrt() < 6 then
                        local current = {tp=player['vitals'].tp, hpp=player['vitals'].hpp, mpp=player['vitals'].mpp, main=helpers['equipment'].main.en, ranged=helpers['equipment'].ranged.en}

                        if self.getSetting('AM') then
                            local weaponskill = helpers["aftermath"].getWeaponskill(current.main)
                            local aftermath   = helpers["aftermath"].getBuffByLevel(self.getSetting('AM LEVEL'))
                            
                            if self.getSetting('SANGUINE') and current.hpp <= self.getSetting('SANGUINE HPP') and helpers['actions'].isReady('WS', "Sanguine Blade") then
                                helpers['queue'].addToFront(bp.WS["Sanguine Blade"], target)

                            elseif not helpers['buffs'].buffActive(aftermath) and current.tp >= (self.getSetting('AM LEVEL')*1000) and weaponskill and helpers['actions'].isReady('WS', weaponskill) then
                                helpers['queue'].addToFront(bp.WS[weaponskill], target)

                            elseif helpers['buffs'].buffActive(aftermath) and current.mpp <= self.getSetting('MOONLIGHT MPP') and helpers['actions'].isReady('WS', "Moonlight") then
                                helpers['queue'].addToFront(bp.WS["Moonlight"], 'me')

                            elseif helpers['buffs'].buffActive(aftermath) and current.mpp <= self.getSetting('MYRKR MPP') and helpers['actions'].isReady('WS', "Myrkr") then
                                helpers['queue'].addToFront(bp.WS["Myrkr"], 'me')
                                
                            elseif (helpers['buffs'].buffActive(aftermath) or not weaponskill) and current.tp >= self.getSetting('TP THRESHOLD') and helpers['actions'].isReady('WS', self.getSetting('WSNAME')) then
                                helpers['queue'].addToFront(bp.WS[self.getSetting('WSNAME')], target)
                                
                            end
                            
                        elseif not self.getSetting('AM') and target then
                            
                            if current.mpp <= self.getSetting('MOONLIGHT MPP') and helpers['actions'].isReady('WS', "Moonlight") then
                                helpers['queue'].addToFront(bp.WS["Moonlight"], 'me')

                            elseif current.mpp <= self.getSetting('MYRKR MPP') and helpers['actions'].isReady('WS', "Myrkr") then
                                helpers['queue'].addToFront(bp.WS["Myrkr"], 'me')

                            elseif current.tp >= self.getSetting('TP THRESHOLD') and helpers['actions'].isReady('WS', self.getSetting('WSNAME')) then
                                helpers['queue'].addToFront(bp.WS[self.getSetting('WSNAME')], target)

                            end
                        
                        end

                    elseif self.getSetting('RA') and self.getSetting('WS') and helpers['actions'].canAct() and target and (target.distance):sqrt() > 6 and (target.distance):sqrt() < 21 then
                        local current = {tp=player['vitals'].tp, hpp=player['vitals'].hpp, mpp=player['vitals'].mpp, main=helpers['equipment'].main.en, ranged=helpers['equipment'].ranged.en}

                        if self.getSetting('AM') and weaponskill and aftermath then
                            local weaponskill = helpers["aftermath"].getWeaponskill(current.ranged)
                            local aftermath   = helpers["aftermath"].getBuffByLevel(self.getSetting('AM LEVEL'))

                            if not helpers['buffs'].buffActive(aftermath) and current.tp >= (self.getSetting('AM LEVEL')*1000) and weaponskill and helpers['actions'].isReady('WS', weaponskill) then
                                helpers['queue'].addToFront(bp.WS[weaponskill], target)

                            elseif helpers['buffs'].buffActive(aftermath) and current.mpp <= self.getSetting('MOONLIGHT MPP') and helpers['actions'].isReady('WS', "Moonlight") then
                                helpers['queue'].addToFront(bp.WS["Moonlight"], 'me')
    
                            elseif helpers['buffs'].buffActive(aftermath) and current.mpp <= self.getSetting('MYRKR MPP') and helpers['actions'].isReady('WS', "Myrkr") then
                                helpers['queue'].addToFront(bp.WS["Myrkr"], 'me')
                                
                            elseif (helpers['buffs'].buffActive(aftermath) or not weaponskill) and current.tp >= self.getSetting('TP THRESHOLD') and helpers['actions'].isReady('WS', self.getSetting('RANGED WS')) then
                                helpers['queue'].addToFront(bp.WS[self.getSetting('RANGED WS')], target)
                                
                            end
                        
                        elseif not self.getSetting('AM') then
                            
                            if current.mpp <= self.getSetting('MOONLIGHT MPP') and helpers['actions'].isReady('WS', "Moonlight") then
                                helpers['queue'].addToFront(bp.WS["Moonlight"], 'me')

                            elseif current.mpp <= self.getSetting('MYRKR MPP') and helpers['actions'].isReady('WS', "Myrkr") then
                                helpers['queue'].addToFront(bp.WS["Myrkr"], 'me')

                            elseif current.tp >= self.getSetting('TP THRESHOLD') and helpers['actions'].isReady('WS', self.getSetting('RANGED WS')) then
                                helpers['queue'].addToFront(bp.WS[self.getSetting('RANGED WS')], target)
                                
                            end
                        
                        end
                        
                    end

                    -- ABILITY LOGIC.
                    if self.getSetting('JA') and helpers['actions'].canAct() then
                        
                        -- PUP/.
                        if player.main_job == 'PUP' then
                            local pet = windower.ffxi.get_mob_by_target('t') or false
                           
                        end

                        -- /RDM.
                        if player.sub_job == "RDM" then
                            
                            -- CONVERT LOGIC.
                            if self.getSetting('CONVERT') and player['vitals'].hpp >= self.getSetting('CONVERT HPP') and player['vitals'].mpp <= self.getSetting('CONVERT MPP') then
                                
                                if helpers['actions'].isReady('JA', "Convert") then
                                    helpers['queue'].add(bp.JA["Convert"], player)
                                    helpers['queue'].add(bp.MA["Cure IV"], player)
                                    
                                end
                                
                            end
                        
                        elseif player.sub_job == "SCH" then
                            
                            -- SUBLIMATION LOGIC.
                            if self.getSetting('SUBLIMATION') then
                            
                                if not helpers['buffs'].buffActive(187) and not helpers['buffs'].buffActive(188) and helpers['actions'].isReady('JA', "Sublimation") then
                                    helpers['queue'].add(bp.JA["Sublimation"], player)
                                
                                elseif not helpers['buffs'].buffActive(187) and helpers['buffs'].buffActive(188) and helpers['actions'].isReady('JA', "Sublimation") then
                                    helpers['queue'].add(bp.JA["Sublimation"], player)

                                end
                                
                            end
                        
                        -- /DRG.
                        elseif player.sub_job == "DRG" then
                            
                            -- JUMP.
                            if target and helpers['actions'].isReady('JA', "Jump") then
                                helpers['queue'].add(bp.JA["Jump"], target)
                                
                            -- HIGH JUMP.
                            elseif target and helpers['actions'].isReady('JA', "High Jump") then
                                helpers['queue'].add(bp.JA["High Jump"], target)
                                
                            end
                            
                        -- /DNC.
                        elseif player.sub_job == "DNC" then
                            
                            -- REVERSE FLOURISH.
                            if target and helpers['actions'].isReady('JA', "Reverse Flourish") and helpers['buffs'].getFinishingMoves() > 4 then
                                helpers['queue'].add(bp.JA["Reverse Flourish"], player)                            
                            end
                        
                        end
                        
                    end

                    -- HATE LOGIC.
                    if self.getSetting('HATE') and target then
                        
                        -- PUP/.
                        if player.main_job == 'PUP' then
                            local pet = windower.ffxi.get_mob_by_target('t') or false
                           
                        end
                        
                        -- /RDM.
                        if player.sub_job == "RDM" then
                        
                        -- /WAR.
                        elseif player.sub_job == "WAR" then
                            
                            -- PROVOKE.
                            if target and helpers['actions'].canAct() and helpers['actions'].isReady('JA', "Provoke") then
                                helpers['queue'].add(bp.JA["Provoke"], target)
                            end
                        
                        -- /RUN.
                        elseif player.sub_job == "RUN" then
                            local active = helpers["runes"].getActive(bp)

                            -- FLASH.
                            if target and helpers['actions'].canCast() and helpers['actions'].isReady('MA', "Flash") then
                                helpers['queue'].addToFront(bp.MA["Flash"], target)                            
                            end
                            
                            if helpers['actions'].canAct() and (os.clock()-timers.hate) > self.getSetting('HATE DELAY') then
                            
                                -- VALLATION.
                                if target and helpers['actions'].isReady('JA', "Vallation") and active > 0 then
                                    helpers['queue'].addToFront(bp.JA["Vallation"], player)
                                    timers.hate = os.clock()
                                    
                                -- PFLUG.
                                elseif target and helpers['actions'].isReady('JA', "Pflug") and active > 0 then
                                    helpers['queue'].addToFront(bp.JA["Pflug"], player)
                                    timers.hate = os.clock()
                                    
                                end
                                
                            end
                        
                        -- /DRK.
                        elseif player.sub_job == "DRK" then
                            
                            -- STUN.
                            if target and helpers['actions'].canCast() and helpers['actions'].isReady('MA', "Stun") then
                                helpers['queue'].addToFront(bp.MA["Stun"], target)                            
                            end
                            
                            if helpers['actions'].canAct() and (os.clock()-timers.hate) > self.getSetting('HATE DELAY') then
                            
                                -- SOULEATER.
                                if target and not helpers['buffs'].buffActive(64) and helpers['actions'].isReady('JA', "Souleater") then
                                    helpers['queue'].addToFront(bp.JA["Souleater"], player)
                                    timers.hate = os.clock()
                                    
                                    if self.getSetting('TANK MODE') then
                                        windower.send_command("wait 1; cancel 63")
                                    end
                                    
                                -- LAST RESORT.
                                elseif target and not helpers['buffs'].buffActive(64) and helpers['actions'].isReady('JA', "Last Resort") then
                                    helpers['queue'].addToFront(bp.JA["Last Resort"], player)
                                    timers.hate = os.clock()
                                    
                                    if self.getSetting('TANK MODE') then
                                        windower.send_command("wait 1; cancel 64")
                                    end
                                    
                                end
                                
                            end
                        
                        -- /BLU.
                        elseif player.sub_job == "BLU" and helpers['actions'].canCast() then
                            
                            -- JETTATURA.
                            if target and helpers['actions'].isReady('MA', "Jettatura") then
                                helpers['queue'].add(bp.MA["Jettatura"], target)
                                
                            -- BLANK GAZE.
                            elseif target and helpers['actions'].isReady('MA', "Blank Gaze") then
                                helpers['queue'].add(bp.MA["Blank Gaze"], target)
                                
                            end
                            
                            if self.getSetting('AOEHATE') and (os.clock()-timers.hate) > self.getSetting('HATE DELAY') then
                                
                                -- SOPORIFIC.
                                if target and helpers['actions'].isReady('MA', "Soporific") then
                                    helpers['queue'].add(bp.MA["Soporific"], target)
                                    timers.hate = os.clock()
                                
                                -- GEIST WALL.
                                elseif target and helpers['actions'].isReady('MA', "Geist Wall") then
                                    helpers['queue'].add(bp.MA["Geist Wall"], target)
                                    timers.hate = os.clock()
                                
                                -- JETTATURA.
                                elseif target and helpers['actions'].isReady('MA', "Sheep Song") then
                                    helpers['queue'].add(bp.MA["Sheep Song"], target)
                                    timers.hate = os.clock()
                                
                                end
                                
                            end
                        
                        -- /DNC.
                        elseif player.sub_job == "DNC" then
                            
                            -- ANIMATED FLOURISH.
                            if target and helpers['actions'].canAct() and helpers['actions'].isReady('JA', "Animated Flourish") and helpers['buffs'].getFinishingMoves() > 0 then
                                helpers['queue'].add(bp.JA["Animated Flourish"], target)
                            end
                        
                        end
                        
                    end

                    -- BUFF LOGIC.
                    if bp.helpers['buffs'].enabled then
                        
                        -- PUP/.
                        if player.main_job == 'PUP' then
                            local pet = windower.ffxi.get_mob_by_target('t') or false
                           
                        end
                        
                        -- /SCH.
                        if player.sub_job == "SCH" then
                            
                            -- ARTS.
                            if helpers['actions'].canAct() and self.getSetting('ARTS') == "Light Arts" and not helpers['buffs'].buffActive(358) and not helpers['buffs'].buffActive(401) and not helpers['buffs'].buffActive(402) then

                                if self.getSetting('ARTS') == "Light Arts" and helpers['actions'].isReady('JA', self.getSetting('ARTS')) then
                                    helpers['queue'].add(bp.JA[self.getSetting('ARTS')], player)
                                end

                            elseif helpers['actions'].canAct() and self.getSetting('ARTS') == "Dark Arts" and not helpers['buffs'].buffActive(359) and not helpers['buffs'].buffActive(401) and not helpers['buffs'].buffActive(402) then

                                if self.getSetting('ARTS') == "Dark Arts" and helpers['actions'].isReady('JA', self.getSetting('ARTS')) then
                                    helpers['queue'].add(bp.JA[self.getSetting('ARTS')], player)
                                end

                            elseif helpers['actions'].canAct() and self.getSetting('ADDENDUM') == 'Addendum: White' and helpers['buffs'].buffActive(358) and not helpers['buffs'].buffActive(401) and helpers["stratagems"].gems.current > 0 then
                                
                                if helpers['actions'].isReady('JA', self.getSetting('ADDENDUM')) then
                                    helpers['queue'].add(bp.JA[self.getSetting('ADDENDUM')], player)
                                end
                                
                            elseif helpers['actions'].canAct() and self.getSetting('ADDENDUM') == 'Addendum: Black' and helpers['buffs'].buffActive(359) and not helpers['buffs'].buffActive(402) and helpers["stratagems"].gems.current > 0 then

                                if helpers['actions'].isReady('JA', self.getSetting('ADDENDUM')) then
                                    helpers['queue'].add(bp.JA[self.getSetting('ADDENDUM')], player)
                                end

                            elseif helpers['buffs'].buffActive(401) or helpers['buffs'].buffActive(402) then
                                
                                -- STORMS.
                                if helpers['actions'].canCast() and helpers['actions'].isReady('MA', self.getSetting('WEATHER')) then
                                    
                                    if self.getSetting('WEATHER') == "Firestorm" and not helpers['buffs'].buffActive(178) then
                                        helpers['queue'].add(bp.MA[self.getSetting('WEATHER')], player)
                                        
                                    elseif self.getSetting('WEATHER') == "Hailstorm" and not helpers['buffs'].buffActive(179) then
                                        helpers['queue'].add(bp.MA[self.getSetting('WEATHER')], player)
                                        
                                    elseif self.getSetting('WEATHER') == "Windstorm" and not helpers['buffs'].buffActive(180) then
                                        helpers['queue'].add(bp.MA[self.getSetting('WEATHER')], player)
                                        
                                    elseif self.getSetting('WEATHER') == "Sandstorm" and not helpers['buffs'].buffActive(181) then
                                        helpers['queue'].add(bp.MA[self.getSetting('WEATHER')], player)
                                        
                                    elseif self.getSetting('WEATHER') == "Thunderstorm" and not helpers['buffs'].buffActive(182) then
                                        helpers['queue'].add(bp.MA[self.getSetting('WEATHER')], player)
                                        
                                    elseif self.getSetting('WEATHER') == "Rainstorm" and not helpers['buffs'].buffActive(183) then
                                        helpers['queue'].add(bp.MA[self.getSetting('WEATHER')], player)
                                        
                                    elseif self.getSetting('WEATHER') == "Aurorastorm" and not helpers['buffs'].buffActive(184) then
                                        helpers['queue'].add(bp.MA[self.getSetting('WEATHER')], player)
                                        
                                    elseif self.getSetting('WEATHER') == "Voidstorm" and not helpers['buffs'].buffActive(185) then
                                        helpers['queue'].add(bp.MA[self.getSetting('WEATHER')], player)
                                        
                                    end
                                
                                -- KLIMAFORM
                                elseif helpers['actions'].canCast() and self.getSetting('ARTS') == 'Dark Arts' and helpers['actions'].isReady('MA', "Klimaform") and not helpers['buffs'].buffActive(407) and target then
                                    helpers['queue'].add(bp.MA["Klimaform"], player)

                                -- STONESKIN.
                                elseif self.getSetting('STONESKIN') and not helpers['buffs'].buffActive(37) and helpers['actions'].isReady('MA', "Stoneskin") then
                                    helpers['queue'].add(bp.MA["Stoneskin"], player)
                                    
                                end

                            end
                        
                        -- /RDM.
                        elseif player.sub_job == "RDM" and helpers['actions'].canCast() then
                            
                            -- HASTE.
                            if helpers['actions'].isReady('MA', "Haste") and not helpers['buffs'].buffActive(33) then
                                helpers['queue'].addToFront(bp.MA["Haste"], player)
                            
                            -- PHALANX.
                            elseif helpers['actions'].isReady('MA', "Phalanx") and not helpers['buffs'].buffActive(116) then
                                helpers['queue'].addToFront(bp.MA["Phalanx"], player)
                                
                            -- REFRESH.
                            elseif not self.getSetting('SUBLIMATION') and helpers['actions'].isReady('MA', "Refresh") and not helpers['buffs'].buffActive(43) then
                                helpers['queue'].addToFront(bp.MA["Refresh"], player)

                            -- ENSPELLS.
                            elseif self.getSetting('ENSPELL') ~= 'None' then
                                    
                                if self.getSetting('ENSPELL') == 'Enfire' and helpers['actions'].isReady('MA', self.getSetting('ENSPELL')) and not helpers['buffs'].buffActive(94) then
                                    helpers['queue'].addToFront(bp.MA[self.getSetting('ENSPELL')], player)

                                elseif self.getSetting('ENSPELL') == 'Enblizzard' and helpers['actions'].isReady('MA', self.getSetting('ENSPELL')) and not helpers['buffs'].buffActive(95) then
                                    helpers['queue'].addToFront(bp.MA[self.getSetting('ENSPELL')], player)

                                elseif self.getSetting('ENSPELL') == 'Enaero' and helpers['actions'].isReady('MA', self.getSetting('ENSPELL')) and not helpers['buffs'].buffActive(96) then
                                    helpers['queue'].addToFront(bp.MA[self.getSetting('ENSPELL')], player)

                                elseif self.getSetting('ENSPELL') == 'Enstone' and helpers['actions'].isReady('MA', self.getSetting('ENSPELL')) and not helpers['buffs'].buffActive(97) then
                                    helpers['queue'].addToFront(bp.MA[self.getSetting('ENSPELL')], player)

                                elseif self.getSetting('ENSPELL') == 'Enthunder' and helpers['actions'].isReady('MA', self.getSetting('ENSPELL')) and not helpers['buffs'].buffActive(98) then
                                    helpers['queue'].addToFront(bp.MA[self.getSetting('ENSPELL')], player)

                                elseif self.getSetting('ENSPELL') == 'Enwater' and helpers['actions'].isReady('MA', self.getSetting('ENSPELL')) and not helpers['buffs'].buffActive(99) then
                                    helpers['queue'].addToFront(bp.MA[self.getSetting('ENSPELL')], player)

                                end
                                
                            -- STONESKIN.
                            elseif self.getSetting('STONESKIN') and not helpers['buffs'].buffActive(37) and helpers['actions'].isReady('MA', "Stoneskin") then
                                helpers['queue'].add(bp.MA["Stoneskin"], player)
                                
                            -- SPIKES.
                            elseif helpers['actions'].isReady('MA', self.getSetting('SPIKES')) and (not helpers['buffs'].buffActive(34) or not helpers['buffs'].buffActive(35) or not helpers['buffs'].buffActive(38)) then
                                helpers['queue'].add(bp.MA[self.getSetting('SPIKES')], player)
                                
                            end                            
                                
                        -- /WAR.
                        elseif player.sub_job == "WAR" and helpers['actions'].canAct() then
                        
                            -- BERSERK.
                            if target and not self.getSetting('TANK MODE') and not helpers['buffs'].buffActive(56) and helpers['actions'].isReady('JA', "Berserk") then
                                helpers['queue'].add(bp.JA["Berserk"], player)
                            
                            -- DEFENDER.
                            elseif self.getSetting('TANK MODE') and not helpers['buffs'].buffActive(57) and helpers['actions'].isReady('JA', "Defender") then
                                helpers['queue'].add(bp.JA["Defender"], player)
                                
                            -- AGGRESSOR.
                            elseif target and not helpers['buffs'].buffActive(58) and helpers['actions'].isReady('JA', "Aggressor") then
                                helpers['queue'].add(bp.JA["Aggressor"], player)
                            
                            -- WARCRY.
                            elseif target and not helpers['buffs'].buffActive(68) and not helpers['buffs'].buffActive(460) and helpers['actions'].isReady('JA', "Warcry") then
                                helpers['queue'].add(bp.JA["Warcry"], player)
                            
                            end
                        
                        -- /SAM.
                        elseif player.sub_job == "SAM" and helpers['actions'].canAct() then
                            local weapon = bp.helpers['equipment'].main
                            
                            -- HASSO.
                            if not self.getSetting('TANK MODE') and not helpers['buffs'].buffActive(353) and helpers['actions'].isReady('JA', "Hasso") and weapon and T{4,6,7,8,10,12}:contains(weapon.skill) then
                                helpers['queue'].add(bp.JA["Hasso"], player)
                            
                            -- SEIGAN.
                            elseif self.getSetting('TANK MODE') and not helpers['buffs'].buffActive(354) and helpers['actions'].isReady('JA', "Seigan") and weapon and T{4,6,7,8,10,12}:contains(weapon.skill) then
                                helpers['queue'].add(bp.JA["Seigan"], player)
                            
                            -- MEDITATE.
                            elseif helpers['actions'].isReady('JA', "Meditate") then
                                helpers['queue'].addToFront(bp.JA["Meditate"], player)
                            
                            -- THIRD EYE.
                            elseif not helpers['buffs'].buffActive(67) and helpers['actions'].isReady('JA', "Third Eye") then
                                helpers['queue'].add(bp.JA["Third Eye"], player)
                            
                            end
                        
                        -- /DRK.
                        elseif player.sub_job == "DRK" and helpers['actions'].canAct() then
                            
                            -- LAST RESORT.
                            if target and not self.getSetting('TANK MODE') and not helpers['buffs'].buffActive(64) and helpers['actions'].isReady('JA', "Last Resort") then
                                helpers['queue'].add(bp.JA["Last Resort"], player)
                            
                            -- SOULEATER.
                            elseif target and not self.getSetting('TANK MODE') and not helpers['buffs'].buffActive(63) and helpers['actions'].isReady('JA', "Souleater") then
                                helpers['queue'].add(bp.JA["Souleater"], player)
                                
                            -- ARCANE CIRCLE.
                            elseif target and helpers['buffs'].buffActive(75) and helpers['actions'].isReady('JA', "Arcane Circle") then
                                helpers['queue'].add(bp.JA["Arcane Circle"], player)
                            
                            end

                        -- RUN/.
                        elseif player.sub_job == "RUN" then
                            local active = helpers["runes"].getActive(bp)
                            
                            -- RUNE ENCHANMENTS.
                            if helpers['actions'].canAct() and active >= 0 and active < 3 then
                                helpers['runes'].handleRunes(bp)
                            end
                            
                        -- /BLU.
                        elseif player.sub_job == "BLU" then
                        
                        -- /DRG.
                        elseif player.sub_job == "DRG" then
                            
                            -- ANCIENT CIRCLE.
                            if target and not helpers['buffs'].buffActive(118) and helpers['actions'].isReady('JA', "Ancient Circle") then
                                helpers['queue'].add(bp.JA["Ancient Circle"], player)                            
                            end
                            
                        -- /RNG.
                        elseif player.sub_job == "RNG" and helpers['actions'].canAct() then
                            
                            -- SHARPSHOT.
                            if target and not helpers['buffs'].buffActive(72) and helpers['actions'].isReady('JA', "Sharpshot") then
                                helpers['queue'].addToFront(JA["Sharpshot"], player)
                            
                            -- BARRAGE.
                            elseif target and not helpers['buffs'].buffActive(371) and helpers['actions'].isReady('JA', "Velocity Shot") then
                                helpers['queue'].addToFront(JA["Velocity Shot"], player)
                            
                            -- VELOCITY SHOT.
                            elseif not helpers['buffs'].buffActive(73) and helpers['actions'].isReady('JA', "Barrage") then
                                helpers['queue'].add(bp.JA["Barrage"], player)
                            
                            end
                        
                        -- /COR.
                        elseif player.sub_job == "COR" and helpers['actions'].canAct() and helpers['rolls'].enabled then
                            bp.helpers['rolls'].roll()
                        
                        -- /DNC.
                        elseif player.sub_job == "DNC" and helpers['actions'].canAct() then
                        
                            -- SAMBAS.
                            if target and (not helpers['buffs'].buffActive(368) and not helpers['buffs'].buffActive(370)) and helpers['actions'].isReady('JA', self.getSetting('SAMBAS')) then
                                helpers['queue'].add(bp.JA[self.getSetting('SAMBAS')], player)                            
                            end
                        
                        -- /NIN.
                        elseif player.sub_job == "NIN" then
                        if self.getSetting('SHADOWS') and helpers['actions'].canCast() and not helpers['buffs'].buffActive(444) and not helpers['buffs'].buffActive(445) and not helpers['buffs'].buffActive(446) and not helpers['buffs'].buffActive(36) then
                                
                                -- UTSUSEMI
                                if helpers['inventory'].findItemByName("Shihei", 0) and (os.clock()-self['UTSU BLOCK'].last) > self['UTSU BLOCK'].delay then
                                    

                                    if not helpers['queue'].typeInQueue(bp.MA["Utsusemi: Ichi"]) then
                                        
                                        if helpers['actions'].isReady('MA', "Utsusemi: San") then
                                            helpers['queue'].addToFront(bp.MA["Utsusemi: San"], player)

                                        elseif helpers['actions'].isReady('MA', "Utsusemi: Ni") then
                                            helpers['queue'].addToFront(bp.MA["Utsusemi: Ni"], player)
                                                
                                        elseif helpers['actions'].isReady('MA', "Utsusemi: Ichi") and not helpers['actions'].isReady('MA', "Utsusemi: San") and not helpers['actions'].isReady('MA', "Utsusemi: Ni") then
                                            helpers['queue'].addToFront(bp.MA["Utsusemi: Ichi"], player)
                                                
                                        end
                                    
                                    end

                                elseif space and helpers['actions'].canItem() and helpers['inventory'].findItemByName("Toolbag (Shihe)") and not helpers['inventory'].findItemByName("Shihe") then
                                    helpers['queue'].addToFront(bp.IT["Toolbag (Shihe)"], player)

                                end

                            end
                        
                        end
                        
                    end

                    -- DEBUFF LOGIC.
                    if self.getSetting('DEBUFF') and target then
                        
                        -- /DNC.
                        if (player.main_job == 'DNC' or player.sub_job == 'DNC') and helpers['actions'].canAct() then
                        
                            -- STEPS.
                            if helpers['actions'].isReady('JA', self.getSetting('STEPS')) and os.clock()-timers.steps > self.getSetting('STEPS DELAY') then
                                helpers['queue'].add(bp.JA[self.getSetting('STEPS')], target)
                                timers.steps = os.clock()

                            end

                        elseif player.main_job == 'COR' and helpers['actions'].canAct() then
                            
                            -- QUICK DRAW.
                            if helpers['actions'].isReady('JA', self.getSetting('COR SHOTS')) then
                                helpers['queue'].add(bp.JA[self.getSetting('COR SHOTS')], target)
                            end

                        end
                        
                    end
                
                    -- DRAINS LOGIC
                    if self.getSetting('DRAINS') and helpers['actions'].canCast() and target then
                        
                        if helpers['actions'].isReady('MA', "Drain III") and player['vitals'].mpp < self.getSetting('DRAIN THRESHOLD') then
                            helpers['queue'].add(bp.MA["Drain III"], target)
                            
                        elseif helpers['actions'].isReady('MA', "Drain II") and player['vitals'].mpp < self.getSetting('DRAIN THRESHOLD') then
                            helpers['queue'].add(bp.MA["Drain II"], target)
                            
                        elseif helpers['actions'].isReady('MA', "Drain") and player['vitals'].mpp < self.getSetting('DRAIN THRESHOLD') then
                            helpers['queue'].add(bp.MA["Drain"], target)
                            
                        end
                        
                        if helpers['actions'].isReady('MA', "Aspir III") and player['vitals'].mpp < self.getSetting('ASPIR THRESHOLD') then
                            helpers['queue'].add(bp.MA["Aspir III"], target)
                        
                        elseif helpers['actions'].isReady('MA', "Aspir II") and player['vitals'].mpp < self.getSetting('ASPIR THRESHOLD') then
                            helpers['queue'].add(bp.MA["Aspir II"], target)
                            
                        elseif helpers['actions'].isReady('MA', "Aspir") and player['vitals'].mpp < self.getSetting('ASPIR THRESHOLD') then
                            helpers['queue'].add(bp.MA["Aspir"], target)
                        
                        end
                        
                    end

                    -- HANDLE RANGED ATTACKS.
                    if self.getSetting('RA') and #helpers['queue'].queue.data == 0 and helpers['equipment'].ammo and helpers['equipment'].ammo.en ~= 'Gil' then
                        helpers['queue'].add(helpers['actions'].unique.ranged, target)
                    end

                -- PLAYER IS DISENGAGED LOGIC.
                elseif player.status == 0 then
                    local target = helpers['target'].getTarget() or false
                    
                    -- SKILLUP LOGIC.
                    if self.getSetting('SKILLUP') then
                        
                        if helpers['inventory'].findItemByName("B.E.W. Pitaru") and not helpers['queue'].inQueue(bp.IT["B.E.W. Pitaru"]) and not helpers['buffs'].buffActive(251) then
                            helpers['queue'].add(bp.IT["B.E.W. Pitaru"], 'me')
                            
                        else
                            local skills = bp.skillup[self.getSetting('SKILLS')]
                                                        
                            if skills and skills.list then

                                for _,v in pairs(skills.list) do
                                    
                                    if helpers['actions'].isReady('MA', v) and not helpers['queue'].inQueue(bp.MA[v]) then

                                        if bp.skillup[self.getSetting('SKILLS')].target == 't' and target then
                                            helpers['queue'].add(bp.MA[v], target)

                                        elseif bp.skillup[self.getSetting('SKILLS')].target == 'me' then
                                            helpers['queue'].add(bp.MA[v], player)

                                        end

                                    end
                                
                                end

                            end
                        
                        end
                        
                    end
                    
                    -- WEAPON SKILL LOGIC.
                    if self.getSetting('WS') and helpers['actions'].canAct() and target and (target.distance):sqrt() < 6 then
                        local current = {tp=player['vitals'].tp, hpp=player['vitals'].hpp, mpp=player['vitals'].mpp, main=helpers['equipment'].main.en, ranged=helpers['equipment'].ranged.en}

                        if self.getSetting('AM') then
                            local weaponskill = helpers["aftermath"].getWeaponskill(current.main)
                            local aftermath   = helpers["aftermath"].getBuffByLevel(self.getSetting('AM LEVEL'))
                            
                            if self.getSetting('SANGUINE') and current.hpp <= self.getSetting('SANGUINE HPP') and helpers['actions'].isReady('WS', "Sanguine Blade") then
                                helpers['queue'].addToFront(bp.WS["Sanguine Blade"], target)

                            elseif not helpers['buffs'].buffActive(aftermath) and current.tp >= (self.getSetting('AM LEVEL')*1000) and weaponskill and helpers['actions'].isReady('WS', weaponskill) then
                                helpers['queue'].addToFront(bp.WS[weaponskill], target)

                            elseif helpers['buffs'].buffActive(aftermath) and current.mpp <= self.getSetting('MOONLIGHT MPP') and helpers['actions'].isReady('WS', "Moonlight") then
                                helpers['queue'].addToFront(bp.WS["Moonlight"], 'me')

                            elseif helpers['buffs'].buffActive(aftermath) and current.mpp <= self.getSetting('MYRKR MPP') and helpers['actions'].isReady('WS', "Myrkr") then
                                helpers['queue'].addToFront(bp.WS["Myrkr"], 'me')
                                
                            elseif (helpers['buffs'].buffActive(aftermath) or not weaponskill) and current.tp >= self.getSetting('TP THRESHOLD') and helpers['actions'].isReady('WS', self.getSetting('WSNAME')) then
                                helpers['queue'].addToFront(bp.WS[self.getSetting('WSNAME')], target)
                                
                            end
                            
                        elseif not self.getSetting('AM') and target then
                            
                            if current.mpp <= self.getSetting('MOONLIGHT MPP') and helpers['actions'].isReady('WS', "Moonlight") then
                                helpers['queue'].addToFront(bp.WS["Moonlight"], 'me')

                            elseif current.mpp <= self.getSetting('MYRKR MPP') and helpers['actions'].isReady('WS', "Myrkr") then
                                helpers['queue'].addToFront(bp.WS["Myrkr"], 'me')

                            elseif current.tp >= self.getSetting('TP THRESHOLD') and helpers['actions'].isReady('WS', self.getSetting('WSNAME')) then
                                helpers['queue'].addToFront(bp.WS[self.getSetting('WSNAME')], target)

                            end
                        
                        end

                    elseif self.getSetting('RA') and self.getSetting('WS') and helpers['actions'].canAct() and target and (target.distance):sqrt() > 6 and (target.distance):sqrt() < 21 then
                        local current = {tp=player['vitals'].tp, hpp=player['vitals'].hpp, mpp=player['vitals'].mpp, main=helpers['equipment'].main.en, ranged=helpers['equipment'].ranged.en}

                        if self.getSetting('AM') and weaponskill and aftermath then
                            local weaponskill = helpers["aftermath"].getWeaponskill(current.ranged)
                            local aftermath   = helpers["aftermath"].getBuffByLevel(self.getSetting('AM LEVEL'))

                            if not helpers['buffs'].buffActive(aftermath) and current.tp >= (self.getSetting('AM LEVEL')*1000) and weaponskill and helpers['actions'].isReady('WS', weaponskill) then
                                helpers['queue'].addToFront(bp.WS[weaponskill], target)

                            elseif helpers['buffs'].buffActive(aftermath) and current.mpp <= self.getSetting('MOONLIGHT MPP') and helpers['actions'].isReady('WS', "Moonlight") then
                                helpers['queue'].addToFront(bp.WS["Moonlight"], 'me')
    
                            elseif helpers['buffs'].buffActive(aftermath) and current.mpp <= self.getSetting('MYRKR MPP') and helpers['actions'].isReady('WS', "Myrkr") then
                                helpers['queue'].addToFront(bp.WS["Myrkr"], 'me')
                                
                            elseif (helpers['buffs'].buffActive(aftermath) or not weaponskill) and current.tp >= self.getSetting('TP THRESHOLD') and helpers['actions'].isReady('WS', self.getSetting('RANGED WS')) then
                                helpers['queue'].addToFront(bp.WS[self.getSetting('RANGED WS')], target)
                                
                            end
                        
                        elseif not self.getSetting('AM') then
                            
                            if current.mpp <= self.getSetting('MOONLIGHT MPP') and helpers['actions'].isReady('WS', "Moonlight") then
                                helpers['queue'].addToFront(bp.WS["Moonlight"], 'me')

                            elseif current.mpp <= self.getSetting('MYRKR MPP') and helpers['actions'].isReady('WS', "Myrkr") then
                                helpers['queue'].addToFront(bp.WS["Myrkr"], 'me')

                            elseif current.tp >= self.getSetting('TP THRESHOLD') and helpers['actions'].isReady('WS', self.getSetting('RANGED WS')) then
                                helpers['queue'].addToFront(bp.WS[self.getSetting('RANGED WS')], target)

                            end
                        
                        end
                        
                    end

                    -- ABILITY LOGIC.
                    if self.getSetting('JA') and helpers['actions'].canAct() then
                        
                        -- PUP/.
                        if player.main_job == 'PUP' then
                            local pet = windower.ffxi.get_mob_by_target('pet') or false
                            
                            if self.getSetting('SUMMON') and not pet then
                                    
                                if helpers['actions'].isReady('JA', 'Activate') and helpers['actions'].canAct() then
                                    helpers['queue'].add(bp.JA['Activate'], player)
                                end

                            elseif pet and self.getSetting('SIC') and target then
                                
                                if pet.status == 0 then

                                    if helpers['actions'].isReady('JA', 'Deploy') and helpers['actions'].canAct() then
                                        helpers['queue'].add(bp.JA['Deploy'], target)
                                    end

                                elseif pet.status == 1 then

                                end

                            end
                           
                        end

                        -- /RDM.
                        if player.sub_job == "RDM" then
                            
                            -- CONVERT LOGIC.
                            if self.getSetting('CONVERT') and player['vitals'].hpp >= self.getSetting('CONVERT HPP') and player['vitals'].mpp <= self.getSetting('CONVERT MPP') then
                                
                                if helpers['actions'].isReady('JA', "Convert") then
                                    helpers['queue'].add(bp.JA["Convert"], player)
                                    helpers['queue'].add(bp.MA["Cure IV"], player)
                                    
                                end
                                
                            end
                        
                        elseif player.sub_job == "SCH" then
                            
                            -- SUBLIMATION LOGIC.
                            if self.getSetting('SUBLIMATION') then
                            
                                if not helpers['buffs'].buffActive(187) and not helpers['buffs'].buffActive(188) and helpers['actions'].isReady('JA', "Sublimation") then
                                    helpers['queue'].add(bp.JA["Sublimation"], player)
                                
                                elseif not helpers['buffs'].buffActive(187) and helpers['buffs'].buffActive(188) and helpers['actions'].isReady('JA', "Sublimation") then
                                    helpers['queue'].add(bp.JA["Sublimation"], player)

                                end
                                
                            end
                        
                        -- /DRG.
                        elseif player.sub_job == "DRG" then
                            
                            -- JUMP.
                            if target and helpers['actions'].isReady('JA', "Jump") then
                                helpers['queue'].add(bp.JA["Jump"], target)
                                
                            -- HIGH JUMP.
                            elseif target and helpers['actions'].isReady('JA', "High Jump") then
                                helpers['queue'].add(bp.JA["High Jump"], target)
                                
                            end
                            
                        -- /DNC.
                        elseif player.sub_job == "DNC" then
                            
                            -- REVERSE FLOURISH.
                            if target and helpers['actions'].isReady('JA', "Reverse Flourish") and helpers['buffs'].getFinishingMoves() > 4 then
                                helpers['queue'].add(bp.JA["Reverse Flourish"], player)                            
                            end
                        
                        end
                        
                    end

                    -- HATE LOGIC.
                    if self.getSetting('HATE') and target then
                        
                        -- PUP/.
                        if player.main_job == 'PUP' then
                            local pet = windower.ffxi.get_mob_by_target('pet') or false
                           
                        end
                        
                        -- /RDM.
                        if player.sub_job == "RDM" then
                        
                        -- /WAR.
                        elseif player.sub_job == "WAR" then
                            
                            -- PROVOKE.
                            if target and helpers['actions'].canAct() and helpers['actions'].isReady('JA', "Provoke") then
                                helpers['queue'].add(bp.JA["Provoke"], target)
                            end
                        
                        -- /RUN.
                        elseif player.sub_job == "RUN" then
                            local active = helpers["runes"].getActive(bp)
                            
                            -- FLASH.
                            if target and helpers['actions'].canCast() and helpers['actions'].isReady('MA', "Flash") then
                                helpers['queue'].addToFront(bp.MA["Flash"], target)                            
                            end
                            
                            if helpers['actions'].canAct() and (os.clock()-timers.hate) > self.getSetting('HATE DELAY') then
                            
                                -- VALLATION.
                                if target and helpers['actions'].isReady('JA', "Vallation") and active > 0 then
                                    helpers['queue'].addToFront(bp.JA["Vallation"], player)
                                    timers.hate = os.clock()
                                    
                                -- PFLUG.
                                elseif target and helpers['actions'].isReady('JA', "Pflug") and active > 0 then
                                    helpers['queue'].addToFront(bp.JA["Pflug"], player)
                                    timers.hate = os.clock()
                                    
                                end
                                
                            end
                        
                        -- /DRK.
                        elseif player.sub_job == "DRK" then
                            
                            -- STUN.
                            if target and helpers['actions'].canCast() and helpers['actions'].isReady('MA', "Stun") then
                                helpers['queue'].addToFront(bp.MA["Stun"], target)                            
                            end
                            
                            if helpers['actions'].canAct() and (os.clock()-timers.hate) > self.getSetting('HATE DELAY') then
                            
                                -- SOULEATER.
                                if target and not helpers['buffs'].buffActive(64) and helpers['actions'].isReady('JA', "Souleater") then
                                    helpers['queue'].addToFront(bp.JA["Souleater"], player)
                                    timers.hate = os.clock()
                                    
                                    if self.getSetting('TANK MODE') then
                                        windower.send_command("wait 1; cancel 63")
                                    end
                                    
                                -- LAST RESORT.
                                elseif target and not helpers['buffs'].buffActive(64) and helpers['actions'].isReady('JA', "Last Resort") then
                                    helpers['queue'].addToFront(bp.JA["Last Resort"], player)
                                    timers.hate = os.clock()
                                    
                                    if self.getSetting('TANK MODE') then
                                        windower.send_command("wait 1; cancel 64")
                                    end
                                    
                                end
                                
                            end
                        
                        -- /BLU.
                        elseif player.sub_job == "BLU" and helpers['actions'].canCast() then
                            
                            -- JETTATURA.
                            if target and helpers['actions'].isReady('MA', "Jettatura") then
                                helpers['queue'].add(bp.MA["Jettatura"], target)
                                
                            -- BLANK GAZE.
                            elseif target and helpers['actions'].isReady('MA', "Blank Gaze") then
                                helpers['queue'].add(bp.MA["Blank Gaze"], target)
                                
                            end
                            
                            if self.getSetting('AOEHATE') and (os.clock()-timers.hate) > self.getSetting('HATE DELAY') then
                                
                                -- SOPORIFIC.
                                if target and helpers['actions'].isReady('MA', "Soporific") then
                                    helpers['queue'].add(bp.MA["Soporific"], target)
                                    timers.hate = os.clock()
                                
                                -- GEIST WALL.
                                elseif target and helpers['actions'].isReady('MA', "Geist Wall") then
                                    helpers['queue'].add(bp.MA["Geist Wall"], target)
                                    timers.hate = os.clock()
                                
                                -- JETTATURA.
                                elseif target and helpers['actions'].isReady('MA', "Sheep Song") then
                                    helpers['queue'].add(bp.MA["Sheep Song"], target)
                                    timers.hate = os.clock()
                                
                                end
                                
                            end
                        
                        -- /DNC.
                        elseif player.sub_job == "DNC" then
                            
                            -- ANIMATED FLOURISH.
                            if target and helpers['actions'].canAct() and helpers['actions'].isReady('JA', "Animated Flourish") and helpers['buffs'].getFinishingMoves() > 0 then
                                helpers['queue'].add(bp.JA["Animated Flourish"], target)
                            end
                        
                        end
                        
                    end

                    -- BUFF LOGIC.
                    if bp.helpers['buffs'].enabled then
                        
                        -- PUP/.
                        if player.main_job == 'PUP' then
                            local pet = windower.ffxi.get_mob_by_target('pet') or false

                            if pet then
                                local maneuvers = 0

                                for i,v in ipairs(bp.player.buffs) do
                                    
                                    if v >= 300 and v <= 307 then
                                        maneuvers = (maneuvers + 1)
                                    end
                                    
                                end

                                if maneuvers < 1 then
                                    helpers['queue'].add(bp.JA["Light Maneuver"], player)
                                end

                            end
                           
                        end
                        
                        -- /SCH.
                        if player.sub_job == "SCH" then
                            
                            -- ARTS.
                            if helpers['actions'].canAct() and self.getSetting('ARTS') == "Light Arts" and not helpers['buffs'].buffActive(358) and not helpers['buffs'].buffActive(401) and not helpers['buffs'].buffActive(402) then

                                if self.getSetting('ARTS') == "Light Arts" and helpers['actions'].isReady('JA', self.getSetting('ARTS')) then
                                    helpers['queue'].add(bp.JA[self.getSetting('ARTS')], player)
                                end

                            elseif helpers['actions'].canAct() and self.getSetting('ARTS') == "Dark Arts" and not helpers['buffs'].buffActive(359) and not helpers['buffs'].buffActive(401) and not helpers['buffs'].buffActive(402) then

                                if self.getSetting('ARTS') == "Dark Arts" and helpers['actions'].isReady('JA', self.getSetting('ARTS')) then
                                    helpers['queue'].add(bp.JA[self.getSetting('ARTS')], player)
                                end

                            elseif helpers['actions'].canAct() and self.getSetting('ADDENDUM') == 'Addendum: White' and helpers['buffs'].buffActive(358) and not helpers['buffs'].buffActive(401) and helpers["stratagems"].gems.current > 0 then
                                
                                if helpers['actions'].isReady('JA', self.getSetting('ADDENDUM')) then
                                    helpers['queue'].add(bp.JA[self.getSetting('ADDENDUM')], player)
                                end
                                
                            elseif helpers['actions'].canAct() and self.getSetting('ADDENDUM') == 'Addendum: Black' and helpers['buffs'].buffActive(359) and not helpers['buffs'].buffActive(402) and helpers["stratagems"].gems.current > 0 then

                                if helpers['actions'].isReady('JA', self.getSetting('ADDENDUM')) then
                                    helpers['queue'].add(bp.JA[self.getSetting('ADDENDUM')], player)
                                end

                            elseif helpers['buffs'].buffActive(401) or helpers['buffs'].buffActive(402) then
                                
                                -- STORMS.
                                if helpers['actions'].canCast() and helpers['actions'].isReady('MA', self.getSetting('WEATHER')) then
                                    
                                    if self.getSetting('WEATHER') == "Firestorm" and not helpers['buffs'].buffActive(178) then
                                        helpers['queue'].add(bp.MA[self.getSetting('WEATHER')], player)
                                        
                                    elseif self.getSetting('WEATHER') == "Hailstorm" and not helpers['buffs'].buffActive(179) then
                                        helpers['queue'].add(bp.MA[self.getSetting('WEATHER')], player)
                                        
                                    elseif self.getSetting('WEATHER') == "Windstorm" and not helpers['buffs'].buffActive(180) then
                                        helpers['queue'].add(bp.MA[self.getSetting('WEATHER')], player)
                                        
                                    elseif self.getSetting('WEATHER') == "Sandstorm" and not helpers['buffs'].buffActive(181) then
                                        helpers['queue'].add(bp.MA[self.getSetting('WEATHER')], player)
                                        
                                    elseif self.getSetting('WEATHER') == "Thunderstorm" and not helpers['buffs'].buffActive(182) then
                                        helpers['queue'].add(bp.MA[self.getSetting('WEATHER')], player)
                                        
                                    elseif self.getSetting('WEATHER') == "Rainstorm" and not helpers['buffs'].buffActive(183) then
                                        helpers['queue'].add(bp.MA[self.getSetting('WEATHER')], player)
                                        
                                    elseif self.getSetting('WEATHER') == "Aurorastorm" and not helpers['buffs'].buffActive(184) then
                                        helpers['queue'].add(bp.MA[self.getSetting('WEATHER')], player)
                                        
                                    elseif self.getSetting('WEATHER') == "Voidstorm" and not helpers['buffs'].buffActive(185) then
                                        helpers['queue'].add(bp.MA[self.getSetting('WEATHER')], player)
                                        
                                    end
                                
                                -- KLIMAFORM
                                elseif helpers['actions'].canCast() and self.getSetting('ARTS') == 'Dark Arts' and helpers['actions'].isReady('MA', "Klimaform") and not helpers['buffs'].buffActive(407) and target then
                                    helpers['queue'].add(bp.MA["Klimaform"], player)

                                -- STONESKIN.
                                elseif self.getSetting('STONESKIN') and not helpers['buffs'].buffActive(37) and helpers['actions'].isReady('MA', "Stoneskin") then
                                    helpers['queue'].add(bp.MA["Stoneskin"], player)
                                    
                                end

                            end
                        
                        -- /RDM.
                        elseif player.sub_job == "RDM" and helpers['actions'].canCast() then
                            
                            -- HASTE.
                            if helpers['actions'].isReady('MA', "Haste") and not helpers['buffs'].buffActive(33) then
                                helpers['queue'].addToFront(bp.MA["Haste"], player)
                            
                            -- PHALANX.
                            elseif helpers['actions'].isReady('MA', "Phalanx") and not helpers['buffs'].buffActive(116) then
                                helpers['queue'].addToFront(bp.MA["Phalanx"], player)
                                
                            -- REFRESH.
                            elseif not self.getSetting('SUBLIMATION') and helpers['actions'].isReady('MA', "Refresh") and not helpers['buffs'].buffActive(43) then
                                helpers['queue'].addToFront(bp.MA["Refresh"], player)

                            -- ENSPELLS.
                            elseif self.getSetting('ENSPELL') ~= 'None' then
                                    
                                if self.getSetting('ENSPELL') == 'Enfire' and helpers['actions'].isReady('MA', self.getSetting('ENSPELL')) and not helpers['buffs'].buffActive(94) then
                                    helpers['queue'].addToFront(bp.MA[self.getSetting('ENSPELL')], player)

                                elseif self.getSetting('ENSPELL') == 'Enblizzard' and helpers['actions'].isReady('MA', self.getSetting('ENSPELL')) and not helpers['buffs'].buffActive(95) then
                                    helpers['queue'].addToFront(bp.MA[self.getSetting('ENSPELL')], player)

                                elseif self.getSetting('ENSPELL') == 'Enaero' and helpers['actions'].isReady('MA', self.getSetting('ENSPELL')) and not helpers['buffs'].buffActive(96) then
                                    helpers['queue'].addToFront(bp.MA[self.getSetting('ENSPELL')], player)

                                elseif self.getSetting('ENSPELL') == 'Enstone' and helpers['actions'].isReady('MA', self.getSetting('ENSPELL')) and not helpers['buffs'].buffActive(97) then
                                    helpers['queue'].addToFront(bp.MA[self.getSetting('ENSPELL')], player)

                                elseif self.getSetting('ENSPELL') == 'Enthunder' and helpers['actions'].isReady('MA', self.getSetting('ENSPELL')) and not helpers['buffs'].buffActive(98) then
                                    helpers['queue'].addToFront(bp.MA[self.getSetting('ENSPELL')], player)

                                elseif self.getSetting('ENSPELL') == 'Enwater' and helpers['actions'].isReady('MA', self.getSetting('ENSPELL')) and not helpers['buffs'].buffActive(99) then
                                    helpers['queue'].addToFront(bp.MA[self.getSetting('ENSPELL')], player)

                                end
                                
                            -- STONESKIN.
                            elseif self.getSetting('STONESKIN') and not helpers['buffs'].buffActive(37) and helpers['actions'].isReady('MA', "Stoneskin") then
                                helpers['queue'].add(bp.MA["Stoneskin"], player)
                                
                            -- SPIKES.
                            elseif helpers['actions'].isReady('MA', self.getSetting('SPIKES')) and (not helpers['buffs'].buffActive(34) or not helpers['buffs'].buffActive(35) or not helpers['buffs'].buffActive(38)) then
                                helpers['queue'].add(bp.MA[self.getSetting('SPIKES')], player)
                                
                            end                            
                                
                        -- /WAR.
                        elseif player.sub_job == "WAR" and helpers['actions'].canAct() then
                        
                            -- BERSERK.
                            if target and not self.getSetting('TANK MODE') and not helpers['buffs'].buffActive(56) and helpers['actions'].isReady('JA', "Berserk") then
                                helpers['queue'].add(bp.JA["Berserk"], player)
                            
                            -- DEFENDER.
                            elseif self.getSetting('TANK MODE') and not helpers['buffs'].buffActive(57) and helpers['actions'].isReady('JA', "Defender") then
                                helpers['queue'].add(bp.JA["Defender"], player)
                                
                            -- AGGRESSOR.
                            elseif target and not helpers['buffs'].buffActive(58) and helpers['actions'].isReady('JA', "Aggressor") then
                                helpers['queue'].add(bp.JA["Aggressor"], player)
                            
                            -- WARCRY.
                            elseif target and not helpers['buffs'].buffActive(68) and not helpers['buffs'].buffActive(460) and helpers['actions'].isReady('JA', "Warcry") then
                                helpers['queue'].add(bp.JA["Warcry"], player)
                            
                            end
                        
                        -- /SAM.
                        elseif player.sub_job == "SAM" and helpers['actions'].canAct() then
                            local weapon = bp.helpers['equipment'].main
                            
                            -- HASSO.
                            if not self.getSetting('TANK MODE') and not helpers['buffs'].buffActive(353) and helpers['actions'].isReady('JA', "Hasso") and weapon and T{4,6,7,8,10,12}:contains(weapon.skill) then
                                helpers['queue'].add(bp.JA["Hasso"], player)
                            
                            -- SEIGAN.
                            elseif self.getSetting('TANK MODE') and not helpers['buffs'].buffActive(354) and helpers['actions'].isReady('JA', "Seigan") and weapon and T{4,6,7,8,10,12}:contains(weapon.skill) then
                                helpers['queue'].add(bp.JA["Seigan"], player)
                            
                            -- MEDITATE.
                            elseif helpers['actions'].isReady('JA', "Meditate") then
                                helpers['queue'].addToFront(bp.JA["Meditate"], player)
                            
                            -- THIRD EYE.
                            elseif not helpers['buffs'].buffActive(67) and helpers['actions'].isReady('JA', "Third Eye") then
                                helpers['queue'].add(bp.JA["Third Eye"], player)
                            
                            end
                        
                        -- /DRK.
                        elseif player.sub_job == "DRK" and helpers['actions'].canAct() then
                            
                            -- LAST RESORT.
                            if target and not self.getSetting('TANK MODE') and not helpers['buffs'].buffActive(64) and helpers['actions'].isReady('JA', "Last Resort") then
                                helpers['queue'].add(bp.JA["Last Resort"], player)
                            
                            -- SOULEATER.
                            elseif target and not self.getSetting('TANK MODE') and not helpers['buffs'].buffActive(63) and helpers['actions'].isReady('JA', "Souleater") then
                                helpers['queue'].add(bp.JA["Souleater"], player)
                                
                            -- ARCANE CIRCLE.
                            elseif target and helpers['buffs'].buffActive(75) and helpers['actions'].isReady('JA', "Arcane Circle") then
                                helpers['queue'].add(bp.JA["Arcane Circle"], player)
                            
                            end

                        -- RUN/.
                        elseif player.sub_job == "RUN" then
                            local active = helpers["runes"].getActive(bp)
                            
                            -- RUNE ENCHANMENTS.
                            if helpers['actions'].canAct() and active >= 0 and active < 3 then
                                helpers['runes'].handleRunes(bp)
                            end
                            
                        -- /BLU.
                        elseif player.sub_job == "BLU" then
                        
                        -- /DRG.
                        elseif player.sub_job == "DRG" then
                            
                            -- ANCIENT CIRCLE.
                            if target and not helpers['buffs'].buffActive(118) and helpers['actions'].isReady('JA', "Ancient Circle") then
                                helpers['queue'].add(bp.JA["Ancient Circle"], player)                            
                            end
                            
                        -- /RNG.
                        elseif player.sub_job == "RNG" and helpers['actions'].canAct() then
                            
                            -- SHARPSHOT.
                            if target and not helpers['buffs'].buffActive(72) and helpers['actions'].isReady('JA', "Sharpshot") then
                                helpers['queue'].addToFront(JA["Sharpshot"], player)
                            
                            -- BARRAGE.
                            elseif target and not helpers['buffs'].buffActive(371) and helpers['actions'].isReady('JA', "Velocity Shot") then
                                helpers['queue'].addToFront(JA["Velocity Shot"], player)
                            
                            -- VELOCITY SHOT.
                            elseif not helpers['buffs'].buffActive(73) and helpers['actions'].isReady('JA', "Barrage") then
                                helpers['queue'].add(bp.JA["Barrage"], player)
                            
                            end
                        
                        -- /COR.
                        elseif player.sub_job == "COR" and helpers['actions'].canAct() and helpers['rolls'].enabled then
                            bp.helpers['rolls'].roll()
                        
                        -- /DNC.
                        elseif player.sub_job == "DNC" and helpers['actions'].canAct() then
                        
                            -- SAMBAS.
                            if target and (not helpers['buffs'].buffActive(368) and not helpers['buffs'].buffActive(370)) and helpers['actions'].isReady('JA', self.getSetting('SAMBAS')) then
                                helpers['queue'].add(bp.JA[self.getSetting('SAMBAS')], player)                            
                            end
                        
                        -- /NIN.
                        elseif player.sub_job == "NIN" then
                        if self.getSetting('SHADOWS') and helpers['actions'].canCast() and not helpers['buffs'].buffActive(444) and not helpers['buffs'].buffActive(445) and not helpers['buffs'].buffActive(446) and not helpers['buffs'].buffActive(36) then
                                
                                -- UTSUSEMI
                                if helpers['inventory'].findItemByName("Shihei", 0) and (os.clock()-self['UTSU BLOCK'].last) > self['UTSU BLOCK'].delay then
                                    

                                    if not helpers['queue'].typeInQueue(bp.MA["Utsusemi: Ichi"]) then
                                        
                                        if helpers['actions'].isReady('MA', "Utsusemi: San") then
                                            helpers['queue'].addToFront(bp.MA["Utsusemi: San"], player)

                                        elseif helpers['actions'].isReady('MA', "Utsusemi: Ni") then
                                            helpers['queue'].addToFront(bp.MA["Utsusemi: Ni"], player)
                                                
                                        elseif helpers['actions'].isReady('MA', "Utsusemi: Ichi") and not helpers['actions'].isReady('MA', "Utsusemi: San") and not helpers['actions'].isReady('MA', "Utsusemi: Ni") then
                                            helpers['queue'].addToFront(bp.MA["Utsusemi: Ichi"], player)
                                                
                                        end
                                    
                                    end

                                elseif space and helpers['actions'].canItem() and helpers['inventory'].findItemByName("Toolbag (Shihe)") and not helpers['inventory'].findItemByName("Shihe") then
                                    helpers['queue'].addToFront(bp.IT["Toolbag (Shihe)"], player)

                                end

                            end
                        
                        end
                        
                    end

                    -- DEBUFF LOGIC.
                    if self.getSetting('DEBUFF') and target then
                        
                        -- /DNC.
                        if (player.main_job == 'DNC' or player.sub_job == 'DNC') and helpers['actions'].canAct() then
                        
                            -- STEPS.
                            if helpers['actions'].isReady('JA', self.getSetting('STEPS')) and os.clock()-timers.steps > self.getSetting('STEPS DELAY') then
                                helpers['queue'].add(bp.JA[self.getSetting('STEPS')], target)
                                timers.steps = os.clock()

                            end

                        elseif player.main_job == 'COR' and helpers['actions'].canAct() then
                            
                            -- QUICK DRAW.
                            if helpers['actions'].isReady('JA', self.getSetting('COR SHOTS')) then
                                helpers['queue'].add(bp.JA[self.getSetting('COR SHOTS')], target)
                            end

                        end
                        
                    end
                
                    -- DRAINS LOGIC
                    if self.getSetting('DRAINS') and helpers['actions'].canCast() and target then
                        
                        if helpers['actions'].isReady('MA', "Drain III") and player['vitals'].mpp < self.getSetting('DRAIN THRESHOLD') then
                            helpers['queue'].add(bp.MA["Drain III"], target)
                            
                        elseif helpers['actions'].isReady('MA', "Drain II") and player['vitals'].mpp < self.getSetting('DRAIN THRESHOLD') then
                            helpers['queue'].add(bp.MA["Drain II"], target)
                            
                        elseif helpers['actions'].isReady('MA', "Drain") and player['vitals'].mpp < self.getSetting('DRAIN THRESHOLD') then
                            helpers['queue'].add(bp.MA["Drain"], target)
                            
                        end
                        
                        if helpers['actions'].isReady('MA', "Aspir III") and player['vitals'].mpp < self.getSetting('ASPIR THRESHOLD') then
                            helpers['queue'].add(bp.MA["Aspir III"], target)
                        
                        elseif helpers['actions'].isReady('MA', "Aspir II") and player['vitals'].mpp < self.getSetting('ASPIR THRESHOLD') then
                            helpers['queue'].add(bp.MA["Aspir II"], target)
                            
                        elseif helpers['actions'].isReady('MA', "Aspir") and player['vitals'].mpp < self.getSetting('ASPIR THRESHOLD') then
                            helpers['queue'].add(bp.MA["Aspir"], target)
                        
                        end
                        
                    end

                    -- HANDLE RANGED ATTACKS.
                    if self.getSetting('RA') and #helpers['queue'].queue.data == 0 and helpers['equipment'].ammo and helpers['equipment'].ammo.en ~= 'Gil' then
                        helpers['queue'].add(helpers['actions'].unique.ranged, target)
                    end

                end

                -- HANDLE EVERYTHING INSIDE THE QUEUE.
                helpers['queue'].handle(bp)

            end

        end

    end
    ]]

    return self

end
return core.get()
