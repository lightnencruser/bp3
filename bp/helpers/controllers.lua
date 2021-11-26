local controllers   = {}
local player        = windower.ffxi.get_player()
local files         = require('files')
local f = files.new(string.format('bp/helpers/settings/controllers/%s_settings.lua', player.name))

if not f:exists() then
  f:write(string.format('return %s', T({}):tovstring()))
end

function controllers.new()
    local self = {}

    -- Static Variables.
    self.settings       = dofile(string.format('%sbp/helpers/settings/controllers/%s_settings.lua', windower.addon_path, player.name))

    -- Private Variables.
    local bp            = false
    local private       = {events={}}
    local controllers   = self.settings.controllers or {}

    -- Private Functions
    local persist = function()
        local next = next

        if self.settings then
            self.settings.controllers = controllers
        end

    end
    persist()

    private.exists = function(name)

        if name and type(name) == 'string' then
            
            for _,v in ipairs(controllers) do
                local check = false

                if v == name then
                    return true
                end

            end

        end
        return false

    end

    private.add = function(name)

        if bp and name and not private.exists(name) then
            table.insert(controllers, name)
            bp.helpers['popchat'].pop(string.format('%s added to controllers list.', name))

        end
        self.writeSettings()

    end

    private.remove = function(name)

        if bp and name then

            for i,v in ipairs(controllers) do

                if v == name then
                    table.remove(controllers, i)
                    bp.helpers['popchat'].pop(string.format('%s removed from the controllers list.', name))
                    break

                end

            end

        end
        self.writeSettings()

    end

    private.clear = function()

        if bp then
            bp.helpers['popchat'].pop('CONTROLLERS LIST CLEARED!')
            controllers = {}

        end
        self.writeSettings()

    end

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

        if c == 'invites' and a[2] then
            local command = a[2]:lower()
            local target = windower.ffxi.get_mob_by_target('t') or false
                
            if (command == '+' or command == 'a') and (target or a[3]) then
                
                if a[3] then
                    private.add(a[3]:lower())

                elseif target.name then
                    private.add(target.name:lower())

                end

            elseif (command == '-' or command == 'r') and (target or a[3]) then
                
                if a[3] then
                    private.remove(a[3]:lower())
                    
                elseif target.name then
                    private.remove(target.name:lower())                        
                end

            elseif (command == 'clear' or command == 'c') then
                private.clear()

            end

        end

    end)

    private.events.login = windower.register_event('login', function(name)

        coroutine.schedule(function()

            if not private.exists(name) then
                private.add(name)
            end
        
        end, 1)

    end)

    private.events.load = windower.register_event('load', function()

        coroutine.schedule(function()
            
            if bp and bp.player and not private.exists(bp.player.name) then
                private.add(bp.player.name)
            end
        
        end, 1)

    end)

    return self

end
return controllers.new()