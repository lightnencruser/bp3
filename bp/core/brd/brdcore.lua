local core = {}
local player    = windower.ffxi.get_player()
local files     = require('files')
local texts     = require('texts')
local res       = require('resources')
local f         = files.new(string.format('bp/core/%s/settings/%s.lua', player.main_job, player.name))

if not f:exists() then
    f:write(string.format('return %s', T({}):tovstring()))
end

function core.get()
    local self = {}

    -- Static Variables
    self.settings   = dofile(string.format('%sbp/core/%s/settings/%s.lua', windower.addon_path, player.main_job, player.name))
    self.layout     = self.settings.layout or {pos={x=300, y=400}, colors={text={alpha=255, r=100, g=215, b=0}, bg={alpha=150, r=0, g=0, b=0}, stroke={alpha=255, r=0, g=0, b=0}}, font={name='Krona One', size=8}, padding=8, stroke_width=2, draggable=true}
    self.display    = texts.new('', {flags={draggable=self.layout.draggable}})
    self.config     = texts.new('', {flags={draggable=self.layout.draggable}})

    -- Public Variables
    self["JOB POINTS"]         = windower.ffxi.get_player()["job_points"][windower.ffxi.get_player().main_job:lower()].jp_spent
    self["AM"]                 = self.settings["AM"] or {{false,true}, false}
    self["AM LEVEL"]           = self.settings["AM LEVEL"] or {{3,2,1}, 3}
    self["AM THRESHOLD"]       = self.settings["AM THRESHOLD"] or 3000
    self["1HR"]                = self.settings["1HR"] or {{false,true}, false}
    self["JA"]                 = self.settings["JA"] or {{false,true}, false}
    self["RA"]                 = self.settings["RA"] or {{false,true}, false}
    self["SUBLIMATION"]        = self.settings["SUBLIMATION"] or {{true,false}, true}
    self["HATE"]               = self.settings["HATE"] or {{false,true}, false}
    self["BUFFS"]              = self.settings["BUFFS"] or {{false,true}, false}
    self["DEBUFFS"]            = self.settings["DEBUFFS"] or {{false,true}, false}
    self["STATUS"]             = self.settings["STATUS"] or {{false,true}, false}
    self["WS"]                 = self.settings["WS"] or {{false,true}, false}
    self["WSNAME"]             = self.settings["WSNAME"] or "Evisceration"
    self["RANGED WS"]          = self.settings["RANGED WS"] or "Leaden Salute"
    self["TP THRESHOLD"]       = self.settings["TP THRESHOLD"] or 1000
    self["SC"]                 = self.settings["SC"] or {{false,true}, false}
    self["BURST"]              = self.settings["BURST"] or {{false,true}, false}
    self["ELEMENT"]            = self.settings["ELEMENT"] or {{"Fire","Ice","Wind","Earth","Lightning","Water","Light","Dark","Random"}, "Fire"}
    self["TIER"]               = self.settings["TIER"] or {{"I","II","III","IV","V","Random"}, "I"}
    self["ALLOW AOE"]          = self.settings["ALLOW AOE"] or {{false,true}, false}
    self["DRAINS"]             = self.settings["DRAINS"] or {{false,true}, false}
    self["STUNS"]              = self.settings["STUNS"] or {{false,true}, false}
    self["TANK MODE"]          = self.settings["TANK MODE"] or {{false,true}, false}
    self["SEKKA"]              = self.settings["SEKKA"] or "Evisceration"
    self["SHADOWS"]            = self.settings["SHADOWS"] or {{false,true}, false}
    self["FOOD"]               = self.settings["FOOD"] or {{"Sublime Sushi","Sublime Sushi +1"}, "Sublime Sushi"}
    self["SAMBAS"]             = self.settings["SAMBAS"] or {{"Drain Samba II","Haste Samba"}, "Haste Samba"}
    self["STEPS"]              = self.settings["STEPS"] or {{"Quickstep","Box Step","Stutter Step"}, "Quickstep"}
    self["SKILLUP"]            = self.settings["SKILLUP"] or {{false,true}, false}
    self["SKILLS"]             = self.settings["SKILLS"] or {{"Singing"}, "Singing"}
    self["COMPOSURE"]          = self.settings["COMPOSURE"] or {{true,false}, true}
    self["CONVERT"]            = self.settings["CONVERT"] or {{true,false}, false}
    self["ENSPELL"]            = self.settings["ENSPELL"] or {{"Enfire","Enblizzard","Enaero","Enstone","Enthunder","Enwater"}, "Enfire"}
    self["GAINS"]              = self.settings["GAINS"] or {{"Gain-DEX","Gain-STR","Gain-MND","Gain-INT","Gain-AGI","Gain-VIT","Gain-CHR"}, "Gain-DEX"}
    self["SPIKES"]             = self.settings["SPIKES"] or {{"None","Blaze Spikes","Ice Spikes","Shock Spikes"}, "None"}
    self["DIA"]                = self.settings["DIA"] or {{"Dia","Bio"}, "Dia"}
    self["SANGUINE"]           = self.settings["SANGUINE"] or {{false,true}, false}
    self["THRENODY"]           = self.settings["THRENODY"] or {{"Fire Threnody II","Ice Threnody II","Wind Threnody II","Earth Threnody II","Lightning Threnody II","Water Threnody II","Light Threnody II","Dark Threnody II"}, "Fire Threnody II"}
    self["QD"]                 = self.settings["QD"] or {{false,true}, false}
    self["SHOTS"]              = self.settings["SHOTS"] or {{"Fire Shot","Ice Shot","Wind Shot","Earth Shot","Thunder Shot","Water Shot","Light Shot","Dark Shot"}, "Fire Shot"}
    self["BOOST"]              = self.settings["BOOST"] or {{false,true}, false}
    self["PET"]                = self.settings["PET"] or {{false,true}, false}
    self["SPIRITS"]            = self.settings["SPIRITS"] or {{"Light Spirit","Fire Spirirt","Ice Spirit","Air Spirit","Earth Spirit","Thunder Spirit","Water Spirit","Dark Spirit"}, "Light Spirit"}
    self["SUMMON"]             = self.settings["SUMMON"] or {{"Carbuncle","Cait Sith","Ifrit","Shiva","Garuda","Titan","Ramuh","Leviathan","Fenrir","Diabolos","Siren"}, "Ifrit"}
    self["BPRAGE"]             = self.settings["BPRAGE"] or {{false,true}, false}
    self["BPWARD"]             = self.settings["BPWARD"] or {{false,true}, false}
    self["AOEHATE"]            = self.settings["AOEHATE"] or {{false,true}, false}
    self["EMBOLDEN"]           = self.settings["EMBOLDEN"] or {{"Palanx","Temper","Regen IV"}, "Phalanx"}
    self["BLU MODE"]           = self.settings["BLU MODE"] or {{"DPS","NUKE"}, "DPS"}
    self["MIGHTY GUARD"]       = self.settings["MIGHTY GUARD"] or {{true,false}, true}
    self["CHIVALRY"]           = self.settings["CHIVALRY"] or {{1000,1500,2000,2500,3000}, 2000}
    self["WEATHER"]            = self.settings["WEATHER"] or {{"Firestorm","Hailstorm","Windstorm","Sandstorm","Thunderstorm","Rainstorm","Voidstorm","Aurorastorm"}, "Aurorastorm"}
    self["ARTS"]               = self.settings["ARTS"] or {{"Light Arts","Dark Arts"}, "Light Arts"}
    self["WHITE"]              = self.settings["WHITE"] or {{"Addendum: White","Addendum: Black"}, "Addendum: White"}
    self["MISERY"]             = self.settings["MISERY"] or {{false,true}, false}
    self["IMPETUS WS"]         = self.settings["IMPETUS WS"] or "Raging Fists"
    self["FOORWORK WS"]        = self.settings["FOOTWORK WS"] or "Tornado Kick"
    self["DEFAULT WS"]         = self.settings["DEFAULT WS"] or "Howling Fist"

    -- MAGIC BURST SPELLS.
    self.settings["MAGIC BURST"]={

        ["Transfixion"]   = {},
        ["Compression"]   = {},
        ["Liquefaction"]  = {},
        ["Scission"]      = {},
        ["Reverberation"] = {},
        ["Detonation"]    = {},
        ["Induration"]    = {},
        ["Impaction"]     = {},

    }

    -- Private Functions.
    local persist = function()

        if self.settings then
            self.settings.layout                = self.layout
            self.settings["AM"]                 = self["AM"]
            self.settings["AM LEVEL"]           = self["AM LEVEL"]
            self.settings["AM THRESHOLD"]       = self["AM THRESHOLD"]
            self.settings["1HR"]                = self["1HR"]
            self.settings["JA"]                 = self["JA"]
            self.settings["RA"]                 = self["RA"]
            self.settings["CURES"]              = self["CURES"]
            self.settings["SUBLIMATION"]        = self["SUBLIMATION"]
            self.settings["HATE"]               = self["HATE"]
            self.settings["BUFFS"]              = self["BUFFS"]
            self.settings["DEBUFFS"]            = self["DEBUFFS"]
            self.settings["STATUS"]             = self["STATUS"]
            self.settings["WS"]                 = self["WS"]
            self.settings["WSNAME"]             = self["WSNAME"]
            self.settings["RANGED WS"]          = self["RANGED WS"]
            self.settings["TP THRESHOLD"]       = self["TP THRESHOLD"]
            self.settings["SC"]                 = self["SC"]
            self.settings["BURST"]              = self["BURST"]
            self.settings["ELEMENT"]            = self["ELEMENT"]
            self.settings["TIER"]               = self["TIER"]
            self.settings["ALLOW AOE"]          = self["ALLOW AOE"]
            self.settings["DRAINS"]             = self["DRAINS"]
            self.settings["STUNS"]              = self["STUNS"]
            self.settings["TANK MODE"]          = self["TANK MODE"]
            self.settings["SEKKA"]              = self["SEKKA"]
            self.settings["SHADOWS"]            = self["SHADOWS"]
            self.settings["FOOD"]               = self["FOOD"]
            self.settings["SAMBAS"]             = self["SAMBAS"]
            self.settings["STEPS"]              = self["STEPS"]
            self.settings["SKILLUP"]            = self["SKILLUP"]
            self.settings["SKILLS"]             = self["SKILLS"]
            self.settings["COMPOSURE"]          = self["COMPOSURE"]
            self.settings["CONVERT"]            = self["CONVERT"]
            self.settings["ENSPELL"]            = self["ENSPELL"]
            self.settings["GAINS"]              = self["GAINS"]
            self.settings["SPIKES"]             = self["SPIKES"]
            self.settings["DIA"]                = self["DIA"]
            self.settings["SANGUINE"]           = self["SANGUINE"]
            self.settings["THRENODY"]           = self["THRENODY"]
            self.settings["QD"]                 = self["QD"]
            self.settings["SHOTS"]              = self["SHOTS"]
            self.settings["BOOST"]              = self["BOOST"]
            self.settings["PET"]                = self["PET"]
            self.settings["SPIRITS"]            = self["SPIRITS"]
            self.settings["SUMMON"]             = self["SUMMON"]
            self.settings["BPRAGE"]             = self["BPRAGE"]
            self.settings["BPWARD"]             = self["BPWARD"]
            self.settings["AOEHATE"]            = self["AOEHATE"]
            self.settings["EMBOLDEN"]           = self["EMBOLDEN"]
            self.settings["BLU MODE"]           = self["BLU MODE"]
            self.settings["MIGHTY GUARD"]       = self["MIGHTY GUARD"]
            self.settings["CHIVALRY"]           = self["CHIVALRY"]
            self.settings["WEATHER"]            = self["WEATHER"]
            self.settings["ARTS"]               = self["ARTS"]
            self.settings["WHITE"]              = self["WHITE"]
            self.settings["MISERY"]             = self["MISERY"]
            self.settings["IMPETUS WS"]         = self["IMPETUS WS"]
            self.settings["FOOTWORK WS"]        = self["FOOTWORK WS"]
            self.settings["DEFAULT WS"]         = self["DEFAULT WS"]

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

        self.config:pos(10, 10)
        self.config:font(self.layout.font.name)
        self.config:color(self.layout.colors.text.r, self.layout.colors.text.g, self.layout.colors.text.b)
        self.config:alpha(self.layout.colors.text.alpha)
        self.config:size(self.layout.font.size + 1)
        self.config:pad(self.layout.padding)
        self.config:bg_color(self.layout.colors.bg.r, self.layout.colors.bg.g, self.layout.colors.bg.b)
        self.config:bg_alpha(self.layout.colors.bg.alpha)
        self.config:stroke_width(self.layout.stroke_width)
        self.config:stroke_color(self.layout.colors.stroke.r, self.layout.colors.stroke.g, self.layout.colors.stroke.b)
        self.config:stroke_alpha(self.layout.colors.stroke.alpha)
        self.config:hide()
        self.config:update()

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
    self.handleCommands = function(bp, commands)
        local bp = bp or false

        if commands and commands[1] then
            local command = commands[1]

            if command == 'config' then
                self.renderConfig(bp)
            end

        end

    end

    -- Public Functions.
    self.handleItems = function(bp)
        local bp = bp or false

        if bp then
            helpers = bp.helpers

            if helpers['actions'].canItem(bp) then

                if helpers['buffs'].buffActive(15) then

                    if helpers['inventory'].findItemByName("Holy Water") and not helpers['queue'].inQueue(bp, bp.IT["Holy Water"], 'me') then
                        helpers['queue'].add(bp, bp.IT["Holy Water"], 'me')

                    elseif helpers['inventory'].findItemByName("Hallowed Water") and not helpers["queue"].inQueue(bp, bp.IT["Hallowed Water"], 'me') then
                        helpers['queue'].add(bp, bp.IT["Hallowed Water"], 'me')

                    end

                elseif helpers['buffs'].buffActive(6) then

                    if helpers['inventory'].findItemByName("Echo Drops") and not helpers['queue'].inQueue(bp, bp.IT["Echo Drops"], 'me') then
                        helpers['queue'].add(bp, bp.IT["Echo Drops"], 'me')
                    end

                end

            end

        end

    end

    self.handleAutomation = function(bp)
        local bp = bp or false

        if bp then
            local helpers = bp.helpers
            local player = windower.ffxi.get_player()

            if helpers['queue'].ready and not helpers['actions'].moving and bp.settings['Enabled'] then

                -- HANDLE ITEMS.
                self.handleItems(bp)

                -- PLAYER IS ENGAGED.
                if player.status == 1 then

                -- PLAYER IS DISENGAGED LOGIC.
                elseif player.status == 0 then

                end

                -- HANDLE EVERYTHING INSIDE THE QUEUE.
                helpers['queue'].handle(bp)

            end

        end

    end

    self.render = function(bp)
        local bp = bp or false

    end

    self.renderConfig = function(bp)
        local bp = bp or false

        if not self.config:visible() then
            local color = string.format('%s,%s,%s', 100, 150, 215)
            local s     = {}
            local c     = 1

            for name, settings in pairs(self) do

                if type(settings) == 'table' then

                    if settings[2] and (type(settings[2]) == 'string' or type(settings[2]) == 'number' or type(settings[2]) == 'boolean') and type(settings[2]) ~= 'function' then
                        table.insert(s, string.format('%s: \\cs(%s)%s\\cr\n', name:upper(), color, tostring(settings[2]):upper():lpad(' ', (25-#name))))

                    elseif not settings[2] and type(settings[2]) == 'boolean' then
                        table.insert(s, string.format('%s: \\cs(%s)%s\\cr\n', name:upper(), color, tostring(settings[2]):upper():lpad(' ', (25-#name))))

                    end

                elseif type(settings) ~= 'table' then

                    if (type(settings) == 'string' or type(settings) == 'number' or type(settings) == 'boolean') then
                        table.insert(s, string.format('%s: \\cs(%s)%s\\cr\n', name:upper(), color, tostring(settings):upper():lpad(' ', (25-#name))))

                    elseif not settings and type(settings) == 'boolean' then
                        table.insert(s, string.format('%s: \\cs(%s)%s\\cr\n', name:upper(), color, tostring(settings[2]):upper():lpad(' ', (25-#name))))

                    end


                end

            end
            self.config:text(table.concat(s, ''))
            self.config:update()
            self.config:show()
            print(c)

        elseif self.config:visible() then
            self.config:hide()

        end

    end

    self.getSetting = function(bp, name)
        local bp    = bp or false
        local name  = name or false

        if bp and name then
            local helpers = bp.helpers
            local setting = self[name]

            if setting then
                return setting[2]
            end

        end

    end

    self.setSetting = function(bp, name, value)
        local bp    = bp or false
        local name  = name or false
        local value = value or false

        if bp and name and value then
            local helpers = bp.helpers
            local setting = self[name]

            if setting then
                self[name][2] = value
            end

        end

    end

    self.nextSetting = function(bp, name)
        local bp    = bp or false
        local name  = name or false

        if bp and name then
            local helpers = bp.helpers
            local setting = self[name]

            if setting then
                local options = setting[1]
                local current = setting[2]

                for i,v in ipairs(options) do

                    if v == current and i < #options then
                        self[name][2] = self[name][1][i+1]

                    elseif v == current and i == #options then
                        self[name][2] = self[name][1][1]

                    end

                end

            end

        end

    end

    return self

end
return core.get()
