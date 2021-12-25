local job = {}
function job.get()
    local self = {}

    -- Private Variables.
    local private   = {}
    local timers    = {}

    self.automate = function(bp)
        local player     = bp.player
        local helpers    = bp.helpers
        local isReady    = helpers['actions'].isReady
        local inQueue    = helpers['queue'].inQueue
        local buff       = helpers['buffs'].buffActive
        local addToFront = helpers['queue'].addToFront
        local add        = helpers['queue'].add
        local get        = bp.core.get

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
                    
                    -- VIVACIOUS PULSE.
                    if get('vivacious pulse').enabled and isReady('JA', "Vivacious Pulse") and _act then

                        if private.hasTenebrae() and player['vitals'].mpp < get('vivacious pulse').mpp then
                            add(bp.JA["Vivacious Pulse"], player)

                        else

                            if player['vitals'].hpp < get('vivacious pulse').hpp then
                                add(bp.JA["Vivacious Pulse"], player)
                            end

                        end

                    end
    
                end
    
                if get('hate').enabled then
    
                    -- FLASH.
                    if isReady('MA', "Flash") and _cast then
                        addToFront(bp.MA["Flash"], target)    
                    end
    
                end
    
                if get('buffs') then
                    local active = helpers['runes'].getActive()

                    if active == 3 then

                        -- VALLATION.
                        if get('vallation') and isReady('JA', "Vallation") and not buff(531) and not buff(535) and _act then
                            add(bp.JA["Vallation"], player)
                        
                        -- VALIANCE.
                        elseif get('valiance') and isReady('JA', "Valiance") and not buff(531) and not buff(535) and _act then
                            add(bp.JA["Valiance"], player)

                        -- PFLUG.
                        elseif get('pflug') and isReady('JA', "Pflug") and not buff(533) and _act then
                            add(bp.JA["Pflug"], player)

                        -- LIEMENT.
                        elseif get('liement') and isReady('JA', "Liement") and not buff(537) and not buff(531) and not buff(535) and _act then
                            add(bp.JA["Liement"], player)

                        end

                        -- BATTUTA.
                        if get('battuta') and isReady('JA', "Battuta") and not buff(570) and _act then
                            add(bp.JA["Battuta"], player)
                        end

                    end

                    -- SWORDPLAY.
                    if get('swordplay') and isReady('JA', "Swordplay") and not buff(532) and _act then
                        add(bp.JA["Swordplay"], player)
    
                    -- FOIL.
                    elseif isReady('MA', "Foil") and not buff(568) and _cast then

                        if get('embolden').enabled and get('embolden').name == 'Foil' then
                            add(bp.JA["Embolden"], player)
                            add(bp.MA["Foil"], player)

                        else
                            add(bp.MA["Foil"], player)

                        end

                    -- PHALANX.
                    elseif isReady('MA', "Phalanx") and not buff(116) and _cast then

                        if get('embolden').enabled and get('embolden').name == 'Phalanx' then
                            add(bp.JA["Embolden"], player)
                            add(bp.MA["Phalanx"], player)

                        else
                            add(bp.MA["Phalanx"], player)

                        end

                    -- CRUSADE.
                    elseif isReady('MA', "Crusade") and not buff(289) and _cast then

                        if get('embolden').enabled and get('embolden').name == 'Crusade' then
                            add(bp.JA["Embolden"], player)
                            add(bp.MA["Crusade"], player)

                        else
                            add(bp.MA["Crusade"], player)

                        end

                    -- TEMPER.
                    elseif isReady('MA', "Temper") and not buff(432) and _cast then

                        if get('embolden').enabled and get('embolden').name == 'Temper' then
                            add(bp.JA["Embolden"], player)
                            add(bp.MA["Temper"], player)

                        else
                            add(bp.MA["Temper"], player)

                        end
    
                    -- REFRESH.
                    elseif isReady('MA', "Refresh") and not buff(43) and _cast then
                        add(bp.MA["Refresh"], player)

                    -- ONE FOR ALL.
                    elseif get('one for all') and isReady('JA', "One For All") and not buff(538) and not buff(624) and not buff(154) and not buff(623) and _act then
                        add(bp.MA["One For All"], player)
        
                    end

                end

            elseif bp and bp.player and bp.player.status == 0 then
                local target  = helpers['target'].getTarget() or false
                local _act    = bp.helpers['actions'].canAct()
                local _cast   = bp.helpers['actions'].canCast()

                if get('ja') and _act then
                    
                    -- VIVACIOUS PULSE.
                    if get('vivacious pulse').enabled and isReady('JA', "Vivacious Pulse") and _act then

                        if private.hasTenebrae() and player['vitals'].mpp < get('vivacious pulse').mpp then
                            add(bp.JA["Vivacious Pulse"], player)

                        else

                            if player['vitals'].hpp < get('vivacious pulse').hpp then
                                add(bp.JA["Vivacious Pulse"], player)
                            end

                        end

                    end
    
                end
    
                if get('hate').enabled and target then
    
                    -- FLASH.
                    if isReady('MA', "Flash") and _cast then
                        addToFront(bp.MA["Flash"], target)                    
                    end
    
                end
    
                if get('buffs') then
                    local active = helpers['runes'].getActive()

                    if active == 3 and target then

                        -- VALLATION.
                        if get('vallation') and isReady('JA', "Vallation") and not buff(531) and not buff(535) and _act then
                            add(bp.JA["Vallation"], player)
                        
                        -- VALIANCE.
                        elseif get('valiance') and isReady('JA', "Valiance") and not buff(531) and not buff(535) and _act then
                            add(bp.JA["Valiance"], player)

                        -- PFLUG.
                        elseif get('pflug') and isReady('JA', "Pflug") and not buff(533) and _act then
                            add(bp.JA["Pflug"], player)

                        -- LIEMENT.
                        elseif get('liement') and isReady('JA', "Liement") and not buff(537) and not buff(531) and not buff(535) and _act then
                            add(bp.JA["Liement"], player)

                        end

                        -- BATTUTA.
                        if get('battuta') and isReady('JA', "Battuta") and not buff(570) and _act then
                            add(bp.JA["Battuta"], player)
                        end

                    end

                    -- SWORDPLAY.
                    if target and get('swordplay') and isReady('JA', "Swordplay") and not buff(532) and _act then
                        add(bp.JA["Swordplay"], player)
    
                    -- FOIL.
                    elseif target and isReady('MA', "Foil") and not buff(568) and _cast then

                        if get('embolden').enabled and get('embolden').name == 'Foil' then
                            add(bp.JA["Embolden"], player)
                            add(bp.MA["Foil"], player)

                        else
                            add(bp.MA["Foil"], player)

                        end

                    -- PHALANX.
                    elseif isReady('MA', "Phalanx") and not buff(116) and _cast then

                        if get('embolden').enabled and get('embolden').name == 'Phalanx' then
                            add(bp.JA["Embolden"], player)
                            add(bp.MA["Phalanx"], player)

                        else
                            add(bp.MA["Phalanx"], player)

                        end

                    -- CRUSADE.
                    elseif isReady('MA', "Crusade") and not buff(289) and _cast then

                        if get('embolden').enabled and get('embolden').name == 'Crusade' then
                            add(bp.JA["Embolden"], player)
                            add(bp.MA["Crusade"], player)

                        else
                            add(bp.MA["Crusade"], player)

                        end

                    -- TEMPER.
                    elseif target and isReady('MA', "Temper") and not buff(432) and _cast then

                        if get('embolden').enabled and get('embolden').name == 'Temper' then
                            add(bp.JA["Embolden"], player)
                            add(bp.MA["Temper"], player)

                        else
                            add(bp.MA["Temper"], player)

                        end
    
                    -- REFRESH.
                    elseif isReady('MA', "Refresh") and not buff(43) and _cast then
                        add(bp.MA["Refresh"], player)

                    -- ONE FOR ALL.
                    elseif target and get('one for all') and isReady('JA', "One For All") and not buff(538) and not buff(624) and not buff(154) and not buff(623) and _act then
                        add(bp.MA["One For All"], player)

                    -- STONESKIN.
                    elseif target and get('stoneskin') and isReady('MA', "Stoneskin") and not buff(37) then
                        add(bp.MA["Stoneskin"], player)

                    -- AQUAVEIL.
                    elseif get('aquaveil') and isReady('MA', "Aquaveil") and not buff(39) then
                        add(bp.MA["Aquaveil"], player)

                    -- BLINK.
                    elseif get('blink') and isReady('MA', "Blink") and not get('utsusemi') and not buff(36) and not bp.core.hasShadows() then
                        add(bp.MA["Blink"], player)
                        
                    -- SPIKES.
                    elseif isReady('MA', get('spikes').name) and not bp.core.hasSpikes() then
                        add(bp.MA[get('spikes')], player)
        
                    end

                end

            end

        end
        
    end

    private.items = function()

    end

    private.hasTenebrae = function()

        if bp and bp.player and T(bp.player.buffs):contains(530) then
            return true
        end
        return false

    end

    return self

end
return job.get()