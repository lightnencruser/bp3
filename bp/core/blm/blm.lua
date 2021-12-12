local job = {}
function job.get()
    local self = {}

    -- Private Variables.
    local private   = {events={}}
    local timers    = {}

    self.magicBurst = function()
        -- NEED TO ADD MAGIC BURST LOGIC IN THE FUTURE.
    end

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

                    if helpers['enmity'].hasEnmity(player) then

                        -- MANA WALL.
                        if get('mana wall') and isReady('JA', "Mana Wall") then
                            add(bp.JA["Mana Wall"], player)
                        end

                        -- ENMITY DOUSE.
                        if get('enmity douse') and isReady('JA', "Enmity Douse") then
                            add(bp.JA["Enmity Douse"], player)
                        end

                    end

                end
                
                if get('buffs') then

                    if get('burst') and _cast then

                        -- ELEMENTAL SEAL.
                        if get('elemental seal') and isReady('JA', "Elemental Seal") then
                            add(bp.JA["Elemental Seal"], player)
                        end

                        -- CASCADE.
                        if get('cascade').enabled and isReady('JA', "Cascade") and player['vitals'].tp > get('cascade').tp then
                            add(bp.JA["Cascade"], player)
                        end

                        -- MANAWELL.
                        if get('manawell') and isReady('JA', "Manawell") then
                            add(bp.JA["Manawell"], player)
                        end

                    end

                end

                -- DRAIN.
                if target and get('drain').enabled and player['vitals'].hpp <= get('drain').hpp and _cast then

                    if isReady('MA', "Drain") then
                        add(bp.MA["Drain"], target)
                    end

                end

                -- ASPIR.
                if target and get('aspir').enabled and player['vitals'].mpp <= get('aspir').mpp and _cast then
                    
                    if isReady('MA', "Aspir II") then
                        add(bp.MA["Drain II"], target)

                    elseif isReady('MA', "Aspir") then
                        add(bp.MA["Aspir"], target)
                        
                    end

                end

            elseif bp and bp.player and bp.player.status == 0 then
                local target  = helpers['target'].getTarget() or false
                local _act    = bp.helpers['actions'].canAct()
                local _cast   = bp.helpers['actions'].canCast()

                if get('ja') and _act then

                    if helpers['enmity'].hasEnmity(player) then

                        -- MANA WALL.
                        if get('mana wall') and isReady('JA', "Mana Wall") then
                            add(bp.JA["Mana Wall"], player)
                        end

                        -- ENMITY DOUSE.
                        if get('enmity douse') and isReady('JA', "Enmity Douse") then
                            add(bp.JA["Enmity Douse"], player)
                        end

                    end

                end
                
                if get('buffs') then

                    if target and get('burst') and _cast then

                        -- ELEMENTAL SEAL.
                        if get('elemental seal') and isReady('JA', "Elemental Seal") then
                            add(bp.JA["Elemental Seal"], player)
                        end

                        -- CASCADE.
                        if get('cascade').enabled and isReady('JA', "Cascade") and player['vitals'].tp > get('cascade').tp then
                            add(bp.JA["Cascade"], player)
                        end

                        -- MANAWELL.
                        if get('manawell') and isReady('JA', "Manawell") then
                            add(bp.JA["Manawell"], player)
                        end

                    end

                end

                -- DRAIN.
                if target and get('drain').enabled and player['vitals'].hpp <= get('drain').hpp and _cast then

                    if isReady('MA', "Drain") then
                        add(bp.MA["Drain"], target)
                    end

                end

                -- ASPIR.
                if target and get('aspir').enabled and player['vitals'].mpp <= get('aspir').mpp and _cast then
                    
                    if isReady('MA', "Aspir II") then
                        add(bp.MA["Drain II"], target)

                    elseif isReady('MA', "Aspir") then
                        add(bp.MA["Aspir"], target)
                        
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