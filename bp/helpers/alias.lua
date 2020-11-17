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

    -- Private Variables.
    local default_aliases = {

        -- BP Shortcuts.
        {'bpon',        "ord pp bp enable"},
        {'bpoff',       "ord pp bp disable"},

        -- HTBF Commands.
        {'lilith',      "ord rr pg maiden"},

        -- Homepoints.
        {'portb',       "ord rr hp Port Bastok 2"},
        {'selbina',     "ord rr hp Selbina"},
        {'mha',         "ord rr hp Mhaura"},

        -- Item commands.
        {'prisms',      "ord rr input /item 'Prism Powder' <me>"},
        {'oils',        "ord rr input /item 'Silent Oil' <me>"},
        {'vshard',      "ord rr input /item 'V. Con. Shard' <me>"},

    }

    -- Static Variables.
    self.settings   = dofile(string.format('%sbp/helpers/settings/alias/%s_settings.lua', windower.addon_path, player.name))
    self.aliases    = self.settings.aliases or default_aliases

    -- Private Functions
    local persist = function()

        if self.settings then
            self.settings.aliases = self.aliases
        end

    end
    persist()

    local update = function()

        for _,v in ipairs(default_aliases) do
            local found = false
            
            for _,vv in ipairs(self.aliases) do
                
                if v[1] == vv[1] and v[2] == vv[2] then
                    found = true
                end

            end

            if not found then
                table.insert(self.aliases, {v[1], v[2]})
            end
    
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
    update()

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
