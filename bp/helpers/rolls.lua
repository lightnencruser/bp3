local rolls     = {}
local player    = windower.ffxi.get_player()
local files     = require('files')
local texts     = require('texts')
local f = files.new(string.format('bp/helpers/settings/rolls/%s_settings.lua', player.name))

if not f:exists() then
  f:write(string.format('return %s', T({}):tovstring()))
end

function rolls.new()
  local self = {}

  -- Static Variables.
  self.allowed  = require('resources').job_abilities:type('CorsairRoll')
  self.settings = dofile(string.format('%sbp/helpers/settings/rolls/%s_settings.lua', windower.addon_path, player.name))
  self.layout   = self.settings.layout or {pos={x=0, y=0}, colors={text={alpha=255, r=0, g=0, b=0}, bg={alpha=255, r=0, g=0, b=0}, stroke={alpha=255, r=0, g=0, b=0}}, font={name='Arial', size=8}, padding=8, stroke_width=2, draggable=false}
  self.display  = texts.new("")

  -- Public Variables.
  self.rolls    = self.settings.rolls or {self.allowed[109], self.allowed[105]}
  self.rolling  = {name="", dice=0}
  self.rolled   = 0

  -- Private Variables.
  local valid   = {310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,319,330,331,332,333,334,335,336,337,338,339,600}
  local short   = {

    ['sam']     = "Samurai Roll",       ['stp']   = "Samurai Roll",     ['att']     = "Chaos Roll",         ['at']    = "Chaos Roll",
    ['atk']     = "Chaos Roll",         ['da']    = "Fighter's Roll",   ['dbl']     = "Fighter's Roll",     ['sc']    = "Allies' Roll",
    ['acc']     = "Hunter's Roll",      ['mab']   = "Wizard's Roll",    ['matk']    = "Wizard's Roll",      ['macc']  = "Warlock's Roll",
    ['regain']  = "Tactician's Roll",   ['tp']    = "Tactician's Roll", ['mev']     = "Runeist's Roll",     ['meva']  = "Runeist's Roll",
    ['mdb']     = "Magus's Roll",       ['patt']  = "Beast Roll",       ['patk']    = "Beast Roll",         ['pacc']  = "Drachen Roll",
    ['pmab']    = "Puppet Roll",        ['pmatk'] = "Puppet Roll",      ['php']     = "Companion's Roll",   ['php+']  = "Companion's Roll",
    ['pregen']  = "Companion's Roll",   ['comp']  = "Companion's Roll", ['refresh'] = "Evoker's Roll",      ['mp']    = "Evoker's Roll",
    ['mp+']     = "Evoker's Roll",      ['xp']    = "Corsair's Roll",   ['exp']     = "Corsair's Roll",     ['cp']    = "Corsair's Roll",
    ['crit']    = "Rogue's Roll",       ['def']   = "Gallant's Roll",

  }

  local lucky = {

    ["Samurai Roll"]   = 2,     ["Chaos Roll"]       = 4,
    ["Hunter's Roll"]  = 4,     ["Fighter's Roll"]   = 5,
    ["Wizard's Roll"]  = 5,     ["Tactician's Roll"] = 5,
    ["Runeist's Roll"] = 5,     ["Beast Roll"]       = 4,
    ["Puppet Roll"]    = 3,     ["Corsair's Roll"]   = 5,
    ["Evoker's Roll"]  = 5,     ["Companion's Roll"] = 2,
    ["Warlock's Roll"] = 4,     ["Magus's Roll"]     = 2,
    ["Drachen Roll"]   = 4,     ["Allies' Roll"]     = 3,
    ["Rogue's Roll"]   = 5,     ["Gallant's Roll"]   = 3,

  }

  -- Static Functions.
  self.writeSettings = function()

      if f:exists() then
          f:write(string.format('return %s', T(self.settings):tovstring()))

      elseif not f:exists() then
          f:write(string.format('return %s', T({}):tovstring()))
      end

  end

  local persist = function()
    local next = next

    if self.settings and next(self.settings) == nil then
      self.settings.rolls  = self.rolls
      self.settings.layout = self.layout
      self.writeSettings()

    end

  end
  persist()

  -- Rolls Functions.

  return self

end
return rolls.new()
