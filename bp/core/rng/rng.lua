local job = {}
function job.get()
    local self = {}

    -- Private Variables.
    local private   = {events={}}
    local timers    = {}
    local move      = 0
    local scavenge  = false

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

                    -- SCAVENGE.
                    if get('scavenge') and isReady('JA', "Scavenge") and scavenge and helpers['inventory'].hasSpace() then
                        add(bp.JA["Scavenge"], player)
                    end
    
                end
    
                if get('buffs') and _act then

                    -- BOUNTY SHOT.
                    if get('bounty shot') and isReady('JA', "Bounty Shot") then
                        add(bp.JA["Bounty Shot"], target)
                    end

                    -- DECOY SHOT.
                    if get('decoy shot').enabled and isReady('JA', "Decoy Shot") and not buff(482) then
                        local decoy = get('decoy shot').target ~= "" and windower.ffxi.get_mob_by_name(get('decoy shot').target) or false

                        if decoy and helpers['actions'].isBehind(decoy) and helpers['distance'].getDistance(decoy) <= 20 then
                            add(bp.JA["Decoy Shot"], player)
                        end

                    end
    
                    -- SHARPSHOT.
                    if get('sharpshot') and isReady('JA', "Sharpshot") then
                        add(bp.JA["Sharpshot"], player)
    
                    -- BARRAGE.
                    elseif get('barrage') and isReady('JA', "Barrage") then
    
                        if get('camouflage') and isReady('JA', "Camouflage") then
                            add(bp.JA["Camouflage"], player)
                            add(bp.JA["Barrage"], player)
    
                        else
                            add(bp.JA["Barrage"], player)
    
                        end
    
                    -- VELOCITY SHOT.
                    elseif get('velocity shot') and isReady('JA', "Velocity Shot") then
                        add(bp.JA["Velocity Shot"], player)

                    -- HOVER SHOT.
                    elseif get('hover shot') and isReady('JA', "Hover Shot") and not buff(628) then
                        add(bp.JA["Hover Shot"], player)

                    -- STEALTH SHOT.
                    elseif get('stealth shot') and isReady('JA', "Stealth Shot") then
                        add(bp.JA["Stealth Shot"], target)

                    -- FLASHY SHOT.
                    elseif get('flashy shot') and isReady('JA', "Flashy Shot") then
                        add(bp.JA["Flashy Shot"], target)

                    -- DOUBLE SHOT.
                    elseif get('double shot') and isReady('JA', "Double Shot") and not buff(433) then
                        add(bp.JA["Double Shot"], player)
    
                    end

                    -- UNLIMITED SHOT.
                    if get('unlimited shot') and isReady('JA', "Unlimited Shot") and get('ws').enabled and player['vitals'].tp > get('ws').tp and bp.core.hasAftermath() and not buff(115) then
                        add(bp.JA["Unlimited Shot"], player)
                    end
                    
                end

            elseif bp and bp.player and bp.player.status == 0 then
                local target  = helpers['target'].getTarget() or false
                local _act    = bp.helpers['actions'].canAct()
                local _cast   = bp.helpers['actions'].canCast()

                if get('ja') and _act then

                    -- SCAVENGE.
                    if get('scavenge') and isReady('JA', "Scavenge") and scavenge and helpers['inventory'].hasSpace() then
                        add(bp.JA["Scavenge"], player)
                    end
    
                end
    
                if get('buffs') and _act then

                    -- BOUNTY SHOT.
                    if get('bounty shot') and isReady('JA', "Bounty Shot") then
                        add(bp.JA["Bounty Shot"], target)
                    end

                    -- DECOY SHOT.
                    if target and get('decoy shot').enabled and isReady('JA', "Decoy Shot") and not buff(482) then
                        local decoy = get('decoy shot').target ~= "" and windower.ffxi.get_mob_by_name(get('decoy shot').target) or false

                        if decoy and helpers['actions'].isBehind(decoy) and helpers['distance'].getDistance(decoy) <= 20 then
                            add(bp.JA["Decoy Shot"], player)
                        end

                    end
    
                    -- SHARPSHOT.
                    if target and get('sharpshot') and isReady('JA', "Sharpshot") then
                        add(bp.JA["Sharpshot"], player)
    
                    -- BARRAGE.
                    elseif target and get('barrage') and isReady('JA', "Barrage") then
    
                        if get('camouflage') and isReady('JA', "Camouflage") then
                            add(bp.JA["Camouflage"], player)
                            add(bp.JA["Barrage"], player)
    
                        else
                            add(bp.JA["Barrage"], player)
    
                        end
    
                    -- VELOCITY SHOT.
                    elseif target and get('velocity shot') and isReady('JA', "Velocity Shot") then
                        add(bp.JA["Velocity Shot"], player)

                    -- HOVER SHOT.
                    elseif target and get('hover shot') and isReady('JA', "Hover Shot") and not buff(628) then
                        add(bp.JA["Hover Shot"], player)

                    -- STEALTH SHOT.
                    elseif target and get('stealth shot') and isReady('JA', "Stealth Shot") then
                        add(bp.JA["Stealth Shot"], target)

                    -- FLASHY SHOT.
                    elseif target and get('flashy shot') and isReady('JA', "Flashy Shot") then
                        add(bp.JA["Flashy Shot"], target)

                    -- DOUBLE SHOT.
                    elseif target and get('double shot') and isReady('JA', "Double Shot") and not buff(433) then
                        add(bp.JA["Double Shot"], player)
    
                    end

                    -- UNLIMITED SHOT.
                    if target and get('unlimited shot') and isReady('JA', "Unlimited Shot") and get('ws').enabled and player['vitals'].tp > get('ws').tp and bp.core.hasAftermath() and not buff(115) then
                        add(bp.JA["Unlimited Shot"], player)
                    end
                    
                end

            end

        end
        
    end

    private.items = function()

    end

    -- Private Events.
    private.events.actions = windower.register_event('incoming chunk', function(id, original, modified, injected, blocked)
        
        if private.bp and id == 0x028 then
            local bp        = private.bp
            local pack      = bp.packets.parse('incoming', original)
            local player    = bp.player
            local actor     = windower.ffxi.get_mob_by_id(pack['Actor'])
            local target    = windower.ffxi.get_mob_by_id(pack['Target 1 ID'])
            local count     = pack['Target Count']
            local category  = pack['Category']
            local param     = pack['Param']
            
            if player and actor and target then
                local buff  = helpers['buffs'].buffActive
                local get   = bp.core.get

                -- Finish Ranged Attack.
                if pack['Category'] == 2 and player.id == actor.id and not scavenge then
                    scavenge = true

                    if get('hover shot') and buff(628) then

                        if move == 0 then
                            bp.helpers['controls'].left()
                            move = 1

                        else
                            bp.helpers['controls'].right()
                            move = 0

                        end

                    end

                end

            end

        end

    end)

    private.events.zone = windower.register_event('zone change', function()
        scavenge = false
    end)

    return self

end
return job.get()