local popchat = {}
local files = require('files')
local texts = require('texts')
local f     = files.new('bp/helpers/settings/popchat_settings.lua')

if not f:exists() then
    f:write(string.format('return %s', T({}):tovstring()))
end

function popchat.new()
    local self = {}

    -- Private Variables.
    local bp        = false
    local private   = {events={}, chats={}, delay=4}

    -- Static Variables.
    self.settings   = dofile(string.format('%sbp/helpers/settings/popchat_settings.lua', windower.addon_path))
    self.layout     = self.settings.layout or {pos={x=300, y=450}, colors={text={alpha=255, r=100, g=215, b=0}, bg={alpha=0, r=0, g=0, b=0}, stroke={alpha=255, r=0, g=25, b=15}}, font={name='Impact', size=20}, padding=2, stroke_width=2, draggable=false}


    -- Private Functions.
    private.persist = function()

        if self.settings and next(self.settings) == nil then
            self.settings.layout = self.layout
        end

    end
    private.persist()

    private.setDisplay = function(index)

        if private.chats[index] then
            private.chats[index].message:pos(self.layout.pos.x, self.layout.pos.y)
            private.chats[index].message:font(self.layout.font.name)
            private.chats[index].message:color(self.layout.colors.text.r, self.layout.colors.text.g, self.layout.colors.text.b)
            private.chats[index].message:alpha(self.layout.colors.text.alpha)
            private.chats[index].message:size(self.layout.font.size)
            private.chats[index].message:pad(self.layout.padding)
            private.chats[index].message:bg_color(self.layout.colors.bg.r, self.layout.colors.bg.g, self.layout.colors.bg.b)
            private.chats[index].message:bg_alpha(self.layout.colors.bg.alpha)
            private.chats[index].message:stroke_width(self.layout.stroke_width)
            private.chats[index].message:stroke_color(self.layout.colors.stroke.r, self.layout.colors.stroke.g, self.layout.colors.stroke.b)
            private.chats[index].message:stroke_alpha(self.layout.colors.stroke.alpha)

        end

    end

    private.updatePosition = function()

        if #private.chats > 0 and private.chats[1] then
            local x, y = private.chats[1].message:extents()
            
            for index, data in ipairs(private.chats) do
                local offset = private.chats[1].message:pos_y()

                if index == 1 then
                    data.message:pos(self.layout.pos.x, self.layout.pos.y)
                else
                    data.message:pos(private.chats[1].message:pos_x(), (private.chats[1].message:pos_y() + (y * (index-1))))

                end

            end

        end

    end

    private.writeSettings = function()

        if f:exists() then
            f:write(string.format('return %s', T(self.settings):tovstring()))

        elseif not f:exists() then
            f:write(string.format('return %s', T({}):tovstring()))
        end

    end

    -- Public Functions.
    self.setSystem = function(buddypal)
        if buddypal then
            bp = buddypal
        end

    end

    self.pop = function(message)
        table.insert(private.chats, {message=texts.new(message, {flags={draggable=self.layout.draggable}}), fade=255})
        do
            private.setDisplay(#private.chats)
            private.chats[#private.chats].message:text(string.format('[  %s  ]', message:upper()))
            private.chats[#private.chats].message:update()

            if not private.chats[#private.chats].message:visible() then
                private.chats[#private.chats].message:show()
            end
            private.updatePosition()

        end

    end

    private.render = function()

        if private.chats[1] then
            
            private.chats[1].fade = (private.chats[1].fade - (255/(private.delay*16)))
            do
                private.chats[1].message:alpha(private.chats[1].fade)
                private.chats[1].message:update()

                if (private.chats[1].fade <= 0 or #private.chats > 5) then
                    private.chats[1].message:destroy()
                    table.remove(private.chats, 1)

                end
                private.updatePosition()

            end

        end

    end

    -- Private Events.
    private.events.commands = windower.register_event('addon command', function(...)
        local commands = T{...}
        local helper = table.remove(commands, 1)
        
        if bp and bp.player and helper and helper:lower() == 'popchat' and #commands > 0 then
            local message = {}
    
            for i=1, #commands do
                table.insert(message, commands[i])
            end
            self.pop(table.concat(message, ' '))

        end

    end)

    private.events.prerender = windower.register_event('prerender', function()

        if bp and bp.player then
            private.render()
        end

    end)

    return self

end
return popchat.new()
