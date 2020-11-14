_addon.name     = 'bp3'
_addon.author   = 'Elidyr'
_addon.version  = '0.20201112 ALPHA'
_addon.command  = 'bp'

local bp = require('bp/bootstrap')
windower.register_event('addon command', function(...)
    local a = T{...}
    local c = a[1] or false

    if c then
        c = c:lower()
        
        if bp.commands[c] then
            bp.commands[c].capture(bp, a)

        elseif c == 'mode' then
            bp.helpers['maintenance'].toggle(bp)

        elseif c == 'follow' then
            local player = windower.ffxi.get_player()

            if player then
                windower.send_command(string.format('ord r* follow %s', player.name))
            end

        elseif c == 'stop' then
            bp.helpers['controls'].stop()

        elseif c == 'request_stop' then
            windower.send_command('ord r* bp stop')

        elseif c =='layout' then
            bp.helpers['layout'].toggle(bp)

        elseif c == 'info' then
            local target = windower.ffxi.get_mob_by_target('t') or false

            if target then
                table.print(target)
            end

        elseif (c == 'r' or c == 'reload') then
            windower.send_command('lua r bp3')

        else
            bp.core.handleCommands(bp, a)

        end

    end

end)

ActionPacket.open_listener(bp.helpers['noknock'].block)
windower.register_event('prerender', function()

    if windower.ffxi.get_player() then
        bp.helpers['actions'].setMoving(bp)
        bp.helpers['stratagems'].render(bp)
        bp.helpers['distance'].render(bp)
        bp.helpers['popchat'].render(bp)
        bp.helpers['bubbles'].render(bp)
        bp.helpers['debuffs'].render(bp)
        bp.helpers['target'].render(bp)
        bp.helpers['status'].render(bp)
        bp.helpers['queue'].render(bp)
        bp.helpers['runes'].render(bp)
        bp.helpers['rolls'].render(bp)
        bp.helpers['songs'].render(bp)
        bp.helpers['speed'].render(bp)
        bp.helpers['cures'].render(bp)

        if bp.settings['Enabled'] and not bp.blocked[windower.ffxi.get_info().zone] and not bp.shutdown[windower.ffxi.get_info().zone] and (os.clock() - bp.pinger) > bp.settings['Ping Delay'] then
            bp.helpers['cures'].buildParty()
            bp.core.handleAutomation(bp)

            -- Update the system pinger.
            bp.pinger = os.clock()

        elseif bp.settings['Enabled'] and bp.blocked[windower.ffxi.get_info().zone] and not bp.shutdown[windower.ffxi.get_info().zone] and (os.clock() - bp.pinger) > bp.settings['Ping Delay'] then
            bp.helpers['cures'].buildParty()
            bp.helpers['queue'].render(bp)

            -- Update the system pinger.
            bp.pinger = os.clock()

        end
        bp.helpers['target'].updateTargets(bp)

    end

end)

