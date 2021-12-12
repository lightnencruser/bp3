local gil = {}
local texts = require('texts')
function gil.new()
    local self = {}
    
    -- Private Variables.
    local bp        = false
    local private   = {events={}, amount=windower.ffxi.get_items().gil, gained=0, time=os.time()}
    local layout    = {pos={x=2190, y=1250}, colors={text={alpha=255, r=245, g=200, b=20}, bg={alpha=200, r=0, g=0, b=0}, stroke={alpha=255, r=0, g=0, b=0}}, font={name='Lucida Console', size=8}, padding=3, stroke_width=1, draggable=true}
    local display   = texts.new('', {flags={draggable=layout.draggable}})
    local important = string.format('%s,%s,%s', 25, 165, 200)

    -- Private Functions.
    private.resetDisplay = function()
        display:pos(layout.pos.x, layout.pos.y)
        display:font(layout.font.name)
        display:color(layout.colors.text.r, layout.colors.text.g, layout.colors.text.b)
        display:alpha(layout.colors.text.alpha)
        display:size(layout.font.size)
        display:pad(layout.padding)
        display:bg_color(layout.colors.bg.r, layout.colors.bg.g, layout.colors.bg.b)
        display:bg_alpha(layout.colors.bg.alpha)
        display:stroke_width(layout.stroke_width)
        display:stroke_color(layout.colors.stroke.r, layout.colors.stroke.g, layout.colors.stroke.b)
        display:stroke_alpha(layout.colors.stroke.alpha)
        display:update()

    end
    private.resetDisplay()

    private.calculate = function()
        local gil   = windower.ffxi.get_items().gil
        local time  = (os.time()-private.time)
        local rate  = ((time/60)/60)

        if (not private.amount or gil ~= private.amount) then
            private.gained = (private.gained + (gil-private.amount))
            private.amount = gil

        end
        private.render(rate)

    end

    private.render = function(rate)

        if bp and bp.hideUI then
            
            if display:visible() then
                display:hide()
            end
            return

        elseif not display:visible() then
            display:show()

        end
        
        if bp and rate and display:visible() then
            local r = tostring(math.floor(private.gained/rate))
            local f = false
            local s = #r
            local a = {}

            for i=1, s do
                local p = (s%3)

                if i == p and not f and s > 3 then
                    table.insert(a, string.format('%s,', r[i]))
                    f = true

                elseif f and ((i-p)%3) == 0 and i ~= s then
                    table.insert(a, string.format('%s,', r[i]))

                else
                    table.insert(a, string.format('%s', r[i]))

                end

            end
            display:text(string.format('[$ \\cs(%s)%s GIL/$HR\\cr $]', important, table.concat(a, '')))
            display:update()

        end

    end
   
    -- Public Functions.
    self.setSystem = function(buddypal)
        if buddypal then
            bp = buddypal          
        end

    end

    -- Private Events.
    private.events.prerender = windower.register_event('prerender', function()
        private.calculate()
    end)
    
    return self
    
end
return gil.new()
