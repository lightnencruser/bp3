local maintenance = {}
function maintenance.new()
    local self = {}

    -- Private Variables.
    local bp        = false

    -- Public Variables.
    self.data       = false
    self.status     = 0
    self.enabled    = false

    -- Public Functions.
    self.setSystem = function(buddypal)
        if buddypal then
            bp = buddypal
        end

    end
    
    self.updateData = function(original)
        local original = original or false

        if original then
            self.data = bp.packets.parse('incoming', original)

            if not self.enabled then
                self.status = self.data['Status']
            end

        end

    end

    self.toggle = function()
        local bp = bp or false

        if bp then

            if self.data and self.status then
                local packed = self.data

                if self.enabled then
                    self.enabled, packed['Status'] = false, self.status

                elseif not self.enabled then
                    self.enabled, packed['Status'] = true, 31

                end
                bp.helpers['popchat'].pop(string.format('MAINTENANCE MODE: %s', tostring(self.enabled)))
                bp.packets.inject(packed)

            elseif not self.data then
                bp.helpers['popchat'].pop('MAINTENANCE MODE CAN NOT BE SET YET!')

            end

        end

    end

    return self

end
return maintenance.new()