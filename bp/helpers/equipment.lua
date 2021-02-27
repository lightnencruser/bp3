local equipment = {}
local res = require('resources')
function equipment.new()
    local self = {}

    -- Public Variables.
    self.main   = false
    self.ranged = false
    self.ammo   = false

    -- Static Functions.
    self.update = function()
        local equipment = windower.ffxi.get_items()['equipment']

        if equipment then
            local main      = windower.ffxi.get_items(equipment['main_bag'], equipment['main']) or false
            local ranged    = windower.ffxi.get_items(equipment['range_bag'], equipment['range']) or false
            local ammo      = windower.ffxi.get_items(equipment['ammo_bag'], equipment['ammo']) or false

            if main and main.id then
                self.main = res.items[main.id]
            end

            if ranged and ranged.id then
                self.ranged = res.items[ranged.id]
            end

            if ammo and ammo.id then
                self.ammo = res.items[ammo.id]
            end

        end

    end
    self.update()

    return self

end
return equipment.new()
