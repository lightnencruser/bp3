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

    -- Public Variables.
    self.enabled    = false

    -- Private Variables.
    local trust     = self.settings.trust or {}

    -- Private Functions.
    local persist = function()
        local next = next

        if self.settings then
            self.settings.enabled   = self.enabled
            self.settings.trust     = trust

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

    return self

end
trust.new()