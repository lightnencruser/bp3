local charges = {}
function charges.new()
    local self = {}

    -- Private Variables.
    local bp        = false
    local private   = {events={}, max=3}

    -- Public Variables.
    self.current    = 0
    self.max        = private.max
    self.next       = 0

    -- Private Functions.
    private.calculate = function()

        if bp and bp.player and bp.player.main_job == 'BST' then
            local recast  = windower.ffxi.get_ability_recasts()[102] or 0
            local charges = (3-math.floor(recast/30))

            do
                self.current = charges > -math.huge and current < math.huge and current or 0
                self.next    = (30 - ((private.max-self.current)*30)-recast)
            end

        end
    
    end

    -- Public Functions.
    self.setSystem = function(buddypal)
        if buddypal then
            bp = buddypal
        end

    end

    -- Private Events.
    private.events.prerender = windower.register_event('prerender', function()
        private.calculate()
    end)

    return self

end
return charges.new()