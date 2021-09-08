local roboto    = {}
local player    = windower.ffxi.get_player()
local files     = require('files')
local f = files.new(string.format('bp/helpers/settings/roboto/%s_settings.lua', player.name))

if not f:exists() then
    f:write(string.format('return %s', T({}):tovstring()))
end

function roboto.new()
    local self = {}

    -- Static Variables.
    self.settings   = dofile(string.format('%sbp/helpers/settings/roboto/%s_settings.lua', windower.addon_path, player.name))

    -- Private Variables.
    local bp        = false
    local private   = {events={}, bot=false}
    local timestamp = {date=os.date('!*t', os.time() + 9 * 60 * 60), time=os.time(os.date('!*t'))}

    -- Public Variables.

    -- Private Functions.
    private.persist = function()

        if self.settings then

        end

    end
    private.persist()

    private.writeSettings = function()
        private.persist()

        if f:exists() then
            f:write(string.format('return %s', T(self.settings):tovstring()))

        elseif not f:exists() then
            f:write(string.format('return %s', T({}):tovstring()))

        end

    end
    private.writeSettings()

    private.launch = function(name)
        
        if name and type(name) == 'string' and not private.bot then
            local launch = files.new(string.format('bp/helpers/settings/roboto/bots/%s.lua', name:lower()))

            if launch:exists() then
                private.bot = dofile(string.format('%sbp/helpers/settings/roboto/bots/%s.lua', windower.addon_path, name:lower()))

                if private.bot.setSystem then
                    private.bot.setSystem(bp)
                    print(('%s launched!'):format(private.bot.identity))

                else
                    private.bot = false

                end
                
            end

        end

    end

    private.kill = function()

        if private.bot then
            private.bot = private.bot.kill()
        end

    end

    private.stamp = function()

        if private.bot and self.settings[private.bot.identity] then
            self.settings[private.bot.identity] = {timestamp=timestamp}
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
        if a[1] and a[2] and a[1] == 'rob' then
            local command = a[2]:lower()

            if command == 'l' and a[3] then
                private.launch(a[3])

            elseif command == 'kill' then
                private.kill()

            end

        end
    
    end)

    private.events.prerender = windower.register_event('prerender', function()
        timestamp = {date=os.date('!*t', os.time() + 9 * 60 * 60), time=os.time(os.date('!*t'))}

    end)
    
    
    return self

end
return roboto.new()