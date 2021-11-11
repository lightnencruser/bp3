local roe = {}
function roe.new()
    local self = {}

    -- Private Variable.
    local bp            = false
    local private       = {events={}}

    private.roes = {

        ['deeds'] = {3781,3784,3787,3788},

    }        

    -- Public Functions.
    self.setSystem = function(buddypal)
        if buddypal then
            bp = buddypal
        end

    end

    self.set = function(id)

        if id then
            bp.packets.inject(bp.packets.new('outgoing', 0x10C, {['RoE Quest']=id}))
        end

    end

    self.remove = function(id)

        if id then
            bp.packets.inject(bp.packets.new('outgoing', 0x10D, {['RoE Quest']=id}))
        end

    end

    self.update = function(data)
        local parsed = bp.packets.parse('incoming', data)

            if packed then
                self.list = {}

                for i=1, 30 do
                    table.insert(self.list, {id=packed[string.format('RoE Quest ID %s', i)], progress=packed[string.format('RoE Quest Progress %s', i)]})
                end

            end

        end

    end

    -- Private Events.

    return self

end
return roe.new()