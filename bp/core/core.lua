local core      = {}
local player    = windower.ffxi.get_player()
local files     = require('files')
local f = files.new(string.format('bp/core/%s/settings/%s.lua', player.main_job:lower(), player.name))
require('tables')

if not f:exists() then
  f:write(string.format('return %s', T({}):tovstring()))
end

function core.new()
    local self = {}

    -- Static Variables.
    local bp        = false
    local private   = {events={}, set={}}
    local settings  = dofile(string.format('%sbp/core/%s/settings/%s.lua', windower.addon_path, player.main_job:lower(), player.name))

    -- Private Variables
    private.flags   = settings or {}
    private.naming  = {

        ['debuffs']     = "AUTO-DEBUFFING",
        ['buffs']       = "AUTO-SELF BUFFING",
        ['tank']        = "DEFENSIVE MODE",
        ['1hr']         = "AUTO-1HRs",
        ['ja']          = "AUTO-JOB ABILITIES",
        ['items']       = "AUTO-ITEMS",
        ['nuke']        = "NUKE MODE",

    }
    private.default = {

        ['am']                      = {enabled=false, tp=3000},
        ['ra']                      = {enabled=false, tp=1000, name="Hot Shot"},
        ['ws']                      = {enabled=false, tp=1000, name="Combo"},
        ['hate']                    = {enabled=false, delay=2, aoe=false},
        ['skillup']                 = {enabled=false, skill="Enhancing Magic"},
        ['food']                    = {enabled=false, name=""},
        ['items']                   = false,
        ['buffs']                   = false,
        ['debuffs']                 = false,
        ['tank']                    = false,
        ['1hr']                     = false,
        ['ja']                      = false,

        ['WAR'] = {
            ["provoke"]             = false,
            ["berserk"]             = false,
            ["defender"]            = false,
            ["warcry"]              = false,
            ["aggressor"]           = false,
            ["retaliation"]         = false,
            ["warrior's charge"]    = false,
            ["tomahawk"]            = false,
            ["restraint"]           = false,
            ["blood rage"]          = false,
            ['sanguine blade']      = {enabled=false, hpp=55},
        },

        ['MNK'] = {
            ["chakra"]              = {enabled=false, hpp=45},
            ["chi blast"]           = false,
            ["counterstance"]       = false,
            ["mantra"]              = false,
            ["formless strikes"]    = false,
            ["perfect counter"]     = false,
        },

        ['WHM'] = {
            ["afflatus solace"]     = false,
            ["afflatus misery"]     = false,
            ["martyr"]              = false,
            ["devotion"]            = {enabled=false, mpp=45, target=""},
            ["sacrosanctity"]       = false,
            ["boost"]               = {enabled=false, name="Boost-STR"},
            ["aquaveil"]            = false,
            ["blink"]               = false,
            ["stoneskin"]           = false,
        },

        ['BLM'] = {
            ["elemental seal"]      = false,
            ["mana wall"]           = false,
            ["cascade"]             = {enabled=false, tp=1000},
            ["enmity douse"]        = false,
            ["manawell"]            = false,
            ["spikes"]              = {enabled=false, name="Blaze Spikes"},
            ['drain']               = {enabled=false, hpp=55},
            ['aspir']               = {enabled=false, mpp=55},
        },

        ['RDM'] = {
            ["convert"]             = {enabled=false, mpp=55, hpp=55},
            ["composure"]           = false,
            ["saboteur"]            = false,
            ["spontaneity"]         = false,
            ["spikes"]              = {enabled=false, name="Blaze Spikes"},
            ["gain"]                = {enabled=false, name="Gain-DEX"},
            ["blink"]               = false,
            ["aquaveil"]            = false,
            ["en"]                  = {enabled=false, name="Enfire", tier=1},
            ['sanguine blade']      = {enabled=false, hpp=55},
            ["stoneskin"]           = false,
        },

        ['THF'] = {
            ["steal"]               = false,
            ["sneak attack"]        = false,
            ["flee"]                = false,
            ["trick attack"]        = false,
            ["mug"]                 = false,
            ["assassin's charge"]   = false,
            ["feint"]               = false,
            ["despoil"]             = false,
            ["conspirator"]         = false,
            ["bully"]               = false,
        },

        ['PLD'] = {
            ["holy circle"]         = false,
            ["shield bash"]         = false,
            ["sentinel"]            = false,
            ["cover"]               = {enabled=false, target=""},
            ["rampart"]             = false,
            ["majesty"]             = false,
            ["fealty"]              = false,
            ["chivalry"]            = {enabled=false, mpp=55, tp=1500},
            ["divine emblem"]       = false,
            ["sepulcher"]           = false,
            ["palisade"]            = false,
            ['sanguine blade']      = {enabled=false, hpp=55},
        },

        ['DRK'] = {
            ["arcane circle"]       = false,
            ["last resort"]         = false,
            ["weapon bash"]         = false,
            ["souleater"]           = false,
            ["consume mana"]        = false,
            ["dark seal"]           = false,
            ["diabolic eye"]        = false,
            ["nether void"]         = false,
            ["arcane crest"]        = false,
            ["scarlet delirium"]    = false,
            ["absorb"]              = {enabled=false, name="Absorb-ACC"},
            ["endark"]              = false,
            ['spikes']              = false,
            ['drain']               = {enabled=false, hpp=55},
            ['aspir']               = {enabled=false, mpp=55},
            ['sanguine blade']      = {enabled=false, hpp=55},
        },

        ['BST'] = {
            ["reward"]              = {enabled=false, pet_hpp=55},
            ["call beast"]          = false,
            ["bestial loyalty"]     = false,
            ["killer instinct"]     = false,
            ["fight"]               = false,
            ["ready"]               = {enabled=false, ""},
            ["snarl"]               = false,
            ["spur"]                = false,
            ["run wild"]            = false,
        },

        ['RNG'] = {
            ["sharpshot"]           = false,
            ["scavenge"]            = false,
            ["camouflage"]          = false,
            ["barrage"]             = false,
            ["velocity shot"]       = false,
            ["unlimited shot"]      = false,
            ["flashy shot"]         = false,
            ["stealth shot"]        = false,
            ["double shot"]         = false,
            ["bounty shot"]         = false,
            ["decoy shot"]          = {enabled=false, target=""},
            ["hover shot"]          = false,
        },

        ['SMN'] = {
            ["elemental siphon"]    = {enabled=false, mpp=55},
            ["apogee"]              = false,
            ["mana cede"]           = false,
            ["assault"]             = false,
            ["blood pact: rage"]    = false,
            ["blood pact: ward"]    = false,
            ['summon']              = {enabled=false, name="Carbuncle"},
            ["bpr"]                 = {enabled=false, pacts={}},
            ["bpw"]                 = {enabled=false, pacts={}},
        },

        ['SAM'] = {
            ["warding circle"]      = false,
            ["third eye"]           = false,
            ["hasso"]               = false,
            ["meditate"]            = false,
            ["seigan"]              = false,
            ["sekkanoki"]           = false,
            ["konzen-ittai"]        = false,
            ["shikikoyo"]           = {enabled=false, tp=1500, target=""},
            ["blade bash"]          = false,
            ["sengikori"]           = false,
            ["hamanoha"]            = false,
            ["hagakure"]            = false,
        },

        ['NIN'] = {
            ["yonin"]               = false,
            ["innin"]               = false,
            ["sange"]               = false,
            ["futae"]               = false,
            ["issekigan"]           = false,
            ["utsusemi"]            = false,
        },

        ['DRG'] = {
            ["call wyvern"]         = false,
            ["ancient circle"]      = false,
            ["jump"]                = false,
            ["spirit link"]         = false,
            ["high jump"]           = false,
            ["super jump"]          = false,
            ["spirit bond"]         = false,
            ["deep breathing"]      = false,
            ["angon"]               = false,
            ["spirit jump"]         = false,
            ["soul jump"]           = false,
            ["dragon breaker"]      = false,
            ["smiting breath"]      = false,
            ["restoring breath"]    = false,
            ["steady wing"]         = false,
        },

        ['BLU'] = {
            ["burst affinity"]      = false,
            ["chain affinity"]      = false,
            ["convergence"]         = false,
            ["diffusion"]           = false,
            ["efflux"]              = false,
            ["unbridled learning"]  = false,
            ['sanguine blade']      = {enabled=false, hpp=55},
        },

        ['COR'] = {
            ["quick draw"]          = {enabled=false, name="Light Shot"},
            ["random deal"]         = false,
            ["triple shot"]         = false,
        },

        ['PUP'] = {
            ["activate"]            = false,
            ["repair"]              = {enabled=false, pet_hpp=55},
            ["maintenance"]         = false,
            ["cooldown"]            = false,
            ["deploy"]              = false,
            ["maneuver"]            = false,
        },

        ['DNC'] = {
            ["contradance"]         = false,
            ["saber dance"]         = false,
            ["fan dance"]           = false,
            ["no foot rise"]        = false,
            ["presto"]              = false,
            ["sambas"]              = {enabled=false, name="Haste Samba"},
            ["steps"]               = {enabled=false, name="Quickstep"},
            ["flourishes"]          = {enabled=false, cat_1="Animated Flourish", cat_2="Reverse Flourish", cat_3="Climactic Flourish"},
            ["jigs"]                = {enabled=false, name="Chocobo Jig"},
        },

        ['SCH'] = {
            ["light arts"]          = false,
            ["dark arts"]           = false,
            ["sublimation"]         = {enabled=false, mpp=65},
            ["modus veritas"]       = false,
            ["enlightenment"]       = false,
            ["libra"]               = false,
            ["helix"]               = {enabled=false, name="Pyrohelix"},
            ["storms"]              = {enabled=false, name="Firestorm"},
            ["spikes"]              = {enabled=false, name="Blaze Spikes"},
            ['drain']               = {enabled=false, hpp=55},
            ['aspir']               = {enabled=false, mpp=55},
            ["aquaveil"]            = false,
            ["blink"]               = false,
            ["stoneskin"]           = false,
        },

        ['GEO'] = {
            ["theurgic focus"]      = false,
            ['drain']               = {enabled=false, hpp=55},
            ['aspir']               = {enabled=false, mpp=55},
        },

        ['RUN'] = {
            ["runes"]               = false,
            ["vallation"]           = false,
            ["swordplay"]           = false,
            ["swipe"]               = false,
            ["lunge"]               = false,
            ["pflug"]               = false,
            ["valiance"]            = false,
            ["embolden"]            = {enabled=false, name=""},
            ["vivacious pulse"]     = {enabled=false, hpp=55, mpp=55},
            ["gambit"]              = false,
            ["battuta"]             = false,
            ["rayke"]               = false,
            ["liement"]             = false,
            ["one for all"]         = false,
            ["spikes"]              = {enabled=false, name="Blaze Spikes"},
            ['sanguine blade']      = {enabled=false, hpp=55},
            ["aquaveil"]            = false,
            ["blink"]               = false,
            ["stoneskin"]           = false,
        },        

    }

    -- Private Functions
    private.persist = function()
        local player = windower.ffxi.get_player()
        local flags = {update={}, initilize=false}

        if settings then

            if T(private.flags):length() == 0 then
                flags.initilize = true
            end

            for name, value in pairs(private.default[player.main_job]) do
                
                if private.flags[name] == nil then
                    private.flags[name] = value
                    table.insert(flags.update, name:upper())
                end

            end

            for name, value in pairs(private.default) do

                if T{'WAR','MNK','WHM','BLM','RDM','THF','PLD','DRK','BST','BRD','RNG','SMN','SAM','NIN','DRG','BLU','COR','PUP','DNC','SCH','GEO','RUN'}:contains(name) then

                    if private.flags[name] == nil then
                        private.flags[name] = value
                        table.insert(flags.update, name:upper())

                    else

                        for i,v in pairs(value) do
                            
                            if private.flags[name][i] == nil then
                                private.flags[name][i] = v
                                table.insert(flags.update, i:upper())
                            end

                        end

                    end

                else
                    
                    if private.flags[name] == nil then
                        private.flags[name] = value
                        table.insert(flags.update, name:upper())
                    end

                end

            end

        end

        if not flags.initilize and flags.update[1] ~= nil then
            coroutine.schedule(function()
                bp.helpers['popchat'].pop(string.format('NEW SETTINGS: {%s}!\nADDED TO %s SETTINGS FILE!', table.concat(flags.update, ', '), player.main_job))
            end, 2)

        elseif flags.initilize then
            coroutine.schedule(function()
                bp.helpers['popchat'].pop(string.format('%s CORE SETTINGS FILE HAS BEEN CREATED!', player.main_job))
            end, 2)
            
        end

    end

    private.writeSettings = function()
        private.persist()

        if f:exists() then
            f:write(string.format('return %s', T(private.flags):tovstring()))

        elseif not f:exists() then
            f:write(string.format('return %s', T({}):tovstring()))
        end

    end
    private.writeSettings()

    private.set = function(name, commands, subjob)
        local set = {}
        
        set['am'] = function(name, commands, subjob)
            local flags = subjob ~= true and private.flags[name] or private.flags[bp.player.sub_job][name]

            if flags and #commands > 0 then
                
                for i in ipairs(commands) do
                    local value = tonumber(commands[i]) ~= nil and tonumber(commands[i]) or commands[i]

                    if type(value) == 'number' and T{1,2,3}:contains(value) then
                        flags.tp = (value*1000)
                        bp.helpers['popchat'].pop(string.format('AUTO-AFTERMATH LEVEL SET TO: %s.', flags.tp))

                    else
                        bp.helpers['popchat'].pop('VALUE MUST BE BETWEEN 1 & 3!')

                    end

                end

            else
                flags.enabled = flags.enabled ~= true and true or false
                bp.helpers['popchat'].pop(string.format('AUTO-AFTERMATH: %s.', tostring(flags.enabled)))

            end

        end

        set['ra'] = function(name, commands, subjob)
            local flags = subjob ~= true and private.flags[name] or private.flags[bp.player.sub_job][name]
            local set = false

            if flags and #commands > 0 then

                for i in ipairs(commands) do
                    local value = tonumber(commands[i]) ~= nil and tonumber(commands[i]) or commands[i]

                    if type(value) == 'number' then    

                        if value >= 1000 and value <= 3000 then
                            flags.tp = value
                            bp.helpers['popchat'].pop(string.format('AUTO-RANGED WEAPONSKILL TP THRESHOLD SET TO: %s.', flags.tp))

                        else
                            bp.helpers['popchat'].pop('VALUE MUST BE BETWEEN 1000 & 3000!')

                        end

                    elseif not set then
                        local value = {}
                        for i,v in ipairs(commands) do

                            if not tonumber(v) then
                                table.insert(value, windower.convert_auto_trans(v))
                            end

                        end
                        set = true

                        do
                            local value = table.concat(value, ' ')
                            local weaponskills = bp.res.weapon_skills

                            for _,v in pairs(windower.ffxi.get_abilities().weapon_skills) do
                                        
                                if weaponskills[v] and weaponskills[v].en then
                                    local match = (weaponskills[v].en):match(("[%a%s%'%:]+"))
                                    
                                    if value:sub(1,8):lower() == match:sub(1,8):lower() then
                                        flags.name = weaponskills[v].en
                                        bp.helpers['popchat'].pop(string.format('AUTO-RANGED WEAPONSKILL SET TO: %s.', flags.name))
                                        break

                                    end
                                    
                                end
                                
                            end

                        end

                    end

                end

            else
                flags.enabled = flags.enabled ~= true and true or false
                bp.helpers['popchat'].pop(string.format('AUTO-RANGED: %s.', tostring(flags.enabled)))

            end

        end

        set['ws'] = function(name, commands, subjob)
            local flags = subjob ~= true and private.flags[name] or private.flags[bp.player.sub_job][name]
            local set = false

            if flags and #commands > 0 then

                for i in ipairs(commands) do
                    local value = tonumber(commands[i]) ~= nil and tonumber(commands[i]) or commands[i]
                    
                    if type(value) == 'number' then

                        if value >= 1000 and value <= 3000 then
                            flags.tp = value
                            bp.helpers['popchat'].pop(string.format('AUTO-WEAPONSKILL TP THRESHOLD SET TO: %s.', flags.tp))

                        else
                            bp.helpers['popchat'].pop('VALUE MUST BE BETWEEN 1000 & 3000!')

                        end
                        table.remove(commands)

                    elseif not set then
                        local value = {}
                        for i,v in ipairs(commands) do

                            if not tonumber(v) then
                                table.insert(value, windower.convert_auto_trans(v))
                            end

                        end
                        set = true

                        do
                            local value = table.concat(value, ' ')
                            local weaponskills = bp.res.weapon_skills

                            for _,v in pairs(windower.ffxi.get_abilities().weapon_skills) do
                                        
                                if weaponskills[v] and weaponskills[v].en then
                                    local match = (weaponskills[v].en):match(("[%a%s%'%:]+"))
                                    
                                    if value:sub(1,8):lower() == match:sub(1,8):lower() then
                                        flags.name = weaponskills[v].en
                                        bp.helpers['popchat'].pop(string.format('AUTO-WEAPONSKILL SET TO: %s.', flags.name))
                                        break

                                    end
                                    
                                end
                                
                            end

                        end

                    end

                end

            else
                flags.enabled = flags.enabled ~= true and true or false
                bp.helpers['popchat'].pop(string.format('AUTO-WEAPONSKILL: %s.', tostring(flags.enabled)))

            end

        end

        set['skillup'] = function(name, commands, subjob)
            local flags = subjob ~= true and private.flags[name] or private.flags[bp.player.sub_job][name]

            if flags and #commands > 0 then

                for i in ipairs(commands) do
                    local value = tonumber(commands[i]) ~= nil and tonumber(commands[i]) or commands[i]

                    if value then
                        local value = windower.convert_auto_trans(value)

                        if S{"Enhancing Magic","Divine Magic","Enfeebling Magic","Elemental Magic","Dark Magic","Singing","Summoning","Blue Magic","Geomancy"}:contains(value) then 
                            flags.name = value
                            bp.helpers['popchat'].pop(string.format('AUTO-SKILLUP SPELL SET TO: %s.', flags.name))

                        else
                            bp.helpers['popchat'].pop('INVALID SKILL NAME!')

                        end

                    end

                end
            
            else
                flags.enabled = flags.enabled ~= true and true or false
                bp.helpers['popchat'].pop(string.format('AUTO-SKILLUP: %s.', tostring(flags.enabled)))

            end

        end

        set['food'] = function(name, commands, subjob)
            local flags = subjob ~= true and private.flags[name] or private.flags[bp.player.sub_job][name]

            if flags and #commands > 0 then
                
                for i in ipairs(commands) do
                    local value = tonumber(commands[i]) ~= nil and tonumber(commands[i]) or commands[i]

                    if value then
                        local food = bp.helpers['inventory'].findItemByName(windower.convert_auto_trans(value))

                        if food and bp.IT[food.en] then
                            flags.name = food.en
                            bp.helpers['popchat'].pop(string.format('AUTO-FOOD SET TO: %s.', flags.name))
        
                        else
                            bp.helpers['popchat'].pop('UNABLE TO FIND THAT FOOD IN YOUR INVENTORY!')
        
                        end

                    end

                end

            elseif #commands == 0 then
                flags.enabled = flags.enabled ~= true and true or false
                bp.helpers['popchat'].pop(string.format('AUTO-FOOD: %s.', tostring(flags.enabled)))

            end

        end

        set['hate'] = function(name, commands, subjob)
            local flags = subjob ~= true and private.flags[name] or private.flags[bp.player.sub_job][name]

            if flags and #commands > 0 then

                for i in ipairs(commands) do
                    local value = tonumber(commands[i]) ~= nil and tonumber(commands[i]) or commands[i]

                    if value then

                        if type(value) == 'string' then

                            if value == 'aoe' then
                                flags.aoehate = flags.aoehate ~= true and true or false
                                bp.helpers['popchat'].pop(string.format('AOE HATE SPELLS: %s.', tostring(flags.enabled)))

                            end

                        elseif type(value) == 'number' then
                            
                            if value >= 0 and value <= 30 then
                                flags.delay = value
                                bp.helpers['popchat'].pop(string.format('AUTO-ENMITY DELAY SET TO: %s.', flags.delay))

                            else
                                bp.helpers['popchat'].pop('ENMITY DELAY VALUE MUST BE A NUMBER BETWEEN 0 & 30!')

                            end

                        end

                    end

                end

            elseif #commands == 0 then
                flags.enabled = flags.enabled ~= true and true or false
                bp.helpers['popchat'].pop(string.format('AUTO-ENMITY: %s.', tostring(flags.enabled)))

            end

        end

        set['sanguine blade'] = function(name, commands, subjob)
            local flags = subjob ~= true and private.flags[name] or private.flags[bp.player.sub_job][name]

            if flags and #commands > 0 then
                
                for i in ipairs(commands) do
                    local value = tonumber(commands[i]) ~= nil and tonumber(commands[i]) or commands[i]

                    if value then

                        if type(value) == 'number' then
                            
                            if value >= 25 and value <= 75 then
                                flags.hpp = value
                                bp.helpers['popchat'].pop(string.format('AUTO-SANGUINE HP%% SET TO: %s.', tostring(flags.hpp)))
            
                            else
                                bp.helpers['popchat'].pop('ENTER A HP% VALUE BETWEEN 25 & 75!')
            
                            end

                        end

                    end

                end

            elseif #commands == 0 then
                flags.enabled = flags.enabled ~= true and true or false
                bp.helpers['popchat'].pop(string.format('AUTO-SANGUINE BLADE: %s.', tostring(flags.enabled)))

            end

        end

        set['chakra'] = function(name, commands, subjob)
            local flags = subjob ~= true and private.flags[name] or private.flags[bp.player.sub_job][name]

            if flags and #commands > 0 then

                for i in ipairs(commands) do
                    local value = tonumber(commands[i]) ~= nil and tonumber(commands[i]) or commands[i]

                    if value then

                        if type(value) == 'number' then
                            
                            if value >= 25 and value <= 75 then
                                flags.hpp = value
                                bp.helpers['popchat'].pop(string.format('AUTO-CHAKRA HP%% SET TO: %s.', flags.hpp))
            
                            else
                                bp.helpers['popchat'].pop('ENTER A HP% VALUE BETWEEN 25 & 75!')
            
                            end

                        end

                    end

                end

            elseif #commands == 0 then
                flags.enabled = flags.enabled ~= true and true or false
                bp.helpers['popchat'].pop(string.format('AUTO-CHAKRA: %s.', tostring(flags.enabled)))

            end

        end

        set['devotion'] = function(name, commands, subjob)
            local flags = subjob ~= true and private.flags[name] or private.flags[bp.player.sub_job][name]
            local target = windower.ffxi.get_mob_by_target('st') or windower.ffxi.get_mob_by_target('t') or false

            if flags and #commands > 0 then
                
                for i in ipairs(commands) do
                    local value = tonumber(commands[i]) ~= nil and tonumber(commands[i]) or commands[i]

                    if (value or target) then
                        
                        if type(value) == 'number' then
                            
                            if value >= 25 and value <= 75 then
                                flags.mpp = value
                                bp.helpers['popchat'].pop(string.format('AUTO-DEVOTION MP%% SET TO: %s.', flags.mpp))
        
                            else
                                bp.helpers['popchat'].pop('ENTER A MP% VALUE BETWEEN 25 & 75!')
        
                            end

                        end
                        
                        if target and target.name ~= bp.player.name then
                            local target = value ~= nil and windower.ffxi.get_mob_by_name(value) or target

                            if target and bp.helpers['party'].isInParty(target) then
                                flags.target = target.name
                                bp.helpers['popchat'].pop(string.format('AUTO-DEVOTION TARGET SET TO: %s.', flags.target))

                            else
                                bp.helpers['popchat'].pop('INVALID TARGET SELECTED!')

                            end

                        end

                    end

                end

            elseif #commands == 0 then
                
                if not target then
                    flags.enabled = flags.enabled ~= true and true or false
                    bp.helpers['popchat'].pop(string.format('AUTO-DEVOTION: %s.', tostring(flags.enabled)))

                else

                    if target and target.name ~= bp.player.name then

                        if target and bp.helpers['party'].isInParty(target) then
                            flags.target = target.name
                            bp.helpers['popchat'].pop(string.format('AUTO-DEVOTION TARGET SET TO: %s.', flags.target))

                        else
                            bp.helpers['popchat'].pop('INVALID TARGET SELECTED!')

                        end

                    end

                end

            end

        end

        set['boost'] = function(name, commands, subjob)
            local flags = subjob ~= true and private.flags[name] or private.flags[bp.player.sub_job][name]

            if flags and #commands > 0 then

                for i in ipairs(commands) do
                    local value = tonumber(commands[i]) ~= nil and tonumber(commands[i]) or commands[i]

                    if value then

                        if type(value) == 'string' then            
                            local spell = windower.convert_auto_trans(value)
                
                            if S{'Boost-STR','Boost-DEX','Boost-INT','Boost-CHR','Boost-AGI','Boost-VIT','Boost-MND'}:contains(spell) then
                                flags.name = spell
                                bp.helpers['popchat'].pop(string.format('AUTO-WHM BOOST SPELL SET TO: %s.', flags.name))

                            else
                                bp.helpers['popchat'].pop('INVALID SPELL NAME!')

                            end

                        end

                    end

                end

            elseif #commands == 0 then
                flags.enabled = flags.enabled ~= true and true or false
                bp.helpers['popchat'].pop(string.format('AUTO-BOOST: %s.', tostring(flags.enabled)))

            end

        end

        set['cascade'] = function(name, commands, subjob)
            local flags = subjob ~= true and private.flags[name] or private.flags[bp.player.sub_job][name]

            if flags and #commands > 0 then
                
                for i in ipairs(commands) do
                    local value = tonumber(commands[i]) ~= nil and tonumber(commands[i]) or commands[i]

                    if value then

                        if type(value) == 'number' then
                            
                            if value >= 1000 and value <= 3000 then
                                flags.tp = value
                                bp.helpers['popchat'].pop(string.format('AUTO-CASCADE TP%% SET TO: %s.', flags.tp))
            
                            else
                                bp.helpers['popchat'].pop('ENTER A TP% VALUE BETWEEN 1000 & 3000!')
            
                            end

                        end

                    end

                end

            elseif #commands == 0 then
                flags.enabled = flags.enabled ~= true and true or false
                bp.helpers['popchat'].pop(string.format('AUTO-CASCADE: %s.', tostring(flags.enabled)))

            end

        end

        set['spikes'] = function(name, commands, subjob)
            local flags = subjob ~= true and private.flags[name] or private.flags[bp.player.sub_job][name]

            if flags and #commands > 0 then

                for i in ipairs(commands) do
                    local value = tonumber(commands[i]) ~= nil and tonumber(commands[i]) or commands[i]

                    if value then

                        if type(value) == 'string' then            
                            local spell = windower.convert_auto_trans(value)
                
                            if (S{'BLM','RDM','SCH','RUN'}:contains(bp.player.main_job) or S{'BLM','RDM','SCH','RUN'}:contains(bp.player.sub_job)) then
                
                                if S{'Blaze Spikes','Ice Spikes','Shock Spikes'}:contains(spell) then
                                    flags.name = spell
                                    bp.helpers['popchat'].pop(string.format('AUTO-SPIKES SPELL SET TO: %s.', flags.name))
            
                                else
                                    bp.helpers['popchat'].pop('INVALID SPELL NAME!')
            
                                end
            
                            elseif S{'DRK'}:contains(bp.player.main_job) then
            
                                if spell == 'Dread Spikes' then
                                    flags.name = spell
                                    bp.helpers['popchat'].pop(string.format('AUTO-SPIKES SPELL SET TO: %s.', flags.name))
            
                                else
                                    bp.helpers['popchat'].pop('INVALID SPELL NAME!')
            
                                end
            
                            end

                        end

                    end

                end

            elseif #commands == 0 then
                flags.enabled = flags.enabled ~= true and true or false
                bp.helpers['popchat'].pop(string.format('AUTO-SPIKES: %s.', tostring(flags.enabled)))

            end

        end

        set['drain'] = function(name, commands, subjob)
            local flags = subjob ~= true and private.flags[name] or private.flags[bp.player.sub_job][name]

            if flags and #commands > 0 then
                
                for i in ipairs(commands) do
                    local value = tonumber(commands[i]) ~= nil and tonumber(commands[i]) or commands[i]

                    if value then

                        if type(value) == 'number' then
                            
                            if value >= 1 and value <= 75 then
                                flags.hpp = value
                                bp.helpers['popchat'].pop(string.format('AUTO-DRAIN HP%% SET TO: %s.', flags.hpp))
            
                            else
                                bp.helpers['popchat'].pop('AUTO-DRAIN HP%% VALUE NEEDS TO BE A NUMBER BETWEEN 1 & 75!')
            
                            end

                        end

                    end

                end

            elseif #commands == 0 then
                flags.enabled = flags.enabled ~= true and true or false
                bp.helpers['popchat'].pop(string.format('AUTO-DRAIN: %s.', tostring(flags.enabled)))

            end

        end

        set['aspir'] = function(name, commands, subjob)
            local flags = subjob ~= true and private.flags[name] or private.flags[bp.player.sub_job][name]

            if flags and #commands > 0 then
                
                for i in ipairs(commands) do
                    local value = tonumber(commands[i]) ~= nil and tonumber(commands[i]) or commands[i]

                    if value then

                        if type(value) == 'number' then
                            
                            if value > 1 and value < 75 then
                                flags.mpp = value
                                bp.helpers['popchat'].pop(string.format('AUTO-ASPIR MP%% SET TO: %s.', flags.mpp))
            
                            else
                                bp.helpers['popchat'].pop('AUTO-ASPIR MP%% VALUE NEEDS TO BE A NUMBER BETWEEN 1 & 75!')
            
                            end

                        end

                    end

                end

            elseif #commands == 0 then
                flags.enabled = flags.enabled ~= true and true or false
                bp.helpers['popchat'].pop(string.format('AUTO-ASPIR: %s.', tostring(flags.enabled)))

            end

        end

        set['convert'] = function(name, commands, subjob)
            local flags = subjob ~= true and private.flags[name] or private.flags[bp.player.sub_job][name]
            
            if flags and #commands > 0 then
                
                if commands[1] then
                    local value = tonumber(commands[1])

                    if value and value > 25 and value < 75 then
                        flags.mpp = value
                        bp.helpers['popchat'].pop(string.format('CONVERT MP%% SET TO: %s.', flags.mpp))

                    else
                        bp.helpers['popchat'].pop('MP%% MUST BE A NUMBER BETWEEN 25 & 75!')

                    end

                end

                if commands[2] then
                    local value = tonumber(commands[2])

                    if value and value > 25 and value < 75 then
                        flags.hpp = value
                        bp.helpers['popchat'].pop(string.format('CONVERT HP%% SET TO: %s.', flags.hpp))

                    else
                        bp.helpers['popchat'].pop('MP%% MUST BE A NUMBER BETWEEN 25 & 75!')

                    end

                end

            else
                flags.enabled = flags.enabled ~= true and true or false
                bp.helpers['popchat'].pop(string.format('AUTO-CONVERT: %s.', tostring(flags.enabled)))

            end

        end

        set['gain'] = function(name, commands, subjob)
            local flags = subjob ~= true and private.flags[name] or private.flags[bp.player.sub_job][name]

            if flags and #commands > 0 then

                for i in ipairs(commands) do
                    local value = tonumber(commands[i]) ~= nil and tonumber(commands[i]) or commands[i]

                    if value then

                        if type(value) == 'string' then
                            local spell = windower.convert_auto_trans(value)

                            if S{'Gain-VIT','Gain-DEX','Gain-CHR','Gain-MND','Gain-AGI','Gain-STR','Gain-INT'}:contains(spell) then
                                flags.name = spell
                                bp.helpers['popchat'].pop(string.format('AUTO-GAIN SPELL SET TO: %s.', flags.name))

                            else
                                bp.helpers['popchat'].pop('INVALID SPELL NAME!')

                            end

                        end

                    end

                end

            else
                flags.enabled = flags.enabled ~= true and true or false
                bp.helpers['popchat'].pop(string.format('AUTO-GAIN: %s.', tostring(flags.enabled)))

            end

        end

        set['en'] = function(name, commands, subjob)
            local flags = subjob ~= true and private.flags[name] or private.flags[bp.player.sub_job][name]

            if flags and #commands > 0 then

                if commands[2] then
                    local tier = tonumber(commands[2])

                    if tier and T{1,2}:contains(tier) then
                        flags.tier = tier
                        bp.helpers['popchat'].pop(string.format('AUTO-ENSPELL TIER SET TO: %s.', flags.tier))

                        do -- Set the new name value if the tier changed.
                            flags.name = flags.tier < 2 and spell or string.format('%s II', spell)
                        end

                    else
                        bp.helpers['popchat'].pop('SPELL TIER MUST BE 1 OR 2!')

                    end

                end

                if commands[1] then
                    local spell = windower.convert_auto_trans(commands[1])

                    if S{'Enfire','Enaero','Enblizzard','Enstone','Enthunder','Enwater'}:contains(spell) then
                        flags.name = flags.tier < 2 and spell or string.format('%s II', spell)
                        bp.helpers['popchat'].pop(string.format('AUTO-ENSPELL SET TO: %s.', flags.name))

                    else
                        bp.helpers['popchat'].pop('INVALID SPELL NAME!')

                    end

                end

            else
                flags.enabled = flags.enabled ~= true and true or false
                bp.helpers['popchat'].pop(string.format('AUTO-ENSPELL: %s.', tostring(flags.enabled)))

            end

        end

        set['cover'] = function(name, commands, subjob)
            local flags = subjob ~= true and private.flags[name] or private.flags[bp.player.sub_job][name]
            local target = windower.ffxi.get_mob_by_target('st') or windower.ffxi.get_mob_by_target('t') or false

            if flags and (commands[1] or target) and target.name ~= bp.player.name then
                local value = commands[1]

                if (value or target) then
                    local target = value ~= nil and windower.ffxi.get_mob_by_name(value) or target or false

                    if target and bp.helpers['party'].isInParty(target) then
                        flags.target = target.name
                        bp.helpers['popchat'].pop(string.format('AUTO-COVER TARGET SET TO: %s.', flags.target))

                    else
                        bp.helpers['popchat'].pop('INVALID TARGET SELECTED!')

                    end

                end

            elseif #commands == 0 and (not target or (target.name == bp.player.name)) then
                flagsflags.enabled = flags.enabled ~= true and true or false
                bp.helpers['popchat'].pop(string.format('AUTO-COVER: %s.', tostring(flags.enabled)))

            end

        end

        set['chivalry'] = function(name, commands, subjob)
            local flags = subjob ~= true and private.flags[name] or private.flags[bp.player.sub_job][name]

            if flags and #commands > 0 then

                for i in ipairs(commands) do
                    local value = tonumber(commands[i]) ~= nil and tonumber(commands[i]) or commands[i]

                    if value then

                        if type(value) == 'number' then
                            
                            if value < 1000 then
                                
                                if value >= 25 and value <= 75 then
                                    flags.mpp = value
                                    bp.helpers['popchat'].pop(string.format('CHIVALRY MP%% SET TO: %s.', flags.mpp))

                                else
                                    bp.helpers['popchat'].pop('MP%% MUST BE A NUMBER BETWEEN 25 & 75!')

                                end

                            else

                                if value >= 1000 and value <= 3000 then
                                    flags.tp = value
                                    bp.helpers['popchat'].pop(string.format('CHIVALRY TP%% SET TO: %s.', flags.tp))

                                else
                                    bp.helpers['popchat'].pop('TP%% MUST BE A NUMBER BETWEEN 1000 & 3000!')

                                end

                            end

                        end

                    end

                end

            elseif #commands == 0 then
                flags.enabled = flags.enabled ~= true and true or false
                bp.helpers['popchat'].pop(string.format('AUTO-CHIVALRY: %s.', tostring(flags.enabled)))

            end

        end

        set['absorb'] = function(name, commands, subjob)
            local flags = subjob ~= true and private.flags[name] or private.flags[bp.player.sub_job][name]

            if flags and #commands > 0 then
                local spell = windower.convert_auto_trans(commands[1])

                if S{'Absorb-VIT','Absorb-DEX','Absorb-CHR','Absorb-MND','Absorb-AGI','Absorb-STR','Absorb-INT','Absorb-ACC','Absorb-TP','Absorb-Attri'}:contains(spell) then
                    flags.name = spell
                    bp.helpers['popchat'].pop(string.format('AUTO-ABSORB SPELL SET TO: %s.', flags.name))

                else
                    bp.helpers['popchat'].pop('INVALID SPELL NAME!')

                end

            else
                flags.enabled = flags.enabled ~= true and true or false
                bp.helpers['popchat'].pop(string.format('AUTO-ABSORB: %s.', tostring(flags.enabled)))

            end

        end

        set['reward'] = function(name, commands, subjob)
            local flags = subjob ~= true and private.flags[name] or private.flags[bp.player.sub_job][name]

            if flags and #commands > 0 then
                
                if commands[1] then
                    local value = tonumber(commands[1])

                    if value and value > 1 and value < 75 then
                        flags.hpp = value
                        bp.helpers['popchat'].pop(string.format('AUTO-REWARD HP%% SET TO: %s.', flags.hpp))

                    else
                        bp.helpers['popchat'].pop('HP% MUST BE A NUMBER BETWEEN 1 & 75!')

                    end

                end

            else
                flags.enabled = flags.enabled ~= true and true or false
                bp.helpers['popchat'].pop(string.format('AUTO-REWARD: %s.', tostring(flags.enabled)))

            end

        end

        set['ready'] = function(name, commands, subjob)
            local flags = subjob ~= true and private.flags[name] or private.flags[bp.player.sub_job][name]

            if flags and #commands > 0 then
                
                if commands[1] then
                    local value = windower.convert_auto_trans(commands[1])

                end

            else
                flags.enabled = flags.enabled ~= true and true or false
                bp.helpers['popchat'].pop(string.format('AUTO-REWARD: %s.', tostring(flags.enabled)))

            end

        end

        set['decoy shot'] = function(name, commands, subjob)
            local flags = subjob ~= true and private.flags[name] or private.flags[bp.player.sub_job][name]
            local target = windower.ffxi.get_mob_by_target('st') or windower.ffxi.get_mob_by_target('t') or false

            if flags and (#commands > 0 or target) and target.name ~= bp.player.name then
                local value = commands[1]

                if (value or target) then
                    local target = value ~= nil and windower.ffxi.get_mob_by_name(value) or target or false

                    if target and bp.helpers['party'].isInParty(target) then
                        flags.target = target.name
                        bp.helpers['popchat'].pop(string.format('AUTO-DECOY SHOT TARGET SET TO: %s.', flags.target))

                    else
                        bp.helpers['popchat'].pop('INVALID TARGET SELECTED!')

                    end

                end

            elseif #commands == 0 and (not target or (target.name == bp.player.name)) then
                flags.enabled = flags.enabled ~= true and true or false
                bp.helpers['popchat'].pop(string.format('AUTO-COVER: %s.', tostring(flags.enabled)))

            end

        end

        set['elemental siphon'] = function(name, commands, subjob)
            local flags = subjob ~= true and private.flags[name] or private.flags[bp.player.sub_job][name]

            if flags and #commands > 0 then
                
                if commands[1] then
                    local value = tonumber(commands[1])

                    if value and value > 1 and value < 75 then
                        flags.mpp = value
                        bp.helpers['popchat'].pop(string.format('AUTO-ELEMENTAL SIPHON MP%% SET TO: %s.', flags.mpp))

                    else
                        bp.helpers['popchat'].pop('MP% MUST BE A NUMBER BETWEEN 1 & 75!')

                    end

                end

            else
                flags.enabled = flags.enabled ~= true and true or false
                bp.helpers['popchat'].pop(string.format('AUTO-ELEMENTAL SIPHON: %s.', tostring(flags.enabled)))

            end

        end

        set['summon'] = function(name, commands, subjob)
            local flags = subjob ~= true and private.flags[name] or private.flags[bp.player.sub_job][name]

            if flags and #commands > 0 then
                local options = {'Carbuncle','Cait Sith','Ifrit','Shiva','Garuda','Ramuh','Titan','Leviathan','Fenrir','Diabolos','Siren','Atomos'}
                local spell = windower.convert_auto_trans(commands[1])
                local error = true

                for _,summon in ipairs(options) do

                    if summon:lower():sub(1, #spell) == spell:lower():sub(1, #spell) then
                        flags.pacts = summon
                        error = false
                        break                        

                    end

                end

                if error then
                    bp.helpers['popchat'].pop('PLEASE ENTER A VALID AVATAR NAME!')

                else
                    bp.helpers['popchat'].pop(string.format('AUTO-SUMMON SET TO: %s.', flags.name))

                end

            else
                flags.enabled = flags.enabled ~= true and true or false
                bp.helpers['popchat'].pop(string.format('AUTO-SUMMON: %s.', tostring(flags.enabled)))

            end

        end

        set['bpr'] = function(name, commands, subjob)
            local flags = subjob ~= true and private.flags[name] or private.flags[bp.player.sub_job][name]
            local pacts = {

                rage = {
        
                    ['Carbuncle']   = {'Poison Nails','Meteorite','Holy Mist'},
                    ['Cait Sith']   = {'Regal Scratch','Level ? Holy', 'Regal Gash'},
                    ['Ifrit']       = {'Flaming Crush','Meteor Strike','Conflag Strike'},
                    ['Shiva']       = {'Double Slap','Rush','Heavenly Strike'},
                    ['Garuda']      = {'Claw','Predator Claws','Wind Blade'},
                    ['Titan']       = {'Mountain Buster','Geocrush','Crag Throw'},
                    ['Ramuh']       = {'Thunderspark','Thunderstorm','Volt Strike'},
                    ['Leviathan']   = {'Spinning Dive','Grand Fall'},
                    ['Fenrir']      = {'Eclipse Bite','Lunar Bay','Impact'},
                    ['Diabolos']    = {'Nether Blast','Night Terror'},
                    ['Siren']       = {'Sonic Buffet','Hysteric Assault'},
        
                },
                
                ward = {
        
                    ['Carbuncle']   = {'Shining Ruby','Glittering Ruby','Healing Ruby II','Soothing Ruby'},
                    ['Cait Sith']   = {'Mewing Lullaby'},
                    ['Ifrit']       = {'Crimson Howl','Inferno Howl'},
                    ['Shiva']       = {'Crystal Blessing'},
                    ['Garuda']      = {'Whispering Wind','Hastega II'},
                    ['Titan']       = {'Earthen Armor'},
                    ['Ramuh']       = {'Rolling Thunder','Shock Squall'},
                    ['Leviathan']   = {'Spring Water'},
                    ['Fenrir']      = {'Ecliptic Growl','Ecliptic Howl'},
                    ['Diabolos']    = {'Dream Shroud'},
                    ['Siren']       = {'Bitter Elegy','Wind\'s Blessing'},
        
                },
        
            }

            if flags and commands[1] and commands[2] then
                local summons = {'Carbuncle','Cait Sith','Ifrit','Shiva','Garuda','Ramuh','Titan','Leviathan','Fenrir','Diabolos','Siren','Atomos'}
                local pet = windower.convert_auto_trans(commands[1])
                local pact = windower.convert_auto_trans(commands[2])
                local error = true

                for _,summon in ipairs(summons) do

                    if pet:lower():sub(1, #pet) == summon:lower():sub(1, #pet) and pacts.rage[summon] and pacts.ward[summon] then

                        for avatar, rage in pairs(pacts.rage[summon]) do

                            if pact:lower():sub(1, #pact) == rage:lower():sub(1, #pact) then
                                flags.pacts[avatar] = rage
                                bp.helpers['popchat'].pop(string.format('AUTO-BLOOD PACT: RAGE SET TO: %s.', flags.pacts[avatar]))
                                error = false
                                break

                            end

                        end

                    end

                end

                if error then
                    bp.helpers['popchat'].pop('PLEASE ENTER A VALID BLOOD PACT: RAGE NAME!')
                end

            else
                flags.enabled = flags.enabled ~= true and true or false
                bp.helpers['popchat'].pop(string.format('AUTO-SUMMON: %s.', tostring(flags.enabled)))

            end

        end

        set['bpw'] = function(name, commands, subjob)
            local flags = subjob ~= true and private.flags[name] or private.flags[bp.player.sub_job][name]

        end

        set['shikikoyo'] = function(name, commands, subjob)
            local flags = subjob ~= true and private.flags[name] or private.flags[bp.player.sub_job][name]
            local target = windower.ffxi.get_mob_by_target('st') or windower.ffxi.get_mob_by_target('t') or false

            if flags and #commands > 0 then
                
                for i in ipairs(commands) do
                    local value = tonumber(commands[i]) ~= nil and tonumber(commands[i]) or commands[i]

                    if (value or target) then
                        
                        if type(value) == 'number' then
                            
                            if value >= 1000 and value <= 3000 then
                                flags.tp = value
                                bp.helpers['popchat'].pop(string.format('AUTO-SHIKIKOYO TP%% SET TO: %s.', flags.tp))
        
                            else
                                bp.helpers['popchat'].pop('ENTER A TP% VALUE BETWEEN 1000 & 3000!')
        
                            end

                        end
                        
                        if target and target.name ~= bp.player.name then
                            local target = value ~= nil and windower.ffxi.get_mob_by_name(value) or target

                            if target and bp.helpers['party'].isInParty(target) then
                                flags.target = target.name
                                bp.helpers['popchat'].pop(string.format('AUTO-SHIKIKOYO TARGET SET TO: %s.', flags.target))
        
                            else
                                bp.helpers['popchat'].pop('INVALID TARGET SELECTED!')
        
                            end

                        end

                    end

                end

            elseif #commands == 0 then
                
                if not target then
                    flags.enabled = flags.enabled ~= true and true or false
                    bp.helpers['popchat'].pop(string.format('AUTO-SHIKIKOYO: %s.', tostring(flags.enabled)))

                else

                    if target and target.name ~= bp.player.name then

                        if target and bp.helpers['party'].isInParty(target) then
                            flags.target = target.name
                            bp.helpers['popchat'].pop(string.format('AUTO-SHIKIKOYO TARGET SET TO: %s.', flags.target))
    
                        else
                            bp.helpers['popchat'].pop('INVALID TARGET SELECTED!')
    
                        end

                    end

                end

            end

        end

        set['quick draw'] = function(name, commands, subjob)
            local flags = subjob ~= true and private.flags[name] or private.flags[bp.player.sub_job][name]

            if flags and #commands > 0 then
                local options = {'Fire Shot','Water Shot','Thunder Shot','Earth Shot','Wind SHot','Ice SHot','Light Shot','Dark Shot'}
                local spell = windower.convert_auto_trans(commands[1])
                local error = true

                for _,shot in ipairs(options) do

                    if shot:lower():sub(1, #spell) == spell:lower():sub(1, #spell) then
                        flags.name = shot
                        error = false
                        break                        

                    end

                end

                if error then
                    bp.helpers['popchat'].pop('PLEASE ENTER A VALID QUICK DRAW NAME!')

                else
                    bp.helpers['popchat'].pop(string.format('AUTO-QUICK DRAW SET TO: %s.', flags.name))

                end

            else
                flags.enabled = flags.enabled ~= true and true or false
                bp.helpers['popchat'].pop(string.format('AUTO-QUICK DRAW: %s.', tostring(flags.enabled)))

            end

        end

        set['repair'] = function(name, commands, subjob)
            local flags = subjob ~= true and private.flags[name] or private.flags[bp.player.sub_job][name]

            if flags and #commands > 0 then
                
                if commands[1] then
                    local value = tonumber(commands[1])

                    if value and value > 1 and value < 75 then
                        flags.hpp = value
                        bp.helpers['popchat'].pop(string.format('AUTO-REPAIR HP%% SET TO: %s.', flags.hpp))

                    else
                        bp.helpers['popchat'].pop('HP% MUST BE A NUMBER BETWEEN 1 & 75!')

                    end

                end

            else
                flags.enabled = flags.enabled ~= true and true or false
                bp.helpers['popchat'].pop(string.format('AUTO-REPAIR: %s.', tostring(flags.enabled)))

            end

        end

        set['sambas'] = function(name, commands, subjob)
            local flags = subjob ~= true and private.flags[name] or private.flags[bp.player.sub_job][name]

            if flags and #commands > 0 then
                local spell = windower.convert_auto_trans(commands[1])

                if S{'Drain Samba','Aspir Samba','Haste Samba','Drain Samba II','Aspir Samba II','Drain Samba III'}:contains(spell) then
                    flags.name = spell
                    bp.helpers['popchat'].pop(string.format('AUTO-SAMBAS SET TO: %s.', flags.name))

                else
                    bp.helpers['popchat'].pop('PLEASE ENTER A VALID SAMBA NAME!')

                end

            else
                flags.enabled = flags.enabled ~= true and true or false
                bp.helpers['popchat'].pop(string.format('AUTO-SAMBA: %s.', tostring(flags.enabled)))

            end

        end

        set['steps'] = function(name, commands, subjob)
            local flags = subjob ~= true and private.flags[name] or private.flags[bp.player.sub_job][name]

            if flags and #commands > 0 then
                local options = {'Quickstep','Box Step','Stutter Step','Feather Step'}
                local spell = windower.convert_auto_trans(commands[1])
                local error = true

                for _,steps in ipairs(options) do

                    if steps:lower():sub(1, #spell) == spell:lower():sub(1, #spell) then
                        flags.name = steps
                        error = false
                        break                        

                    end

                end

                if error then
                    bp.helpers['popchat'].pop('PLEASE ENTER A VALID STEPS NAME!')

                else
                    bp.helpers['popchat'].pop(string.format('AUTO-STEPS SET TO: %s.', flags.name))

                end

            else
                flags.enabled = flags.enabled ~= true and true or false
                bp.helpers['popchat'].pop(string.format('AUTO-STEP: %s.', tostring(flags.enabled)))

            end

        end

        set['flourishes'] = function(name, commands, subjob)
            local flags = subjob ~= true and private.flags[name] or private.flags[bp.player.sub_job][name]

            if flags and #commands > 0 then
                local cat1 = T{'Animated Flourish','Desperate Flourish','Violent Flourish'}
                local cat2 = T{'Reverse Flourish','Building Flourish','Wild Flourish'}
                local cat3 = T{'Climactic Flourish','Striking Flourish','Ternary Flourish'}

                for i in ipairs(commands) do
                    local value = tonumber(commands[i]) ~= nil and tonumber(commands[i]) or commands[i]

                    if value then
                        local spell = windower.convert_auto_trans(value)

                        if cat1:contains(spell) then
                            local options = cat1
                            local spell = windower.convert_auto_trans(value)
                            local error = true

                            for _,flourish in ipairs(options) do

                                if flourish:lower():sub(1, #spell) == spell:lower():sub(1, #spell) then
                                    flags.cat_1 = flourish
                                    error = false

                                end

                            end

                            if error then
                                bp.helpers['popchat'].pop(string.format('INVALID OPTION (#%s) - FLOURISH NAME NOT FOUND!', i))

                            else
                                bp.helpers['popchat'].pop(string.format('AUTO-FLOURISHES (CATEGORY I) SET TO: %s.', flags.cat_1))

                            end

                        elseif cat2:contains(spell) then
                            local options = cat2
                            local spell = windower.convert_auto_trans(value)
                            local error = true

                            for _,flourish in ipairs(options) do

                                if flourish:lower():sub(1, #spell) == spell:lower():sub(1, #spell) then
                                    flags.cat_2 = flourish
                                    error = false

                                end

                            end

                            if error then
                                bp.helpers['popchat'].pop(string.format('INVALID OPTION (#%s) - FLOURISH NAME NOT FOUND!', i))

                            else
                                bp.helpers['popchat'].pop(string.format('AUTO-FLOURISHES (CATEGORY I) SET TO: %s.', flags.cat_1))

                            end

                        elseif cat3:contains(spell) then
                            local options = cat3
                            local spell = windower.convert_auto_trans(value)
                            local error = true

                            for _,flourish in ipairs(options) do

                                if flourish:lower():sub(1, #spell) == spell:lower():sub(1, #spell) then
                                    flags.cat_3 = flourish
                                    error = false

                                end

                            end

                            if error then
                                bp.helpers['popchat'].pop(string.format('INVALID OPTION (#%s) - FLOURISH NAME NOT FOUND!', i))

                            else
                                bp.helpers['popchat'].pop(string.format('AUTO-FLOURISHES (CATEGORY I) SET TO: %s.', flags.cat_1))

                            end

                        end

                    end

                end

            else
                flags.enabled = flags.enabled ~= true and true or false
                bp.helpers['popchat'].pop(string.format('AUTO-FLOURISHES: %s.', tostring(flags.enabled)))

            end

        end

        set['jigs'] = function(name, commands, subjob)
            local flags = subjob ~= true and private.flags[name] or private.flags[bp.player.sub_job][name]

            if flags and #commands > 0 then
                local options = {'Spectral Jig','Chocobo Jig','Chocobo Jig II'}
                local spell = windower.convert_auto_trans(commands[1])
                local error = true

                for _,jig in ipairs(options) do

                    if jig:lower():sub(1, #spell) == spell:lower():sub(1, #spell) then
                        flags.name = jig
                        error = false
                        break                        

                    end

                end

                if error then
                    bp.helpers['popchat'].pop('UNABLE TO FIND A JIG BY THAT NAME!')

                else
                    bp.helpers['popchat'].pop(string.format('AUTO-JIGS SET TO: %s.', flags.name))

                end

            else
                flags.enabled = flags.enabled ~= true and true or false
                bp.helpers['popchat'].pop(string.format('AUTO-JIG: %s.', tostring(flags.enabled)))

            end

        end

        set['sublimation'] = function(name, commands, subjob)
            local flags = subjob ~= true and private.flags[name] or private.flags[bp.player.sub_job][name]

            if flags and #commands > 0 then
                
                if commands[1] then
                    local value = tonumber(commands[1]) ~= nil and tonumber(commands[1]) or commands[1]

                    if type(value) == 'number' and value >= 1 and value <= 60 then
                        flags.mpp = value
                        bp.helpers['popchat'].pop(string.format('AUTO-SUBLIMATION MP%% SET TO: %s.', flags.mpp))

                    else
                        bp.helpers['popchat'].pop('VALUE MUST BE BETWEEN 1 & 60!')

                    end

                end

            else
                flags.enabled = flags.enabled ~= true and true or false
                bp.helpers['popchat'].pop(string.format('AUTO-SUBLIMATION: %s.', tostring(flags.enabled)))

            end

        end

        set['storms'] = function(name, commands, subjob)
            local flags = subjob ~= true and private.flags[name] or private.flags[bp.player.sub_job][name]

            if flags and #commands > 0 then
                local options = {'Sandstorm','Rainstorm','Windstorm','Firestorm','Hailstorm','Thunderstorm','Voidstorm','Aurorastorm'}
                local spell = windower.convert_auto_trans(commands[1])
                local error = true

                for _,storm in ipairs(options) do

                    if storm:lower():sub(1, #spell) == spell:lower():sub(1, #spell) then
                        flags.name = storm
                        error = false
                        break                        

                    end

                end

                if error then
                    bp.helpers['popchat'].pop('UNABLE TO FIND A SPELL BY THAT NAME!')

                else
                    bp.helpers['popchat'].pop(string.format('AUTO-STORMS SPELL SET TO: %s.', flags.name))

                end

            else
                flags.enabled = flags.enabled ~= true and true or false
                bp.helpers['popchat'].pop(string.format('AUTO-STORMS: %s.', tostring(flags.enabled)))

            end

        end

        set['vivacious pulse'] = function(name, commands, subjob)
            local flags = subjob ~= true and private.flags[name] or private.flags[bp.player.sub_job][name]

            if flags and #commands > 0 then
                
                if commands[1] then
                    local value = tonumber(commands[1])

                    if value and value > 1 and value < 75 then
                        flags.hpp = value
                        bp.helpers['popchat'].pop(string.format('AUTO-V. PULSE HP%% SET TO: %s.', flags.hpp))

                    else
                        bp.helpers['popchat'].pop('HP% MUST BE A NUMBER BETWEEN 1 & 75!')

                    end

                end

                if commands[2] then
                    local value = tonumber(commands[2])

                    if value and value > 1 and value < 75 then
                        flags.mpp = value
                        bp.helpers['popchat'].pop(string.format('AUTO-V. PULSE MP%% SET TO: %s.', flags.mpp))

                    else
                        bp.helpers['popchat'].pop('MP% MUST BE A NUMBER BETWEEN 1 & 75!')

                    end

                end

            else
                flags.enabled = flags.enabled ~= true and true or false
                bp.helpers['popchat'].pop(string.format('AUTO-VIVACIOUS PULSE: %s.', tostring(flags.enabled)))

            end

        end

        set['embolden'] = function(name, commands, subjob)
            local flags = subjob ~= true and private.flags[name] or private.flags[bp.player.sub_job][name]

            if flags and #commands > 0 then
                local options = {'Protect','Crusade','Temper','Phalanx','Foil'}
                local spell = windower.convert_auto_trans(commands[1])
                local error = true

                for _,v in ipairs(options) do

                    if v:lower():sub(1, #spell) == spell:lower():sub(1, #spell) then
                        
                        if spell:lower() == 'protect' then
                            flags.name = string.format('%s IV', v)
                            error = false
                            break

                        else
                            flags.name = v
                            error = false
                            break

                        end

                    end

                end

                if error then
                    bp.helpers['popchat'].pop('SPELL OPTIONS ARE: PROTECT, CRUSADE, TEMPER, PHALANX, FOIL!')

                else
                    bp.helpers['popchat'].pop(string.format('AUTO-EMBOLDEN SPELL SET TO: %s.', flags.name))

                end

            else
                flags.enabled = flags.enabled ~= true and true or false
                bp.helpers['popchat'].pop(string.format('AUTO-EMBOLDEN: %s.', tostring(flags.enabled)))

            end

        end
        
        if bp and bp.player and name and commands and set[name] then
            set[name](name, commands, subjob or false)
        end

    end

    -- Public Functions.
    self.setSystem = function(buddypal)
        if buddypal then
            bp = buddypal
        end

    end

    self.getFlags = function()
        return private.flags
    end

    self.get = function(name)

        if bp and bp.player and bp.player.sub_job then
            return private.flags[bp.player.sub_job][name] ~= nil and private.flags[bp.player.sub_job][name] or private.flags[name]
        end
        return nil

    end

    self.set = function(name, value)
        local flag = private.flags[bp.player.sub_job][name] ~= nil and private.flags[bp.player.sub_job][name] or private.flags[name]

        if flag ~= nil and type(value) == 'table' and type(flag) == 'table' then

            for i,v in pairs(value) do
                
                if flag[i] ~= nil then
                    flag[i] = v
                end

            end

        elseif flag ~= nil and type(flag) == type(value) then
            private.flags[name] = value

        end
        private.writeSettings()

    end

    -- Private Events.
    private.events.commands = windower.register_event('addon command', function(...)
        local commands = T{...}
        local helper = table.remove(commands, 1)

        if bp and bp.player and helper and helper:lower() == 'set' then
            local flag = windower.convert_auto_trans(table.remove(commands, 1)):lower()
            
            if private.flags[flag] ~= nil and type(private.flags[flag]) ~= 'boolean' then
                private.set(flag, commands)

            else
                
                if private.flags[bp.player.sub_job] and private.flags[bp.player.sub_job][flag] ~= nil then

                    if type(private.flags[bp.player.sub_job][flag]) ~= 'boolean' then
                        private.set(flag, commands, true)
                        
                    elseif type(private.flags[bp.player.sub_job][flag]) == 'boolean' then    
                        local message = private.naming[flag] ~= nil and private.naming[flag] or flag
                        
                        if private.flags[bp.player.sub_job][flag] ~= nil then
                            private.flags[bp.player.sub_job][flag] = private.flags[bp.player.sub_job][flag] ~= true and true or false
                            bp.helpers['popchat'].pop(string.format('%s: %s.', message, tostring(private.flags[bp.player.sub_job][flag])))

                        end

                    end

                elseif private.flags[flag] ~= nil and type(private.flags[flag]) == 'boolean' then
                    private.flags[flag] = private.flags[flag] ~= true and true or false
                    
                    if private.naming[flag] then
                        bp.helpers['popchat'].pop(string.format('%s: %s.', private.naming[flag], tostring(private.flags[flag])))

                    else
                        bp.helpers['popchat'].pop(string.format('%s: %s.', flag, tostring(private.flags[flag])))
                    end

                end

            end
            private.writeSettings()

        end

    end)

    return self

end
return core.new()
