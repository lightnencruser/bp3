local sparks = {}
function sparks.new()
    local self = {}
    
    -- Private Variables.
    local items     = dofile(string.format("%sbp/resources/sparks_list.lua", windower.addon_path))
    local name      = false
    local purchase  = false
    local quantity  = 0

    -- Static Variables.
    self.busy       = false
    self.important  = string.format('%s,%s,%s', 25, 165, 200)

    -- Public Functions.
    self.poke = function(bp, item, count)
        local bp        = bp or false
        local item      = item or false
        local count     = tonumber(count) or 1
        local target    = windower.ffxi.get_mob_by_target('t') or false

        if not target then
            bp.helpers['popchat'].pop("YOU DIDN'T SELECT A TARGET!")
            return false
        
        end

        if bp and item and target and items[item] and bp.helpers['inventory'].hasSpace() and count ~= nil then
            local space = bp.helpers['inventory'].getSpace()

            do -- Correct our count if we dont have enough room.
                quantity    = count <= space and count or space
                purchase    = items[item]
                name        = item
                self.busy   = true

            end
            bp.helpers['actions'].doAction(target, 0, 'interact')
        
        else
            bp.helpers['popchat'].pop("NOT ENOUGH INVENTORY SPACE!")

        end

    end

    self.purchase = function(bp, data)
        local bp = bp or false
        local data = data or false

        if bp and data and self.busy then
            local packed = bp.packets.parse('incoming', data) or false
            local target = windower.ffxi.get_mob_by_id(packed['NPC']) or false
        
            if packed and target and purchase and quantity ~= 0 then
                bp.helpers['popchat'].pop(string.format('NOR PURCHASING \\cs(%s)(%d)%s\\cr.', self.important, quantity, name))
                
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
    
    return self
    
end
return sparks.new()
