local items  = {}
local player    = windower.ffxi.get_player()
local files     = require('files')
local res       = require('resources').items
local f = files.new(string.format('bp/helpers/settings/items/%s_settings.lua', player.name))

if not f:exists() then
  f:write(string.format('return %s', T({}):tovstring()))
end

function items.new()
    local self = {}

    -- Static Variables.
    self.settings   = dofile(string.format('%sbp/helpers/settings/items/%s_settings.lua', windower.addon_path, player.name))

    -- Public Variables.
    self.enabled    = false

    -- Private Variables.
    local items     = {

        res[6391],
        res[6392],
        res[3501],

    }

    -- Private Functions
    local persist = function()

        if self.settings then
            self.settings.layout    = self.layout
            self.settings.important = self.important

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

    self.toggle = function(bp)
        
        if self.enabled then
            self.enabled = false

        else
            self.enabled = true
        
        end
        bp.helpers['popchat'].pop(string.format('AUTO-ITEM USE: %s', tostring(self.enabled)))
    
    end        

    -- Public Functions.
    self.queueItems = function(bp)
        local bp = bp or false

        if bp and self.enabled then

            for _,v in ipairs(items) do

                if bp.helpers['inventory'].findItemByName(v.en) and not bp.helpers['queue'].inQueue(bp, v) then
                    bp.helpers['queue'].add(bp, v, 'me')
                end

            end


        end

    end

    return self

end
return items.new()