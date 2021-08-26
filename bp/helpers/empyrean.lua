local empyrean  = {}
local player    = windower.ffxi.get_player()
local files     = require('files')
local texts     = require('texts')
local f = files.new(string.format('bp/helpers/settings/empyrean/%s_settings.lua', player.name))

if not f:exists() then
  f:write(string.format('return %s', T({}):tovstring()))
end

function empyrean.new()
    local self = {}

    -- Static Variables.
    self.settings   = dofile(string.format('%sbp/helpers/settings/empyrean/%s_settings.lua', windower.addon_path, player.name))
    self.layout     = self.settings.layout or {pos={x=100, y=100}, colors={text={alpha=255, r=245, g=200, b=20}, bg={alpha=200, r=0, g=0, b=0}, stroke={alpha=255, r=0, g=0, b=0}}, font={name='Lucida Console', size=9}, padding=4, stroke_width=1, draggable=false}
    self.display    = texts.new('', {flags={draggable=self.layout.draggable}})

    -- Private Variables.
    local bp        = false
    local timers    = {sound={last=0, delay=30}, scan={last=0, delay=20}, warning={}}
    local sounds    = {ph='Energy_Blade', nm='Energy_Blade'}
    local spawned   = {}
    local colors    = {
        
        string.format('%s,%s,%s', 200, 000, 000),
        string.format('%s,%s,%s', 000, 200, 030),
        string.format('%s,%s,%s', 000, 140, 200),
        string.format('%s,%s,%s', 140, 200, 125),

    }
    local data      = self.settings.data or {

        ["Verethragna"] = {
            
            {mob="Tumbling Truffle",    count=0,max=3,weapon="Pugilists",    trial=68,          nm={0x0FB},             ph={0x0F8},                     delay=300,           zone="La Theine Plateau"},
            {mob="Helldiver",           count=0,max=3,weapon="Simian Fists", trial=69,          nm={0xa6B},             ph={0x16A},                     delay=300,           zone="Buburimu Peninsula"},
            {mob="Orctrap",             count=0,max=3,weapon="Simian Fists", trial=70,          nm={0x10C},             ph={0x10B},                     delay=300,           zone="Carpenters' Landing"},
            {mob="Intulo",              count=0,max=4,weapon="Simian Fists", trial=71,          nm={0x08E},             ph={0x08D},                     delay=300,           zone="Bibiki Bay"},
            {mob="Ramponneau",          count=0,max=4,weapon="Mantis",       trial=72,          nm={0x171},             ph={0x16D},                     delay=300,           zone="West Sarutabaruta [S]"},
            {mob="Keeper of Halidom",   count=0,max=4,weapon="Mantis",       trial=73,          nm={0x092},             ph={0x091},                     delay=300,           zone="The Sanctuary of Zi'Tah"},
            {mob="Shoggoth",            count=0,max=6,weapon="Mantis",       trial=74,          nm={0},                 ph={0},                         delay=0,             zone=""},
            {mob="Farruca Fly",         count=0,max=6,weapon="Mantis",       trial=75,          nm={0},                 ph={0},                         delay=0,             zone=""},
            {mob="Chesma",              count=0,max=8,weapon="Mantis",       trial=1138,        nm={0},                 ph={0},                         delay=0,             zone=""}
        
        },                                                
        ["Twashtar"] = {
            
            {mob="Nocuous Weapon",      count=0,max=3,weapon="Peeler",       trial=2,           nm={0x099},             ph={0x095,0x097},               delay=300,           zone="Inner Horutoto Ruins"},
            {mob="Black Triple Stars",  count=0,max=3,weapon="Renegade",     trial=3,           nm={0x0D8},             ph={0x0D4,0x0C0},               delay=300,           zone="Rolanberry Fields"},
            {mob="Serra",               count=0,max=3,weapon="Renegade",     trial=4,           nm={0x02E},             ph={0x02D},                     delay=300,           zone="Bibiki Bay"},
            {mob="Bugbear Strongman",   count=0,max=4,weapon="Renegade",     trial=5,           nm={0x097,0x09B},       ph={0x095,0x09A},               delay=0,             zone="Oldton Movalpolos"},
            {mob="La Velue",            count=0,max=4,weapon="Kartika",      trial=6,           nm={0x128},             ph={0x112},                     delay=300,           zone="Batallia Downs [S]"},
            {mob="Hovering Hotpot",     count=0,max=4,weapon="Kartika",      trial=7,           nm={0xD4},              ph={0x0D2,0x0D0},               delay=300,           zone="Garlaige Citadel"},
            {mob="Yacumama",            count=0,max=6,weapon="Kartika",      trial=8,           nm={0},                 ph={0},                         delay=0,             zone=""},
            {mob="Feuerunke",           count=0,max=6,weapon="Kartika",      trial=9,           nm={0},                 ph={0},                         delay=0,             zone=""},
            {mob="Tammuz",              count=0,max=8,weapon="Kartika",      trial=1092,        nm={0},                 ph={0},                         delay=0,             zone=""}
        
        },                                            
        ["Almace"] = {
                    
            {mob="Serpopard Ishtar",    count=0,max=3,weapon="Side-Sword",   trial=150,   nm={0x073,0x0F2},             ph={0x070,0x0EE},               delay=300,           zone="Tahrongi Canyon"},
            {mob="Tottering Toby",      count=0,max=3,weapon="Schiavona",    trial=151,   nm={0x0B4},                   ph={0x099},                     delay=300,           zone="Batallia Downs"},
            {mob="Drooling Daisy",      count=0,max=3,weapon="Schiavona",    trial=152,   nm={0x1CC},                   ph={0x1CB},                     delay=300,           zone="Rolanberry Fields"},
            {mob="Gargantua",           count=0,max=4,weapon="Schiavona",    trial=153,   nm={0x0CF},                   ph={0x0CE},                     delay=300,           zone="Beaucedine Glacier"},
            {mob="Megalobugard",        count=0,max=4,weapon="Nobilis",      trial=154,   nm={0x0DD},                   ph={0x0BF,0x0C8,0x0DB},         delay=300,           zone="Lufaise Meadows"},
            {mob="Ratatoskr",           count=0,max=4,weapon="Nobilis",      trial=155,   nm={},                        ph={0x028},                     delay=300,           zone="Fort Karugo-Narugo [S]"},
            {mob="Jyeshtha",            count=0,max=6,weapon="Nobilis",      trial=156,   nm={0},                       ph={0},                         delay=0,             zone=""},
            {mob="Capricornus",         count=0,max=6,weapon="Nobilis",      trial=157,   nm={0},                       ph={0},                         delay=0,             zone=""},
            {mob="Tammuz",              count=0,max=8,weapon="Nobilis",      trial=1200,  nm={0},                       ph={0},                         delay=0,             zone=""}
        
        },                                        
        ["Caladbolg"] = {
                    
            {mob="Bloodpool Vorax",         count=0,max=3,weapon="Break Blade",  trial=216,   nm={0x153},               ph={0x14E},                     delay=300,           zone="Pashhow Marshlands"},
            {mob="Golden Bat",              count=0,max=3,weapon="Sunblade",     trial=217,   nm={0x1CC},               ph={0x1CB,0x1CA,0x1AB},         delay=300,           zone="Valkurm Dunes"},
            {mob="Slippery Sucker",         count=0,max=3,weapon="Sunblade",     trial=218,   nm={0x04D},               ph={0x040,0x041,0x042,0x044},   delay=300,           zone="Qufim Island"},
            {mob="Seww the Squidlimbed",    count=0,max=4,weapon="Sunblade",     trial=219,   nm={0x0BD},               ph={0x0BA},                     delay=300,           zone="Sea Serpent Grotto"},
            {mob="Ankabut",                 count=0,max=4,weapon="Albion",       trial=220,   nm={0x029},               ph={0x025},                     delay=300,           zone="North Gustaberg [S]"},
            {mob="Okyupete",                count=0,max=4,weapon="Albion",       trial=221,   nm={0x0E7},               ph={0x0DF},                     delay=300,           zone="Misareaux Coast"},
            {mob="Urd",                     count=0,max=6,weapon="Albion",       trial=222,   nm={0},                   ph={0},                         delay=0,             zone=""},
            {mob="Lamprey Lord",            count=0,max=6,weapon="Albion",       trial=223,   nm={0},                   ph={0},                         delay=0,             zone=""},
            {mob="Chesma",                  count=0,max=8,weapon="Albion",       trial=1246,  nm={0},                   ph={0},                         delay=0,             zone=""}
        
        },                                                
        ["Farsha"] = {
                    
            {mob="Panzer Percival",         count=0,max=3,weapon="Chopper",      trial=282,   nm={0x181,0x1BA},         ph={0x17D,0x1B5},               delay=300,           zone="Jugner Forest"},
            {mob="Ge'Dha Evileye",          count=0,max=3,weapon="Splinter",     trial=283,   nm={0x07A},               ph={0x077},                     delay=600,           zone="Beadeaux"},
            {mob="Bashe",                   count=0,max=3,weapon="Splinter",     trial=284,   nm={0x034},               ph={0x02E},                     delay=300,           zone="Sauromugue Champaign"},
            {mob="Intulo",                  count=0,max=4,weapon="Splinter",     trial=285,   nm={0x08E},               ph={0x08D},                     delay=300,           zone="Bibiki Bay"},
            {mob="Ramponneau",              count=0,max=4,weapon="Bonebiter",    trial=286,   nm={0x171},               ph={0x16D},                     delay=300,           zone="West Sarutabaruta [S]"},
            {mob="Keeper of Halidom",       count=0,max=4,weapon="Bonebiter",    trial=287,   nm={0x092},               ph={0x091},                     delay=300,           zone="The Sanctuary of Zi'Tah"},
            {mob="Shoggoth",                count=0,max=6,weapon="Bonebiter",    trial=288,   nm={0},                   ph={0},                         delay=0,             zone=""},
            {mob="Farruca Fly",             count=0,max=6,weapon="Bonebiter",    trial=289,   nm={0},                   ph={0},                         delay=0,             zone=""},
            {mob="Tammuz",                  count=0,max=8,weapon="Bonebiter",    trial=1292,  nm={0},                   ph={0},                         delay=0,             zone=""}
        
        },                                
        ["Ukonvasara"] = {
                    
            {mob="Hoo Mjuu the Torrent",    count=0,max=3,weapon="Lumberjack",   trial=364,   nm={0x17B},               ph={0x179},                     delay=480,           zone="Giddeus"},
            {mob="Daggerclaw Dracos",       count=0,max=3,weapon="Sagaris",      trial=365,   nm={0x0B2},               ph={0x0AF},                     delay=300,           zone="Meriphataud Mountains"},
            {mob="Namtar",                  count=0,max=3,weapon="Sagaris",      trial=366,   nm={0x048},               ph={0x042,0x047},               delay=300,           zone="Sea Serpent Grotto"},
            {mob="Gargantua",               count=0,max=4,weapon="Sagaris",      trial=367,   nm={0x0CF},               ph={0x0CE},                     delay=300,           zone="Beaucedine Glacier"},
            {mob="Megalobugard",            count=0,max=4,weapon="Bonesplitter", trial=368,   nm={0x0DD},               ph={0x0BF,0x0C8,0x0DB},         delay=300,           zone="Lufaise Meadows"},
            {mob="Ratatoskr",               count=0,max=4,weapon="Bonesplitter", trial=369,   nm={0x02B},               ph={0x028},                     delay=300,           zone="Fort Karugo-Narugo [S]"},
            {mob="Jyeshtha",                count=0,max=6,weapon="Bonesplitter", trial=370,   nm={0},                   ph={0},                         delay=0,             zone=""},
            {mob="Capricornus",             count=0,max=6,weapon="Bonesplitter", trial=371,   nm={0},                   ph={0},                         delay=0,             zone=""},
            {mob="Chesma",                  count=0,max=8,weapon="Bonesplitter", trial=1354,  nm={0},                   ph={0},                         delay=0,             zone=""}
        
        },                    
        ["Redemption"] = {
                    
            {mob="Barbastelle",             count=0,max=3,weapon="Farmhand",     trial=512,   nm={0x109},               ph={},                          delay=0,             zone="King Ranperre's Tomb"},
            {mob="Ah Puch",                 count=0,max=3,weapon="Stigma",       trial=513,   nm={0x03F},               ph={0x058},                     delay=300,           zone="Outer Horutoto Ruins"},
            {mob="Donggu",                  count=0,max=3,weapon="Stigma",       trial=514,   nm={0x039},               ph={0x035},                     delay=300,           zone="Ordelle's Caves"},
            {mob="Bugbear Strongman",       count=0,max=4,weapon="Stigma",       trial=515,   nm={0x097,0x09B},         ph={0x095,0x09A},               delay=0,             zone="Oldton Movalpolos"},
            {mob="La Velue",                count=0,max=4,weapon="Ultimatum",    trial=516,   nm={0x128},               ph={0x112},                     delay=300,           zone="Batallia Downs [S]"},
            {mob="Hovering Hotpot",         count=0,max=4,weapon="Ultimatum",    trial=517,   nm={0x0D4},               ph={0x0D2,0x0D0},               delay=300,           zone="Garlaige Citadel"},
            {mob="Yacumama",                count=0,max=6,weapon="Ultimatum",    trial=518,   nm={0},                   ph={0},                         delay=0,             zone=""},
            {mob="Feuerunke",               count=0,max=6,weapon="Ultimatum",    trial=519,   nm={0},                   ph={0},                         delay=0,             zone=""},
            {mob="Tammuz",                  count=0,max=8,weapon="Ultimatum",    trial=1462,  nm={0},                   ph={0},                         delay=0,             zone=""}
        
        },                                        
        ["Rhongomiant"] = {
                    
            {mob="Slendlix Spindlethumb",   count=0,max=3,weapon="Ranseur",      trial=430,   nm={0x089},               ph={0x087,0x06E},               delay=300,           zone="Inner Horutoto Ruins"},
            {mob="Herbage Hunter",          count=0,max=3,weapon="Copperhead",   trial=431,   nm={0x184},               ph={0x183},                     delay=300,           zone="Tahrongi Canyon"},
            {mob="Kirata",                  count=0,max=3,weapon="Copperhead",   trial=432,   nm={0x0AC},               ph={0x0AB},                     delay=300,           zone="Beaucedine Glacier"},
            {mob="Intulo",                  count=0,max=4,weapon="Copperhead",   trial=433,   nm={0x08E},               ph={0x08D},                     delay=300,           zone="Bibiki Bay"},
            {mob="Ramponneau",              count=0,max=4,weapon="Oathkeeper",   trial=434,   nm={0x171},               ph={0x16D},                     delay=300,           zone="West Sarutabaruta [S]"},
            {mob="Keeper of Halidom",       count=0,max=4,weapon="Oathkeeper",   trial=435,   nm={0x92},                ph={0x091},                     delay=300,           zone="The Sanctuary of Zi'Tah"},
            {mob="Shoggoth",                count=0,max=6,weapon="Oathkeeper",   trial=436,   nm={0},                   ph={0},                         delay=0,             zone=""},
            {mob="Farruca Fly",             count=0,max=6,weapon="Oathkeeper",   trial=437,   nm={0},                   ph={0},                         delay=0,             zone=""},
            {mob="Chesma",                  count=0,max=8,weapon="Oathkeeper",   trial=1400,  nm={0},                   ph={0},                         delay=0,             zone=""}
        
        },                                            
        ["Kannagi"] = {
                    
            {mob="Zi'Ghi Boneeater",        count=0,max=3,weapon="Kibashiri",    trial=578,   nm={0x108},               ph={0x105},                     delay=480,           zone="Palborough Mines"},
            {mob="Lumbering Lambert",       count=0,max=3,weapon="Koruri",       trial=579,   nm={0x135},               ph={0x134},                     delay=300,           zone="La Theine Plateau"},
            {mob="Deadly Dodo",             count=0,max=3,weapon="Koruri",       trial=580,   nm={0x073},               ph={0x071,0x072},               delay=300,           zone="Sauromugue Champaign"},
            {mob="Gargantua",               count=0,max=4,weapon="Koruri",       trial=581,   nm={0x0CF},               ph={0x0CE},                     delay=300,           zone="Beaucedine Glacier"},
            {mob="Megalobugard",            count=0,max=4,weapon="Mozu",         trial=582,   nm={0x0DD},               ph={0x0BF,0x0C8,0x0DB},         delay=300,           zone="Lufaise Meadows"},
            {mob="Ratatoskr",               count=0,max=4,weapon="Mozu",         trial=583,   nm={0x02B},               ph={0x028},                     delay=300,           zone="Fort Karugo-Narugo [S]"},
            {mob="Jyeshtha",                count=0,max=6,weapon="Mozu",         trial=584,   nm={0},                   ph={0},                         delay=0,             zone=""},
            {mob="Capricornus",             count=0,max=6,weapon="Mozu",         trial=585,   nm={0},                   ph={0},                         delay=0,             zone=""},
            {mob="Tammuz",                  count=0,max=8,weapon="Mozu",         trial=1508,  nm={0},                   ph={0},                         delay=0,             zone=""}
        
        },                                                                
        ["Masamune"] = {
                    
            {mob="Vuu Puqu the Beguller",   count=0,max=3,weapon="Donto",        trial=644,   nm={0x1BA},               ph={0x1B9},                     delay=480,           zone="Giddeus"},
            {mob="Buburimboo",              count=0,max=3,weapon="Shirodachi",   trial=645,   nm={0x1CB},               ph={0x1CA},                     delay=300,           zone="Buburimu Peninsula"},
            {mob="Zo'Khu Blackcloud",       count=0,max=3,weapon="Shirodachi",   trial=646,   nm={0x0EC},               ph={0x0EA},                     delay=720,           zone="Beadeaux"},
            {mob="Seww the Squidlimbed",    count=0,max=4,weapon="Shirodachi",   trial=647,   nm={0x0BD},               ph={0x0BA},                     delay=300,           zone="Sea Serpent Grotto"},
            {mob="Ankabut",                 count=0,max=4,weapon="Radennotachi", trial=648,   nm={0x029},               ph={0x025},                     delay=300,           zone="North Gustaberg [S]"},
            {mob="Okyupete",                count=0,max=4,weapon="Radennotachi", trial=649,   nm={0x0E7},               ph={0x0DF},                     delay=300,           zone="Misareaux Coast"},
            {mob="Urd",                     count=0,max=6,weapon="Radennotachi", trial=650,   nm={0},                   ph={0},                         delay=0,             zone=""},
            {mob="Lamprey Lord",            count=0,max=6,weapon="Radennotachi", trial=651,   nm={0},                   ph={0},                         delay=0,             zone=""},
            {mob="Chesma",                  count=0,max=8,weapon="Radennotachi", trial=1554,  nm={0},                   ph={0},                         delay=0,             zone=""}
        
        },                                                        
        ["Gambanteinn"] = {
                    
            {mob="Stray Mary",              count=0,max=3,weapon="Stenz",        trial=710,   nm={0x0D3,0x15D},         ph={0x158,0x0CF},               delay=300,           zone="Konschtat Highlands"},
            {mob="Hawkeyed Dnatbat",        count=0,max=3,weapon="Rageblow",     trial=711,   nm={0x02F},               ph={0x026,0x028,0x02B},         delay=0,             zone="Davoi"},
            {mob="Dune Widow",              count=0,max=3,weapon="Rageblow",     trial=712,   nm={0x0EC},               ph={0x0EB},                     delay=300,           zone="Eastern Altepa Desert"},
            {mob="Seww the Squidlimbed",    count=0,max=4,weapon="Rageblow",     trial=713,   nm={0x0BD},               ph={0x0BA},                     delay=300,           zone="Sea Serpent Grotto"},
            {mob="Ankabut",                 count=0,max=4,weapon="Culacula",     trial=714,   nm={0x029},               ph={0x025},                     delay=300,           zone="North Gustaberg [S]"},
            {mob="Okyupete",                count=0,max=4,weapon="Culacula",     trial=715,   nm={0x0E7},               ph={0x0DF},                     delay=300,           zone="Misareaux Coast"},
            {mob="Urd",                     count=0,max=6,weapon="Culacula",     trial=716,   nm={0},                   ph={0},                         delay=0,             zone=""},
            {mob="Lamprey Lord",            count=0,max=6,weapon="Culacula",     trial=717,   nm={0},                   ph={0},                         delay=0,             zone=""},
            {mob="Tammuz",                  count=0,max=8,weapon="Culacula",     trial=1600,  nm={0},                   ph={0},                         delay=0,             zone=""}
        
        },                                                        
        ["Hverglmir"] = {
                    
            {mob="Teporingo",               count=0,max=3,weapon="Crook",        trial=776,   nm={0x020},               ph={0x01F},                     delay=300,           zone="Dangruf Wadi"},
            {mob="Valkurm Emperor",         count=0,max=3,weapon="Shillelagh",   trial=777,   nm={0x14E},               ph={0x14A},                     delay=300,           zone="Valkurm Dunes"},
            {mob="Hyakume",                 count=0,max=3,weapon="Shillelagh",   trial=778,   nm={0x054},               ph={0x04D},                     delay=300,           zone="Ranguemont Pass"},
            {mob="Gloomanita",              count=0,max=4,weapon="Shillelagh",   trial=779,   nm={0x09D},               ph={0x09C},                     delay=300,           zone="North Gustaberg [S]"},
            {mob="Mischievous Micholas",    count=0,max=4,weapon="Slaine",       trial=780,   nm={0x07C},               ph={0x07D},                     delay=300,           zone="Yuhtunga Jungle"},
            {mob="Cactuar Cantautor",       count=0,max=4,weapon="Slaine",       trial=781,   nm={0x158},               ph={0x156,0x157},               delay=300,           zone="Western Altepa Desert"},
            {mob="Erebus",                  count=0,max=6,weapon="Slaine",       trial=782,   nm={0},                   ph={0},                         delay=0,             zone=""},
            {mob="Skuld",                   count=0,max=6,weapon="Slaine",       trial=783,   nm={0},                   ph={0},                         delay=0,             zone=""},
            {mob="Chesma",                  count=0,max=8,weapon="Slaine",       trial=1646,  nm={0},                   ph={0},                         delay=0,             zone=""}
        
        },                                            
        ["Gandiva"] = {
                    
            {mob="Be'Hya Hundredwall",      count=0,max=3,weapon="Sparrow",      trial=941,   nm={0x13A},               ph={0x138,0x139},               delay=600,           zone="Palborough Mines"},
            {mob="Jolly Green",             count=0,max=3,weapon="Kestrel",      trial=942,   nm={0x0D1},               ph={0x0D0},                     delay=300,           zone="Pashhow Marshlands"},
            {mob="Trembler Tabitha",        count=0,max=3,weapon="Kestrel",      trial=943,   nm={0x036},               ph={0x034,0x035},               delay=300,           zone="Maze of Shakhrami"},
            {mob="Seww the Squidlimbed",    count=0,max=4,weapon="Kestrel",      trial=944,   nm={0x0BD},               ph={0x0BA},                     delay=300,           zone="Sea Serpent Grotto"},
            {mob="Ankabut",                 count=0,max=4,weapon="Astrild",      trial=945,   nm={0x029},               ph={0x025},                     delay=300,           zone="North Gustaberg [S]"},
            {mob="Okyupete",                count=0,max=4,weapon="Astrild",      trial=946,   nm={0x0E7},               ph={0x0DF},                     delay=300,           zone="Misareaux Coast"},
            {mob="Urd",                     count=0,max=6,weapon="Astrild",      trial=947,   nm={0},                   ph={0},                         delay=0,             zone=""},
            {mob="Lamprey Lord",            count=0,max=6,weapon="Astrild",      trial=948,   nm={0},                   ph={0},                         delay=0,             zone=""},
            {mob="Chesma",                  count=0,max=8,weapon="Astrild",      trial=1788,  nm={0},                   ph={0},                         delay=0,             zone=""}
        
        },                                            
        ["Armageddon"] = {
                    
            {mob="Desmodont",               count=0,max=3,weapon="Thunderstick", trial=891,   nm={0x01E},               ph={0x01C},                     delay=300,           zone="Outer Horutoto Ruins"},
            {mob="Moo Ouzi the Swiftblade", count=0,max=3,weapon="Blue Steel",   trial=892,   nm={0x068},               ph={0x065},                     delay=600,           zone="Castle Oztroja"},
            {mob="Ni'Zho Bladebender",      count=0,max=3,weapon="Blue Steel",   trial=893,   nm={0x075},               ph={0x06D,0x03C},               delay=300,           zone="Pashhow Marshlands"},
            {mob="Bugbear Strongman",       count=0,max=4,weapon="Blue Steel",   trial=894,   nm={0x097,0x09B},         ph={0x095,0x09A},               delay=0,             zone="Oldton Movalpolos"},
            {mob="La Velue",                count=0,max=4,weapon="Magnatus",     trial=895,   nm={0x128},               ph={0x112},                     delay=300,           zone="Batallia Downs [S]"},
            {mob="Hovering Hotpot",         count=0,max=4,weapon="Magnatus",     trial=896,   nm={0x0D4},               ph={0x0D2,0x0D0},               delay=300,           zone="Garlaige Citadel"},
            {mob="Yacumama",                count=0,max=6,weapon="Magnatus",     trial=897,   nm={0},                   ph={0},                         delay=0,             zone=""},
            {mob="Feuerunke",               count=0,max=6,weapon="Magnatus",     trial=898,   nm={0},                   ph={0},                         delay=0,             zone=""},
            {mob="Tammuz",                  count=0,max=8,weapon="Magnatus",     trial=1758,  nm={0},                   ph={0},                         delay=0,             zone=""}
        
        },

    }

    -- Public Variables.
    self.trial      = {}
    self.Target     = false
    self.enabled    = false

    -- Private Functions
    local persist = function()
        local next = next

        if self.settings then
            self.settings.enbled    = self.enabled
            self.settings.trial     = self.trial
            self.settings.layout    = self.layout
            self.settings.data      = data

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

    local playSound = function(name)
        local bp    = bp or false
        local name  = name or false
        
        if bp and name and type(name) == 'string' and (os.clock()-timers.sound.last) > timers.sound.delay then
            bp.helpers['sounds'].play(name)
            timers.sound.last = os.clock()    
        end

    end

    local updateCount = function()

        if self.enabled and self.trial and self.trial.trial then

            for i,v in pairs(data) do
                    
                if type(v) == 'table' then
                    
                    for n, info in pairs(v) do

                        if info.count < info.max and info.trial == self.trial.trial and info.mob == self.trial.mob then
                            data[i][n].count = (data[i][n].count + 1)
                            break

                        end

                    end

                end

            end

        end
        self.writeSettings()

    end

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

    end

    self.getNextTrial = function()

        if self.enabled and self.trial and self.trial.trial then

            for i,v in pairs(data) do
                    
                if type(v) == 'table' then
                    
                    for n,info in pairs(v) do
                        
                        if info.trial == self.trial.trial then
                            local count = #data[i]
                            
                            if count and n < count then
                                return data[i][n+1].trial

                            else
                                return 0

                            end

                        end

                    end

                end

            end

        end

    end

    self.getWarnings = function()
        local player = windower.ffxi.get_mob_by_target('me')

        if self.enabled and self.trial.trial then
            local index = spawned[self.trial.ph[i]]
            local t     = {}
            
            for i=1, #timers.warning do
                
                if timers.warning[i] then
                    local clock = ((timers.warning[i].delay-(os.clock()-timers.warning[i].last) )/60)
                    local ready = clock > 0 and clock or 0

                    do
                        table.insert(t, string.format('PH: \\cs(%s)%s\\cr time remaining: \\cs(%s)~%.2f minutes.\\cr', colors[3], timers.warning[i].index, colors[3], ready))
                    end

                    if spawned and spawned[self.trial.ph[i]] then
                        local index = timers.warning[i].index
                        
                        if spawned[index].active then
                            local pos       = spawned[index].pos
                            local distance  = math.sqrt( (pos.x-player.x)^2 + (pos.y-player.y)^2 )

                            do
                                table.insert(t, string.format('%s\\cs(%s)Placeholder has spawned %.2f yalms away!\\cr\n', (''):lpad(' ', 5), colors[2], distance))
                            end

                        elseif not spawned[self.trial.ph[i]].active then
                            table.insert(t, string.format('%s\\cs(%s)Placeholder is inactive...\\cr\n', (''):lpad(' ', 5), colors[1]))

                        end

                    end

                end

            end

            for i,v in ipairs(self.trial.nm) do

                if spawned and spawned[v] then

                    if spawned[v].active then
                        table.insert(t, string.format('\n\\cs(%s) *** [[ %s is currently active!! ]] ***\\cr', colors[2], self.trial.mob))

                    elseif not spawned[v].active then
                        table.insert(t, string.format('\n\\cs(%s) *** [[ The NM is currently inactive. ]] ***\\cr', colors[1]))

                    end

                end

            end
            return table.concat(t, '\n')

        end
        return ''


    end

    -- Public Functions.
    self.setSystem = function(buddypal)
        if buddypal then
            bp = buddypal
        end

    end
    
    self.scan = function()
        local bp    = bp or false
        local zone  = bp.res.zones[windower.ffxi.get_info().zone] or false

        if bp and self.trial and self.enabled and (os.clock()-timers.scan.last) > timers.scan.delay and zone and zone.en == self.trial.zone then

            if self.trial.nm then
            
                for _,v in ipairs(self.trial.nm) do
                    bp.packets.inject(bp.packets.new('outgoing', 0x016, {["Target Index"] = v}))
                end

            end

            if self.trial.ph then

                for _,v in ipairs(self.trial.ph) do
                    bp.packets.inject(bp.packets.new('outgoing', 0x016, {["Target Index"] = v}))
                end
            
            end
            timers.scan.last = os.clock()

        end

    end

    self.find = function(data)
        local bp    = bp or false
        local data  = data or false
        local zone  = bp.res.zones[windower.ffxi.get_info().zone] or false
        
        if bp and self.enabled and data and zone and zone.en == self.trial.zone then
            local packed = bp.packets.parse('incoming', data)

            if T(self.trial.nm):contains(packed['Index']) then
                local player    = windower.ffxi.get_mob_by_target('me')
                local check     = packed['X'] + packed['Y'] + packed['Z']

                if packed['Status'] == 0 then

                    if packed['Mask'] == 15 then

                        if spawned[packed['Index']] and not spawned[packed['Index']].active then
                            spawned[packed['Index']].active = true
                            spawned[packed['Index']].pos    = {x=packed['X'], y=packed['Y'], z=packed['Z']}

                        end

                    elseif packed['Mask'] == 1 then

                        if spawned[packed['Index']] and spawned[packed['Index']].active then
                            spawned[packed['Index']].pos = {x=packed['X'], y=packed['Y'], z=packed['Z']}
                        end

                    end

                elseif packed['Status'] == 1 then

                    if packed['Mask'] == 15 then

                        if spawned[packed['Index']] and not spawned[packed['Index']].active then
                            spawned[packed['Index']].active = true
                            spawned[packed['Index']].pos    = {x=packed['X'], y=packed['Y'], z=packed['Z']}

                        end
                        playSound(sounds.nm)

                    end

                end

            elseif T(self.trial.ph):contains(packed['Index']) then
                local player    = windower.ffxi.get_mob_by_target('me')
                local distance  = math.sqrt( (packed['X']-player.x)^2 + (packed['Y']-player.y)^2 )
                local check     = packed['X'] + packed['Y'] + packed['Z']

                if packed['Status'] == 0 then

                    if packed['Mask'] == 15 then

                        if spawned[packed['Index']] and not spawned[packed['Index']].active then
                            spawned[packed['Index']].active = true
                            spawned[packed['Index']].pos    = {x=packed['X'], y=packed['Y'], z=packed['Z']}
                            
                        end
                        playSound(sounds.ph)

                    elseif packed['Mask'] == 1 then

                        if spawned[packed['Index']] and spawned[packed['Index']].active then
                            spawned[packed['Index']].pos = {x=packed['X'], y=packed['Y'], z=packed['Z']}
                        end

                    end

                elseif packed['Status'] == 3 and packed['Mask'] == 7 and packed['HP %'] == 0 and spawned[packed['Index']].active then
                    spawned[packed['Index']].active = false

                    for i,v in ipairs(timers.warning) do

                        if v.index and v.index == packed['Index'] and (os.clock()-v.last) > 2 then
                            timers.warning[i].last = os.clock()
                            break

                        end

                    end

                end

            end

        end
    
    end

    self.set = function(trial)
        local bp    = bp or false
        local trial = trial or false

        do -- Reset the timers, and enable the addon.
            timers = {sound={last=0, delay=30}, scan={last=0, delay=20}, warning={}}
            self.enabled = true
        end

        if bp and trial and tonumber(trial) ~= nil then
            local weapon = bp.helpers['equipment'].main
            local ranged = bp.helpers['equipment'].ranged

            for i,v in pairs(data) do
                    
                if type(v) == 'table' then
                    
                    for _,info in pairs(v) do
                        
                        if (weapon and weapon.en and weapon.en == info.weapon) or (ranged and ranged.en and ranged.en == info.weapon) and info.trial == trial then
                            bp.helpers['popchat'].pop(string.format('%s Trials now set to Trial# %s: NM - %s', i, info.trial, info.mob))
                            self.trial = info

                            for n, index in ipairs(info.ph) do
                                table.insert(timers.warning, {last=0, delay=info.delay, index=index})
                                spawned[index] = {active=false, pos=0, index=index}
                            end

                            for n, index in ipairs(info.nm) do
                                spawned[index] = {active=false, pos=0, index=index}
                            end
                            break

                        end

                    end

                end

            end

        end

    end

    self.toggle = function()
        local bp = bp or false

        if bp then

            if self.enabled then
                self.enabled = false

            else
                self.enabled = true

            end
            bp.helpers['popchat'].pop(string.format('EMPYEAN HELPER: %s', tostring(self.enabled)))

        end

    end

    self.parseText = function(message, mode)
        local bp        = bp or false
        local message   = message or false
        local mode      = mode or false

        if bp and message and mode and mode == 36 then
            local message   = (message):strip_format() or false
            local player    = windower.ffxi.get_player()

            if self.trial and self.trial.trial then

                if message == string.format('%s defeats the %s.', player.name, self.trial.mob) then
                    updateCount()

                    for i=1, #self.trial.nm do

                        if self.trial.nm[i] and spawned[self.trial.nm[i]] then
                            spawned[self.trial.nm[i]].active = false
                        end

                    end
                
                end

            end
            
        end

    end

    self.render = function()
        local bp = bp or false

        if bp then
            local zone = bp.res.zones[windower.ffxi.get_info().zone] or false

            if self.enabled and self.trial and self.trial.trial and zone and zone.en == self.trial.zone then
                local warning   = self.getWarnings()
                local update    = {

                    string.format('[ EMPYREAN TRIAL: \\cs(%s)#%s\\cr ]\n', colors[3], self.trial.trial),
                    string.format('MOB: \\cs(%s)%s\\cr', colors[3], self.trial.mob),
                    string.format('KILLS: \\cs(%s)%s\\cr / \\cs(%s)%s\\cr', colors[4], self.trial.count, colors[2], self.trial.max),
                    string.format('NEXT TRIAL: \\cs(%s)%s\\cr\n', colors[3], self.getNextTrial()),
                    string.format('%s', 'PLACEHOLDERS:'),
                    string.format('%s', warning),

                }
                self.display:text(table.concat(update, '\n'))
                self.display:update()

                if not self.display:visible() then
                    self.display:show()
                end

            elseif not self.enabled and self.display:visible() then
                self.display:text('')
                self.display:update()
                self.display:hide()

            end

        end

    end

    return self

end
return empyrean.new()