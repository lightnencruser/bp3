local job = {}
function job.get()
    local self = {}

    -- Private Variables.
    local private   = {events={}}
    local timers    = {}

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

                -- RERAISE.
                if not buff(113) and _cast then

                    if player.job_points['whm'].jp_spent >= 100 and isReady('MA', "Reraise IV") then
                        add(bp.MA["Reraise IV"], player)

                    elseif player.job_points['whm'].jp_spent < 100 then

                        if isReady('MA', "Reraise III") then
                            add(bp.MA["Reraise III"], player)

                        elseif isReady('MA', "Reraise II") then
                            add(bp.MA["Reraise II"], player)

                        elseif isReady('MA', "Reraise") then
                            add(bp.MA["Reraise"], player)

                        end

                    end

                end

                if get('ja') and _act then

                    -- MARTYR.
                    if get('martyr').enabled and get('martyr').target ~= "" and isReady('JA', "Martyr") then
                        local target = windower.ffxi.get_mob_by_name(get('martyr').name)

                        if target and helpers['party'].isInParty(target) and target.hpp <= get('martyr').hpp and player['vitals'].hpp > 30 then
                            add(bp.JA["Martyr"], target)
                        end

                    end

                    -- DEVOTION.
                    if get('devotion').enabled and get('devotion').target ~= "" and isReady('JA', "Devotion") then
                        local target = windower.ffxi.get_mob_by_name(get('devotion').name)

                        if target and helpers['party'].isInParty(target) and target.mpp <= get('devotion').mpp and player['vitals'].hpp > 30 then
                            add(bp.JA["Devotion"], target)
                        end

                    end

                end

                if get('buffs') then

                    if (get('afflatus solace') or get('afflatus misery')) and not buff(417) and not buff(418) and _act then

                        -- AFFLATUS.
                        if get('afflatus solace') and isReady('JA', "Afflatus Solace") then
                            add(bp.JA["Afflatus Solace"], player)
                            add(bp.JA["Light Arts"], player)

                        elseif get('afflatus misery') and isReady('JA', "Afflatus Misery") then
                            add(bp.JA["Afflatus Misery"], player)
                            add(bp.JA["Light Arts"], player)

                        end

                    else

                        if (get('afflatus solace') or get('afflatus misery')) and (buff(417) or buff(418) or not _act) and buff(358) then

                            -- BOOSTS.
                            if get('boost').enabled and not bp.core.hasBoost() and isReady('MA', get('boost').name) then
                                add(bp.MA[get('boost').name], player)

                            -- STONESKIN.
                            elseif get('stoneskin') and not helpers['buffs'].buffActive(37) and isReady('MA', "Stoneskin") then
                                add(bp.MA["Stoneskin"], player)
            
                            -- BLNK.
                            elseif get('blink') and not get('utsusemi') and not helpers['buffs'].buffActive(36) and isReady('MA', "Blink") then
                                add(bp.MA["Blink"], player)
            
                            -- AQUAVEIL.
                            elseif get('aquaveil') and isReady('MA', "Aquaveil") and not buff(39) then
                                add(bp.MA["Aquaveil"], player)
            
                            end

                            -- SACROSANCTITY.
                            if get('sacrosanctity') and isReady('JA', "Sacrosanctity") and not buff(477) then
                                add(bp.JA["Sacrosanctity"], player)
                            end

                        elseif (not get('afflatus solace') and not get('afflatus misery') or not _act) then

                            -- BOOSTS.
                            if get('boost').enabled and not bp.core.hasBoost() and isReady('MA', get('boost').name) then
                                add(bp.MA[get('boost').name], player)

                            -- STONESKIN.
                            elseif get('stoneskin') and not helpers['buffs'].buffActive(37) and isReady('MA', "Stoneskin") then
                                add(bp.MA["Stoneskin"], player)
            
                            -- BLNK.
                            elseif get('blink') and not get('utsusemi') and not helpers['buffs'].buffActive(36) and isReady('MA', "Blink") and _cast then
                                add(bp.MA["Blink"], player)
            
                            -- AQUAVEIL.
                            elseif get('aquaveil') and isReady('MA', "Aquaveil") and not buff(39) then
                                add(bp.MA["Aquaveil"], player)
            
                            end

                            -- SACROSANCTITY.
                            if get('sacrosanctity') and isReady('JA', "Sacrosanctity") and not buff(477) then
                                add(bp.JA["Sacrosanctity"], player)
                            end

                        end

                    end
    
                end

            elseif bp and bp.player and bp.player.status == 0 then
                local target  = helpers['target'].getTarget() or false
                local _act    = bp.helpers['actions'].canAct()
                local _cast   = bp.helpers['actions'].canCast()

                -- RERAISE.
                if not buff(113) and _cast then

                    if player.job_points['whm'].jp_spent >= 100 and isReady('MA', "Reraise IV") then
                        add(bp.MA["Reraise IV"], player)

                    elseif player.job_points['whm'].jp_spent < 100 then

                        if isReady('MA', "Reraise III") then
                            add(bp.MA["Reraise III"], player)

                        elseif isReady('MA', "Reraise II") then
                            add(bp.MA["Reraise II"], player)

                        elseif isReady('MA', "Reraise") then
                            add(bp.MA["Reraise"], player)

                        end

                    end

                end

                if get('ja') and _act then

                    -- MARTYR.
                    if get('martyr').enabled and get('martyr').target ~= "" and isReady('JA', "Martyr") then
                        local target = windower.ffxi.get_mob_by_name(get('martyr').target) or false

                        if target and helpers['party'].isInParty(target) then
                            local member = helpers['party'].getMember(target) or false

                            if member and member.mpp and member.mpp <= get('martyr').hpp and player['vitals'].hpp > 30 then
                                add(bp.JA["Martyr"], target)
                            end
                            
                        end

                    end

                    -- DEVOTION.
                    if get('devotion').enabled and get('devotion').target ~= "" and isReady('JA', "Devotion") then
                        local target = windower.ffxi.get_mob_by_name(get('devotion').target) or false
                        
                        if target and helpers['party'].isInParty(target) then
                            local member = helpers['party'].getMember(target) or false

                            if member and member.mpp and member.mpp <= get('devotion').mpp and player['vitals'].hpp > 30 then
                                add(bp.JA["Devotion"], target)
                            end

                        end

                    end

                end

                if get('buffs') then

                    if (get('afflatus solace') or get('afflatus misery')) and not buff(417) and not buff(418) and _act then

                        -- AFFLATUS.
                        if get('afflatus solace') and isReady('JA', "Afflatus Solace") then
                            add(bp.JA["Afflatus Solace"], player)

                        elseif get('afflatus misery') and isReady('JA', "Afflatus Misery") then
                            add(bp.JA["Afflatus Misery"], player)

                        end

                    else

                        if (get('afflatus solace') or get('afflatus misery')) and (buff(417) or buff(418) or not _act) then

                            -- BOOSTS.
                            if target and get('boost').enabled and not bp.core.hasBoost() and isReady('MA', get('boost').name) and _cast then
                                add(bp.MA[get('boost').name], player)

                            -- STONESKIN.
                            elseif get('stoneskin') and not helpers['buffs'].buffActive(37) and isReady('MA', "Stoneskin") and _cast then
                                add(bp.MA["Stoneskin"], player)
            
                            -- BLNK.
                            elseif get('blink') and not get('utsusemi') and not helpers['buffs'].buffActive(36) and isReady('MA', "Blink") and _cast then
                                add(bp.MA["Blink"], player)
            
                            -- AQUAVEIL.
                            elseif get('aquaveil') and isReady('MA', "Aquaveil") and not buff(39) and _cast then
                                add(bp.MA["Aquaveil"], player)
            
                            end

                            -- SACROSANCTITY.
                            if target and get('sacrosanctity') and isReady('JA', "Sacrosanctity") and not buff(477) and _act then
                                add(bp.JA["Sacrosanctity"], player)
                            end

                        elseif not get('afflatus solace') and not get('afflatus misery') then

                            -- BOOSTS.
                            if target and get('boost').enabled and not bp.core.hasBoost() and isReady('MA', get('boost').name) and _cast then
                                add(bp.MA[get('boost').name], player)

                            -- STONESKIN.
                            elseif get('stoneskin') and not helpers['buffs'].buffActive(37) and isReady('MA', "Stoneskin") and _cast then
                                add(bp.MA["Stoneskin"], player)
            
                            -- BLNK.
                            elseif get('blink') and not get('utsusemi') and not helpers['buffs'].buffActive(36) and isReady('MA', "Blink") and _cast then
                                add(bp.MA["Blink"], player)
            
                            -- AQUAVEIL.
                            elseif get('aquaveil') and isReady('MA', "Aquaveil") and not buff(39) and _cast then
                                add(bp.MA["Aquaveil"], player)
            
                            end

                            -- SACROSANCTITY.
                            if target and get('sacrosanctity') and isReady('JA', "Sacrosanctity") and not buff(477) and _act then
                                add(bp.JA["Sacrosanctity"], player)
                            end

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