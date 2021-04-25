local debug = {}
function debug.new()
    local self = {}

    self.capture = function(bp)
        local bp = bp or false

        if bp then
            bp.helpers['debug'].toggle()
        end
        
    end

    return self

end
return debug.new()
