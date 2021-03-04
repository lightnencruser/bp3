local sounds = {}
local files  = require('files')
function sounds.new()
    local self = {}
    
    self.play = function(bp, name)
        local bp = bp or false
        local name = name or false

        if bp and name then
            local f = files.new(string.format('bp/resources/sounds//%s.wav', name))

            if f:exists() then
                windower.play_sound(string.format('%sbp/resources/sounds/%s.wav', windower.addon_path, name))
            end
            return false

        end

    end
    
    return self
    
end
return sounds.new()
