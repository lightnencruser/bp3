local actions   = {}
local res       = require('resources')

function actions.new()
    local self = {}

    -- Static Variables.
    local categories    = {[6]='JobAbility',[7]='WeaponSkill',[8]='Magic',[9]='Item',[12]='Ranged',[13]='JobAbility',[14]='JobAbility',[15]='JobAbility'}
    local types         = {['Magic']={res='spells'},['Trust']={res='spells'},['JobAbility']={res='job_abilities'},['WeaponSkill']={res='weapon_skills'},['Item']={res='items'},['Ranged']={res='none'}}
    local ranges        = {[0]=255,[2]=3.40,[3]=4.47,[4]=5.76,[5]=6.89,[6]=7.80,[7]=8.40,[8]=10.40,[9]=12.40,[10]=14.50,[11]=16.40,[12]=20.40,[13]=23.4}
    local actions       = {

        ['interact']    = 0,    ['engage']          = 2,    ['/magic']          = 3,    ['magic']           = 3,    ['/mount'] = 26,
        ['disengage']   = 4,    ['/help']           = 5,    ['help']            = 5,    ['/weaponskill']    = 7,
        ['weaponskill'] = 7,    ['/jobability']     = 9,    ['jobability']      = 9,    ['return']          = 11,
        ['/assist']     = 12,   ['assist']          = 12,   ['accept raise']    = 13,   ['/fish']           = 14,
        ['fish']        = 14,   ['switch target']   = 15,   ['/range']          = 16,   ['range']           = 16,
        ['/dismount']   = 18,   ['dismount']        = 18,   ['zone']            = 20,   ['accept tractor']  = 19,
        ['mount']       = 26,

    }

    local delays = {

        ['Misc']        = 1.5,  ['WeaponSkill']     = 0.6,  ['Item']            = 2.7,    ['JobAbility']    = 0.6,
        ['CorsairRoll'] = 1.5,  ['CorsairShot']     = 0.6,  ['Samba']           = 0.6,    ['Waltz']         = 0.6,
        ['Jig']         = 0.6,  ['Step']            = 0.6,  ['Flourish1']       = 0.6,    ['Flourish2']     = 0.6,
        ['Flourish3']   = 0.6,  ['Scholar']         = 0.6,  ['Effusion']        = 0.6,    ['Rune']          = 0.6,
        ['Ward']        = 0.6,  ['BloodPactRage']   = 0.6,  ['BloodPactWard']   = 0.6,    ['PetCommand']    = 0.6,
        ['Monster']     = 1.0,  ['Dismount']        = 1.0,  ['Ranged']          = 1.0,    ['WhiteMagic']    = 2.7,
        ['BlackMagic']  = 2.7,  ['BardSong']        = 2.7,  ['Ninjutsu']        = 2.7,    ['SummonerPact']  = 2.7,
        ['BlueMagic']   = 2.7,  ['Geomancy']        = 2.7,  ['Trust']           = 2.7,

    }

    -- Public Variables.
    self.locked     = {flag=false, x=0, y=0, z=0}
    self.midaction  = false
    self.moving     = false
    self.injecting  = false
    self.allowed    = {act=true, move=true, cast=true, item=true, move=true}
    self.position   = {x=0, y=0, z=0}
    self.unique     = {

        ranged = {id=65536,en='Ranged',element=-1,prefix='/ra',type='Ranged', range=13},

    }

    -- Static Functions.
    self.doAction = function(target, param, action, x, y, z)
        local x, y, z = x or 0, y or 0, z or 0

        if target and action and actions[action] and not self.midaction and not self.injecting and not windower.ffxi.get_info().mog_house then
            windower.packets.inject_outgoing(0x01a, ('iIHHHHfff'):pack(0x00001A00, target.id, target.index, actions[action], param or 0, 0, x, z, y))
        end

    end

    self.synthItem = function(bp, crystal, ingredients, materials)
        local bp            = bp or false
        local crystal       = bp.libraries['inventory'].findItemByName(crystal) or false
        local materials     = T(materials) or false
        local ingredients   = ingredients or 1
        
        if bp and crystal and materials then
            local crystal   = {name=crystal.en, id=crystal.id, index=bp.libraries['inventory'].findItemIndexByName(crystal.en)}
            local n         = 1
            
            -- Build Basic Packet.
            local synth = bp.packets.new("outgoing", 0x096, {
                
                ['_unknown1']           = 0,
                ['_unknown2']           = 0,
                ['Crystal']             = crystal.id,
                ['Crystal Index']       = crystal.index,
                ['Ingredient count']    = ingredients,

            })

            -- Rebuild the packet based on material data.
            for _,material in ipairs(materials) do

                if material and material.count then
                    local item  = bp.libraries['inventory'].findItemIndexByName(material.name, 0, material.count) or false
                    local count = bp.libraries['inventory'].getCountByIndex(item)
                    
                    if count and count >= material.count then

                        for ii=1, material.count do
                            synth[string.format('Ingredient %s', n)] = bp.libraries['inventory'].findItemByIndex(item).id
                            synth[string.format('Ingredient Index %s', n)] = item
                            n = n + 1

                        end

                    else
                        return false

                    end

                else
                    synth[string.format('Ingredient %s', n)] = 0
                    synth[string.format('Ingredient Index %s', n)] = 0

                end

            end

            -- Build _unknown1 packet data.
            local c  = ((crystal.id % 6506) % 4238) % 4096
            local m  = (c + 1) * 6 + 77
            local b  = (c + 1) * 42 + 31
            local m2 = (8 * c + 26) + (synth['Ingredient 1'] - 1) * (c + 35)
            synth['_unknown1'] = ((m * synth['Ingredient 1'] + b + m2 * (ingredients - 1)) % 127)
            
            if (n-1) == ingredients then
                bp.packets.inject(synth)
            end

        end

    end

    self.buyItem = function(slot, quantity)
        local slot      = slot or false
        local quantity  = quantity or 1

        if slot and quantity > 0 then
            windower.packets.inject_outgoing(0x083, ('iIHCCI'):pack(0x00008308, quantity, 0, slot, 0, 0))
        end

    end

    self.tradeItem = function(bp, npc, total, ...)
        local bp    = bp or false
        local npc   = npc or false
        local items = T{...} or false
        local total = total or false
        
        if bp and npc and items and total and npc.id and npc.index then
            local inventory = windower.ffxi.get_items(0)
            local blocked   = T{}
            local update    = false

            -- Build the trade packet.
            local trade = bp.packets.new('outgoing', 0x036, {
                
                ['Target']          = npc.id,
                ['Target Index']    = npc.index,
                ['Number of Items'] = total,

            })
            
            for i=1, #items do
                
                if items[i].name and items[i].count then
                    
                    for index, item in ipairs(inventory) do
                        
                        if bp.res.items[item.id] and bp.res.items[item.id].en == items[i].name then
                            
                            if index and item and item.id and item.count and items[i].count <= item.count and not blocked:contains(index) then
                                trade[string.format('Item Index %s', i)] = index
                                trade[string.format('Item Count %s', i)] = items[i].count
                                update = true

                                -- Block this index from repeating!
                                table.insert(blocked, index)
                                break

                            end

                        end

                    end
                    
                    if not update then
                        trade[string.format('Item Index %s', i)] = 0
                        trade[string.format('Item Count %s', i)] = 0

                    end

                else
                    trade[string.format('Item Index %s', i)] = 0
                    trade[string.format('Item Count %s', i)] = 0

                end
                bp.packets.inject(trade)

            end

        end
        return false

    end

    self.canCast = function()
        local player  = windower.ffxi.get_player() or false
        local ready   = {[0]=0,[1]=1}

        if player and ready[player.status] and not self.injecting and not self.moving then

            if player.buffs then
                local bad = T{[0]=0,[2]=2,[6]=6,[7]=7,[10]=10,[14]=14,[17]=17,[19]=19,[22]=22,[28]=28,[29]=29,[193]=193,[252]=252}

                for _,v in ipairs(player.buffs) do

                    if bad[v] then
                        return false
                    end

                end

            end

        end
        return true
    
    end

    self.canAct = function(bp)
        local player  = windower.ffxi.get_player()
        local ready   = {[0]=0,[1]=1}

        if player and ready[player.status] and not self.injecting then

            if player.buffs then
                local bad = T{[0]=0,[2]=2,[7]=7,[10]=10,[14]=14,[16]=16,[17]=17,[19]=19,[22]=22,[193]=193,[252]=252}

                for _,v in ipairs(player.buffs) do

                    if bad[v] then
                        return false
                    end

                end

            end

        end
        return true

    end

    self.canItem = function(bp)
        local player  = windower.ffxi.get_player() or false
        local ready   = {[0]=0,[1]=1}

        if player and ready[player.status] and not self.injecting and not self.moving then

            if player.buffs then
                local bad = T{[473]=473,[252]=252}

                for _,v in ipairs(player.buffs) do

                    if bad[v] then
                        return false
                    end

                end

            end

        end
        return true

    end

    self.canMove = function(bp)
        local player  = windower.ffxi.get_player() or false
        local ready   = {[0]=0,[1]=1,[10]=10,[11]=11,[85]=85}

        if player and ready[player.status] and not self.injecting then

            if player.buffs then
                local bad = T{[0]=0,[2]=2,[7]=7,[11]=11,[14]=14,[17]=17,[19]=19,[22]=22,[193]=193,[252]=252}

                for _,v in ipairs(player.buffs) do

                    if bad[v] then
                        return false
                    end

                end

            end

        end
        return true

    end


    -- Public Functions.
    self.isReady = function(bp, category, name)
        local bp          = bp or false
        local player      = windower.ffxi.get_player() or false
        local category    = category or false

        if bp and player and category then
            local JA, MA, WS = bp.JA, bp.MA, bp.WS

            if category == 'JA' then
                local action = JA[name] or false

                if action and self.allowed.act then

                    if (action.prefix == '/jobability' or action.prefix == '/pet') then
                        local skills = windower.ffxi.get_abilities().job_abilities
                        local recast = windower.ffxi.get_ability_recasts()

                        if skills then

                            for _,v in ipairs(skills) do

                                if v == action.id then

                                    if recast[action.recast_id] and recast[action.recast_id] < 1 then
                                        return true
                                    end

                                end

                            end

                        end

                    end

                end

            elseif category == 'MA' then
                local action  = MA[name] or false
                local job     = {main = {id=player.main_job_id, level=player.main_job_level}, sub = {id=player.sub_job_id, level=player.sub_job_level}}

                if action and self.allowed.cast then
                    local spells = windower.ffxi.get_spells()
                    local recast = windower.ffxi.get_spell_recasts()

                    if spells and spells[action.id] and recast[action.recast_id] and recast[action.recast_id] < 1 then
                        local main    = action.levels[job.main.id] or 0
                        local sub     = action.levels[job.sub.id] or 0

                        if (job.main.level >= main or job.sub.level >= sub) then
                            return true
                        end

                    end

                end

            elseif category == 'WS' then
                local action = WS[name] or false
                local skills = windower.ffxi.get_abilities().weapon_skills

                if self.allowed.act and action and player['vitals'].tp > 999 then

                    for _,v in ipairs(skills) do

                        if action.id == v then
                            return true
                        end

                    end

                end

            end

        end
        return false

    end

    self.useItem = function(bp, item, target, bag)
        local bp      = bp or false
        local target  = target or windower.ffxi.get_player()
        local bag     = bag or 0

        if bp and target and item and not self.midaction then
            local helpers = bp.helpers
            local temp    = helpers['inventory'].findItemByName(bp, item)
            local index   = select(1, helpers['inventory'].findItemById(bp, temp.id))

            if type(index) == 'number' then
                windower.packets.inject_outgoing(0x037, ('iIIHCCCCCC'):pack(0x00003700, target.id, 1, target.index, index, bag, 0, 0, 0, 0))
            end

        end

    end

    self.equipItem = function(bp, name, slot)
        local bp = bp or false

        if bp and name and not self.midaction then
            local helpers = bp.helpers
            local bag = helpers['items'].findBag(name)

            if bag and slot and type(slot) == 'number' then
                local temp = helpers['items'].findItemByName(name, bag)
                local bags = {0,8,10,11,12}
                local bag, item

                for i,v in ipairs(bags) do

                    if helpers['items'].findItemById(temp.id, v) then
                        item, bag = helpers['items'].findItemById(temp.id, v), v
                    end

                end

                if type(select(1, item)) == 'number' then
                    windower.packets.inject_outgoing(0x050, ('iCCCC'):pack(0x00005000, select(1, item), slot, bag, 0))
                end

            end

        end

    end

    self.turn = function(bp, x, y)
        local bp      = bp or false
        local x       = x or false
        local y       = y or false
        local player  = windower.ffxi.get_mob_by_target('me') or false

        if player then
            windower.ffxi.turn(-math.atan2(y-player.y, x-player.x))
        end

    end

    self.face = function(bp, mob)
        local player  = windower.ffxi.get_mob_by_target('me')
        local mob     = mob or false

        if player and mob then
            windower.ffxi.turn(((math.atan2((mob.y - player.y), (mob.x - player.x))*180/math.pi)*-1):radian())
        end

    end

    self.move = function(bp, x, y)
        local bp = bp or false
        local me = windower.ffxi.get_mob_by_target("me") or false
        
        if bp and me then
            windower.ffxi.turn(-math.atan2(y-me.y, x-me.x))
            windower.ffxi.run(-math.atan2(y-me.y, x-me.x))
            
        end
        
    end

    self.stop = function()
        windower.ffxi.run(false)
    end

    self.acceptRaise = function(bp)
        windower.packets.inject_outgoing(0x01a, ('iIHHHHfff'):pack(0x1A0E3C0A, player.id, player.index, 13, 0, 0, 0, 0, 0))
    end

    self.setMoving = function(bp)
        local bp        = bp or false
        local player    = windower.ffxi.get_mob_by_target('me') or false
        local ready     = {[0]=0,[1]=1,[10]=10,[11]=11,[85]=85}

        if bp and  player then

            if (player.x ~= self.position.x or player.y ~= self.position.y) then
                self.position.x   = player.x
                self.position.y   = player.y
                self.position.z   = player.z
                self.moving       = true

                do -- Turn the player idle they have not been moving for longer than 30 minutes.
                    bp.helpers['idle'].activate(bp)
                end

            else
                self.position.x   = player.x
                self.position.y   = player.y
                self.position.z   = player.z
                self.moving       = false

                do -- Turn the player idle they have not been moving for longer than 30 minutes.
                    bp.helpers['idle'].isIdle(bp)
                end

            end

        else
            self.position.x   = 0
            self.position.y   = 0
            self.position.z   = 0
            self.moving       = true

        end

    end

    self.getRanges = function(bp)
        local bp = bp or false
        return ranges
    end

    self.getActionRange = function(bp, action)
        local bp      = bp or false
        local action  = action or false

        if action and type(action) == 'table' and action.range and ranges[action.range] then
            return ranges[action.range]
        end
        return 999

    end

    self.getDelays = function(bp)
        return delays
    end

    self.buildAction = function(bp, category, param)
        local bp = bp or false

        if category and param and categories[category] then
            local name = categories[category]

            if types[categories[category]] then
                local resource = res[types[categories[category]].res]

                if type(resource) == 'table' then
                    return resource[param]

                elseif type(resource) == 'nil' then

                    if name == 'Ranged' then
                        return name

                    end

                end

            end

        end
        return false

    end

    self.getActionType = function(bp, action)
        local bp      = bp or false
        local action  = action or false

        if action and type(action) == 'table' then

            if action.prefix then

                if action.type then
                    return action.type

                elseif action.prefix == '/weaponskill' then
                    return ('WeaponSkill')

                end

            elseif action.category then
                return ('Item')

            end

        elseif action and type(action) == 'string' and action == ('Ranged') then
            return ('Ranged')

        end

    end

    self.getActionDelay = function(bp, action)
        local bp      = bp or false
        local action  = action or 1

        if bp and action and type(action) == 'table' then
            local helpers = bp.helpers

            if action.prefix then

                if action.prefix == '/jobability' or action.prefix == '/pet' then

                    return (delays[action.type])

                elseif action.prefix == '/magic' or action.prefix == '/ninjutsu' or action.prefix == '/song' then
                    return (delays[action.type] + action.cast_time)

                elseif action.prefix == '/weaponskill' then
                    return (delays['WeaponSkill'])

                end

            elseif action.category then
                return (delays['Item'] + action.cast_time)

            end

        elseif action and type(action) == 'string' and action == 'Ranged' then
            return delays['Ranged'] + math.ceil( 550/106 )

        end

    end

    self.doMenu = function(bp, id, index, zone, option, menuid, automated, u1, u2)
        local u1 = u1 or 0
        local u2 = u2 or 0

        if id and index and option and zone and menuid and (automated or not automated) then
            windower.packets.inject_outgoing(0x05b, ("iIHHHBCHH"):pack(0x05b, id, option, u1, index, automated, u2, zone, menuid))
        end

    end

    self.exitMenu = function(bp, packets, target)
        
        if packets and target then
            windower.packets.inject_outgoing(0x05b, ("iIHHHBCHH"):pack(0x05b, target.id, 0, 16384, target.index, false, 0, packets["Zone"], packets["Menu ID"]))
        end

    end

    self.getDirection = function(bp, x, y)
        local facing        = windower.ffxi.get_mob_by_target("me").facing
        local directions    = {"E","NE","N","NW","W","SW","S","SE"}
        --[[
        if facing < 0 then
            facing = bpcore:round((-facing), 1)
        else
            facing = bpcore:round(((2*pi)-facing), 1)
        end

        -- EAST.
        if (facing <= 0.3 or facing >= 6) then
            return directions[1]

        -- NORTH-EAST.
        elseif (facing > 0.3 and facing <= 1.4) then
            return directions[2]

        -- NORTH.
        elseif (facing > 1.4 and facing <= 2.0) then
            return directions[3]

        -- NORTH-WEST.
        elseif (facing > 2.0 and facing <= 2.8) then
            return directions[4]

        -- WEST.
        elseif (facing > 2.8 and facing <= 3.5) then
            return directions[5]

        -- SOUTH-WEST.
        elseif (facing > 3.5 and facing <= 4.3) then
            return directions[6]

        -- SOUTH.
        elseif (facing > 4.3 and facing <= 5.1) then
            return directions[7]

        -- SOUTH-EAST.
        elseif (facing > 5.1 and facing < 6.0) then
            return directions[8]

        end
        ]]--

    end

    return self

end
return actions.new()
