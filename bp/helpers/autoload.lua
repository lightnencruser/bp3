local autoload  = {}
local player    = windower.ffxi.get_player()
local files     = require('files')
local f = files.new(string.format('bp/helpers/settings/autoload/%s_settings.lua', player.name))

if not f:exists() then
  f:write(string.format('return %s', T({}):tovstring()))
end

function autoload.new()
    local self = {}

    -- Private Variables.
    local default_addons = {

        'orders',
        'enter',
        'skillchains',
        'allmaps',
        'phantomgem',
        'superwarp',
        'interactbruh',

    }


    -- Static Variables.
    self.settings   = dofile(string.format('%sbp/helpers/settings/autoload/%s_settings.lua', windower.addon_path, player.name))
    self.addons     = self.settings.addons or default_addons

    -- Private Functions
    local persist = function()

        if self.settings then
            self.settings.addons = self.addons
        end

    end
    persist()

    local update = function()

        for _,v in ipairs(default_addons) do
            local found = false
            
            for _,vv in ipairs(self.addons) do
                
                if v == vv then
                    found = true
                end

            end

            if not found then
                table.insert(self.addons, v)
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

    -- Public Functions.
    self.install = function(bp, name)
        local bp    = bp or false
        local name  = name or false

        if bp and name and self.settings.addons then
            local found = false

            for _,v in ipairs(self.settings.addons) do
                        
                if v == name then
                    found = true
                    bp.helpers['popchat'].pop('THAT ADDON IS ALREADY INSTALLED IN THE AUTOLOADER!')
                end

            end

            if not found then
                table.insert(self.addons, name)
                windower.send_command(string.format('lua load %s', name))
                bp.helpers['popchat'].pop(string.format('ADDING %s TO THE AUTOLOAD SEQUENCE!', name))            
            end
            self.writeSettings()
            persist()

        end

    end

    self.remove = function(bp, name)
        local bp    = bp or false
        local name  = name or false

        if bp and name and self.settings.addons then
            local found = false

            for i,v in ipairs(self.settings.addons) do
                        
                if v == name then
                    found = true
                    bp.helpers['popchat'].pop('THAT ADDON IS ALREADY INSTALLED IN THE AUTOLOADER!')
                end

            end

            if not found then
                table.remove(self.addons, i)
                windower.send_command(string.format('lua load %s', name))
                bp.helpers['popchat'].pop(string.format('REMOVING %s TO THE AUTOLOAD SEQUENCE!', name))
            end
            self.writeSettings()
            persist()

        end

    end

    return self

end
return autoload.new()
