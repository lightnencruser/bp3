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

        res[6391],  res[6312],  res[6358],  res[6533],
        res[6392],  res[6313],  res[6359],  res[6534],
        res[5947],  res[6314],  res[6360],  res[6572],
        res[6541],  res[6315],  res[6361],  res[6573],
        res[6542],  res[6316],  res[6362],  res[5854],
        res[6543],  res[6317],  res[6363],  res[5855],
        res[6544],  res[6318],  res[6364],  res[5856],
        res[6545],  res[6319],  res[6365],  res[5857],
        res[6546],  res[6320],  res[6366],  res[5858],
        res[6547],  res[6321],  res[6382],  res[5946],
        res[6548],  res[6322],  res[6383],
        res[6549],  res[6323],  res[6384],
        res[6550],  res[6324],  res[6385],
        res[6551],  res[6325],  res[6386],
        res[6552],  res[6326],  res[6387],
        res[6553],  res[6327],  res[6388],
        res[6554],  res[6328],  res[6389],
        res[6555],  res[6329],  res[6390],
        res[6556],  res[6330],  res[6403],
        res[6557],  res[6331],  res[6404],
        res[6558],  res[6332],  res[6405],
        res[6559],  res[6350],  res[6479],
        res[6550],  res[6351],  res[6480],
        res[6561],  res[6352],  res[6481],
        res[6562],  res[6353],  res[6482],
        res[6563],  res[6354],  res[6483],
        res[6564],  res[6355],  res[6484],
        res[6283],  res[6356],  res[6485],
        res[6284],  res[6357],  res[6535],

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

        if bp and self.enabled and bp.helpers['inventory'].hasSpace() and not bp.helpers['target'].getTarget() then
            local player = windower.ffxi.get_player()

            for _,v in ipairs(items) do

                if bp.helpers['inventory'].findItemByName(v.en) and not bp.helpers['queue'].inQueue(bp, v) then
                    bp.helpers['queue'].add(bp, v, player)
                end

            end


        end

    end

    return self

end
return items.new()