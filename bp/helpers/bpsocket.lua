local bpsocket  = {}
local JSON      = require('/bp/resources/JSON')
bpsocket.new = function()
    local self = {}

    -- Private Variables.
    local bp    = false
    local host  = '127.0.0.1'
    local port  = 8080
    local private = {events={}}

    -- Public Variables.
    self.socket = require('socket')
    self.tcp    = self.socket.tcp()

    -- Public Functions.
    self.setSystem = function(buddypal)
        if buddypal then
            bp = buddypal
        end

    end
    
    self.send = function(event, data)

        if data and type(data) == 'table' then
            self.tcp:send(string.format('%s|BP|', JSON.encode({event, data})))
        end

    end

    self.receive = function()
        local s, status, partial = self.tcp:receive()

        if status and status == 'closed' then
            bp.helpers['popchat'].pop('SERVER CLOSED')
            self.tcp:close()
            return false
        
        end

        if (s or partial) then
            --local data = JSON.decode(s or partial)
            local data = s or partial
            
            if data then
                return data
            end

        end
        return false

    end

    self.close = function()
        self.tcp:close()
    end

    self.handle = function(data)

        if data then

        end
        return false

    end

    -- Create a conection.
    --self.tcp:connect(host, port)
    --self.tcp:settimeout(0.01)

    --[[
    private.events.textin = windower.register_event('incoming text', function(original, modified, omode, mmode, blocked)
        local blocked = T{161}

        if not blocked:contains(omode) then
            bp.helpers['bpsocket'].send('chat', {original=original:strip_format(), omode=omode})
        end
    
    end)

    private.events.textout = windower.register_event('outgoing text', function(original, modified, blocked)
        --bp.helpers['bpsocket'].send('chat_out', {original=string.format('%s', original:strip_format())})
    
    end)

    local data_check = windower.register_event('time change', function()
        self.receive()
    
    end)
    ]]--

    return self

end
return bpsocket.new()