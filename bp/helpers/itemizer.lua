local itemizer = {}
function itemizer.new()
    local self = {}

    -- Private Variables.
    local bp = false

    -- Public Functions.
    self.setSystem = function(buddypal)
        if buddypal then
            bp = buddypal
        end

    end   
    
    self.get = function(name, bag, count)

        if name and bag then
            windower.send_command(('get %s %s %s'):format(name, bag, count or 0))
        end

    end

    self.put = function(name, bag, count)

        if name and bag then
            windower.send_command(('put %s %s %s'):format(name, bag, count or 0))
        end

    end
    
    return self

end
return itemizer.new()