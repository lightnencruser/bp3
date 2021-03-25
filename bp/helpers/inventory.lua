local inventory = {}
local res = require('resources')

function inventory.new()
    local self = {}

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

    self.findItemIndexByName = function(name, bag)
        local bag = bag or 0
        local items = windower.ffxi.get_items(bag)

        for index, item in ipairs(items) do

            if item and index and item.id then
                local found_item  = res.items[item.id]

                if found_item and found_item.name then

                    if name:sub(1, #name):lower() == found_item.name:lower() then
                        return index
                    end

                end

            end

        end
        return false

    end

    self.findItemById = function(id, bag)
        local bag = bag or 0
        local items = windower.ffxi.get_items(bag)

        for index, item in ipairs(items) do

            if item and item.id == id and item.status == 0 then
                return index, item.count, item.id
            end

        end
        return false

    end

    self.findItemByIndex = function(i_index, bag)
        local bag = bag or 0
        local items = windower.ffxi.get_items(bag)

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
        local count = 0
        local bag   = bag or 0
        local items = windower.ffxi.get_items(bag)

        if name and items then

            for index, item in ipairs(items) do

                if item and type(item) == "table" then
                    local new = self.findItemByName(name) or false

                    if new and new.id == item.id then
                        count = (count + item.count)
                    end

                end

            end
            return count

        end

    end

    self.getCountByIndex = function(index, bag)
        local bag = bag or 0
        local items = windower.ffxi.get_items(bag)

        for i, item in ipairs(items) do

            if item and i == index and item.status == 0 then
                return item.count
            end

        end
        return false

    end

    self.getSlotCount = function(name, bag)
        local count = 0
        local bag   = bag or 0
        local items = windower.ffxi.get_items(bag)

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

    return self

end
return inventory.new()
