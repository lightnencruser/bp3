local runes     = {}
local player    = windower.ffxi.get_player()
local files     = require('files')
local texts     = require('texts')
local f = files.new(string.format('bp/helpers/settings/runes/%s_settings.lua', player.name))

if not f:exists() then
  f:write(string.format('return %s', T({}):tovstring()))
end

function runes.new()
    local self = {}

    -- Static Variables.
    self.allowed  = require('resources').job_abilities:type('Rune')
    self.settings = dofile(string.format('%sbp/helpers/settings/runes/%s_settings.lua', windower.addon_path, player.name))
    self.layout   = self.settings.layout or {pos={x=0, y=0}, colors={text={alpha=255, r=0, g=0, b=0}, bg={alpha=255, r=0, g=0, b=0}, stroke={alpha=255, r=0, g=0, b=0}}, font={name='Arial', size=8}, padding=8, stroke_width=2, draggable=false}
    self.display  = texts.new("")

    -- Public Variables.
    self.runes    = self.settings.runes or {self.allowed[365], self.allowed[365], self.allowed[365]}
    self.active   = {false, false, false}

    -- Private Functions.
    local persist = function()
        local next = next

        if self.settings and next(self.settings) == nil then
            self.settings.runes   = self.runes
            self.settings.layout  = self.layout

        elseif self.settings and next(self.settings) ~= nil then
            self.settings.runes   = self.runes
            self.settings.layout  = self.layout

        end

    end
    persist()

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

    -- Public Functions.

    return self

end
return runes.new()
