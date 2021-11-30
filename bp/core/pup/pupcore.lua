local core = {}
local player = windower.ffxi.get_player()
function core.get()
    local self = {}

    self.handleAutomation = function()
        local bp = bp or false
                    

                -- PLAYER IS DISENGAGED LOGIC.
                elseif player.status == 0 then
                    
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
                        
                    end

                    -- BUFF LOGIC.
                    if bp.helpers['buffs'].enabled then
                        
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
