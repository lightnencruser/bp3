local distance  = {}
local player    = windower.ffxi.get_player()
local files     = require('files')
local texts     = require('texts')
local f = files.new(string.format('bp/helpers/settings/distance/%s_settings.lua', player.name))
require('vectors')

if not f:exists() then
  f:write(string.format('return %s', T({}):tovstring()))
end

function distance.new()
    local self = {}

    -- Static Variables.
    self.settings   = dofile(string.format('%sbp/helpers/settings/distance/%s_settings.lua', windower.addon_path, player.name))
    self.layout     = self.settings.layout or {pos={x=400, y=865}, colors={text={alpha=255, r=245, g=200, b=20}, bg={alpha=200, r=0, g=0, b=0}, stroke={alpha=255, r=0, g=0, b=0}}, font={name='Lucida Console', size=9}, padding=4, stroke_width=1, draggable=false}
    self.display    = texts.new('', {flags={draggable=self.layout.draggable}})
    self.important  = string.format('%s,%s,%s', 25, 165, 200)

    -- Private Variables.
    local bp        = false
    local private   = {events={}}

    -- Public Variables.
    self.distance   = nil

    -- Private Functions
    local persist = function()

        if self.settings then
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
        self.display:hide()
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

    private.render = function()
        local target    = windower.ffxi.get_mob_by_target('t') or false
        local color     = {string.format('%s,%s,%s', 25, 165, 200), string.format('%s,%s,%s', 25, 165, 200)}
        local update    = ''

        if bp.hideUI then
            
            if self.display:visible() then
                self.display:hide()
            end
            return

        end

        if bp and bp.me and target and target.distance then
            self.distance = ((V{bp.me.x, bp.me.y, bp.me.z} - V{target.x, target.y, target.z}):length())

            if self.distance > 0 and self.distance ~= nil then
                update = string.format('%05.2f', self.distance)
                self.display:text(string.format('{  \\cs(%s)%s\\cr  }', self.important, update))

                if not self.display:visible() then
                    self.display:show()
                end
                self.display:update()

            elseif self.distance == 0 or self.distance == nil and self.display:visible() then
                self.display:text('0')
                self.display:hide()

            end

        elseif self.display:visible() then
            self.display:hide()

        end

    end

    private.pos = function(x, y)
        local x = tonumber(x) or self.layout.pos.x
        local y = tonumber(y) or self.layout.pos.y

        if bp and x and y then
            self.display:pos(x, y)
            self.layout.pos.x = x
            self.layout.pos.y = y
            self.writeSettings()
        
        elseif bp and (not x or not y) then
            bp.helpers['popchat'].pop('PLEASE ENTER AN "X" OR "Y" COORDINATE!')

        end

    end

    -- Public Functions.
    self.setSystem = function(buddypal)
        if buddypal then
            bp = buddypal
        end

    end

    self.getDistance = function(target)
        local m = windower.ffxi.get_mob_by_target('me') or false
        local t = target or false

        if m and t then
            return ((V{m.x, m.y, m.z} - V{t.x, t.y, t.z}):length())
        end
        return 0

    end

    -- Private Events.
    private.events.commands = windower.register_event('addon command', function(...)
        local commands = T{...}
        local helper = commands[1]

        if bp and bp.player and helper and helper:lower() == 'distance' then
            table.remove(commands[1])

            if commands[1] then
                local command = commands[1]:lower()

                if command == 'pos' and commands[2] then
                    private.pos(commands[2], commands[3] or false)
                end

            end

        end

    end)

    private.events.prerender = windower.register_event('prerender', function()
        private.render()
    end)

    return self

end
return distance.new()