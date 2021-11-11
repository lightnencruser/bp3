local spaz = {}
function spaz.new()
    local self = {}

    -- Private Variables.
    local bp            = false
    local private       = {events={}}
    local enabled       = false

    -- Public Functions.
    self.setSystem = function(buddypal)
        if buddypal then
            bp = buddypal
        end

    end

    -- Private Events.
    private.events.commands = windower.register_event('addon command', function(...)
        local a = T{...}
        local c = a[1] or false

        if c == 'spaz' then
            enabled = not enabled and true or false
            bp.helpers['popchat'].pop(string.format('SPAZTIC MELEE HIT: %s', tostring(enabled):upper()))
        end

    end)

    private.events.actions = windower.register_event('incoming chunk', function(id, original, modified, injected, blocked)

        if enabled and id == 0x028 then
            local parsed    = bp.packets.parse('incoming', original)
            local player    = bp.player
            local actor     = windower.ffxi.get_mob_by_id(parsed['Actor'])
            local target    = windower.ffxi.get_mob_by_id(parsed['Target 1 ID'])
            local count     = parsed['Target Count']
            local category  = parsed['Category']
            local param     = parsed['Param']
            
            if actor and target then
                
                -- Melee Attacks.
                if parsed['Category'] == 1 then

                    if actor.id == bp.player.id then
                        parsed['Category'] = 3
                        parsed['Param'] = math.random(1,65535)
                        parsed['_unknown1'] = math.random(1,65535)

                        for i=1, parsed['Target Count'] do

                            for ii=1, parsed[string.format('Target %s Action Count', i)] do
                                parsed[string.format('Target %s Action %s Reaction', i, ii)] = math.random(1,15)
                                parsed[string.format('Target %s Action %s Animation', i, ii)] = math.random(1,255)
                                parsed[string.format('Target %s Action %s Effect', i, ii)] = math.random(1,15)

                            end

                        end
                        bp.packets.inject(parsed)
                        return

                    end

                end

            end

        end

    end)

    return self

end
return spaz.new()