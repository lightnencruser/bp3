local autoload  = {}
local player    = windower.ffxi.get_player()
local files     = require('files')
local texts     = require('texts')
local f = files.new(string.format('bp/helpers/settings/autoload/%s_settings.lua', player.name))

if not f:exists() then
  f:write(string.format('return %s', T({}):tovstring()))
end

function autoload.new()
    local self = {}

    -- Static Variables.
    self.settings   = dofile(string.format('%sbp/helpers/settings/autoload/%s_settings.lua', windower.addon_path, player.name))
    self.addons     = self.settings.addons or {

        'superwarp',
        'orders',
        'enter',
        'interactbruh',

    }

    -- Private Functions
    local persist = function()

        if self.settings then
            self.settings.addons = self.addons
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

    self.load = function()
        
        if self.addons then

            for _,v in ipairs(self.addons) do
                windower.send_command(string.format('lua load %s', v))
            end

        end

    end
    self.load()

    self.unload = function()

        if self.addons then

            for _,v in ipairs(self.addons) do
                windower.send_command(string.format('lua unload %s', v))
            end

        end

    end

    return self

end
return autoload.new()
