local attachments = {}
local automaton = require('resources').items:category('Automaton')
local general = require('resources').items:category('General')
function attachments.new()
    local self = {}

    -- Private Variables.
    local bp        = false
    local private   = {events={}}
    local enabled   = false
    local timer     = {last=0, delay=6}
    local npc       = 16982163
    local attach    = {}

    -- Build Attachment IDs.
    for i,v in pairs(automaton) do
        
        for ii,vv in pairs(general) do

            if v.enl == vv.enl then
                table.insert(attach, vv.id)
                break

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
    private.events.commands = windower.register_event('addon command', function(...)
        local a = T{...}
        local c = a[1] or false

        if c == 'attach' then
            enabled = not enabled and true or false
            private.npc = windower.ffxi.get_mob_by_id(16982163) or false
            bp.helpers['popchat'].pop(string.format('ATTACHMENT HELPER: %s', tostring(enabled):upper()))

        end

    end)

    private.events.prerender = windower.register_event('prerender', function()

        if enabled and (os.clock()-timer.last) > timer.delay and not private.busy and not private.trade then
            
            if private.npc and (private.npc.distance):sqrt() <= 6 then
                private.busy = true

                for _,v in ipairs(attach) do
                    private.attachment, private.count, private.id = bp.helpers['inventory'].findItemById(v)
                    
                    if private.attachment then
                        break
                    end
    
                end
                
                if private.attachment and bp.player.status ~= 4 then
                    
                    coroutine.schedule(function()
                        bp.helpers['actions'].tradeItem(private.npc, 1, {name=bp.res.items[private.id].en, count=1})
                        private.trade = true
                        
                        coroutine.schedule(function()
                            bp.helpers['actions'].keyCombo({'enter','enter'}, 2)
                            
                            coroutine.schedule(function()
                                private.busy = false
                                private.trade = false
                            
                            end, 2)
                    
                        end, 2)
                    
                    end, 1)

                else
                    bp.helpers['popchat'].pop('NO ATTACHMENTS FOUND!')
                    private.busy = false
                    private.trade = false
                    enabled = false


                end

            end
            timer.last = os.clock()

        end

    end)

    return self

end
return attachments.new()