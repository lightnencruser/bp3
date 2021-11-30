local equipment = {}
local res = require('resources')
function equipment.new()
    local self = {}

    -- Private Variables.
    local bp        = false
    local private   = {events={}}

    -- Public Variables.
    self.main   = false
    self.ranged = false
    self.ammo   = false

    -- Public Functions.
    self.setSystem = function(buddypal)
        if buddypal then
            bp = buddypal
        end

    end

    self.update = function()
        local items = windower.ffxi.get_items()
        local equipment = items['equipment']

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

    -- Private Events.
    private.events.outgoing = windower.register_event('outgoing chunk', function(id, original, modified, injected, blocked)

        if id == 50 then
            coroutine.schedule(self.update, 5)
        end
    
    end)

    private.events.login = windower.register_event('login', function()
        coroutine.schedule(self.update, 8)
    
    end)

    return self

end
return equipment.new()
