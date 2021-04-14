_addon.name     = 'bp3'
_addon.author   = 'Elidyr'
_addon.version  = '1.20210413'
_addon.command  = 'bp'

-- Get system data.
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

        elseif c == 'info' then
            local target    = windower.ffxi.get_mob_by_target('t') or false
            local zone      = windower.ffxi.get_info().zone

            if target and zone then
                print(string.format('Target ID: %s', target.id))
                print(string.format('Target Index: %s', target.index))
                print(string.format('Zone ID: %s', zone))
                table.print(target)
            end

        elseif c == 'trade' and a[2] then
            local player    = windower.ffxi.get_player() or false
            local target    = windower.ffxi.get_mob_by_target('t') or false
            local items     = {}

            if player and target and target.id and target.id ~= player.id then
                
                for i=2, #a do
                    
                    if a[i] and (a[i]):match(':') then
                        local split = a[i]:split(':')

                        if bp.helpers['inventory'].findItemByName(split[1]) and split[2] and tonumber(split[2]) ~= nil then
                            table.insert(items, {name=bp.helpers['inventory'].findItemByName(split[1]).en, count=tonumber(split[2])})
                        end

                    end

                end
                
                if items and items[1] then
                    bp.helpers['actions'].tradeItem(bp, target, #items, unpack(items))
                end

            end

        elseif (c == 'r' or c == 'reload') then
            windower.send_command('lua r bp3')

        elseif c == 'test' then
            local party = windower.ffxi.get_party()
            for i,v in pairs(party) do

                if (i:sub(1,1) == "p" or i:sub(1,1) == "a") and tonumber(i:sub(2)) ~= nil then
                    
                    if v and type(v) == 'table' and v.mob then
                        
                        for ii,vv in pairs(v.mob) do
                            print(ii,vv)
                        end

                    end

                end

            end

        else
            bp.core.handleCommands(bp, a)

        end

    end

end)

ActionPacket.open_listener(bp.helpers['noknock'].block)
windower.register_event('prerender', function()
    local player = windower.ffxi.get_player() or false

    if player and player.status ~= 4 then
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
        bp.helpers['dax'].render(bp)
        bp.helpers['coms'].render(bp)
        bp.helpers['assist'].render(bp)

        if bp.helpers['empyrean'] then
            bp.helpers['empyrean'].render(bp)
        end

        if (player.status == 2 or player.status == 3) and player.vitals.hp <= 0 and bp.helpers['target'].getTarget() then
            bp.helpers['target'].clear()
        end

        if bp.settings['Enabled'] and not bp.blocked[windower.ffxi.get_info().zone] and not bp.shutdown[windower.ffxi.get_info().zone] and (os.clock() - bp.pinger) > bp.settings['Ping Delay'] then
            
            if not bp.helpers['idle'].getIdle() and not bp.helpers['buffs'].buffActive(69) and not bp.helpers['buffs'].buffActive(71) then
                bp.helpers['cures'].buildParty()
                bp.helpers['controls'].checkFacing(bp)
                bp.helpers['controls'].checkDistance(bp)
                bp.helpers['controls'].checkAssisting(bp)
                bp.core.handleAutomation(bp)

                if bp.helpers['empyrean'] then
                    bp.helpers['empyrean'].scan(bp)
                end

                -- Handle using bagged goods.
                bp.helpers['items'].queueItems(bp)

            end            

            -- Update the system pinger.
            bp.pinger = os.clock()

        elseif bp.settings['Enabled'] and bp.blocked[windower.ffxi.get_info().zone] and not bp.shutdown[windower.ffxi.get_info().zone] and (os.clock() - bp.pinger) > bp.settings['Ping Delay'] then

            if not bp.helpers['idle'].getIdle() and not bp.helpers['buffs'].buffActive(69) and not bp.helpers['buffs'].buffActive(71) then
                bp.helpers['cures'].buildParty()
                bp.helpers['queue'].render(bp)

                -- Handle using bagged goods.
                bp.helpers['items'].queueItems(bp)
                bp.helpers['queue'].handle(bp)

            end            

            -- Update the system pinger.
            bp.pinger = os.clock()

        end
        bp.helpers['target'].updateTargets(bp, player)
        
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

                        -- Check for Utsusemi, and protect from over casting.
                        if (player.main_job == 'NIN' or player.sub_job == 'NIN') and (spell.en):match('Utsusemi') then
                            bp.core['UTSU BLOCK'].last = os.clock()
                        end
                    
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
                        bp.helpers['queue'].remove(bp, bp.res.job_abilities[param], actor)

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
                        bp.helpers['queue'].remove(bp, bp.res.job_abilities[param], actor)

                    end

                end
            
            else
                bp.helpers['queue'].ready = (os.clock() + 1)

            end
            bp.helpers['status'].catchStatus(bp, original)
            bp.helpers['burst'].registerSkillchain(bp, original)

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
        coroutine.schedule(bp.helpers['equipment'].update, 2)

    elseif id == 0x015 then

        if not blocked then
            local packed = bp.packets.parse('outgoing', original)

            if bp.helpers['actions'].locked.flag then
                packed['X'], packed['Y'], packed['Z'] = bp.helpers['actions'].locked.x, bp.helpers['actions'].locked.y, bp.helpers['actions'].locked.z
                return bp.packets.build(packed)

            end

        end

    end

end)

