local roe       = {}
local player    = windower.ffxi.get_player()
local files     = require('files')
local texts     = require('texts')
local f = files.new(string.format('bp/helpers/settings/roe/%s_settings.lua', player.name))

if not f:exists() then
  f:write(string.format('return %s', T({}):tovstring()))
end

function roe.new()
    local self = {}

    -- Static Variables.
    self.settings   = dofile(string.format('%sbp/helpers/settings/roe/%s_settings.lua', windower.addon_path, player.name))
    self.layout     = self.settings.layout or {pos={x=500, y=350}, colors={text={alpha=255, r=245, g=200, b=20}, bg={alpha=200, r=0, g=0, b=0}, stroke={alpha=255, r=0, g=0, b=0}}, font={name='Lucida Console', size=8}, padding=3, stroke_width=1, draggable=true}
    self.display    = texts.new('', {flags={draggable=self.layout.draggable}})
    self.important  = string.format('%s,%s,%s', 25, 165, 200)

    -- Public Variables.
    self.list       = self.settings.list or {}

    -- Private Functions
    local persist = function()
        local next = next

        if self.settings then
            self.settings.list          = self.list
            self.settings.flags         = self.flags
            self.settings.layout        = self.layout

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

    -- Public Functions.
    self.set = function(bp, id)
        local bp = bp or false
        local id = id or false

        if bp and id then
            bp.packets.inject(rob.packets.new('outgoing', 0x10C, {['RoE Quest']=id}))
        end

    end

    self.remove = function(bp, id)
        local bp = bp or false
        local id = id or false

        if bp and id then
            bp.packets.inject(rob.packets.new('outgoing', 0x10D, {['RoE Quest']=id}))
        end

    end

    self.update = function(bp, data)
        local bp = bp or false

        if bp then
            local packed = bp.packets.parse('incoming', data)

            if packed then
                self.list = {}

                for i=1, 30 do
                    table.insert(self.list, {id=packed[string.format('RoE Quest ID %s', i)], progress=packed[string.format('RoE Quest Progress %s', i)]})
                end
                self.writeSettings()

            end

        end

    end

    self.render = function(bp)

    end

    return self

end
return roe.new()