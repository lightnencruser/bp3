local inventory = {}
local res = require('resources')

function inventory.new()
    local self = {}
    local bp   = false

    -- Private Variables.
    local private = {events={}}

    self.setSystem = function(buddypal)
        if buddypal then
            bp = buddypal
        end

    end

    self.sellItems = function(name)
        local appraise = bp.packets.new('outgoing', 0x084)

        if name and type(name) == 'string' then
            local item = self.findItemByName(name, 0)
            local n = self.getSlotCount(name, 0)
        
            if item and n then
                
                bp.helpers['popchat'].pop(string.format('SELLING %s %s', self.getItemCount('name'), item.en))
                for i=1, n do
                    local index = self.findItemIndexByName(name)
                    local count = self.getCountByIndex(index)

                    do
                        bp.packets.inject(bp.packets.new('outgoing', 0x084, {['Count']=count, ['Item']=item.id, ['Inventory Index']=index}))
                        coroutine.sleep(math.random())
                        bp.packets.inject(bp.packets.new('outgoing', 0x085))
                        coroutine.sleep(1+math.random())
                    end

                end
                bp.helpers['popchat'].pop('SELLING FINISHED!')

            end

        end

    end

    self.findItemByName = function(name, bag)
        local items = windower.ffxi.get_items(bag or 0)

        if name and (name ~= '' or name ~= 'None') then
            
            for index, item in ipairs(items) do
                
                if item and index and item.id then
                    local found = res.items[item.id]

                    if found and found.en then
                        
                        if name:sub(1, #name):lower() == (found.en):sub(1, #name):lower() then
                            return found
                        end

                    end

                end

            end

        end
        return false

    end

    self.findItemIndexByName = function(name, bag, amount)
        local items = windower.ffxi.get_items(bag or 0)

        for index, item in ipairs(items) do
            local amount = amount or 1

            if item and index and amount and item.id and item.count and item.count >= amount then
                local found_item = res.items[item.id]
                
                if found_item and found_item.name then

                    if name:sub(1, #name):lower() == found_item.name:lower() then
                        return index, id
                    end

                end

            end

        end
        return false

    end

    self.findItemById = function(id, bag)
        local items = windower.ffxi.get_items(bag or 0)

        for index, item in ipairs(items) do

            if item and item.id == id and item.status == 0 then
                return index, item.count, item.id
            end

        end
        return false

    end

    self.findItemByIndex = function(i_index, bag)
        local items = windower.ffxi.get_items(bag or 0)

        for index, item in ipairs(items) do

            if item and index and item.id and item.status == 0 then
                local found_item  = res.items[item.id]

                if index == tonumber(i_index) then
                    return found_item
                end

            end

        end
        return false

    end

    self.getItemCount = function(name, bag)
        local items = windower.ffxi.get_items(bag or 0)
        local count = 0

        if name and items then

            for index, item in ipairs(items) do
                
                if item and type(item) == 'table' then
                    local found = self.findItemByName(name, bag)

                    if found and found.id == item.id then
                        count = (count + item.count)
                    end

                end

            end
            return count

        end

    end

    self.getTotalCount = function(name)
        local bags = {0,6,7}
        local count = 0

        for i=1, #bags do
            local items = windower.ffxi.get_items(bags[i])
            local bag = bags[i]

            if name and items then

                for index, item in ipairs(items) do
                    
                    if item and type(item) == 'table' then
                        local found = self.findItemByName(name, bag)

                        if found and found.id == item.id then
                            count = (count + item.count)
                        end

                    end

                end

            end

        end
        return count

    end

    self.getCountByIndex = function(index, bag)
        local items = windower.ffxi.get_items(bag or 0)

        for i, item in ipairs(items) do

            if item and i == index and item.status == 0 then
                return item.count
            end

        end
        return false

    end

    self.getSlotCount = function(name, bag)
        local items = windower.ffxi.get_items(bag or 0)
        local count = 0

        if name and items then

            for index, item in ipairs(items) do

                if item and type(item) == "table" then
                    local new = self.findItemByName(name) or false

                    if new and new.id == item.id then
                        count = (count + 1)
                    end

                end

            end
            return count

        end

    end

    self.inBag = function(name)
        local bags = {0,8,10,11,12}

        for _,v in pairs(bags) do
            
            if self.findItemByName(name, v) then
                return true
            end

        end
        return false

    end

    self.hasSpace = function(bag)
        local bag = windower.ffxi.get_bag_info(bag or 0)

        if bag.count < bag.max then
            return true
        end
        return false

    end

    self.getSpace = function(bag)
        local bag = windower.ffxi.get_bag_info(bag or 0)

        if bag.count < bag.max then
            return (bag.max - bag.count)
        end
        return 0

    end

    self.getCount = function(bag)
        local bag = windower.ffxi.get_bag_info(bag or 0)

        if bag then
            return bag.count
        end
        return 0

    end

    -- Private Events.
    private.events.inventory = windower.register_event('incoming chunk', function(id, original, modified, blocked, injected)
        
        if id == 0x020 then
            local parsed = bp.packets.parse('incoming', original)
            local bags = bp.res.bags

            if parsed then

            end

        end

    end)
    private.inventory = {}

    return self

end
return inventory.new()