windower.register_event('incoming chunk', function(id, original, modified, injected, blocked)

    if id == 0x00e then
        bp.helpers['empyrean'].find(bp, original)
        return bp.helpers['models'].adjustModel(bp, original)

    elseif id == 0x029 then
        bp.helpers['status'].lostStatus(bp, original)

    elseif id == 0x0dd then
        bp.helpers['party'].updateJobs(bp, original)

    elseif id == 0x034 then
        local menu_hacks = bp.helpers['menus'].enabled

        if menu_hacks and not injected then
            return bp.helpers['menus'].capture(bp, original)

        elseif not menu_hacks then

            if bp.helpers['sparks'].busy then
                bp.helpers['sparks'].purchase(bp, original)

            elseif bp.helpers['accolades'].busy then
                bp.helpers['accolades'].purchase(bp, original)

            elseif bp.helpers['ciphers'].busy then
                return bp.helpers['ciphers'].build(bp, original)

            elseif bp.helpers['chests'].busy then
                return bp.helpers['chests'].handleChest(bp, original)

            end

        end

    elseif id == 0x05c then

        --[[
        if bp.helpers['menus'].enabled and not injected then
            local unpacked  = { original:sub(5,36):unpack("C32") }
            local packed    = {}
            
            for i,v in ipairs(unpacked) do
                packed[i] = ('C'):pack(200)
            end
            windower.packets.inject_incoming(0x05c, original:sub(1,4)..table.concat(packed, ''))
            return true

        end
        ]]

    elseif id == 0x03C then
        local money = false

        if bp.files.new('bp/helpers/moneyteam/moneyteam.lua'):exists() then
            money = dofile(string.format('%sbp/helpers/moneyteam/moneyteam.lua', windower.addon_path))
        end

        if money then
            
        end

    elseif id == 0x058 then

    elseif id == 0x037 then
        local packed = bp.packets.parse('incoming', original)

        if packed then
            local player = windower.ffxi.get_player()

            -- Update saved packet data for injection.
            if player and player.id == packed['Player'] and packed['Status'] ~= 31 then
                bp.helpers['maintenance'].updateData(bp, original)
            end

        end
        return bp.helpers['speed'].adjustSpeed(bp, id, original)

    elseif id == 0x00d then
        local packed = bp.packets.parse('incoming', original)

        if packed then
            local player = windower.ffxi.get_player()

            if player and player.id == packed['Player'] then
                return bp.helpers['speed'].adjustSpeed(bp, id, original)
            end

        end

    elseif id == 0x111 then
        bp.helpers['roe'].update(bp, original)
    
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
    local reset = T{2,3,4,5,33,38,39,40,41,42,43,44,47,48,51,52,53,54,55,56,57,58,59,60,61,85}

    -- Reset the queue if any of these statuses.
    if reset:contains(new) then
        bp.helpers['queue'].clear()
    end

    -- Handle ping delay if you were previously dead.
    if new == 0 and (old == 2 or old == 3) then
        bp.pinger = (os.clock() + 30)

    elseif new == 0 and old == 1 then
        bp.helpers['queue'].clear()

    end
    bp.helpers['actions'].locked.flag = false

end)

windower.register_event('gain buff', function(id)
    local id = id or false
    
    if id then

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
    bp.helpers['actions'].locked.flag = false

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

windower.register_event('incoming text', function(original, modified, o_mode, m_mode, blocked)

    if bp.helpers['empyrean'] then
        bp.helpers['empyrean'].parseText(bp, original, o_mode)
    end

end)

windower.register_event('party invite', function(sender, id)
    local whitelist = T(bp.settings['Auto Join'])
    
    if whitelist and whitelist:contains(sender) then
        windower.send_command('wait 0.5; input /join')
    end

end)

windower.register_event('login', function()

    coroutine.schedule(bp.helpers['equipment'].update, 2)
    bp.helpers['autoload'].load()

end)

windower.register_event('logout', function()
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

windower.register_event('ipc message', function(message)
    local message = message or false

    if message then

        if message:sub(1,4) == 'coms' then
            bp.helpers['coms'].catch(message)

        elseif message:sub(1,6) == 'assist' then
            bp.helpers['assist'].catch(bp, message)

        end

    end

end)

windower.register_event('time change', function(new, old)

    if new then
        bp.helpers['assist'].assist(bp)
    end

end)
