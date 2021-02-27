local menus = {}
function menus.new()
    local self = {}

    self.capture = function(bp, commands)
        local bp = bp or false

        if bp then
            bp.helpers['menus'].toggle(bp)
        end

    end

    return self

end
return menus.new()