windower.register_event('incoming chunk', function(id, original, modified, injected, blocked)

    if id == 0x028 then
        local pack      = bp.packets.parse('incoming', original)
        local player    = windower.ffxi.get_player()
        local actor     = windower.ffxi.get_mob_by_id(pack['Actor'])
        local target    = windower.ffxi.get_mob_by_id(pack['Target 1 ID'])
        local count     = pack['Target Count']
        local category  = pack['Category']
        local param     = pack['Param']
        
        if actor and target then

            -- Melee Attacks.
            if pack['Category'] == 1 then

            -- Finish Ranged Attack.
            elseif pack['Category'] == 2 then

                if actor.name == player.name then
                    bp.helpers['queue'].ready = (os.clock() + bp.helpers['actions'].getDelays(bp)['Ranged'])
                    
                    -- Remove from action from queue.
                    bp.helpers['queue'].remove(bp, helpers['actions'].unique.ranged, actor)

                end

                -- Finish Weaponskill.
            elseif pack['Category'] == 3 then

                if actor.name == player.name then
                    bp.helpers['queue'].ready = (os.clock() + bp.helpers['actions'].getDelays(bp)['WeaponSkill'])
                    
                    -- Remove from action from queue.
                    bp.helpers['queue'].remove(bp.res.weapon_skills[param], actor)

                end

                -- Finish Spell Casting.
            elseif pack['Category'] == 4 then

                if actor.name == player.name then
                    local spell  = bp.res.spells[param] or false

                    if spell and type(spell) == 'table' and spell.type then
                        bp.helpers['queue'].ready = (os.clock() + bp.helpers['actions'].getDelays(bp)[spell.type] or 1)

                        -- Remove from action from queue.
                        bp.helpers['queue'].remove(bp, spell, actor)

                        -- Update Cure weights.
                        bp.helpers['cures'].updateWeight(bp, original)
                    
                    else
                        bp.helpers['queue'].ready = (os.clock() + 1)

                    end

                end

            -- Finish using an Item.
            elseif pack['Category'] == 5 then

                if actor.name == player.name then
                    bp.helpers['queue'].ready = (os.clock() + bp.helpers['actions'].getDelays(bp)['Item'] or 1)

                    -- Remove from action from queue.
                    bp.helpers['queue'].remove(bp, bp.res.items[param], actor)

                end

            -- Use Job Ability.
            elseif pack['Category'] == 6 then
                local rolls = bp.res.job_abilities:type('CorsairRoll')
                local runes = bp.res.job_abilities:type('Rune')

                if actor.name == player.name then
                    local action = bp.helpers['actions'].buildAction(bp, category, param)
                    local delay  = bp.helpers['actions'].getActionDelay(bp, action) or 1

                    if action then
                        --bp.helpers['actions'].midaction = false
                        bp.helpers['queue'].ready = (os.clock() + delay)

                        -- Remove from action from queue.
                        bp.helpers['queue'].remove(bp, bp.res.job_abilities[param], actor)
                        
                        -- Handle Specialty Abilities.
                        if action.type == 'CorsairRoll' and rolls[param] then
                            bp.helpers['rolls'].add(bp, bp.helpers['rolls'].getRoll(bp, rolls[param].en))
                            bp.helpers['rolls'].diceTotal(bp, pack['Target 1 Action 1 Param'])

                        elseif param == 123 then
                            bp.helpers['rolls'].diceTotal(bp, pack['Target 1 Action 1 Param'])

                        end

                    else
                        bp.helpers['queue'].ready = (os.clock() + 1)

                    end

                elseif actor.name ~= player.name and actor.spawn_type == 16 and bp.res.monster_abilities[param] then

                    if helpers['stunner'].stunnable(bp, param) then
                        helpers['stunner'].stun(bp, param, actor)
                    end

                end

            -- Use Weaponskill.
            elseif pack['Category'] == 7 then

                if actor.name == player.name then
                    local param  = pack['Target 1 Action 1 Param']
                    local action = bp.helpers['actions'].buildAction(bp, category, param)
                    local delay  = bp.helpers['actions'].getActionDelay(bp, action) or 1

                    if param == 24931 then
                        bp.helpers['queue'].ready = (os.clock() + delay)

                    elseif param == 28787 then
                        bp.helpers['queue'].ready = (os.clock() + 1)

                    else
                        bp.helpers['queue'].ready = (os.clock() + 1)

                    end


                end

            -- Begin Spell Casting.
            elseif pack['Category'] == 8 then

                if actor.name == player.name then

                    if param == 24931 then
                        local param  = pack['Target 1 Action 1 Param']
                        local action = bp.helpers['actions'].buildAction(bp, category, param)
                        local delay  = bp.helpers['actions'].getActionDelay(bp, action) or 1

                        do  -- Update ready status.
                            bp.helpers['queue'].ready = (os.clock() + delay)
                        end

                    elseif param == 28787 then
                        bp.helpers['queue'].ready = (os.clock() + 1)

                    else
                        bp.helpers['queue'].ready = (os.clock() + 1)

                    end

                end

            -- Begin Item Usage.
            elseif pack['Category'] == 9 then

                -- Make sure that I am using an item.
                if actor.name == player.name then

                    if param == 24931 then
                        local param  = pack['Target 1 Action 1 Param']
                        local action = bp.helpers['actions'].buildAction(bp, category, param)
                        local delay  = bp.helpers['actions'].getActionDelay(bp, action) or 1

                        do  -- Update ready status.
                            bp.helpers['queue'].ready = (os.clock() + delay)
                        end

                    elseif param == 28787 then
                        bp.helpers['queue'].ready = (os.clock() + 1)

                    else
                        bp.helpers['queue'].ready = (os.clock() + 1)

                    end

                end

            -- NPC TP Move.
            elseif pack['Category'] == 11 then

            -- Begin Ranged Attack.
            elseif pack['Category'] == 12 then

                if actor.name == player.name then
                    
                    if param == 24931 then
                        local param  = pack['Target 1 Action 1 Param']
                        local action = bp.helpers['actions'].buildAction(bp, category, param)
                        local delay  = bp.helpers['actions'].getActionDelay(bp, action) or 1
                        
                        do  -- Update ready status.
                            bp.helpers['queue'].ready = (os.clock() + delay)
                        end

                    elseif param == 28787 then
                        bp.helpers['queue'].ready = (os.clock() + 1)

                    else
                        bp.helpers['queue'].ready = (os.clock() + 1)

                    end

                end

            -- Finish Pet Ability / Weaponskill.
            elseif pack['Category'] == 13 then

                -- Make sure that I am using the ability.
                if actor.name == player.name then
                    local action = bp.helpers['actions'].buildAction(bp, category, param)
                    local delay  = bp.helpers['actions'].getActionDelay(bp, action) or 1

                    if action then
                        bp.helpers['queue'].ready = (os.clock() + delay)

                        -- Remove from action from queue.
                        bp.helpers['queue'].remove(bp, res.job_abilities[param], actor)

                    end

                end

            -- DNC Abilities
            elseif pack['Category'] == 14 then

                if actor.name == player.name then
                    local action = bp.helpers['actions'].buildAction(bp, category, param)
                    local delay  = bp.helpers['actions'].getActionDelay(bp, action) or 1

                    if action then
                        bp.helpers['queue'].ready = os.clock() + delay

                        -- Remove from action from queue.
                        bp.helpers['queue'].remove(bp, res.job_abilities[param], actor)

                        -- Update Cure weights.
                        bp.helpers['cures'].updateWeight(bp, original)

                    end

                end

            -- RUN Abilities
            elseif pack['Category'] == 15 then

                if actor.name == player.name then
                    local action = bp.helpers['actions'].buildAction(bp, category, param)
                    local delay  = bp.helpers['actions'].getActionDelay(bp, action) or 1

                    if action then
                        bp.helpers['queue'].ready = os.clock() + delay

                        -- Remove from action from queue.
                        bp.helpers['queue'].remove(bp, res.job_abilities[param], actor)

                    end

                end
            
            else
                bp.helpers['queue'].ready = (os.clock() + 1)

            end

            -- Handle Status Debuffing.
            bp.helpers['status'].catchStatus(bp, original)

        end

    end

end)

