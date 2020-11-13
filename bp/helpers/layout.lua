local layout = {}
function layout.new()
    local self = {}

    -- Private Functions.
    local enabled = false

    -- Public Functions.
    self.toggle = function(bp)
        local bp = bp or false

        if bp and self.enabled then
            self.enabled = false

            for i,helper in pairs(bp.helpers) do
                
                if helper.display and helper.display:visible() then
                    helper.display:text('')
                    helper.display:update()
                    helper.display:hide()

                end

            end                    

        elseif bp and not self.enabled then
            self.enabled = true

            for i,helper in pairs(bp.helpers) do
                
                if helper.display and not helper.display:visible() then
                    helper.display:text(i:upper())
                    helper.display:update()
                    helper.display:show()
                    
                end

            end

        end

    end

    return self

end
return layout.new()
