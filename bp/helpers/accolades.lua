local accolades = {}
function accolades.new()
    local self = {}
    
    -- Private Variables.
    local name      = false
    local purchase  = false
    local quantity  = 0
    local targets   = {'Igsli'}
    local items     = {

        {name="Refractive Crystal", id=003, buy=8164, quantity=0, unknown1=0},
        {name="Gobbiedial Key",     id=035, buy=8196, quantity=0, unknown1=0},
        {name="Instant Warp",       id=067, buy=8260, quantity=0, unknown1=0},
        {name="Instant Raise",      id=099, buy=8292, quantity=0, unknown1=0},
        {name="Instant Protect",    id=131, buy=8324, quantity=0, unknown1=0},
        {name="Instant Shell",      id=163, buy=8356, quantity=0, unknown1=0},
        {name="Moist Rolanberry",   id=195, buy=8388, quantity=0, unknown1=0},
        {name="Ravaged Moko Grass", id=227, buy=8420, quantity=0, unknown1=0},
        {name="Cavorting Worm",     id=259, buy=8452, quantity=0, unknown1=0},
        {name="Levigated Rock",     id=291, buy=8484, quantity=0, unknown1=0},
        {name="Little Lugworm",     id=323, buy=8516, quantity=0, unknown1=0},
        {name="Training Manual",    id=355, buy=8548, quantity=0, unknown1=0},
        {name="Prize Powder",       id=387, buy=8580, quantity=0, unknown1=0},

    }

    -- Static Variables.
    self.busy = false

    -- Public Functions.
    self.poke = function(bp, item, count)
        local bp        = bp or false
        local item      = item or false
        local count     = tonumber(count) or 1
        local target    = false

        for _,v in ipairs(targets) do
            target = windower.ffxi.get_mob_by_name(v) or false
        end

        if not target or (target and (target.distance):sqrt() > 6) then
            bp.helpers['popchat'].pop("COULD NOT FIND A UNITY NPC NEARBY!!")
            return false
        
        end

        if bp and item and target and bp.helpers['inventory'].hasSpace(0) and count ~= nil then
            local space = bp.helpers['inventory'].getSpace()

            for i,v in ipairs(items) do
                
                if (v.name:lower()):match(item) then
                    purchase = items[i]
                    break

                end

            end

            
            if purchase and purchase.name then
                quantity    = count or 1
                name        = item
                self.busy   = true

                do -- Interact with NPC.
                    bp.helpers['actions'].doAction(target, 0, 'interact')
                end

            else
                bp.helpers['popchat'].pop("THAT ISN'T A VALID ACCOLADES ITEM!")

            end
        
        else
            bp.helpers['popchat'].pop("NOT ENOUGH INVENTORY SPACE!")

        end

    end

    self.purchase = function(bp, data)
        local bp = bp or false
        local data = data or false

        if bp and data and self.busy then
            local packed    = bp.packets.parse('incoming', data) or false
            local target    = windower.ffxi.get_mob_by_id(packed['NPC']) or false
        
            if packed and target and purchase and quantity ~= 0 then

                do -- Calculate item quantity.

                    if quantity == 1 then
                        purchase.quantity = purchase.buy

                    else
                        purchase.quantity = math.floor((purchase.buy+((quantity-1) * 8192))%65536)
                        purchase.unknown1 = math.floor((purchase.buy+(quantity * 8192))/65536)

                    end

                end
                bp.helpers['popchat'].pop(string.format('NOW PURCHASING %s %s.', quantity, purchase.name))
                bp.helpers['actions'].doMenu(bp, target.id, target.index, packed['Zone'], 10, packed['Menu ID'], true)
                bp.helpers['actions'].doMenu(bp, target.id, target.index, packed['Zone'], purchase.id, packed['Menu ID'], true)
                bp.helpers['actions'].doMenu(bp, target.id, target.index, packed['Zone'], purchase.quantity, packed['Menu ID'], true, purchase.unknown1)
            
            end
            
        end

        do -- Reset our variables.
            quantity    = 0
            purchase    = false
            name        = false
            self.busy   = false

        end
    
    end

    self.sellPowders = function(bp)
        local n         = bp.helpers['inventory'].getSlotCount('Prize Powder', 0)
        local item      = bp.helpers['inventory'].findItemByName('Prize Powder', 0)
        local appraise  = bp.packets.new('outgoing', 0x084)
        
        if appraise and item and n then
            self.busy = true
            
            bp.helpers['popchat'].pop(string.format('SELLING PRIZE POWDERS!', n, item.en))
            for i=1, n do
                local selling = bp.helpers['inventory'].findItemIndexByName('Prize Powder', 0) or false

                if selling then
                    bp.packets.inject(bp.packets.new('outgoing', 0x084, {['Count']=bp.helpers['inventory'].getCountByIndex(selling), ['Item']=item.id, ['Inventory Index']=selling}))
                    coroutine.sleep(math.random())
                    bp.packets.inject(bp.packets.new('outgoing', 0x085))
                    coroutine.sleep(1+math.random())

                end

                if i == n then
                    self.busy = false
                end

            end
            bp.helpers['popchat'].pop('SELLING FINISHED!')

        end

    end
    
    return self
    
end
return accolades.new()
