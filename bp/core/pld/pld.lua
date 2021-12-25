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
                    local cover  = get('cover').target ~= "" and windower.ffxi.get_mob_by_name(get('cover').target) or false
                    local behind = helpers['actions'].isBehind(cover)

                    -- [[ NEED TO ADD SEPULCHER AND HOLY CIRCLY ]]**

                    -- COVER.
                    if get('cover').enabled and isReady('JA', "Cover") and cover and behind and helpers['party'].isInParty(cover) and helpers['enmity'].hasEnmity(cover) then
                        add(bp.JA["Cover"], cover)
    
                    -- SHIELD BASH.
                    elseif get('shield bash') and isReady('JA', "Shield Bash") then
                        add(bp.JA["Shield Bash"], target)
    
                    end

                    -- CHIVALRY.
                    if get('chivalry').enabled and isReady('JA', "Chivalry") and player['vitals'].mpp < get('chivalry').mpp and player['vitals'].tp >= get('chivalry').tp then
                        add(bp.JA["Chivalry"], player)
                    end
    
                end
    
                if get('hate').enabled then
    
                    -- FLASH.
                    if isReady('MA', "Flash") and _cast then

                        if get('divine emblem') and isReady('JA', "Divine Emblem") then
                            addToFront(bp.MA["Flash"], target)
                            addToFront(bp.JA["Divine Emblem"], me)

                        else
                            addToFront(bp.MA["Flash"], target)

                        end
    
                    -- SHIELD BASH.
                    elseif get('shield bash') and isReady('JA', "Shield Bash") and _act then
                        add(bp.JA["Shield Bash"], target)
    
                    end
    
                end
    
                if get('buffs') then

                    -- MAJESTY.
                    if get('majesty') and isReady('JA', "Majesty") and not buff(621) and _act then
                        add(bp.JA["Majesty"], player)
    
                    -- REPRISAL.
                    elseif isReady('MA', "Reprisal") and not buff(403) and _cast then
                        add(bp.MA["Reprisal"], player)

                    -- PHALANX.
                    elseif isReady('MA', "Phalanx") and not buff(116) and _cast then
                        add(bp.MA["Phalanx"], player)

                    -- CRUSADE.
                    elseif isReady('MA', "Crusade") and not buff(289) and _cast then
                        add(bp.MA["Crusade"], player)
    
                    -- SENTINEL.
                    elseif get('sentinel') and isReady('JA', "Sentinel") and not buff(62) and (get('hate') or helpers['enmity'].hasEnmity(player)) and _act then
                        add(bp.JA["Sentinel"], player)

                    -- PALISADE.
                    elseif get('palisade') and isReady('JA', "Palisade") and not buff(478) and (get('hate') or helpers['enmity'].hasEnmity(player)) and _act then
                        add(bp.JA["Palisade"], player)
    
                    -- RAMPART.
                    elseif get('rampart') and isReady('JA', "Rampart") and not buff(623) and _act then
                        add(bp.MA["Rampart"], player)

                    -- FEALTY.
                    elseif get('fealty') and isReady('JA', "Fealty") and not buff(344) and _act then
                        add(bp.MA["Fealty"], player)

                    -- ENLIGHT.
                    elseif _cast then

                        if bp.player.job_points['PLD'].jp_spent >= 100 then

                            if isReady('MA', "Enlight II") and not buff(274) then
                                add(bp.MA["Enlight II"], player)
                            end

                        else

                            if isReady('MA', "Enlight") and not buff(274) then
                                add(bp.MA["Enlight"], player)
                            end

                        end
    
                    end
    
                end

            elseif bp and bp.player and bp.player.status == 0 then
                local target  = helpers['target'].getTarget() or false
                local _act    = bp.helpers['actions'].canAct()
                local _cast   = bp.helpers['actions'].canCast()

                if get('ja') and _act then
                    local cover  = get('cover').target ~= "" and windower.ffxi.get_mob_by_name(get('cover').target) or false
                    local behind = helpers['actions'].isBehind(cover)
                    -- [[ NEED TO ADD SEPULCHER AND HOLY CIRCLY ]]**

                    -- COVER.
                    if target and get('cover').enabled and isReady('JA', "Cover") and cover and behind and helpers['party'].isInParty(cover) and helpers['enmity'].hasEnmity(cover) then
                        add(bp.JA["Cover"], cover)
    
                    -- SHIELD BASH.
                    elseif target and get('shield bash') and isReady('JA', "Shield Bash") then
                        add(bp.JA["Shield Bash"], target)
    
                    end

                    -- CHIVALRY.
                    if get('chivalry').enabled and isReady('JA', "Chivalry") and player['vitals'].mpp < get('chivalry').mpp and player['vitals'].tp >= get('chivalry').tp then
                        add(bp.JA["Chivalry"], player)
                    end
    
                end
    
                if get('hate').enabled and target then
    
                    -- FLASH.
                    if isReady('MA', "Flash") and _cast then

                        if get('divine emblem') and isReady('JA', "Divine Emblem") then
                            addToFront(bp.MA["Flash"], target)
                            addToFront(bp.JA["Divine Emblem"], me)

                        else
                            addToFront(bp.MA["Flash"], target)

                        end
    
                    -- SHIELD BASH.
                    elseif get('shield bash') and isReady('JA', "Shield Bash") and _act then
                        add(bp.JA["Shield Bash"], target)
    
                    end
    
                end
    
                if get('buffs') and target then

                    -- MAJESTY.
                    if get('majesty') and isReady('JA', "Majesty") and not buff(621) and _act then
                        add(bp.JA["Majesty"], player)
    
                    -- REPRISAL.
                    elseif isReady('MA', "Reprisal") and not buff(403) and _cast then
                        add(bp.MA["Reprisal"], player)

                    -- PHALANX.
                    elseif isReady('MA', "Phalanx") and not buff(116) and _cast then
                        add(bp.MA["Phalanx"], player)

                    -- CRUSADE.
                    elseif isReady('MA', "Crusade") and not buff(289) and _cast then
                        add(bp.MA["Crusade"], player)
    
                    -- SENTINEL.
                    elseif get('sentinel') and isReady('JA', "Sentinel") and not buff(62) and (get('hate') or helpers['enmity'].hasEnmity(player)) and _act then
                        add(bp.JA["Sentinel"], player)

                    -- PALISADE.
                    elseif get('palisade') and isReady('JA', "Palisade") and not buff(478) and (get('hate') or helpers['enmity'].hasEnmity(player)) and _act then
                        add(bp.JA["Palisade"], player)
    
                    -- RAMPART.
                    elseif get('rampart') and isReady('JA', "Rampart") and not buff(623) and _act then
                        add(bp.MA["Rampart"], player)

                    -- FEALTY.
                    elseif get('fealty') and isReady('JA', "Fealty") and not buff(344) and _act then
                        add(bp.MA["Fealty"], player)

                    -- ENLIGHT.
                    elseif _cast then

                        if bp.player.job_points['PLD'].jp_spent >= 100 then

                            if isReady('MA', "Enlight II") and not buff(274) then
                                add(bp.MA["Enlight II"], player)
                            end

                        else

                            if isReady('MA', "Enlight") and not buff(274) then
                                add(bp.MA["Enlight"], player)
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