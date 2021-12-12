local roe = {}
function roe.new()
    local self = {}

    -- Private Variable.
    local bp            = false
    local private       = {events={}}

    private.roes = {

        ['deeds'] = {3779,3780,3781,3782,3783,3784,3785,3786,3787,3788,3789,3790},

    }        

    -- Public Functions.
    self.setSystem = function(buddypal)
        if buddypal then
            bp = buddypal
        end

    end

    self.set = function(id)

        if bp and id and tonumber(id) ~= nil then
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

    self.load = function(set)

        if bp and set and private.roes[set] then
            bp.helpers['popchat'].pop(string.format('LOADING: %s', set))

            for i,v in ipairs(private.roes[set]) do
                self.set(v)
                coroutine.sleep(1.5)

                if i == #private.roes[set] then
                    bp.helpers['popchat'].pop(string.format('FINISHED LOADING: %s', set))
                end

            end


        end

    end

    -- Private Events.
    private.events.commands = windower.register_event('addon command', function(...)
        local commands = T{...}
        local helper = commands[1]
        
        if helper and helper:lower() == 'records' then
            table.remove(commands, 1)
            
            if commands[1] then
                local command = commands[1]:lower()
                
                if command == 'set' and commands[2] then
                    self.set(commands[2])
                    bp.helpers['popchat'].pop(string.format('ADDING ROE: %s', commands[2]))

                elseif command == 'load' and commands[2] then
                    self.load(commands[2])

                end

            end

        end        

    end)

    return self

end
return roe.new()