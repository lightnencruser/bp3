local aftermath = {}
function aftermath.new()
    local self = {}
    
    -- Private Variables
    local bp         = false
    local levels     = {270,271,272,273}
    local relics     = {"Spharai","Mandau","Excalibur","Ragnarok","Guttler","Bravura","Apocalypse","Gungnir","Kikoku","Amanomurakumo","Mjollnir","Claustrum","Yoichinoyumi","Annihilator"}
    local aftermaths = {
        
        ["Verethragna"]         = "Victory Smite",
        ["Glanzfaust"]          = "Ascetic's Fury",
        ["Kenkonken"]           = "Stringing Pummel",
        ["Godhands"]            = "Shijin Spiral",
        ["Twashtar"]            = "Rudra's Storm",
        ["Vajra"]               = "Mandalic Stab",
        ["Carnwenhan"]          = "Mordant Rime",
        ["Terpsichore"]         = "Pyrrihic Kleos",
        ["Aeneas"]              = "Exenterator",
        ["Almace"]              = "Chant du Cygne",
        ["Burtgang"]            = "Atonement",
        ["Murgleis"]            = "Death Blossom",
        ["Tizona"]              = "Expacion",
        ["Sequence"]            = "Requiescat",
        ["Caladbolg"]           = "Torcleaver",
        ["Epeolatry"]           = "Dimidiation",
        ["Lionheart"]           = "Resolution",
        ["Farsha"]              = "Cloudsplitter",
        ["Aymur"]               = "Primal Rend",
        ["Tri-edge"]            = "Ruinator",
        ["Ukonvasara"]          = "Ukko's Fury",
        ["Conqueror"]           = "King's Justice",
        ["Chango"]              = "Upheaval",
        ["Redemption"]          = "Quietus",
        ["Liberator"]           = "Insurgency",
        ["Anguta"]              = "Entropy",
        ["Rhongomiant"]         = "Camlann's Torment",
        ["Ryunohige"]           = "Drakesbane",
        ["Trishula"]            = "Stardiver",
        ["Kannagi"]             = "Blade: Hi",
        ["Nagi"]                = "Blade: Kamu",
        ["Heishi Shorinken"]    = "Blade: Shun",
        ["Masamune"]            = "Tachi: Fudo",
        ["Kogarasumaru"]        = "Tachi: Rana",
        ["Dojikiri Yasutsuna"]  = "Tashi: Shoha",
        ["Gambateinn"]          = "Dagan",
        ["Yagrush"]             = "Mystic Boon",
        ["Idris"]               = "Exudation",
        ["Tishtrya"]            = "Realmrazer",
        ["Hvergelmir"]          = "Myrkr",
        ["Laevteinn"]           = "Vidohunir",
        ["Nirvana"]             = "Garland of Bliss",
        ["Tupsimati"]           = "Omniscience",
        ["Khatvanga"]           = "Shattersoul",
        ["Gandiva"]             = "Jishnu's Radiance",
        ["Fail-not"]            = "Apex Arrow",
        ["Armageddon"]          = "Wildfire",
        ["Gastraphetes"]        = "Trueflight",
        ["Death Penalty"]       = "Leaden Salute",
        ["Fomalhaut"]           = "Last Stand",
        ["Spharai"]             = "Final Heaven",
        ["Mandau"]              = "Mercy Stroke",
        ["Excalibur"]           = "Kights of Round",
        ["Ragnarok"]            = "Scourge",
        ["Guttler"]             = "Onslaught",
        ["Bravura"]             = "Metatron Torment",
        ["Apocalypse"]          = "Catastrophe",
        ["Gungnir"]             = "Geirskogul",
        ["Kikoku"]              = "Blade: Metsu",
        ["Amanomurakumo"]       = "Tachi: Kaiten",
        ["Mjollnir"]            = "Randgrith",
        ["Claustrum"]           = "Gates of Tartarus",
        ["Yoichinoyumi"]        = "Namas Arrow",
        ["Annihilator"]         = "Coronach",
        
    }
    
    self.getWeaponskill = function(weapon)
        local bp        = bp or false
        local weapon    = weapon or false
        
        if weapon and aftermaths[weapon] then
            return aftermaths[weapon]
        end
        return false
        
    end
    
    self.checkRelic = function()
        local bp = bp or false

        if bp and bp.helpers['equipment'] ~= nil then
        
            for _,v in ipairs(relics) do
            
                if bp.helpers['equipment'].main and bp.helpers['equipment'].main.en == v then
                    return true
                end
            
            end

        end
        return false
        
    end

    self.getBuffByLevel = function(level)
        local bp    = bp or false
        local level = level or false
        
        if self.checkRelic() then
            return levels[4]
        
        elseif level and levels[level] then
            return levels[level]

        end
        return false
        
    end
    
    return self
    
end
return aftermath.new()
