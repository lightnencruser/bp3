local maps  = {}
function maps.new()
    local self = {}

    -- Private Variables.
    local bp        = false
    local private   = {events={}}
    local vendors   = {
        
        [17780860] = {id=17780860, index=124, menuid=10000, maps=255},
        [17776720] = {id=17776720, index=80, menuid=10000, maps=255},
    
    }

    -- Public Variables.
    self.busy       = false

    -- Public Functions.
    self.setSystem = function(buddypal)
        if buddypal then
            bp = buddypal
        end

    end
    
    self.buyMaps = function(data)

        if bp and data then
            local packed = bp.packets.parse('incoming', data)
            local target = windower.ffxi.get_mob_by_id(packed['NPC'])

            self.busy = false
            if target and vendors[target.id] and (target.distance):sqrt() < 6 then

                for i=0, vendors[target.id].maps do
                
                    local map = bp.packets.new('outgoing', 0x05b, {
                        ['Target']            = target.id,
                        ['Option Index']      = 1,
                        ['_unknown1']         = i,
                        ['Target Index']      = target.index,
                        ['Automated Message'] = true,
                        ['Zone']              = packed['Zone'],
                        ['Menu ID']           = vendors[target.id].menuid,
                    })
                    bp.packets.inject(map)
                    
                    if i == vendors[target.id].maps then
                    
                        local exit = bp.packets.new('outgoing', 0x05b, {
                            ['Target']            = target.id,
                            ['Option Index']      = 0,
                            ['_unknown1']         = 16384,
                            ['Target Index']      = target.index,
                            ['Automated Message'] = false,
                            ['Zone']              = packed['Zone'],
                            ['Menu ID']           = vendors[target.id].menuid,
                        })
                        return bp.packets.build(exit)
                        
                    end
                    
                end

            else
        
                bp.helpers['popchat'].pop("UNABLE TO FIND THIS VENDOR!")
                local exit = bp.packets.new('outgoing', 0x05b, {
                    ['Target']            = target.id,
                    ['Option Index']      = 0,
                    ['_unknown1']         = 16384,
                    ['Target Index']      = target.index,
                    ['Automated Message'] = false,
                    ['Zone']              = packed['Zone'],
                    ['Menu ID']           = vendors[target.id].menuid,
                })
                bp.packets.inject(exit)

            end


        end

    end

    -- Private Events.
    private.events.commands = windower.register_event('addon command', function(...)
        local a = T{...}
        local c = a[1] or false
    
        if c and c == 'sparks' then
            local command = a[2] or false

        end        

    end)

    private.events.incoming = windower.register_event('incoming chunk', function(id, original, modified, injected, blocked)

        if id == 0x034 and self.busy then
            self.buyMaps(original)
        end

    end)

    return self

end
return maps.new()