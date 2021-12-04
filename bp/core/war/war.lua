local job = {}
function job.get()
    local self = {}

    local private = {}

    self.automate = function(bp)
        local player    = bp.player
        local helpers   = bp.helpers
        local isReady   = helpers['actions'].isReady
        local inQueue   = helpers['queue'].inQueue
        local buff      = helpers['buffs'].buffActive
        local add       = helpers['queue'].add
        local get       = bp.core.get

        do
            private.items(bp, settings)
            if bp and bp.player and bp.player.status == 1 then
                local target  = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
                local _act    = bp.helpers['actions'].canAct()
                local _cast   = bp.helpers['actions'].canCast()

                if get('hate').enabled then

                    -- PROVOKE.
                    if get('provoke') and isReady('JA', "Provoke") and _act then
                        add(bp.JA["Provoke"], target)
                    end
    
                end

                if get('ja') and _act then

                    -- TOMOHAWK.
                    if get('tomohawk') and isReady('JA', "Tomohawk") and _act then
                        add(bp.JA["Tomohawk"], target)
                    end

                end
    
                if get('buffs') and _act then

                    -- 1 HOURS.
                    if get('1hr') and not buff(44) and not buff(490) and isReady('JA', "Mighty Strikes") and isReady('JA', "Brazen Rush") then
                        add(bp.JA["Mighty Strikes"], player)
                        add(bp.JA["Brazen Rush"], player)

                    end
    
                    -- BERSERK.
                    if not get('tank') and get('berserk') and isReady('JA', "Berserk") and not inQueue(bp.JA["Defender"]) and not buff(56) then
                        add(bp.JA["Berserk"], player)
    
                    -- DEFENDER.
                    elseif get('tank') and get('defender') and isReady('JA', "Defender") and not inQueue(bp.JA["Berserk"]) and not buff(57) then
                        add(bp.JA["Defender"], player)
    
                    -- WARCRY.
                    elseif get('warcry') and isReady('JA', "Warcry") and not buff(68) and not buff(460) and inQueue(bp.JA["Blood Rage"]) and inQueue(bp.JA["Warcry"]) then
                        add(bp.JA["Warcry"], player)
    
                    -- AGGRESSOR.
                    elseif get('aggressor') and isReady('JA', "Aggressor") and not buff(58) then
                        add(bp.JA["Aggressor"], player)
    
                    -- RETALIATION.
                    elseif get('retaliation') and isReady('JA', "Retaliation") and not buff(405) then
                        add(bp.JA["Retaliation"], player)

                    -- RESTRAINT.
                    elseif get('restraint') and isReady('JA', "Restraint") and not buff(435) then
                        add(bp.JA["Restraint"], player)

                    -- BLOOD RAGE.
                    elseif get('blood rage') and isReady('JA', "Blood Rage") and not buff(460) and not buff(68) and not inQueue(bp.JA["Blood Rage"]) and not inQueue(bp.JA["Warcry"]) then
                        add(bp.JA["Blood Rage"], player)
    
                    end

                    -- WARRIORS CHARGE.
                    if get('warrior\'s charge') and isReady('JA', "Warrior's Charge") and player['vitals'].tp >= get('ws').tp then
                        add(bp.JA["Warrior's Charge"], player)
                    end
    
                end               

            elseif bp and bp.player and bp.player.status == 0 then
                local target  = helpers['target'].getTarget() or false
                local _act    = bp.helpers['actions'].canAct()
                local _cast   = bp.helpers['actions'].canCast()

                if get('hate').enabled and target then

                    -- PROVOKE.
                    if target and get('provoke') and _act and isReady('JA', "Provoke") then
                        add(bp.JA["Provoke"], target)
                    end
    
                end

                if get('ja') and _act then

                    -- TOMOHAWK.
                    if target and get('tomohawk') and isReady('JA', "Tomohawk") and _act then
                        add(bp.JA["Tomohawk"], target)
                    end

                end
    
                if get('buffs') and target and _act then

                    -- 1 HOURS.
                    if target and get('1hr') and not buff(44) and not buff(490) and isReady('JA', "Mighty Strikes") and isReady('JA', "Brazen Rush") then
                        add(bp.JA["Mighty Strikes"], player)
                        add(bp.JA["Brazen Rush"], player)

                    end
    
                    -- BERSERK.
                    if target and not get('tank') and get('berserk') and isReady('JA', "Berserk") and not inQueue(bp.JA["Defender"]) and not buff(56) then
                        add(bp.JA["Berserk"], player)
    
                    -- DEFENDER.
                    elseif target and get('tank') and get('defender') and isReady('JA', "Defender") and not inQueue(bp.JA["Berserk"]) and not buff(57) then
                        add(bp.JA["Defender"], player)
    
                    -- WARCRY.
                    elseif get('warcry') and isReady('JA', "Warcry") and not buff(68) and not buff(460) and inQueue(bp.JA["Blood Rage"]) and inQueue(bp.JA["Warcry"]) then
                        add(bp.JA["Warcry"], player)
    
                    -- AGGRESSOR.
                    elseif target and get('aggressor') and isReady('JA', "Aggressor") and not buff(58) then
                        add(bp.JA["Aggressor"], player)
    
                    -- RETALIATION.
                    elseif target and get('retaliation') and isReady('JA', "Retaliation") and not buff(405) then
                        add(bp.JA["Retaliation"], player)

                    -- RESTRAINT.
                    elseif target and get('restraint') and isReady('JA', "Restraint") and not buff(435) then
                        add(bp.JA["Restraint"], player)

                    -- BLOOD RAGE.
                    elseif get('blood rage') and isReady('JA', "Blood Rage") and not buff(460) and not buff(68) and not inQueue(bp.JA["Blood Rage"]) and not inQueue(bp.JA["Warcry"]) then
                        add(bp.JA["Blood Rage"], player)
    
                    end

                    -- WARRIORS CHARGE.
                    if target and get('warrior\'s charge') and isReady('JA', "Warrior's Charge") and player['vitals'].tp >= get('ws').tp then
                        add(bp.JA["Warrior's Charge"], player)
                    end
    
                end

            end

        end
        
    end

    private.items = function(bp)

    end

    return self

end
return job.get()