windower.register_event('outgoing chunk', function(id, original, modified, injected, blocked)

    if id == 0x01a then
        local packed = bp.packets.parse('outgoing', original)

        if packed and packed['Category'] == 3 then

            if bp.helpers['bubbles'].isGeoSpell(bp, packed['Param']) then
                local inject = bp.packets.build(bp.helpers['bubbles'].offsetBubble(bp, packed['Target'], packed['Param'], packed['Category']))

                if inject then
                    return inject
                end

            end
            return original

        end
    
    elseif id == 0x050 then
        coroutine.schedule(bp.helpers['equipment'].update, 1)

    end

end)

windower.register_event('incoming chunk', function(id, original, modified, injected, blocked)

    if id == 0x00e then
        return bp.helpers['models'].adjustModel(bp, original)

    elseif id == 0x029 then
        --bp.helpers['status'].messages(bp, original)

    elseif id == 0x037 then
        local packed = bp.packets.parse('incoming', original)

        if packed then
            local player = windower.ffxi.get_player()
            
            -- Update saved packet data for injection.
            if player and player.id == packed['Player'] and packed['Status'] ~= 31 then
                bp.helpers['maintenance'].updateData(bp, original)
            end

        end
        return bp.helpers['speed'].adjustSpeed(bp, original)
    
    elseif id == 0x063 then
        local check = original:unpack('H', 0x04+1)

        if check == 9 then
            local player = windower.ffxi.get_player() or false
            
            if player then
                local buffs = { list={original:unpack('H32', 0x08+1)}, count=0 }

                -- Track buff count.
                for i=1, 32 do

                    if buffs.list[i] ~= 255 then
                        buffs.count = (buffs.count + 1)
                    end

                end
                
                if bp.helpers['buffs'].buffs then

                    for i=0, 32 do

                        if buffs.list[i] ~= bp.helpers['buffs'].buffs[i] then

                            -- Gained a buff.
                            if not T(bp.helpers['buffs'].buffs):contains(buffs.list[i]) and buffs.list[i] ~= nil then

                                if bp.res.buffs[buffs.list[i]] then
                                    local gain = bp.res.buffs[buffs.list[i]]
                                    
                                    if (player.main_job == 'COR' or player.sub_job == 'COR') then

                                        if gain.id == 308 then
                                            bp.helpers['rolls'].rolling = true
                                        
                                        elseif bp.helpers['rolls'].validBuff(bp, gain.id) then
                                            local rolls = bp.res.job_abilities:type('CorsairRoll')
                                            
                                            if gain.id == 309 then
                                                bp.helpers['rolls'].add(bp, bp.res.buffs[309])
                                                bp.helpers['rolls'].rolling = false
                                                bp.helpers['rolls'].rolled  = 0

                                            end

                                        end

                                    end

                                end

                            end

                            -- Lost a buff.
                            if not T(buffs.list):contains(bp.helpers['buffs'].buffs[i]) and bp.helpers['buffs'].buffs[i] ~= nil then

                                if bp.res.buffs[bp.helpers['buffs'].buffs[i]] then
                                    local lost = bp.res.buffs[bp.helpers['buffs'].buffs[i]]
                                        
                                    if (player.main_job == 'COR' or player.sub_job == 'COR') then
                                        
                                        if lost.id == 308 then
                                            bp.helpers['rolls'].rolling = false
                                            bp.helpers['rolls'].rolled  = 0

                                        elseif bp.helpers['rolls'].validBuff(bp, lost.id) then
                                            bp.helpers['rolls'].remove(bp, lost.id)

                                        end

                                    end

                                end

                            end

                        end

                    end

                end
                bp.helpers['buffs'].buffs = buffs.list
                bp.helpers['buffs'].count = buffs.count

            end

        end

    end

end)

