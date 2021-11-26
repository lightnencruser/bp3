local ciphers = {}
function ciphers.new()
    local self = {}

    -- Private Variables.
    local bp        = false
    local private   = {events={}}
    local npc       = {'Clarion Star','Gondebaud','Wetata'}

    -- Public Variables.
    self.busy       = false
    self.cipher     = false

    -- Private Functions.
    private.poke = function()
        local item = bp.helpers['inventory'].findItemByName('Cipher') or false
        local target

        if item then

            for _,v in ipairs(npc) do

                if windower.ffxi.get_mob_by_name(v) and (windower.ffxi.get_mob_by_name(v).distance):sqrt() < 6 then
                    target = windower.ffxi.get_mob_by_name(v) or false
                    break
                
                end

            end
            
            if target and item and type(item) == 'table' and self.isTrust(item) then
                self.busy = true

                do
                    bp.helpers['actions'].tradeItem(target, 1, {name=item.en, count=1})

                end

            elseif not target then
                bp.helpers['popchat'].pop('UNABLE TO FIND CIPHER NPC!')

            end

        else
            bp.helpers['popchat'].pop('UNABLE TO FIND CIPHER!')

        end
        
    end

    -- Public Functions.
    self.setSystem = function(buddypal)
        if buddypal then
            bp = buddypal
        end

    end

    self.build = function(data)
        local bp    = bp or false
        local data  = data or false

        if bp and data then
            local packed = bp.packets.parse('incoming', data)
    
            if packed and packed['NPC'] then
                local inject = bp.packets.new('outgoing', 0x05b, {
                    ['Target']              = packed['NPC'],
                    ['Target Index']        = packed['NPC Index'],
                    ['Option Index']        = self.cipher,
                    ['Automated Message']   = false,
                    ['Zone']                = packed['Zone'],
                    ['Menu ID']             = packed['Menu ID'],
                    ['_unknown1']           = 0,
                    ['_unknown2']           = 0,
                })
                bp.packets.inject(inject)

                do
                    self.busy      = false
                    self.cipher    = false
                    return true

                end
                
            end

        end
        return original

    end
    
    self.isTrust = function(check)
        local check = check or false
        
        if bp and check and type(check) == 'table' then
            local allowed = bp.res.spells:type('Trust')

            for i,v in pairs(allowed) do
                
                if v and v.en and (check.en):sub(9, #check.en) == v.en then
                    self.cipher = v.id
                    return true

                end
                
            end
            
        end
        return false
        
    end

    -- Private Events.
    private.events.commands = windower.register_event('addon command', function(...)
        local commands = T{...}

        if commands[1] and commands[1]:lower() == 'ciphers' then
            private.poke()
        end

    end)

    private.events.incoming = windower.register_event('incoming chunk', function(id, original, modified, injected, blocked)
    
        if id == 0x034 then
            local menu_hacks = bp.helpers['menus'].enabled
    
            if not menu_hacks and self.busy then
                return self.build(original)
            end

        end

    end)

    return self

end
return ciphers.new()