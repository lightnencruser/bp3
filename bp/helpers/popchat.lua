local popchat = {}
local files = require('files')
local texts = require('texts')
local f     = files.new('bp/helpers/settings/popchat_settings.lua')

if not f:exists() then
    f:write(string.format('return %s', T({}):tovstring()))
end

function popchat.new()
    local self = {}

    -- Static Variables.
    self.settings   = dofile(string.format('%sbp/helpers/settings/popchat_settings.lua', windower.addon_path))
    self.layout     = self.settings.layout or {pos={x=300, y=450}, colors={text={alpha=255, r=100, g=215, b=0}, bg={alpha=0, r=0, g=0, b=0}, stroke={alpha=255, r=0, g=25, b=15}}, font={name='Impact', size=20}, padding=2, stroke_width=2, draggable=false}
    self.display    = texts.new('', {flags={draggable=self.layout.draggable}})
    self.delay      = 7
    self.fade       = 255
    self.fader      = (255/(self.delay*16))

    -- Private Variables.
    local bp        = false

    -- Static Functions.
    self.writeSettings = function()

        if f:exists() then
            f:write(string.format('return %s', T(self.settings):tovstring()))

        elseif not f:exists() then
            f:write(string.format('return %s', T({}):tovstring()))
        end

    end

    -- Private Functions.
    local persist = function()
        local next = next

        if self.settings and next(self.settings) == nil then
            self.settings.layout    = self.layout
            self.writeSettings()

        end

    end
    persist()

    local resetDisplay = function()
        self.display:pos(self.layout.pos.x, self.layout.pos.y)
        self.display:font(self.layout.font.name)
        self.display:color(self.layout.colors.text.r, self.layout.colors.text.g, self.layout.colors.text.b)
        self.display:alpha(self.layout.colors.text.alpha)
        self.display:size(self.layout.font.size)
        self.display:pad(self.layout.padding)
        self.display:bg_color(self.layout.colors.bg.r, self.layout.colors.bg.g, self.layout.colors.bg.b)
        self.display:bg_alpha(self.layout.colors.bg.alpha)
        self.display:stroke_width(self.layout.stroke_width)
        self.display:stroke_color(self.layout.colors.stroke.r, self.layout.colors.stroke.g, self.layout.colors.stroke.b)
        self.display:stroke_alpha(self.layout.colors.stroke.alpha)
        self.display:update()

    end
    resetDisplay()

    -- Public Functions.
    self.setSystem = function(buddypal)
        if buddypal then
            bp = buddypal
        end

    end
    
    self.pop = function(message)
        local message = message or false

        if message and tostring(message) ~= nil and message ~= '' then
            self.fade = 255
            self.display:text(string.format('[  %s  ]', message:upper()))
            self.display:update()
            self.display:show()

        end

    end

    self.render = function()

        if self.display:visible() then
            self.fade = (self.fade-self.fader)
            self.display:alpha(self.fade)
            self.display:update()

            if self.fade <= 0 then
                self.display:text('')
                self.display:update()
                self.display:hide()

            end

        end

    end

    return self

end
return popchat.new()
