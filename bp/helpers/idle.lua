local idle  = {}
local player    = windower.ffxi.get_player()
local files     = require('files')
local f = files.new(string.format('bp/helpers/settings/idle/%s_settings.lua', player.name))

if not f:exists() then
  f:write(string.format('return %s', T({}):tovstring()))
end

function idle.new()
    local self = {}

    -- Static Variables.
    self.settings   = dofile(string.format('%sbp/helpers/settings/idle/%s_settings.lua', windower.addon_path, player.name))

    -- Public Variables.
    self.enabled    = self.settings.enabled or true

    -- Private Variables.
    local timers    = {last=os.clock(), delay=1800}
    local active    = true

    -- Private Functions
    local persist = function()

        if self.settings then
            self.settings.enabled = self.enabled
        end

    end
    persist()

    -- Static Functions.
    self.writeSettings = function()
        persist()

        if f:exists() then
            f:write(string.format('return %s', T(self.settings):tovstring()))

        elseif not f:exists() then
            f:write(string.format('return %s', T({}):tovstring()))

        end

    end
    self.writeSettings()

    self.getIdle = function()

        if not active then
            return true
        end
        return false

    end

    -- Public Functions.
    self.isIdle = function(bp)
        local bp = bp or false

        if bp and self.enabled then
            
            if (os.clock()-timers.last) > timers.delay then
                active = false
                bp.helpers['popchat'].pop('YOU ARE NOW IDLE!')

            end

        end

    end

    self.activate = function(bp)
        local bp = bp or false

        if self.enabled then
        
            if bp and not active then
                active = true
                bp.helpers['popchat'].pop('YOU ARE NOW ACTIVE!')

            end
            timers.last = os.clock()

        end

    end

    self.setTimeout = function(bp, time)
        local bp    = bp or false
        local time  = time or false

        if bp and time then

            if (type(time) == 'number' or tonumber(time) ~= nil) then
                local time = tonumber(time)
            
                if time >= 60 and time <= 3600 then
                    bp.helpers['popchat'].pop(string.format('IDLE TIMEOUT NOW SET TO: %s!', time))
                    timers.delay = time

                else
                    bp.helpers['popchat'].pop('ENTER A NUMBER BETWEEN 60 AND 3600!')

                end

            else
                bp.helpers['popchat'].pop('INVALID TIME ENTERED!')

            end

        end

    end

    self.toggle = function(bp)
        local bp = bp or false

        if bp then

            if self.enabled then
                self.enabled = false

            else
                self.enabled = true

            end
            bp.helpers['popchat'].pop(string.format('IDLE MODE: %s.', tostring(self.enabled)))

        end

    end

    return self

end
return idle.new()