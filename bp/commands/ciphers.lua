local ciphers = {}
function ciphers.new()
    local self = {}

    self.capture = function(bp)
        local bp = bp or false
        
        if bp then
            bp.helpers['ciphers'].poke(bp)
        end

    end

    return self

end
return ciphers.new()
