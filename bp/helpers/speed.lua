local speed = {}
local player    = windower.ffxi.get_player()
local files     = require('files')
local texts     = require('texts')
local res       = require('resources')
local f = files.new(string.format('bp/helpers/settings/speed/%s_settings.lua', player.name))

if not f:exists() then
    f:write(string.format('return %s', T({}):tovstring()))
end

function speed.new()
    local self = {}

    -- Static Variables.
    self.settings   = dofile(string.format('%sbp/helpers/settings/speed/%s_settings.lua', windower.addon_path, player.name))
    self.layout     = self.settings.layout or {pos={x=800, y=80}, colors={text={alpha=255, r=245, g=200, b=20}, bg={alpha=0, r=0, g=0, b=0}, stroke={alpha=255, r=0, g=0, b=0}}, font={name='Impact', size=12}, padding=5, stroke_width=2, draggable=true}
    self.display    = texts.new('', {flags={draggable=self.layout.draggable}})
    self.important  = self.settings.important or string.format('%s,%s,%s', 25, 165, 200)

    -- Public Variables.
    self.speed      = self.settings.speed or 50
    self.enabled    = self.settings.enabled or false

    -- Private Functions.
    local persist = function()
        local next = next

        if self.settings then
            self.settings.speed     = self.speed
            self.settings.enabled   = self.enabled
            self.settings.layout    = self.layout
            self.settings.important = self.important

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

    -- Static Functions.
    self.writeSettings = function()
        persist()

        if f:exists() then
            f:write(string.format('return %s', T(self.settings):tovstring()))

        elseif not f:exists() then
            f:write(string.format('return %s', T({}):tovstring()))
        end

    end
    self.writeSettings()

    self.zoneChange = function()
        self.writeSettings()

    end

    self.jobChange = function()
        self.writeSettings()
        persist()
        resetDisplay()

    end

    self.render = function()

        if self.enabled then
            self.display:text(string.format('{{ SPEED: \\cs(%s)%03d\\cr }}', self.important, self.speed))
            self.display:update()

            if not self.display:visible() then
                self.display:show()
            end

        elseif not self.enabled then

            if self.display:visible() then
                self.display:hide()
            end

        end

    end

    -- Public Functions.
    self.adjustSpeed = function(bp, packet_id, data)
        local bp    = bp or false
        local data  = data or false
        
        if bp and packet_id and data then
            local packed    = bp.packets.parse('incoming', data)
            local maint     = bp.helpers['maintenance'].enabled
            
            if packet_id == 0x037 then
            
                if packed and packed['Movement Speed/2'] and self.enabled then
                    packed['Movement Speed/2'] = self.speed

                    if bp.helpers['maintenance'].enabled then
                        packed['Status'] = 31
                    end

                elseif packed and packed['Movement Speed/2'] and not self.enabled and packed['Movement Speed/2'] < 50 then
                    packed['Movement Speed/2'] = 50

                    if bp.helpers['maintenance'].enabled then
                        packed['Status'] = 31
                    end

                end

            elseif packet_id == 0x00d then
                
                if packed and packed['Movement Speed'] and self.enabled then
                    packed['Movement Speed'] = self.speed

                    if bp.helpers['maintenance'].enabled then
                        packed['Status'] = 31
                    end

                elseif packed and packed['Movement Speed'] and not self.enabled and packed['Movement Speed'] < 50 then
                    packed['Movement Speed'] = 50

                    if bp.helpers['maintenance'].enabled then
                        packed['Status'] = 31
                    end

                end
            
            end
            return bp.packets.build(packed)

        end

    end

    self.setSpeed = function(bp, speed)
        local bp    = bp or false
        local speed = tonumber(speed) or false

        if bp and speed and speed ~= nil and speed >= 50 and speed <= 255 then
            self.speed = speed
            bp.helpers['popchat'].pop(string.format('SPEED SET TO: %03d', self.speed))
            self.writeSettings()
        
        else
            bp.helpers['popchat'].pop('ENTER A NUMBER BETWEEN 50 & 255!')

        end

    end


    self.toggle = function(bp)
        local bp = bp or false

        if self.enabled then
            self.enabled = false
        else
            self.enabled = true
        end
        bp.helpers['popchat'].pop(string.format('SPEED MODE: %s', tostring(self.enabled)))
        self.writeSettings()

    end

    self.pos = function(bp, x, y)
        local bp    = bp or false
        local x     = tonumber(x) or self.layout.pos.x
        local y     = tonumber(y) or self.layout.pos.y

        if bp and x and y then
            self.display:pos(x, y)
            self.layout.pos.x = x
            self.layout.pos.y = y
            self.writeSettings()
        
        elseif bp and (not x or not y) then
            bp.helpers['popchat'].pop('PLEASE ENTER AN "X" OR "Y" COORDINATE!')

        end

    end

    return self

end
return speed.new()