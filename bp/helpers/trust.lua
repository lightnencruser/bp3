local trust = {}
local files = require('files')
local res   = require('resources')
local f     = files.new('bp/helpers/settings/trust_settings.lua')

if not f:exists() then
    f:write(string.format('return %s', T({}):tovstring()))
end

function trust.new()
    local self = {}

    -- Static Variables.
    self.settings   = dofile(string.format('%sbp/helpers/settings/trust_settings.lua', windower.addon_path))

    -- Private Variables.
    local bp        = false
    local trust     = self.settings.trust or {}

    -- Public Variables.
    self.enabled    = false

    -- Private Functions.
    local persist = function()

        if self.settings then
            self.settings.enabled   = self.enabled
            self.settings.trust     = trust

        end

    end
    persist()

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
    
    return self

end
return trust.new()