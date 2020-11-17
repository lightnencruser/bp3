local sparks = {}
function sparks.new()
    local self = {}
    
    -- Private Variables.
    local items     = dofile(string.format("%sbp/resources/sparks_list.lua", windower.addon_path))
    local purchase  = false
    local quantity  = 0

    -- Static Variables.
    self.busy = false

    -- Public Functions.
    self.poke = function(bp, item, count)
        local bp    = bp or false
        local item  = item or false
        local count = count or 1

        if bp and item and items[item] and bp.helpers['inventory'].hasSpace() then
            local space = bp.helpers['inventory'].getSpace()

            do -- Correct our count if we dont have enough room.
                quantity = count <= space and count or space
                purchase = items[item]
            end

        end

    end

    self.purchase = function(bp, data)
        local bp = bp or false
        local data = data or false

        if bp and data then
            local packed = bp.packets.parse('incoming', data) or false
            local target = windower.ffxi.get_mob_by_id(packets["NPC"]) or false
        
            if packed and target and purchase and quantity ~= 0 then
                
                for i=1, count do
                    helpers["actions"].injectMenu(packets["NPC"], packets["NPC Index"], packets["Zone"], v.option, packets["Menu ID"], true, v._u1, v._u2)
                            
                    if i == count then
                        helpers['popchat']:pop((message), system["Popchat Window"])
                        helpers["actions"].doExitMenu(packets, target)
                    end
                
                end
            
            else
                helpers['popchat']:pop(("Make sure you have enough inventory space!!"), system["Popchat Window"])
                helpers["actions"].doExitMenu(packets, target)
            
            end
            
        else
            helpers["actions"].doExitMenu(packets, target)
            
        end
    
    end
    
    return self
    
end
return sparks.new()
