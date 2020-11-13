local alias     = {}
local player    = windower.ffxi.get_player()
local files     = require('files')
local texts     = require('texts')
local f = files.new(string.format('bp/helpers/settings/alias/%s_settings.lua', player.name))

if not f:exists() then
  f:write(string.format('return %s', T({}):tovstring()))
end

function alias.new()
    local self = {}

    -- Static Variables.
    self.settings   = dofile(string.format('%sbp/helpers/settings/alias/%s_settings.lua', windower.addon_path, player.name))
    self.aliases    = self.settings.aliases or {

        {'prisms',      "ord rr input /item 'Prism Powder' <me>"},
        {'oils',        "ord rr input /item 'Silent Oil' <me>"},

    }

    -- Private Functions
    local persist = function()

        if self.settings then
            self.settings.aliases = self.aliases
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

    self.bind = function()
        
        if self.aliases then

            for _,v in ipairs(self.aliases) do
                windower.send_command(string.format('alias %s %s', v[1], v[2]))
            end

        end

    end
    self.bind()

    self.unbind = function()

        if self.aliases then

            for _,v in ipairs(self.aliases) do
                windower.send_command(string.format('unalias %s', v[1]))
            end

        end

    end

    return self

end
return alias.new()
