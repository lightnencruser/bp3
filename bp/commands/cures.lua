local cures = {}
function cures.new()
    local self = {}

    self.capture = function(bp)
        local bp = bp or false

        if bp then
            bp.helpers['cures'].changeMode(bp)
        end

    end

    return self

end
return cures.new()
