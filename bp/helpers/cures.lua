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
    local modes     = {0,1,2}
    local math      = math
    local needed    = {}
    local party     = {}
    local alliance  = {}
    local allowed   = {
        
        {{id=1,priority=false,min=65},{id=2,priority=false,min=145},{id=3,priority=false,min=340},{id=4,priority=true,min=640},{id=5,priority=true,min=780},{id=6,priority=true,min=1010}},
        {{id=7,priority=false,min=90},{id=8,priority=false,min=130},{id=9,priority=true,min=270},{id=10,priority=true,min=450},{id=011,priority=true,min=900}},
        {{id=190,priority=false,min=100},{id=191,priority=false,min=300},{id=192,priority=false,min=600},{id=193,priority=true,min=700},{id=311,priority=true,min=1000}},
        {{id=195,priority=false,min=130},{id=262,priority=true,min=270}},
        {{id=578,priority=false,min=120},{id=593,priority=false,min=250},{id=658,priority=true,min=350}},
        {{id=581,priority=false,min=60},{id=690,priority=true,min=450}},
        
    }

    -- Public Variables.
    self.mode = self.settings.mode or 0

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
    
    -- Public Functions.
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

                            if #weights[player.main_job_id][cure.id] > 100 then
                                table.remove(weights[player.main_job_id][id], 1)
                            end

                        elseif not weights[player.main_job_id][cure.id] then
                            weights[player.main_job_id][cure.id] = {}

                            if amount >= info.min then
                                table.insert(weights[player.main_job_id][cure.id], amount)
                            else
                                table.insert(weights[player.main_job_id][cure.id], info.min)                            
                            end

                            if #weights[player.main_job_id][cure.id] > 100 then
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

                            if #self.weights[player.main_job_id][cure.id] > 100 then
                                table.remove(weights[player.main_job_id][id], 1)
                            end

                        elseif not self.weights[player.main_job_id][cure.id] then
                            self.weights[player.main_job_id][cure.id] = {}

                            if amount >= info.min then
                                table.insert(self.weights[player.main_job_id][cure.id], amount)
                            else
                                table.insert(self.weights[player.main_job_id][cure.id], info.min)                            
                            end

                            if #self.weights[player.main_job_id][cure.id] > 100 then
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
    
    return self

end
return cures.new()