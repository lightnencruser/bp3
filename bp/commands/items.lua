local items = {}
function items.new()
    local self = {}

    self.capture = function(bp, commands)
        bp.helpers['items'].toggle(bp)
    end

    return self

end
return items.new()