windower.register_event('status change', function(new, old)
    
    if new == 1 then
        local target = windower.ffxi.get_mob_by_target('t') or false

        if target then
            bp.helpers['target'].setTarget(bp, target)
        end

    elseif new == 0 then
        bp.helpers['target'].clear()

    end

    -- Handle ping delay if you were previously dead.
    if new == 0 and (old == 2 or old == 3) then
        bp.pinger = (os.clock() + 60)
    end

end)

windower.register_event('zone change', function(new, old)

    -- Delay pinger to prevent spam.
    bp.pinger = (os.clock() + 10)

    -- Handle all helpers zone change function.
    for _,helper in pairs(bp.helpers) do

        if helper.zoneChange then
            helper.zoneChange()        
        end

    end

end)

windower.register_event('job change', function(...)
    bp.buildCore(true)

    -- Handle all helpers job change function.
    for _,helper in pairs(bp.helpers) do

        if helper.jobChange then
            helper.jobChange()        
        end

    end

end)

windower.register_event('party invite', function(sender, id)
    local whitelist = T(bp.settings['Auto Join'])
    
    if whitelist and whitelist:contains(sender) then
        windower.send_command('input /join')
    end

end)

windower.register_event('unload', function()
    bp.helpers['alias'].unbind()
    bp.helpers['keybinds'].unbind()
    bp.helpers['autoload'].unload()

end)

windower.register_event('chat message', function(message, sender, mode, gm)
    bp.helpers['commands'].captureChat(bp, message, sender, mode, gm)

end)

local drag = 1
windower.register_event('mouse', function(param, x, y, delta, blocked)
    local player = windower.ffxi.get_player()
    
    if player then

        -- Set dragging.
        if (param == 1 or param == 2) then
            drag = ( drag == 1 and 2 or 1 )
        end

        if player.main_job == 'BRD' and param == 0 then
            local jukebox   = bp.helpers['songs'].jukebox
            local display   = bp.helpers['songs'].display
            local icon      = bp.helpers['songs'].icon
            
            if jukebox:length() > 0 and icon:hover(x, y) and not display:visible() then
                bp.helpers['songs'].updatePosition()
                display:show()

            elseif jukebox:length() > 0 and icon:hover(x, y) and display:visible() and drag == 2 then
                bp.helpers['songs'].updatePosition()
                display:update()

            elseif not icon:hover(x, y) and display:visible() then
                bp.helpers['songs'].updatePosition()
                display:hide()

            end
        
        elseif (player.main_job == 'SCH' or player.sub_job == 'SCH') and param == 0 then
            local display = bp.helpers['stratagems'].display

            if display:visible() and display:hover(x, y) and drag == 2 then
                bp.helpers['stratagems'].updatePosition(x, y)
            end

        elseif (player.main_job == 'SCH' or player.sub_job == 'SCH') and param == 2 then
            local display = bp.helpers['stratagems'].display

            if display:visible() and display:hover(x, y) then
                bp.helpers['stratagems'].writeSettings()
            end

        end

    end

end)