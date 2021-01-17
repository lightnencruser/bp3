local sparks = {}
function sparks.new()
    local self = {}
    
    -- Private Variables.
    local items     = dofile(string.format("%sbp/resources/sparks_list.lua", windower.addon_path))
    local name      = false
    local purchase  = false
    local quantity  = 0
    local targets   = {'Isakoth'}

    -- Static Variables.
    self.busy       = false

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
            bp.helpers['popchat'].pop("COULD NOT FIND A SPARKS NPC NEARBY!!")
            return false
        
        end

        if bp and item and target and bp.helpers['inventory'].hasSpace(0) and count ~= nil then
            local space = bp.helpers['inventory'].getSpace()
            
            if items[item] then
            
                do -- Correct our count if we dont have enough room.
                    quantity    = count <= space and count or space
                    purchase    = items[item]
                    name        = item
                    self.busy   = true

                end
                bp.helpers['actions'].doAction(target, 0, 'interact')

            else
                bp.helpers['popchat'].pop("THAT ISN'T A VALID SPARKS ITEM!")

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
                bp.helpers['popchat'].pop(string.format('NOW PURCHASING %s %s.', quantity, name))
                
                for i=1, quantity do
                    bp.helpers['actions'].doMenu(bp, target.id, target.index, packed['Zone'], purchase.option, packed['Menu ID'], true, purchase._u1, purchase._u2)
                    
                    if i == quantity then
                        bp.helpers['actions'].exitMenu(bp, packed, target)
                    end
                
                end
            
            else
                bp.helpers['popchat'].pop("MAKE SURE YOU HAVE ENOUGH INVENTORY SPACE!")
                bp.helpers['actions'].exitMenu(bp, packed, target)
            
            end
            
        else
            bp.helpers['actions'].exitMenu(bp, packets, target)
            
        end

        do -- Reset our variables.
            quantity    = 0
            purchase    = false
            name        = false
            self.busy   = false

        end
    
    end

    self.sellShields = function(bp)
        local n         = bp.helpers['inventory'].getSlotCount('Acheron Shield', 0)
        local item      = bp.helpers['inventory'].findItemByName('Acheron Shield', 0)
        local appraise  = bp.packets.new('outgoing', 0x084)
        
        if appraise then
            self.busy = true
            
            bp.helpers['popchat'].pop(string.format('SELLING ACHERON SHIELDS!', n, item.en))
            for i=1, n do
                bp.packets.inject(bp.packets.new('outgoing', 0x084, {['Count']=1, ['Item']=item.id, ['Inventory Index']=bp.helpers['inventory'].findItemIndexByName('Acheron Shield', 0)}))
                coroutine.sleep(math.random())
                bp.packets.inject(bp.packets.new('outgoing', 0x085))
                coroutine.sleep(1+math.random())

                if i == n then
                    self.busy = false
                end

            end
            bp.helpers['popchat'].pop('SELLING FINISHED!')

        end

    end
    
    return self
    
end
return sparks.new()
