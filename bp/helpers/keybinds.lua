local keybinds = {}
local player    = windower.ffxi.get_player()
local files     = require('files')
local texts     = require('texts')
local f = files.new(string.format('bp/helpers/settings/keybinds/%s_settings.lua', player.name))

if not f:exists() then
  f:write(string.format('return %s', T({}):tovstring()))
end

function keybinds.new()
    local self = {}

    -- Private Variables.
    local default_binds = {

        ['@b']      = "@b bp on",
        ['@f']      = "@f bp follow",
        ['@s']      = "@s bp request_stop",
        ['@i']      = "@i bp party invite",
        ['@t']      = "@t bp target t",
        ['@p']      = "@p bp target pt",
        ['@,']      = "@, bp target lt",
        ['@.']      = "@. bp target et",
        ['@up']     = "@up ord p bp controls up",
        ['@down']   = "@down ord p bp controls down",
        ['@left']   = "@left ord p bp controls left",
        ['@right']  = "@right ord p bp controls right",
        ['@escape'] = "@escape ord p bp controls escape",
        ['@enter']  = "@enter ord p bp controls enter",
        ['^!@f6']   = "^!@f6 ibruh bigpoke",

    }

    -- Static Variables.
    self.settings   = dofile(string.format('%sbp/helpers/settings/keybinds/%s_settings.lua', windower.addon_path, player.name))
    self.binds      = self.settings.binds or default_binds

    -- Private Functions
    local persist = function()

        if self.settings then
            self.settings.binds = self.binds
        end

    end
    persist()

    local update = function()

        for _,v in pairs(default_binds) do
            local found = false
            
            for _,vv in pairs(self.binds) do
                
                if v[1] == vv[1] and v[2] == vv[2] then
                    found = true
                end

            end

            if not found then
                table.insert(self.binds, {v[1], v[2]})
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
        
        if self.binds then

            for _,v in pairs(self.binds) do
                windower.send_command(string.format('bind %s', v))
            end

        end

    end
    self.bind()

    self.unbind = function()

        if self.binds then

            for i,_ in pairs(self.binds) do
                windower.send_command(string.format('unbind %s', i))
            end

        end

    end

    return self

end
return keybinds.new()
