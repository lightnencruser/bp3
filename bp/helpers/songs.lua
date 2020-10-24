local songs     = {}
local player    = windower.ffxi.get_player()
local files     = require('files')
local texts     = require('texts')
local f = files.new(string.format('bp/helpers/settings/songs/%s_settings.lua', player.name))

if not f:exists() then
  f:write(string.format('return %s', T({}):tovstring()))
end

function songs.new()
    local self = {}

    -- Static Variables.
    self.allowed  = require('resources').spells:type('BardSong')
    self.settings = dofile(string.format('%sbp/helpers/settings/songs/%s_settings.lua', windower.addon_path, player.name))
    self.layout   = self.settings.layout or {pos={x=300, y=400}, colors={text={alpha=255, r=100, g=215, b=0}, bg={alpha=0, r=0, g=0, b=0}, stroke={alpha=255, r=0, g=25, b=15}}, font={name='Mulish', size=8}, padding=2, stroke_width=2, draggable=false}
    self.display  = texts.new('', {flags={draggable=self.layout.draggable}})

    -- Public Variables.
    self.max        = 0
    self.position   = self.settings.position or 1
    self.dummies    = self.settings.dummies or {}

    -- Private Variables.
    local dummies = {{self.allowed[378], self.allowed[379]}, {self.allowed[409], self.allowed[410]}, {self.allowed[403], self.allowed[404]}}
    local valid   = {310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,319,330,331,332,333,334,335,336,337,338,339,600}
    local complex = {

        ["March"]        = {count=1, songs={"Honor March","Victory March","Advancing March"}},
        ["Minuet"]       = {count=1, songs={"Valor Minuet V","Valor Minuet IV","Valor Minuet III","Valor Minuet II","Valor Minuet"}},
        ["Madrigal"]     = {count=1, songs={"Blade Madrigal","Sword Madrigal"}},
        ["Prelude"]      = {count=1, songs={"Archer's Prelude","Hunter's Prelude"}},
        ["Minne"]        = {count=1, songs={"Knight's Minne V","Knight's Minne IV","Knight's Minne III","Knight's Minne II","Knight's Minne"}},
        ["Ballad"]       = {count=1, songs={"Mage's Ballad III","Mage's Ballad II","Mage's Ballad"}},
        ["Mambo"]        = {count=1, songs={"Dragonfoe Mambo","Sheepfoe Mambo"}},
        ["Strength"]     = {count=1, songs={"Herculean Etude","Sinewy Etude"}},
        ["Dexterity"]    = {count=1, songs={"Uncanny Etude","Dextrous Etude"}},
        ["Vitality"]     = {count=1, songs={"Vital Etude","Vivacious Etude"}},
        ["Agility"]      = {count=1, songs={"Swift Etude","Quick Etude"}},
        ["Intelligence"] = {count=1, songs={"Sage Etude","Learned Etude"}},
        ["Mind"]         = {count=1, songs={"Logical Etude","Spirited Etude"}},
        ["Charisma"]     = {count=1, songs={"Bewitching Etude","Enchanting Etude"}},
        ["Fire"]         = {count=1, songs={"Fire Carol","Fire Carol II"}},
        ["Ice"]          = {count=1, songs={"Ice Carol","Ice Carol II"}},
        ["Wind"]         = {count=1, songs={"Wind Carol","Wind Carol II"}},
        ["Earth"]        = {count=1, songs={"Earth Carol","Earth Carol II"}},
        ["Thunder"]      = {count=1, songs={"Thunder Carol","Thunder Carol II"}},
        ["Water"]        = {count=1, songs={"Water Carol","Water Carol II"}},
        ["Light"]        = {count=1, songs={"Light Carol","Light Carol II"}},
        ["Dark"]         = {count=1, songs={"Dark Carol","Dark Carol II"}},

    }

    local short = {

        ["req1"]      = "Foe Requiem",          ["req2"]        = "Foe Requiem II",        ["req3"]      = "Foe Requiem III",      ["req4"]      = "Foe Requiem IV",
        ["req5"]      = "Foe Requiem V",        ["req6"]        = "Foe Requiem VI",        ["req7"]      = "Foe Requiem VII",      ["lull1"]     = "Foe Lullaby",
        ["lull2"]     = "Foe Lullaby II",       ["horde1"]      = "Horde Lullaby",         ["horde2"]    = "Horde Lullaby II",     ["army1"]     = "Army's Paeon",
        ["army2"]     = "Army's Paeon II",      ["army3"]       = "Army's Paeon III",      ["army4"]     = "Army's Paeon IV",
        ["army5"]     = "Army's Paeon V",       ["army6"]       = "Army's Paeon VI",       ["ballad1"]   = "Mage's Ballad",        ["ballad2"]   = "Mage's Ballad II",
        ["ballad3"]   = "Mage's Ballad III",    ["minne1"]      = "Knight's Minne",        ["minne2"]    = "Knight's Minne II",
        ["minne3"]    = "Knight's Minne III",   ["minne4"]      = "Knight's Minne IV",     ["minne5"]    = "Knight's Minne V",
        ["min1"]      = "Valor Minuet",         ["min2"]        = "Valor Minuet II",       ["min3"]      = "Valor Minuet III",     ["min4"]      = "Valor Minuet IV",
        ["min5"]      = "Valor Minuet V",       ["mad1"]        = "Sword Madrigal",        ["mad2"]      = "Blade Madrigal",
        ["lude1"]     = "Hunter's Prelude",     ["lude2"]       = "Archer's Prelude",      ["mambo1"]    = "Sheepfoe Mambo",       ["mambo2"]    = "Dragonfoe Mambo",
        ["herb1"]     = "Herb Pastoral",        ["shining1"]    = "Shining Fantasia",      ["oper1"]     = "Scop's Operetta",      ["oper2"]     = "Puppet's Operetta",
        ["gold1"]     = "Gold Capriccio",       ["round1"]      = "Warding Round",         ["gob1"]      = "Goblin Gavotte",       ["march1"]    = "Advancing March",
        ["march2"]    = "Victory March",        ["hm"]          = "Honor March",           ["elegy1"]    = "Battlefield Elegy",    ["elegy2"]    = "Carnage Elegy",
        ["str1"]      = "Sinewy Etude",         ["str2"]        = "Herculean Etude",       ["dex1"]      = "Dextrous Etude",       ["dex2"]      = "Uncanny Etude",
        ["vit1"]      = "Vivacious Etude",      ["vit2"]        = "Vital Etude",           ["agi1"]      = "Quick Etude",          ["agi2"]      = "Swift Etude",
        ["int1"]      = "Learned Etude",        ["int2"]        = "Sage Etude",            ["mnd1"]      = "Spirited Etude",       ["mnd2"]      = "Logical Etude",
        ["chr1"]      = "Enchanting Etude",     ["chr2"]        = "Bewitching Etude",      ["firec1"]    = "Fire Carol",           ["firec2"]    = "Fire Carol II",
        ["icec1"]     = "Ice Carol",            ["icec2"]       = "Ice Carol II",          ["windc1"]    = "Wind Carol",           ["windc2"]    = "Wind Carol II",
        ["earthc1"]   = "Earth Carol",          ["earthc2"]     = "Earth Carol II",        ["thunderc1"] = "Lightning Carol",      ["thunderc2"] = "Lightning Carol II",
        ["waterc1"]   = "Water Carol",          ["waterc2"]     = "Water Carol II",        ["lightc1"]   = "Light Carol",          ["lightc2"]   = "Light Carol II",
        ["darkc1"]    = "Dark Carol",           ["darkc2"]      = "Dark Carol II",         ["firet1"]    = "Fire Threnody",        ["firet2"]    = "Fire Threnody II",
        ["icet1"]     = "Ice Threnody",         ["icet2"]       = "Ice Threnody II",       ["windt1"]    = "Wind Threnody",        ["windt2"]    = "Wind Threnody II",
        ["eartht1"]   = "Earth Threnody",       ["eartht2"]     = "Earth Threnody II",     ["thundt1"]   = "Lightning Threnody",   ["thundt2"]   = "Lightning Threnody II",
        ["watert1"]   = "Water Threnody",       ["watert2"]     = "Water Threnody II",     ["lightt1"]   = "Light Threnody",       ["lightt2"]   = "Light Threnody II",
        ["darkt1"]    = "Dark Threnody",        ["darkt2"]      = "Dark Threnody II",      ["finale"]    = "Magic Finale",         ["ghym"]      = "Goddess's Hymnus",
        ["scherzo"]   = "Sentinel's Scherzo",   ["pining"]      = "Pining Nocturne",       ["zurka1"]    = "Raptor Mazurka",       ["zurka2"]    = "Chocobo Mazurka",
        ["fcarol1"]   = "Fire Carol",           ["fcarol2"]     = "Fire Carol II",         ["icarol1"]   = "Ice Carol",            ["icarol2"]   = "Ice Carol II",
        ["wcarol1"]   = "Wind Carol",           ["wcarol2"]     = "Wind Carol II",         ["ecarol1"]   = "Earth Carol",          ["ecarol2"]   = "Earth Carol II",
        ["tcarol1"]   = "Lightning Carol",      ["tcarol2"]     = "Lightning Carol II",    ["wcarol1"]   = "Water Carol",          ["waterc2"]   = "Water Carol II",
        ["lcarol1"]   = "Light Carol",          ["lcarol2"]     = "Light Carol II",        ["dcarol1"]   = "Dark Carol",           ["dcarol2"]   = "Dark Carol II",

    }

    -- Correct Dummy Songs
    self.dummies = {dummies[self.position][1], dummies[self.position][2]}

    -- Private Functions.
    local persist = function()
        local next = next

        if self.settings and next(self.settings) == nil then
            self.settings.dummy  = self.dummy
            self.settings.layout = self.layout

        elseif self.settings and next(self.settings) ~= nil then
            self.settings.dummy  = self.dummy
            self.settings.layout = self.layout

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

    -- Public Functions.
    self.valid = function(bp, song)
        local bp    = bp or false
        local song  = song or false

        if bp and song and (type(song) == 'number' or tonumber(song) ~= nil) then

            for _,v in ipairs(valid) do

                if v == song then
                    return true
                end

            end

        end
        return false

    end

    self.change = function(bp)
        local bp = bp or false

        if bp then
            self.position = (self.position + 1)

            if self.position > #dummies then
                self.position = 1
            end
            self.dummies = {dummies[self.position][1], dummies[self.position][2]}
            self.writeSettings()
            bp.helpers['popchat'].pop(string.format('Dummy songs are now set to %s & %s.', self.dummies[1].en, self.dummies[2].en))

        end

    end

    return self

end
return songs.new()
