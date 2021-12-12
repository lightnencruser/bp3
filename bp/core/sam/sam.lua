local job = {}
function job.get()
    local self = {}

    -- Private Variables.
    local private   = {events={}}
    local timers    = {meditate=0}

    self.automate = function(bp)
        local player    = bp.player
        local helpers   = bp.helpers
        local isReady   = helpers['actions'].isReady
        local inQueue   = helpers['queue'].inQueue
        local buff      = helpers['buffs'].buffActive
        local add       = helpers['queue'].add
        local get       = bp.core.get

        if not private.bp then
            private.bp = bp
        end

        do
            private.items()
            if bp and bp.player and bp.player.status == 1 then
                local target  = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
                local _act    = bp.helpers['actions'].canAct()
                local _cast   = bp.helpers['actions'].canCast()

                if get('ja') and _act then
                    local shiki = get('shikikoyo').target ~= "" and windower.ffxi.get_mob_by_name(get('shikikoyo').target) or false
    
                    -- MEDITATE
                    if get('meditate') and isReady('JA', "Meditate") and (os.clock()-timers.meditate) > 30 then
                        add(bp.JA["Meditate"], player)
                        timers.meditate = os.clock()

                    -- BLADE BASH.
                    elseif get('blade bash') and isReady('JA', "Blade Bash") then
                        add(bp.JA["Blade Bash"], target)
                        
                    end
    
                    -- SHIKIKOYO.
                    if get('shikikoyo').enabled and shiki and isReady('JA', "Shikikoyo") and helpers['party'].isInParty(shiki) and player['vitals'].tp >= get('shikikoyo').tp and shiki.tp < get('shikikoyo').tp and helpers['target'].inRange(shiki, 10.9) then
                        add(bp.JA["Shikikoyo"], shiki)
                    end
    
                end
    
                if get('buffs') and _act then
                    local weapon = bp.helpers['equipment'].main
                                
                    -- HASSO & SEIGAN.
                    if (get('hasso') or get('seigan')) and weapon then
    
                        if get('hasso') and isReady('JA', "Hasso") and not buff(353) and not get('tank') and T{4,6,7,8,10,12}:contains(weapon.skill) then
                            add(bp.JA["Hasso"], player)
    
                        elseif get('seigan') and isReady('JA', "Seigan") and not buff(354) and get('tank') and T{4,6,7,8,10,12}:contains(weapon.skill) then
                            add(bp.JA["Seigan"], player)
    
                        end
    
                    end
    
                    if (not get('hasso') and not get('seigan')) or (buff(353) or buff(354)) then

                        -- 1 HOURS.
                        if target and get('1hr') and not buff(54) and not buff(501) and isReady('JA', "Meikyo Shisui") and isReady('JA', "Yaegasumi") and player['vitals'].tp <= 750 then
                            add(bp.JA["Meikyo Shisui"], player)
                            add(bp.JA["Yaegasumi"], player)

                        end
    
                        -- THIRD EYE.
                        if get('third eye') and isReady('JA', "Third Eye") and not buff(67) and not buff(36) and not bp.core.hasShadows() then
                            add(bp.JA["Third Eye"], player)
                        end
    
                        -- SEKKANOKI.
                        if get('sekkanoki') and isReady('JA', "Sekkanoki") and not buff(408) and player['vitals'].tp >= 2000 then
                            add(bp.JA["Sekkanoki"], player)
                        end

                        -- HAGAKURE.
                        if get('hagakure') and isReady('JA', "Hagakure") and not buff(483) and player['vitals'].tp < 2000 and player['vitals'].tp >= get('ws').tp then
                            add(bp.JA["Sekkanoki"], player)
                        end
    
                        -- KONZEN-ITTAI.
                        if get('konzen-ittai') and isReady('JA', "Konzen-Ittai") and player['vitals'].tp >= math.floor((get('ws').tp/3)*2) and (os.clock()-timers.konzen) > 60 then
                            add(bp.JA["Konzen-Ittai"])
                            timers.konzen = os.clock()
    
                        end
    
                    end
    
                end

            elseif bp and bp.player and bp.player.status == 0 then
                local target  = helpers['target'].getTarget() or false
                local _act    = bp.helpers['actions'].canAct()
                local _cast   = bp.helpers['actions'].canCast()

                if get('ja') and _act then
                    local shiki = get('shikikoyo').target ~= "" and windower.ffxi.get_mob_by_name(get('shikikoyo').target) or false
    
                    -- MEDITATE
                    if get('meditate') and isReady('JA', "Meditate") and (os.clock()-timers.meditate) > 30 then
                        add(bp.JA["Meditate"], player)
                        timers.meditate = os.clock()

                    -- BLADE BASH.
                    elseif target and get('blade bash') and isReady('JA', "Blade Bash") then
                        add(bp.JA["Blade Bash"], target)
                        
                    end
    
                    -- SHIKIKOYO.
                    if get('shikikoyo').enabled and shiki and isReady('JA', "Shikikoyo") and helpers['party'].isInParty(shiki) and player['vitals'].tp >= get('shikikoyo').tp and shiki.tp < get('shikikoyo').tp and helpers['target'].inRange(shiki, 10.9) then
                        add(bp.JA["Shikikoyo"], shiki)
                    end
    
                end
    
                if get('buffs') and _act then
                    local weapon = bp.helpers['equipment'].main
                                
                    -- HASSO & SEIGAN.
                    if (get('hasso') or get('seigan')) and weapon then
    
                        if get('hasso') and isReady('JA', "Hasso") and not buff(353) and not get('tank') and T{4,6,7,8,10,12}:contains(weapon.skill) then
                            add(bp.JA["Hasso"], player)
    
                        elseif get('seigan') and isReady('JA', "Seigan") and not buff(354) and get('tank') and T{4,6,7,8,10,12}:contains(weapon.skill) then
                            add(bp.JA["Seigan"], player)
    
                        end
    
                    end
    
                    if (not get('hasso') and not get('seigan')) or (buff(353) or buff(354)) and target then
    
                        -- THIRD EYE.
                        if get('third eye') and isReady('JA', "Third Eye") and not buff(67) and not buff(36) and target and not bp.core.hasShadows() then
                            add(bp.JA["Third Eye"], player)
                        end
    
                    end
    
                end

            end

        end
        
    end

    private.items = function()

    end

    return self

end
return job.get()