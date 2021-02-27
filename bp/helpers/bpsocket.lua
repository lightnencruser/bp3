local bpsocket  = {}
local JSON      = require('/bp/resources/JSON')
bpsocket.new = function()
    local self = {}

    -- Private Variables.
    local host  = '127.0.0.1'
    local port  = 8080

    -- Public Variables.
    self.socket = require('socket')
    self.tcp    = self.socket.tcp()

    -- Public Functions.
    self.send = function(bp, data)
        local bp    = bp or false
        local data  = data or false

        if bp and data and type(data) == 'table' then
            self.tcp:send(JSON:encode(data))
        end

    end

    self.receive = function(bp)
        local bp = bp or false
        local s, status, partial = self.tcp:receive()

        if status and status == 'closed' then
            self.tcp:close()
            return false
        
        end

        if bp and (s or partial) then
            local data = JSON:decode(s or partial)

            if data then
                return data
            end

        end
        return false

    end

    self.handle = function(bp, data)
        local bp    = bp or false
        local data  = data or false

        if bp and data then

        end
        return false

    end

    -- Create a conection.
    --self.tcp:connect(host, port)
    --self.tcp:settimeout(0.01)

    return self

end
return bpsocket.new()