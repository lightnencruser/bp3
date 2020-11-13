local cures     = {}
local player    = windower.ffxi.get_player()
local files     = require('files')
local texts     = require('texts')
local res       = require('resources')
local packets   = require('packets')
local f = files.new(string.format('bp/helpers/settings/cures/%s_settings.lua', player.name))

if not f:exists() then
    f:write(string.format('return %s', T({}):tovstring()))
end

function cures.new()
    local self = {}

    -- Static Variables.
    self.settings   = dofile(string.format('%sbp/helpers/settings/cures/%s_settings.lua', windower.addon_path, player.name))

    -- Private Variables.
    local weights   = self.settings.weights or {}
    local spells    = {1,2,3,4,5,6,7,8,9,10,11,578,593,658,581,690}
    local abilities = {190,191,192,193,311,195,262}
    local modes     = {'OFF','PARTY','ALLIANCE'}
    local store     = 100
    local math      = math
    local needed    = {}
    local allowed   = {
        
        {{id=1,priority=false,min=65},{id=2,priority=false,min=145},{id=3,priority=false,min=340},{id=4,priority=true,min=640},{id=5,priority=true,min=780},{id=6,priority=true,min=1010}},
        {{id=7,priority=false,min=90},{id=8,priority=false,min=130},{id=9,priority=true,min=270},{id=10,priority=true,min=450},{id=011,priority=true,min=900}},
        {{id=190,priority=false,min=100},{id=191,priority=false,min=300},{id=192,priority=false,min=600},{id=193,priority=true,min=700},{id=311,priority=true,min=1000}},
        {{id=195,priority=false,min=130},{id=262,priority=true,min=270}},
        {{id=578,priority=false,min=120},{id=593,priority=false,min=250},{id=658,priority=true,min=350}},
        {{id=581,priority=false,min=60},{id=690,priority=true,min=450}},
        
    }

    -- Public Variables.
    self.mode       = self.settings.mode or 1
    self.updating   = false
    self.party      = {}
    self.alliance   = {}

    -- Private Functions.
    local persist = function()
        local next = next

        if self.settings then
            self.settings.mode      = self.mode
            self.settings.weights   = weights

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

    self.zoneChange = function()
        self.writeSettings()

    end

    self.buildParty = function()
        self.party      = {}
        self.alliance   = {}
            
        for i,v in pairs(windower.ffxi.get_party()) do
                
            if i:sub(1,1) == 'p' and tonumber(i:sub(2)) ~= nil and type(v) == "table" then
                local hp    = v.hp 
                local hpp   = v.hpp
                local max   = math.floor(v.hp/( v.hpp/100) )
                    
                if v.mob then
                    table.insert(self.party, {id=v.mob.id, distance=v.mob.distance, hp=hp, hpp=hpp, max=max, missing=(max-hp)})
                end
                    
            elseif i:sub(1,1) == "a" and type(v) == "table" then
                local hp    = v.hp 
                local hpp   = v.hpp
                local max   = math.floor(v.hp/( v.hpp/100) )
                    
                if v.mob then
                    table.insert(self.alliance, {id=v.mob.id, distance=v.mob.distance, hp=hp, hpp=hpp, max=max, missing=(max-hp)})
                end
                    
            end
            
        end
        
    end

    self.curesNeeded = function()
        local count = 0
        
        for _,v in ipairs(self.party) do
            local max = v.max

            if v.hpp < 90 and v.hpp ~= 0 then
                count = (count + 1)
            end
            
        end
        return count
        
    end
    
    -- Public Functions.
    self.changeMode = function(bp)
        local bp = bp or false

        if bp then
            self.mode = (self.mode + 1)
            
            if self.mode > #modes then
                self.mode = 1
            end
            bp.helpers['popchat'].pop(string.format('CURE MODE: %s', modes[self.mode]))

        end


    end

    self.validSpell = function(bp, id)
        local bp = bp or false
        local id = id or false

        if bp and id then

            for _,v in ipairs(spells) do

                if v == id then
                    return true
                end

            end

        end

    end

    self.validAbility = function(bp, id)
        local bp = bp or false
        local id = id or false

        if bp and id then

            for _,v in ipairs(abilities) do

                if v == id then
                    return true
                end

            end

        end

    end

    self.getCure = function(bp, id)
        local bp = bp or false
        local id = id or false
        
        if bp and id then
            
            for _,v in ipairs(allowed) do
                
                if type(v) == "table" then
                    
                    for _,spell in ipairs(v) do
                        
                        if spell and spell.id == id then
                            return spell
                        end
                        
                    end
                    
                end
                
            end
            
        end
        return false
        
    end

    self.getWeight = function(bp, id)
        local player    = windower.ffxi.get_player() or false
        local bp        = bp or false
        local id        = id or false
        
        if bp and player and id and weights[player.main_job_id] and weights[player.main_job_id][id] then
            local weight = 0
            
            for _,v in ipairs(weights[player.main_job_id][id]) do
                weight = (weight + v)
            end
            
            return math.floor(weight/#weights[player.main_job_id][id])
            
        else
            return self.getCure(bp, id).min
            
        end
        
    end
    
    self.estimateCure = function(bp, missing)
        local bp        = bp or false
        local player    = windower.ffxi.get_player()
        local levels    = {main=player.main_job_level, sub=player.sub_job_level}
        local missing   = missing or false
        local spell     = false
        local required
        
        if bp and missing then
            
            for _,v in ipairs({1,2,3,4,5,6}) do
                local weight = self.getWeight(bp, v)
                local cure   = res.spells[v]
                
                if cure.levels then
                    required = {main=(cure.levels[player.main_job_id] or 255), sub=(cure.levels[player.sub_job_id] or 255)}
                end
                
                if cure and weight <= missing and (levels.main >= required.main or levels.sub >= required.sub) then
                    spell = cure
                end
                
            end
            
        end
        return spell
        
    end
    
    self.estimateWaltz = function(bp, missing)
        local bp        = bp or false
        local player    = windower.ffxi.get_player()
        local levels    = {main=player.main_job_level, sub=player.sub_job_level}
        local missing   = missing or false
        local spell     = false
        local required
        
        if bp and missing then
            
            for _,v in ipairs({190,191,192,193,311}) do
                local weight = self.getWeight(v)
                local cure   = res.job_abilities[v]
                
                if cure.levels then
                    required = {main=(cure.levels[player.main_job_id] or 255), sub=(cure.levels[player.sub_job_id] or 255)}
                end
                
                if cure and weight <= missing and (levels.main >= required.main or levels.sub >= required.sub) then
                    spell = cure
                end
                
            end
            
        end
        return spell
        
    end
    
    self.estimateBlu = function(bp, missing)
        local bp        = bp or false
        local player    = windower.ffxi.get_player()
        local levels    = {main=player.main_job_level, sub=player.sub_job_level}
        local missing   = missing or false
        local spell     = false
        local required
        
        if bp and missing then
            
            for _,v in ipairs({578,593,658}) do
                local weight = self.getWeight(v)
                local cure   = res.spells[v]
                
                if cure.levels then
                    required = {main=(cure.levels[player.main_job_id] or 255), sub=(cure.levels[player.sub_job_id] or 255)}
                end
                
                if cure and weight <= missing and (levels.main >= required.main or levels.sub >= required.sub) then
                    spell = cure
                end
                
            end
            
        end
        return spell
        
    end
    
    self.estimateCuraga = function(bp, missing, count)
        local bp        = bp or false
        local player    = windower.ffxi.get_player()
        local levels    = {main=player.main_job_level, sub=player.sub_job_level}
        local missing   = missing or false
        local count     = count or false
        local spell     = false
        local required
        
        if bp and missing and count then
            missing = missing
            
            for _,v in ipairs({7,8,9,10,11}) do
                local weight = self.getWeight(v)
                local cure   = res.spells[v]
                
                if cure.levels then
                    required = {main=(cure.levels[player.main_job_id] or 255), sub=(cure.levels[player.sub_job_id] or 255)}
                end
                
                if cure and weight <= (missing/count) and (levels.main >= required.main or levels.sub >= required.sub) then
                    spell = cure
                end
                
            end
            
        end
        return spell
        
    end
    
    self.estimateWaltzga = function(bp, missing, count)
        local bp        = bp or false
        local player    = windower.ffxi.get_player()
        local levels    = {main=player.main_job_level, sub=player.sub_job_level}
        local missing   = missing or false
        local count     = count or false
        local spell     = false
        local required
        
        if bp and missing and count then
            missing = missing
            
            for _,v in ipairs({195,262}) do
                local weight = self.getWeight(v)
                local cure   = res.job_abilities[v]
                
                if cure.levels then
                    required = {main=(cure.levels[player.main_job_id] or 255), sub=(cure.levels[player.sub_job_id] or 255)}
                end
                
                if cure and weight <= (missing/count) and (levels.main >= required.main or levels.sub >= required.sub) then
                    spell = cure
                end
                
            end
            
        end
        return spell
        
    end
    
    self.estimateBluga = function(bp, missing, count)
        local bp        = bp or false
        local player    = windower.ffxi.get_player()
        local levels    = {main=player.main_job_level, sub=player.sub_job_level}
        local missing   = missing or false
        local count     = count or false
        local spell     = false
        local required
        
        if bp and missing and count then
            missing = missing
            
            for _,v in ipairs({581,690}) do
                local weight = self.getWeight(v)
                local cure   = res.spells[v]
                
                if cure.levels then
                    required = {main=(cure.levels[player.main_job_id] or 255), sub=(cure.levels[player.sub_job_id] or 255)}
                end
                
                if cure and weight <= (missing/count) and (levels.main >= required.main or levels.sub >= required.sub) then
                    spell = cure
                end
                
            end
            
        end
        return spell
        
    end

    self.updateWeight = function(bp, data)
        local packets   = packets.parse("incoming", data)
        local id        = packets["Param"] or false
        local targets   = packets["Target Count"] or false
        local amount    = packets["Target 1 Action 1 Param"]
        local bp        = bp or false

        if id and targets and bp and amount then
            local helpers = bp.helpers
            local player  = windower.ffxi.get_player()

            if self.validSpell(bp, id) then
                local cure = res.spells[id] or false
                local info = self.getCure(bp, cure.id)

                if cure and info then

                    if weights[player.main_job_id] then

                        if weights[player.main_job_id][cure.id] and #weights[player.main_job_id][cure.id] > 0 then

                            if amount >= info.min then
                                table.insert(weights[player.main_job_id][cure.id], amount)
                            else
                                table.insert(weights[player.main_job_id][cure.id], info.min)                            
                            end

                            if #weights[player.main_job_id][cure.id] > store then
                                table.remove(weights[player.main_job_id][id], 1)
                            end

                        elseif not weights[player.main_job_id][cure.id] then
                            weights[player.main_job_id][cure.id] = {}

                            if amount >= info.min then
                                table.insert(weights[player.main_job_id][cure.id], amount)
                            else
                                table.insert(weights[player.main_job_id][cure.id], info.min)                            
                            end

                            if #weights[player.main_job_id][cure.id] > store then
                                table.remove(weights[player.main_job_id][id], 1)
                            end

                        end

                    elseif not weights[player.main_job_id] then
                        weights[player.main_job_id] = {[cure.id] = {}}

                        if amount >= info.min then
                            table.insert(weights[player.main_job_id][cure.id], amount)
                        else
                            table.insert(weights[player.main_job_id][cure.id], info.min)                            
                        end

                    end

                end

            elseif self.validAbility(bp, id) then
                local cure = res.job_abilities[id] or false
                local info = self.getCure(bp, cure.id)

                if cure and info then

                    if self.weights[player.main_job_id] then

                        if self.weights[player.main_job_id][cure.id] and #self.weights[player.main_job_id][cure.id] > 0 then

                            if amount >= info.min then
                                table.insert(self.weights[player.main_job_id][cure.id], amount)
                            else
                                table.insert(self.weights[player.main_job_id][cure.id], info.min)                            
                            end

                            if #self.weights[player.main_job_id][cure.id] > store then
                                table.remove(weights[player.main_job_id][id], 1)
                            end

                        elseif not self.weights[player.main_job_id][cure.id] then
                            self.weights[player.main_job_id][cure.id] = {}

                            if amount >= info.min then
                                table.insert(self.weights[player.main_job_id][cure.id], amount)
                            else
                                table.insert(self.weights[player.main_job_id][cure.id], info.min)                            
                            end

                            if #self.weights[player.main_job_id][cure.id] > store then
                                table.remove(weights[player.main_job_id][id], 1)
                            end

                        end

                    elseif not self.weights[player.main_job_id] then
                        self.weights[player.main_job_id] = {[cure.id] = {}}

                        if amount >= info.min then
                            table.insert(self.weights[player.main_job_id][cure.id], amount)
                        else
                            table.insert(self.weights[player.main_job_id][cure.id], info.min)                            
                        end

                    end

                end

            end

        end

    end

    self.handleCuring = function(bp)
        local bp = bp or false
        
        if self.party and self.alliance and self.mode ~= 1 then
            local count     = self.curesNeeded()
            local player    = windower.ffxi.get_player() or false
            local helpers   = bp.helpers            
            
            if self.mode == 2 and count > 0 then
                local party     = T(self.party)
                local id        = false

                if count < 3 and (player.main_job == "WHM" or player.main_job == "RDM" or player.main_job == "SCH" or player.main_job == "PLD" or player.sub_job == "WHM" or player.sub_job == "RDM" or player.sub_job == "SCH" or player.sub_job == "PLD") and player.main_job ~= "DNC" and player.main_job ~= "BLU" then
                    
                    for _,v in ipairs(party) do
                        local cure   = self.estimateCure(bp, v.missing) or false
                        local target = windower.ffxi.get_mob_by_id(v.id) or false
                        
                        if cure and target then
                            helpers['queue'].updateCure(bp, cure, target)
                        end
                        
                    end
                
                elseif count < 3 and (player.main_job == "DNC" or player.sub_job == "DNC") and player.main_job ~= "WHM" then
                    
                    for _,v in ipairs(party) do
                        local cure   = self.estimateWaltz(bp, v.missing) or false
                        local target = windower.ffxi.get_mob_by_id(v.id) or false
                        
                        if cure and target then
                            
                            if cure and target then
                                helpers['queue'].updateCure(bp, cure, target)
                            end
                            
                        end
                        
                    end
                
                elseif count < 3 and player.main_job == "BLU" then
                    
                    for _,v in ipairs(party) do
                        local cure   = self.estimateBlu(bp, v.missing) or false
                        local target = windower.ffxi.get_mob_by_id(v.id) or false
                        
                        if cure and target then
                            
                            if cure and target then
                                helpers['queue'].updateCure(bp, cure, target)
                            end
                            
                        end
                        
                    end
                
                end
                
                if count > 2 and (player.main_job == "WHM" or player.sub_job == "WHM") and player.main_job ~= "DNC" then
                
                    for _,v in ipairs(party) do
                        missing = (missing + v.missing)
                        
                        if not id and v.id ~= player.id then
                            id = v.id
                        end
                        
                    end
    
                    if missing > 0 then
                        local cure   = self.estimateCuraga(bp, missing, count) or false
                        local target = windower.ffxi.get_mob_by_id(id) or false
                        
                        if cure and target then
                            
                            if cure and target then
                                helpers['queue'].updateCure(bp, cure, target)
                            end
                            
                        end
                        
                    end
                
                elseif count > 2 and (player.main_job == "DNC" or player.sub_job == "DNC") and player.main_job ~= "WHM" then
                    
                    for _,v in ipairs(party) do
                        missing = (missing + v.missing)
                        
                        if not id and v.id ~= player.id then
                            id = v.id
                        end
                        
                    end
    
                    if missing > 0 then
                        local cure   = self.estimateWaltzga(bp, missing, count) or false
                        local target = windower.ffxi.get_mob_by_id(id) or false
                        
                        if cure and target then
                            
                            if cure and target then
                                helpers['queue'].updateCure(bp, cure, target)
                            end
                            
                        end
                        
                    end
                    
                elseif count > 2 and player.main_job == "BLU" then
                    
                    for _,v in ipairs(party) do
                        missing = (missing + v.missing)
                        
                        if not id and v.id ~= player.id then
                            id = v.id
                        end
                        
                    end
    
                    if missing > 0 then
                        local cure   = self.estimateBluga(bp, missing, count) or false
                        local target = windower.ffxi.get_mob_by_id(id) or false
                        
                        if cure and target then
                            
                            if cure and target then
                                helpers['queue'].updateCure(bp, cure, target)
                            end
                            
                        end
                        
                    end
                    
                end
            
            elseif mode == 3 and count > 0 then
                local alliance = T(T(party):extend(T(alliance)))
                local missing = 0
                local id = false
                
                if count < 3 and (player.main_job == "WHM" or player.main_job == "RDM" or player.main_job == "SCH" or player.main_job == "PLD" or player.sub_job == "WHM" or player.sub_job == "RDM" or player.sub_job == "SCH" or player.sub_job == "PLD") and player.main_job ~= "DNC" and player.main_job ~= "BLU" then
                    
                    for _,v in ipairs(alliance) do
                        local cure   = self.estimateCure(bp, v.missing) or false
                        local target = windower.ffxi.get_mob_by_id(v.id) or false
                        
                        if cure and target then
                            
                            if cure and target then
                                helpers['queue'].updateCure(bp, cure, target)
                            end
                            
                        end
                        
                    end
                
                elseif count < 3 and (player.main_job == "DNC" or player.sub_job == "DNC") and player.main_job ~= "WHM" then
                    
                    for _,v in ipairs(alliance) do
                        local cure   = self.estimateWaltz(bp, v.missing) or false
                        local target = windower.ffxi.get_mob_by_id(v.id) or false
                        
                        if cure and target then
                            
                            if cure and target then
                                helpers['queue'].updateCure(bp, cure, target)
                            end
                            
                        end
                        
                    end
                
                elseif count < 3 and player.main_job == "BLU" then
                    
                    for _,v in ipairs(party) do
                        local cure   = self.estimateBlu(bp, v.missing) or false
                        local target = windower.ffxi.get_mob_by_id(v.id) or false
                        
                        if cure and target then
                            
                            if cure and target then
                                helpers['queue'].updateCure(bp, cure, target)
                            end
                            
                        end
                        
                    end
                
                end
                
                if count > 2 and (player.main_job == "WHM" or player.sub_job == "WHM") and player.main_job ~= "DNC" then
                
                    for _,v in ipairs(party) do
                        missing = (missing + v.missing)
                        
                        if not id and v.id ~= player.id then
                            id = v.id
                        end
                        
                    end
    
                    if missing > 0 then
                        local cure   = self.estimateCuraga(bp, missing, count) or false
                        local target = windower.ffxi.get_mob_by_id(id) or false
                        
                        if cure and target then
                            
                            if cure and target then
                                helpers['queue'].updateCure(bp, cure, target)
                            end
                            
                        end
                        
                    end
                
                elseif count > 2 and (player.main_job == "DNC" or player.sub_job == "DNC") and player.main_job ~= "WHM" then
                    
                    for _,v in ipairs(party) do
                        missing = (missing + v.missing)
                        
                        if not id and v.id ~= player.id then
                            id = v.id
                        end
                        
                    end
    
                    if missing > 0 then
                        local cure   = self.estimateWaltzga(bp, missing, count) or false
                        local target = windower.ffxi.get_mob_by_id(id) or false
                        
                        if cure and target then
                            
                            if cure and target then
                                helpers['queue'].updateCure(bp, cure, target)
                            end
                            
                        end
                        
                    end
                    
                elseif count > 2 and player.main_job == "BLU" then
                    
                    for _,v in ipairs(party) do
                        missing = (missing + v.missing)
                        
                        if not id and v.id ~= player.id then
                            id = v.id
                        end
                        
                    end
    
                    if missing > 0 then
                        local cure   = self.estimateBluga(bp, missing, count) or false
                        local target = windower.ffxi.get_mob_by_id(id) or false
                        
                        if cure and target then
                            
                            if cure and target then
                                helpers['queue'].updateCure(bp, cure, target)
                            end
                            
                        end
                        
                    end
                
                end
            
            end
            
        end
        
    end
    
    return self

end
return cures.new()