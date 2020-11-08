local equipment = {}
local res = require('resources')
function equipment.new()
    local self = {}

    -- Public Variables.
    self.main   = res.items[windower.ffxi.get_items(windower.ffxi.get_items()["equipment"][string.format("%s_bag", "main")],  windower.ffxi.get_items()["equipment"]["main"]).id]
    self.ranged = res.items[windower.ffxi.get_items(windower.ffxi.get_items()["equipment"][string.format("%s_bag", "range")], windower.ffxi.get_items()["equipment"]["range"]).id]
    self.ammo   = res.items[windower.ffxi.get_items(windower.ffxi.get_items()["equipment"][string.format("%s_bag", "ammo")], windower.ffxi.get_items()["equipment"]["ammo"]).id]

    -- Static Functions.
    self.update = function()
        self.main   = res.items[windower.ffxi.get_items(windower.ffxi.get_items()["equipment"][string.format("%s_bag", "main")],  windower.ffxi.get_items()["equipment"]["main"]).id]
        self.ranged = res.items[windower.ffxi.get_items(windower.ffxi.get_items()["equipment"][string.format("%s_bag", "range")], windower.ffxi.get_items()["equipment"]["range"]).id]
        self.ammo   = res.items[windower.ffxi.get_items(windower.ffxi.get_items()["equipment"][string.format("%s_bag", "ammo")], windower.ffxi.get_items()["equipment"]["ammo"]).id]

    end

    return self

end
return equipment.new()
