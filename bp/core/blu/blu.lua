local job = {}
function job.get()
    local self = {}

    -- Private Variables.
    local private   = {events={}}
    local timers    = {}

    self.magicBurst = function()

        -- ADD MAGIC BURST LOG.

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

                if not get('nuke') then

                    if get('hate').enabled and _cast then

                        -- JETTATURA.
                        if isReady('MA', "Jettatura") then
                            add(bp.MA["Jettatura"], target)
                            
                        -- BLANK GAZE.
                        elseif isReady('MA', "Blank Gaze") then
                            add(bp.MA["Blank Gaze"], target)
                            
                        end
                        
                        if get('hate').aoe and (os.clock()-timers.hate) > get('hate').delay then
                            
                            -- SOPORIFIC.
                            if isReady('MA', "Soporific") then
                                add(bp.MA["Soporific"], target)
                                timers.hate = os.clock()
                            
                            -- GEIST WALL.
                            elseif isReady('MA', "Geist Wall") then
                                add(bp.MA["Geist Wall"], target)
                                timers.hate = os.clock()
                            
                            -- SHEEP SONG.
                            elseif isReady('MA', "Sheep Song") then
                                add(bp.MA["Sheep Song"], target)
                                timers.hate = os.clock()
        
                            -- STINKING GAS.
                            elseif isReady('MA', "Stinking Gas") then
                                add(bp.MA["Stinking Gas"], target)
                                timers.hate = os.clock()
                            
                            end
                            
                        end
        
                    end
        
                    if get('buffs') and _cast then

                        -- MIGHTY GUARD.
                        if get('unbridled learning') and isReady('JA', "Unbridled Learning") and not buff(485) and _act then

                            if get('diffusion') and isReady('MA', "Mighty Guard") and not buff(604) then
                                add(bp.JA["Unbridled Learning"], player)
                                add(bp.JA["Diffusion"], player)
                                add(bp.MA["Mighty Guard"], player)

                            end
                            
                        end

                        -- HASTE.
                        if not buff(93) then

                            if player.main_job_level >= 99 and isReady('MA', "Erratic Flutter") then
                                add(bp.MA["Erratic Flutter"], player)

                            elseif player.main_job_level >= 99 and isReady('MA', "Animating Wail") then
                                add(bp.MA["Animating Wail"], player)

                            elseif player.main_job_level <= 48 and isReady('MA', "Refueling") then
                                add(bp.MA["Refueling"], player)

                            end

                        end

                        -- COCOON.
                        if isReady('MA', "Cocoon") and not buff(93) then
                            add(bp.MA["Cocoon"], player)

                        -- NATURES MEDITATION.
                        elseif isReady('MA', "Nature's Meditation") and not buff(91) then
                            add(bp.MA["Nature's Meditation"], player)

                        -- MAGIC BARRIER.
                        elseif isReady('MA', "Magic Barrier") and not buff(152) then
                            add(bp.MA["Magic Barrier"], player)

                        -- SALINE COAT.
                        elseif isReady('MA', "Saline Coat") and not buff(191) then
                            add(bp.MA["Saline Coat"], player)

                        -- OCCULTATION.
                        elseif isReady('MA', "Occultation") and not buff(36) and not bp.core.hasShadows() then
                            add(bp.MA["Occultation"], player)

                        end
        
                    end

                    -- MAGIC HAMMER.
                    if get('aspir').enabled and player['vitals'].mpp <= get('aspir').mpp and isReady('MA', "Magic Hammer") then
                        add(bp.MA["Magic Hammer"], target)
                    end

                    -- WINDS OF PROMY.
                    if get('winds of promy.') and isReady('MA', "Winds of Promy.") and helpers['status'].windsRemoval() then
                        add(bp.MA["Winds of Promy"], player)
                    end

                elseif get('nuke') then

                    if get('hate').enabled and _cast then

                        -- JETTATURA.
                        if isReady('MA', "Jettatura") then
                            add(bp.MA["Jettatura"], target)
                            
                        -- BLANK GAZE.
                        elseif isReady('MA', "Blank Gaze") then
                            add(bp.MA["Blank Gaze"], target)
                            
                        end
                        
                        if get('hate').aoe and (os.clock()-timers.hate) > get('hate').delay then
                            
                            -- SOPORIFIC.
                            if isReady('MA', "Soporific") then
                                add(bp.MA["Soporific"], target)
                                timers.hate = os.clock()
                            
                            -- GEIST WALL.
                            elseif isReady('MA', "Geist Wall") then
                                add(bp.MA["Geist Wall"], target)
                                timers.hate = os.clock()
                            
                            -- SHEEP SONG.
                            elseif isReady('MA', "Sheep Song") then
                                add(bp.MA["Sheep Song"], target)
                                timers.hate = os.clock()
        
                            -- STINKING GAS.
                            elseif isReady('MA', "Stinking Gas") then
                                add(bp.MA["Stinking Gas"], target)
                                timers.hate = os.clock()
                            
                            end
                            
                        end
        
                    end
        
                    if get('buffs') and _cast then

                        -- MIGHTY GUARD.
                        if get('unbridled learning') and isReady('JA', "Unbridled Learning") and not buff(485) and _act then

                            if get('diffusion') and isReady('MA', "Mighty Guard") and not buff(604) then
                                add(bp.JA["Unbridled Learning"], player)
                                add(bp.JA["Diffusion"], player)
                                add(bp.MA["Mighty Guard"], player)

                            end
                            
                        end

                        -- HASTE.
                        if not buff(93) then

                            if player.main_job_level >= 99 and isReady('MA', "Erratic Flutter") then
                                add(bp.MA["Erratic Flutter"], player)

                            elseif player.main_job_level >= 99 and isReady('MA', "Animating Wail") then
                                add(bp.MA["Animating Wail"], player)

                            elseif player.main_job_level <= 48 and isReady('MA', "Refueling") then
                                add(bp.MA["Refueling"], player)

                            end

                        end

                        -- COCOON.
                        if isReady('MA', "Cocoon") and not buff(93) then
                            add(bp.MA["Cocoon"], player)

                        -- MOMENTO MORI.
                        elseif isReady('MA', "Momento Mori") and not buff(91) then
                            add(bp.MA["Nature's Meditation"], player)

                        -- MAGIC BARRIER.
                        elseif isReady('MA', "Magic Barrier") and not buff(152) then
                            add(bp.MA["Magic Barrier"], player)

                        -- SALINE COAT.
                        elseif isReady('MA', "Saline Coat") and not buff(191) then
                            add(bp.MA["Saline Coat"], player)

                        -- OCCULTATION.
                        elseif isReady('MA', "Occultation") and not buff(36) and not bp.core.hasShadows() then
                            add(bp.MA["Occultation"], player)

                        end
        
                    end

                    -- MAGIC HAMMER.
                    if get('aspir').enabled and player['vitals'].mpp <= get('aspir').mpp and isReady('MA', "Magic Hammer") then
                        add(bp.MA["Magic Hammer"], target)
                    end

                    -- WINDS OF PROMY.
                    if get('winds of promy.') and isReady('MA', "Winds of Promy.") and helpers['status'].windsRemoval() then
                        add(bp.MA["Winds of Promy"], player)
                    end

                end

            elseif bp and bp.player and bp.player.status == 0 then
                local target  = helpers['target'].getTarget() or false
                local _act    = bp.helpers['actions'].canAct()
                local _cast   = bp.helpers['actions'].canCast()

                if not get('nuke') then

                    if target and get('hate').enabled and _cast then

                        -- JETTATURA.
                        if isReady('MA', "Jettatura") then
                            add(bp.MA["Jettatura"], target)
                            
                        -- BLANK GAZE.
                        elseif isReady('MA', "Blank Gaze") then
                            add(bp.MA["Blank Gaze"], target)
                            
                        end
                        
                        if get('hate').aoe and (os.clock()-timers.hate) > get('hate').delay then
                            
                            -- SOPORIFIC.
                            if isReady('MA', "Soporific") then
                                add(bp.MA["Soporific"], target)
                                timers.hate = os.clock()
                            
                            -- GEIST WALL.
                            elseif isReady('MA', "Geist Wall") then
                                add(bp.MA["Geist Wall"], target)
                                timers.hate = os.clock()
                            
                            -- SHEEP SONG.
                            elseif isReady('MA', "Sheep Song") then
                                add(bp.MA["Sheep Song"], target)
                                timers.hate = os.clock()
        
                            -- STINKING GAS.
                            elseif isReady('MA', "Stinking Gas") then
                                add(bp.MA["Stinking Gas"], target)
                                timers.hate = os.clock()
                            
                            end
                            
                        end
        
                    end
        
                    if get('buffs') and _cast then

                        -- MIGHTY GUARD.
                        if target and get('unbridled learning') and isReady('JA', "Unbridled Learning") and not buff(485) and _act then

                            if get('diffusion') and isReady('MA', "Mighty Guard") and not buff(604) then
                                add(bp.JA["Unbridled Learning"], player)
                                add(bp.JA["Diffusion"], player)
                                add(bp.MA["Mighty Guard"], player)

                            end
                            
                        end

                        -- HASTE.
                        if not buff(93) then

                            if player.main_job_level >= 99 and isReady('MA', "Erratic Flutter") then
                                add(bp.MA["Erratic Flutter"], player)

                            elseif player.main_job_level >= 99 and isReady('MA', "Animating Wail") then
                                add(bp.MA["Animating Wail"], player)

                            elseif player.main_job_level <= 48 and isReady('MA', "Refueling") then
                                add(bp.MA["Refueling"], player)

                            end

                        end

                        -- COCOON.
                        if isReady('MA', "Cocoon") and not buff(93) then
                            add(bp.MA["Cocoon"], player)

                        -- NATURES MEDITATION.
                        elseif target and isReady('MA', "Nature's Meditation") and not buff(91) then
                            add(bp.MA["Nature's Meditation"], player)

                        -- MAGIC BARRIER.
                        elseif isReady('MA', "Magic Barrier") and not buff(152) then
                            add(bp.MA["Magic Barrier"], player)

                        -- SALINE COAT.
                        elseif isReady('MA', "Saline Coat") and not buff(191) then
                            add(bp.MA["Saline Coat"], player)

                        -- OCCULTATION.
                        elseif target and isReady('MA', "Occultation") and not buff(36) and not bp.core.hasShadows() then
                            add(bp.MA["Occultation"], player)

                        end
        
                    end

                    -- MAGIC HAMMER.
                    if target and get('aspir').enabled and player['vitals'].mpp <= get('aspir').mpp and isReady('MA', "Magic Hammer") then
                        add(bp.MA["Magic Hammer"], target)
                    end

                    -- WINDS OF PROMY.
                    if get('winds of promy.') and isReady('MA', "Winds of Promy.") and helpers['status'].windsRemoval() then
                        add(bp.MA["Winds of Promy"], player)
                    end

                elseif get('nuke') then

                    if target and get('hate').enabled and _cast then

                        -- JETTATURA.
                        if isReady('MA', "Jettatura") then
                            add(bp.MA["Jettatura"], target)
                            
                        -- BLANK GAZE.
                        elseif isReady('MA', "Blank Gaze") then
                            add(bp.MA["Blank Gaze"], target)
                            
                        end
                        
                        if get('hate').aoe and (os.clock()-timers.hate) > get('hate').delay then
                            
                            -- SOPORIFIC.
                            if isReady('MA', "Soporific") then
                                add(bp.MA["Soporific"], target)
                                timers.hate = os.clock()
                            
                            -- GEIST WALL.
                            elseif isReady('MA', "Geist Wall") then
                                add(bp.MA["Geist Wall"], target)
                                timers.hate = os.clock()
                            
                            -- SHEEP SONG.
                            elseif isReady('MA', "Sheep Song") then
                                add(bp.MA["Sheep Song"], target)
                                timers.hate = os.clock()
        
                            -- STINKING GAS.
                            elseif isReady('MA', "Stinking Gas") then
                                add(bp.MA["Stinking Gas"], target)
                                timers.hate = os.clock()
                            
                            end
                            
                        end
        
                    end
        
                    if get('buffs') and _cast then

                        -- MIGHTY GUARD.
                        if target and get('unbridled learning') and isReady('JA', "Unbridled Learning") and not buff(485) and _act then

                            if get('diffusion') and isReady('MA', "Mighty Guard") and not buff(604) then
                                add(bp.JA["Unbridled Learning"], player)
                                add(bp.JA["Diffusion"], player)
                                add(bp.MA["Mighty Guard"], player)

                            end
                            
                        end

                        -- HASTE.
                        if not buff(93) then

                            if player.main_job_level >= 99 and isReady('MA', "Erratic Flutter") then
                                add(bp.MA["Erratic Flutter"], player)

                            elseif player.main_job_level >= 99 and isReady('MA', "Animating Wail") then
                                add(bp.MA["Animating Wail"], player)

                            elseif player.main_job_level <= 48 and isReady('MA', "Refueling") then
                                add(bp.MA["Refueling"], player)

                            end

                        end

                        -- COCOON.
                        if isReady('MA', "Cocoon") and not buff(93) then
                            add(bp.MA["Cocoon"], player)

                        -- MOMENTO MORI.
                        elseif target and isReady('MA', "Momento Mori") and not buff(91) then
                            add(bp.MA["Nature's Meditation"], player)

                        -- MAGIC BARRIER.
                        elseif isReady('MA', "Magic Barrier") and not buff(152) then
                            add(bp.MA["Magic Barrier"], player)

                        -- SALINE COAT.
                        elseif isReady('MA', "Saline Coat") and not buff(191) then
                            add(bp.MA["Saline Coat"], player)

                        -- OCCULTATION.
                        elseif target and isReady('MA', "Occultation") and not buff(36) and not bp.core.hasShadows() then
                            add(bp.MA["Occultation"], player)

                        end
        
                    end

                    -- MAGIC HAMMER.
                    if target and get('aspir').enabled and player['vitals'].mpp <= get('aspir').mpp and isReady('MA', "Magic Hammer") then
                        add(bp.MA["Magic Hammer"], target)
                    end

                    -- WINDS OF PROMY.
                    if get('winds of promy.') and isReady('MA', "Winds of Promy.") and helpers['status'].windsRemoval() then
                        add(bp.MA["Winds of Promy"], player)
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
                local isReady = bp.helpers['actions'].isReady
                local buff = bp.helpers['buffs'].buffActive
                local add = bp.helpers['queue'].add
                local get = bp.core.get

                -- Finish Weapon Skill.
                if pack['Category'] == 3 and player.id == actor.id and target and get('ws').enabled and get('chain affinity') and isReady('JA', "Chain Affinity") then

                    if bp.res.weapon_skills[param] then
                        local ws = bp.res.weapon_skills[param]

                        if ws.en == 'Expiacion' then

                            if isReady('MA', "Amorphic Spikes") then
                                
                                if isReady('JA', "Efflux") and player['vital'].tp < 2500 then
                                    add(bp.JA["Efflux"], player)
                                end
                                add(bp.JA["Chain Affinity"], player)
                                add(bp.MA["Amorphic Spikes"], target)

                            elseif isReady('MA', "Benthic Typhoon") then
                                
                                if isReady('JA', "Efflux") and player['vital'].tp < 2500 then
                                    add(bp.JA["Efflux"], player)
                                end
                                add(bp.JA["Chain Affinity"], player)
                                add(bp.MA["Benthic Typhoon"], target)

                            elseif isReady('MA', "Vertical Cleave") then
                                
                                if isReady('JA', "Efflux") and player['vital'].tp < 2500 then
                                    add(bp.JA["Efflux"], player)
                                end
                                add(bp.JA["Chain Affinity"], player)
                                add(bp.MA["Vertical Cleave"], target)

                            end

                        elseif ws.en == 'Chant du Cygne' then

                            if isReady('MA', "Amorphic Spikes") then
                                
                                if isReady('JA', "Efflux") and player['vital'].tp < 2500 then
                                    add(bp.JA["Efflux"], player)
                                end
                                add(bp.JA["Chain Affinity"], player)
                                add(bp.MA["Amorphic Spikes"], target)

                            elseif isReady('MA', "Benthic Typhoon") then
                                
                                if isReady('JA', "Efflux") and player['vital'].tp < 2500 then
                                    add(bp.JA["Efflux"], player)
                                end
                                add(bp.JA["Chain Affinity"], player)
                                add(bp.MA["Benthic Typhoon"], target)

                            end

                        elseif ws.en == 'Requiescat' then

                            if isReady('MA', "Barbed Crescent") then
                                
                                if isReady('JA', "Efflux") and player['vital'].tp < 2500 then
                                    add(bp.JA["Efflux"], player)
                                end
                                add(bp.JA["Chain Affinity"], player)
                                add(bp.MA["Barbed Crescent"], target)

                            elseif isReady('MA', "Quad. Continuum") then
                                
                                if isReady('JA', "Efflux") and player['vital'].tp < 2500 then
                                    add(bp.JA["Efflux"], player)
                                end
                                add(bp.JA["Chain Affinity"], player)
                                add(bp.MA["Quad. Continuum"], target)

                            elseif isReady('MA', "Disseverment") then
                                
                                if isReady('JA', "Efflux") and player['vital'].tp < 2500 then
                                    add(bp.JA["Efflux"], player)
                                end
                                add(bp.JA["Chain Affinity"], player)
                                add(bp.MA["Disseverment"], target)

                            end

                        end

                    end

                end

            end

        end

    end)

    return self

end
return job.get()