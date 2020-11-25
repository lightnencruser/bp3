local chests  = {}
local player    = windower.ffxi.get_player()
local files     = require('files')
local res       = require('resources').items
local f = files.new(string.format('bp/helpers/settings/items/%s_settings.lua', player.name))

if not f:exists() then
  f:write(string.format('return %s', T({}):tovstring()))
end

function chests.new()
    local self = {}

    -- Private Variables.

    -- Static Variables.
    self.settings   = dofile(string.format('%sbp/helpers/settings/items/%s_settings.lua', windower.addon_path, player.name))

    -- Public Variables.
    self.enabled    = true

    -- Private Functions
    local persist = function()

        if self.settings then

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

    -- Public Functions.
    

    return self

end
return chests.new()