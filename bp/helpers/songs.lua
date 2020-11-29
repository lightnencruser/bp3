local songs     = {}
local player    = windower.ffxi.get_player()
local files     = require('files')
local texts     = require('texts')
local images    = require('images')
local f = files.new(string.format('bp/helpers/settings/songs/%s_settings.lua', player.name))

if not f:exists() then
  f:write(string.format('return %s', T({}):tovstring()))
end

function songs.new()
    local self = {}

    -- Static Variables.
    self.allowed    = require('resources').spells:type('BardSong')
    self.settings   = dofile(string.format('%sbp/helpers/settings/songs/%s_settings.lua', windower.addon_path, player.name))
    self.layout     = self.settings.layout or {pos={x=500, y=400}, colors={text={alpha=255, r=245, g=200, b=20}, bg={alpha=200, r=0, g=0, b=0}, stroke={alpha=255, r=0, g=0, b=0}}, font={name='Lucida Console', size=8}, padding=3, stroke_width=1, draggable=false}
    self.display    = texts.new('', {flags={draggable=self.layout.draggable}})
    self.icon       = images.new({color={alpha = 255},texture={fit=false},draggable=true})
    self.important  = string.format('%s,%s,%s', 25, 165, 200)

    -- Public Variables.
    self.position   = self.settings.position or 1
    self.dummies    = self.settings.dummies or {}
    self.warning    = self.settings.warning or false
    self.delay      = self.settings.delay or 180
    self.piano      = false
    self.jukebox    = Q{}

    -- Private Variables.
    local math      = math
    local dummies   = {{self.allowed[378], self.allowed[379]}, {self.allowed[409], self.allowed[410]}, {self.allowed[403], self.allowed[404]}}
    local valid     = {310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,319,330,331,332,333,334,335,336,337,338,339,600}
    local complex   = {

        ["march"]       = {count=1, songs={"Honor March","Victory March","Advancing March"}},
        ["min"]         = {count=1, songs={"Valor Minuet V","Valor Minuet IV","Valor Minuet III","Valor Minuet II","Valor Minuet"}},
        ["mad"]         = {count=1, songs={"Blade Madrigal","Sword Madrigal"}},
        ["prelude"]     = {count=1, songs={"Archer's Prelude","Hunter's Prelude"}},
        ["minne"]       = {count=1, songs={"Knight's Minne V","Knight's Minne IV","Knight's Minne III","Knight's Minne II","Knight's Minne"}},
        ["ballad"]      = {count=1, songs={"Mage's Ballad III","Mage's Ballad II","Mage's Ballad"}},
        ["mambo"]       = {count=1, songs={"Dragonfoe Mambo","Sheepfoe Mambo"}},
        ["str"]         = {count=1, songs={"Herculean Etude","Sinewy Etude"}},
        ["dex"]         = {count=1, songs={"Uncanny Etude","Dextrous Etude"}},
        ["vit"]         = {count=1, songs={"Vital Etude","Vivacious Etude"}},
        ["agi"]         = {count=1, songs={"Swift Etude","Quick Etude"}},
        ["int"]         = {count=1, songs={"Sage Etude","Learned Etude"}},
        ["mnd"]         = {count=1, songs={"Logical Etude","Spirited Etude"}},
        ["chr"]         = {count=1, songs={"Bewitching Etude","Enchanting Etude"}},
        ["fire"]        = {count=1, songs={"Fire Carol","Fire Carol II"}},
        ["ice"]         = {count=1, songs={"Ice Carol","Ice Carol II"}},
        ["wind"]        = {count=1, songs={"Wind Carol","Wind Carol II"}},
        ["earth"]       = {count=1, songs={"Earth Carol","Earth Carol II"}},
        ["thunder"]     = {count=1, songs={"Thunder Carol","Thunder Carol II"}},
        ["water"]       = {count=1, songs={"Water Carol","Water Carol II"}},
        ["light"]       = {count=1, songs={"Light Carol","Light Carol II"}},
        ["dark"]        = {count=1, songs={"Dark Carol","Dark Carol II"}},

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

        if self.settings then
            self.settings.position  = self.position
            self.settings.warning   = self.warning
            self.settings.dummy     = self.dummy
            self.settings.layout    = self.layout

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

        do -- Handle icon if one exists.
            local player = windower.ffxi.get_player()

            if self.icon and player.main_job == 'BRD' then
                self.icon:path(string.format("%sbp/resources/icons/songs/jukebox.png", windower.addon_path))
                self.icon:size(36, 36)
                self.icon:transparency(0)
                self.icon:pos_x(self.layout.pos.x-40)
                self.icon:pos_y(self.layout.pos.y-15)
                self.icon:show()

            else
                self.icon:hide()
                self.display:hide()

            end

        end

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

    self.resetComplexCount = function()

        for i,v in pairs(complex) do

            if complex[i] and complex[i].count then
                complex[i].count = 1
            end

        end

    end

    self.playJukebox = function()

        if self.jukebox:length() > 0 then

            for _,v in ipairs(self.jukebox.data) do
                local time = math.max(math.ceil(self.delay-(os.clock()-v.time)), 0)

                if time <= 0 then
                    v.time = os.clock()
                    windower.send_command(string.format('bp %s', table.concat(v.commands, ' ')))

                end

            end

        end                

    end

    self.clearJukebox = function()
        self.jukebox:clear()
        self.jukebox = Q{}
    end

    self.jobChange = function()
        self.clearJukebox()
        self.writeSettings()
        persist()
        resetDisplay()

    end

    -- Public Functions.
    self.render = function(bp)
        
        if self.jukebox:length() > 0 and self.display:visible() then
            local update = {}

            for _,v in ipairs(self.jukebox.data) do
                table.insert(update, string.format('SINGING ON: ♪[ \\cs(%s)%s\\cr ]♪ IN \\cs(%s)%03d\\cr\n%sCOMMAND: \\cs(%s)%s\\cr', self.important, v.target.name:upper(), self.important, math.max(math.ceil(self.delay-(os.clock()-v.time)), 0), ('♫'):lpad(' ', 5), self.important, table.concat(v.commands, ' '):upper()))
            end
            self.display:text(table.concat(update, '\n\n'))
            self.display:update()

        elseif self.jukebox:length() == 0 and self.display:visible() then
            self.display:hide()

        end

    end

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

    self.changeDummy = function(bp)
        local bp = bp or false

        if bp then
            self.position = (self.position + 1)

            if self.position > #dummies then
                self.position = 1
            end
            self.dummies = {dummies[self.position][1], dummies[self.position][2]}
            bp.helpers['popchat'].pop(string.format('DUMMY SONGS ARE NOW SET TO %s & %s.', self.dummies[1].en, self.dummies[2].en))
            self.writeSettings()

        end

    end

    self.toggleWarning = function(bp)
        local bp = bp or false

        if bp then

            if self.warning then
                self.warning = false
                bp.helpers['popchat'].pop(string.format('JA WARNING MESSAGE IS NOW: %s', tostring(self.warning)))

            else
                self.warning = true
                bp.helpers['popchat'].pop(string.format('JA WARNING MESSAGE IS NOW: %s', tostring(self.warning)))

            end
            self.writeSettings()

        end

    end

    self.sing = function(bp, commands)
        local bp        = bp or false
        local commands  = commands or false
        
        -- Song Command Structure: songs <song1> <song2> <song3> <song4> <song5> <target>
        if bp and commands then
            local player    = windower.ffxi.get_player()
            local helpers   = bp.helpers
            local loop      = false
            local target    = false
            local count     = {songs=1, allowed=self.getSongsAllowed(bp)}
            local flags     = {specials=false, ja=false}

            -- Reset Pianissimo.
            self.piano = false

            -- Clear the queue for incoming songs if it was not to loop.
            if not T(commands):contains('loop') then
                --helpers['queue'].clear()
            end
            
            if commands[#commands]:sub(1, 1) == '*' and helpers['party'].getMember(bp, commands[#commands]:sub(2, #commands[#commands]), false) then
                target = helpers['party'].getMember(bp, commands[#commands]:sub(2, #commands[#commands]), false)
                
                if target and player then
                    
                    if target.name == player.name then
                        target = player
                    end

                end

            end

            -- Check to see if Pianissimo need to be flagged.
            if target then
                self.piano = true
            
            elseif not target then
                target = player

            end

            -- Determine if NiTro should CAN used.
            if bp.core.getSetting('JA') and helpers['actions'].isReady(bp, 'JA', 'Nightingale') and helpers['actions'].isReady(bp, 'JA', 'Troubadour') then
                flags.ja = true
            end

            -- Adjust songs allowed if one-hour is enabled and available.
            if bp.core.getSetting('1HR') and flags.ja and helpers['actions'].isReady(bp, 'JA', 'Soul Voice') and helpers['actions'].isReady(bp, 'JA', 'Clarion Call') then
                count.allowed   = (count.allowed + 1)
                flags.specials  = true

            -- If enabled but used and the buff is currently active.
            elseif bp.core.getSetting('1HR') and not flags.ja and self.specialIsActive(bp) then
                count.allowed   = (count.allowed + 1)
                flags.specials  = true

            end

            -- Trigger a warning message if NiTro is down but one-hours are enabled and available.
            if bp.core.getSetting('JA') and bp.core.getSetting('1HR') and not flags.ja and not self.specialIsActive(bp) then
                windower.send_command('p ***WARNING!*** NITRO IS UNAVAILABLE AND 1HR IS CURRENTLY ACTIVATED!')
            end

            if flags.ja and not flags.specials then
                helpers['queue'].add(bp, bp.JA['Nightingale'], player)
                helpers['queue'].add(bp, bp.JA['Troubadour'], player)

                if helpers['actions'].isReady(bp, 'JA', 'Marcato') then
                    helpers['queue'].add(bp, bp.JA['Marcato'], player)
                end

            elseif flags.ja and flags.specials then
                helpers['queue'].add(bp, bp.JA['Soul Voice'], player)
                helpers['queue'].add(bp, bp.JA['Clarion Call'], player)
                helpers['queue'].add(bp, bp.JA['Nightingale'], player)
                helpers['queue'].add(bp, bp.JA['Troubadour'], player)

                if helpers['actions'].isReady(bp, 'JA', 'Marcato') then
                    helpers['queue'].add(bp, bp.JA['Marcato'], player)
                end

            end

            for i=2, #commands do
                local param = commands[i]:lower()
                
                if param == 'loop' then
                    loop = true

                    do -- Rebuild the commands in to a new format to prevent inserting multiple times.
                        local new_commands = {}

                        for i,v in ipairs(commands) do

                            if commands[i] ~= 'loop' then
                                table.insert(new_commands, commands[i])
                            end

                        end

                        if helpers['buffs'].buffActive(348) or helpers['queue'].inQueue(bp, bp.JA['Troubadour']) then
                            self.jukebox:push({target=target, commands=new_commands, time=(os.clock()+self.delay)})

                        else
                            self.jukebox:push({target=target, commands=new_commands, time=os.clock()})

                        end

                    end

                elseif complex[param] and count.songs <= count.allowed and complex[param].songs[complex[param].count] then
                    
                    if complex[param].songs[complex[param].count] == 'Honor March' and self.hasHonorMarch(bp) then

                        if count.songs == 3 and not flags.specials then
                            helpers['queue'].add(bp, bp.MA[dummies[self.position][1].en], target)
    
                        elseif count.songs == 4 and flags.specials then
                            helpers['queue'].add(bp, bp.MA[dummies[self.position][1].en], target)
    
                        elseif count.songs == 4 and not flags.specials then
                            helpers['queue'].add(bp, bp.MA[dummies[self.position][2].en], target)
    
                        elseif count.songs == 5 and flags.specials then
                            helpers['queue'].add(bp, bp.MA[dummies[self.position][2].en], target)
    
                        end
                        helpers['queue'].add(bp, bp.MA[complex[param].songs[complex[param].count]], target)
                        complex[param].count = (complex[param].count + 1)
                        count.songs = (count.songs + 1)

                    elseif complex[param].songs[complex[param].count] == 'Honor March' and not self.hasHonorMarch(bp) then
                        
                        if count.songs == 3 and not flags.specials then
                            helpers['queue'].add(bp, bp.MA[dummies[self.position][1].en], target)
    
                        elseif count.songs == 4 and flags.specials then
                            helpers['queue'].add(bp, bp.MA[dummies[self.position][1].en], target)
    
                        elseif count.songs == 4 and not flags.specials then
                            helpers['queue'].add(bp, bp.MA[dummies[self.position][2].en], target)
    
                        elseif count.songs == 5 and flags.specials then
                            helpers['queue'].add(bp, bp.MA[dummies[self.position][2].en], target)
    
                        end
                        helpers['queue'].add(bp, bp.MA[complex[param].songs[(complex[param].count+1)]], target)
                        complex[param].count = (complex[param].count + 2)
                        count.songs = (count.songs + 1)

                    else                    

                        if count.songs == 3 and not flags.specials then
                            helpers['queue'].add(bp, bp.MA[dummies[self.position][1].en], target)
    
                        elseif count.songs == 4 and flags.specials then
                            helpers['queue'].add(bp, bp.MA[dummies[self.position][1].en], target)
    
                        elseif count.songs == 4 and not flags.specials then
                            helpers['queue'].add(bp, bp.MA[dummies[self.position][2].en], target)
    
                        elseif count.songs == 5 and flags.specials then
                            helpers['queue'].add(bp, bp.MA[dummies[self.position][2].en], target)
    
                        end
                        helpers['queue'].add(bp, bp.MA[complex[param].songs[complex[param].count]], target)
                        complex[param].count = (complex[param].count + 1)
                        count.songs = (count.songs + 1)

                    end

                elseif short[param] and count.songs <= count.allowed then

                    if count.songs == 3 and not flags.specials then
                        helpers['queue'].add(bp, bp.MA[dummies[self.position][1].en], target)

                    elseif count.songs == 4 and flags.specials then
                        helpers['queue'].add(bp, bp.MA[dummies[self.position][1].en], target)

                    elseif count.songs == 4 and not flags.specials then
                        helpers['queue'].add(bp, bp.MA[dummies[self.position][2].en], target)

                    elseif count.songs == 5 and flags.specials then
                        helpers['queue'].add(bp, bp.MA[dummies[self.position][2].en], target)

                    end
                    helpers['queue'].add(bp, bp.MA[short[param]], target)
                    count.songs = (count.songs + 1)

                end

            end
            self.resetComplexCount()

        end

    end

    self.getSongsAllowed = function(bp)
        local bp = bp or false

        if bp then
            local helpers = bp.helpers

            if helpers['inventory'].inBag('Daurdabla') then
                return 4

            elseif helpers['inventory'].inBag('Terpander') or helpers['inventory'].inBag('Blurred Harp +1') then
                return 3

            end

        end
        return 2

    end

    self.hasHonorMarch = function(bp)
        local bp = bp or false

        if bp then
            local helpers = bp.helpers

            if helpers['inventory'].inBag('Marsyas') then
                return true
            end

        end
        return false

    end

    self.specialIsActive = function(bp)
        local bp = bp or false

        if bp then

            if bp.helpers['buffs'].buffActive(52) and bp.helpers['buffs'].buffActive(499) then
                return true
            end

        end
        return false

    end

    self.resetTimers = function(value)
        local value = tonumber(value) or false

        if self.jukebox:length() > 0 then

            for _,v in ipairs(self.jukebox.data) do
                local time = math.max(math.ceil(self.delay-(os.clock()-v.time)), 0)

                if value and value ~= nil and time <= value then
                    v.time = 0

                elseif not value then
                    v.time = 0

                end

            end

        end                

    end

    self.updatePosition = function(x, y)
        self.icon:pos(x or self.icon:pos_x(), y or self.icon:pos_y())
        self.icon:update()
        self.display:pos(self.icon:pos_x()+40, self.icon:pos_y()+15)
        self.display:update()
    end

    return self

end
return songs.new()