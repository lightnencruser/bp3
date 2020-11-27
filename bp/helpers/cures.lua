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
    self.layout     = self.settings.layout or {pos={x=1400, y=900}, colors={text={alpha=255, r=245, g=200, b=20}, bg={alpha=200, r=0, g=0, b=0}, stroke={alpha=255, r=0, g=0, b=0}}, font={name='Lucida Console', size=8}, padding=2, stroke_width=2, draggable=true}
    self.display    = texts.new('', {flags={draggable=self.layout.draggable}})
    self.important  = string.format('%s,%s,%s', 25, 165, 200)

    -- Private Variables.
    local weights   = self.settings.weights or {}
    local spells    = {1,2,3,4,5,6,7,8,9,10,11}
    local abilities = {190,191,192,193,311,195,262}
    local jobs      = {3,4,5,7,10,15,19,20,21}
    local modes     = {'OFF','PARTY','ALLIANCE'}
    local timers    = {last=0, delay=3600}
    local store     = 50
    local math      = math
    local needed    = {}
    local allowed   = {
        
        {{id=1,priority=false,min=65},{id=2,priority=false,min=145},{id=3,priority=false,min=340},{id=4,priority=true,min=640},{id=5,priority=true,min=780},{id=6,priority=true,min=1010}},
        {{id=7,priority=false,min=90},{id=8,priority=false,min=130},{id=9,priority=true,min=270},{id=10,priority=true,min=450},{id=011,priority=true,min=900}},
        {{id=190,priority=false,min=100},{id=191,priority=false,min=300},{id=192,priority=false,min=600},{id=193,priority=true,min=700},{id=311,priority=true,min=1000}},
        {{id=195,priority=false,min=130},{id=262,priority=true,min=270}},
        
    }

    local priority  = {

        ['RUN']=0, ['PLD']=0,
        ['WAR']=1, ['MNK']=1, ['SAM']=1, ['GEO']=1, ['NIN']=1,
        ['DRK']=2, ['THF']=2, ['DNC']=2, ['DRG']=2, ['COR']=2, ['RNG']=2, ['BLU']=2,
        ['BRD']=3, ['RDM']=3, ['PUP']=3, ['BST']=3,
        ['WHM']=4, ['SCH']=4, ['SMN']=4, ['BLM']=4,
    
    }

    -- Public Variables.
    self.mode       = self.settings.mode or 1
    self.power      = self.settings.power or 15
    self.updating   = false
    self.party      = {}
    self.alliance   = {}

    -- Private Functions.
    local persist = function()
        local next = next

        if self.settings then
            self.settings.mode      = self.mode
            self.settings.power     = self.power
            self.settings.weights   = weights
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
        self.display:update()

        if T(jobs):contains(windower.ffxi.get_player().main_job_id) and weights[windower.ffxi.get_player().main_job_id] then
            self.display:show()
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
        persist()
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
                    
            elseif (i:sub(1,1) == "a" or i:sub(1,1) == "p") and type(v) == "table" then
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
        local party     = T(self.party)
        local alliance  = T(self.alliance)
        local count     = 0
        
        if self.mode == 2 then

            for _,v in ipairs(party) do
                local max = v.max

                if v.hpp < 90 and v.hpp ~= 0 then
                    count = (count + 1)
                end
                
            end
            return count

        elseif self.mode == 3 then

            for _,v in ipairs(party:extend(alliance)) do
                local max = v.max

                if v.hpp < 90 and v.hpp ~= 0 then
                    count = (count + 1)
                end
                
            end
            return count

        end
        
    end
    
    -- Public Functions.
    self.render = function(bp)
        local bp = bp or false

        if bp and (os.clock()-timers.last) > 15 then
            
            if self.display:visible() then
                local update = {}
                
                for i,v in pairs(weights) do
                    local job   = bp.res.jobs[i]

                    if (job.en == 'White Mage' or job.en == 'Bard' or job.en == 'Geomancer' or job.en == 'Paladin' or job.en == 'Scholar' or job.en == 'Red Mage' or job.en == 'Blue Mage' or job.en == 'Dancer') then
                        table.insert(update, "[ Avg. Cure Weights ]\n")

                        for id,spells in pairs(weights[job.id]) do
                            local avg = 0

                            if type(spells) == 'table' then
                                
                                for _,weight in ipairs(spells) do
                                    avg = (avg + (weight + (weight * (self.power / 100) ) ))                                    
                                end
                                table.insert(update, string.format('%s\\cs(%s)%s%04d\\cr', bp.res.spells[id].en, self.important, (''):lpad(' ',15-bp.res.spells[id].en:len()), (avg / #spells)))

                            end

                        end

                    end

                end
                self.display:text(table.concat(update, '\n'))
                self.display:update()
                timers.last = os.clock()

            end

        end

    end

    self.changeMode = function(bp)
        local bp = bp or false

        if bp then
            self.mode = (self.mode + 1)
            
            if self.mode > #modes then
                self.mode = 1
            end
            bp.helpers['popchat'].pop(string.format('CURE MODE: %s', modes[self.mode]))
            self.writeSettings()

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
            local spell = self.getCure(bp, id)

            if spell and spell.min then
                return spell.min
            end
            
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
                
                if cure and weight and (weight + (weight * (self.power / 100) ) ) <= missing and (levels.main >= required.main or levels.sub >= required.sub) then
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
                local weight = self.getWeight(bp, v)
                local cure   = res.job_abilities[v]
                
                if cure.levels then
                    required = {main=(cure.levels[player.main_job_id] or 255), sub=(cure.levels[player.sub_job_id] or 255)}
                end
                
                if cure and weight and (weight + (weight * (self.power / 100) ) ) <= missing and (levels.main >= required.main or levels.sub >= required.sub) then
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
            
            for _,v in ipairs({7,8,9,10,11}) do
                local weight = self.getWeight(bp, v)
                local cure   = res.spells[v]

                if cure.levels then
                    required = {main=(cure.levels[player.main_job_id] or 255), sub=(cure.levels[player.sub_job_id] or 255)}
                end
                
                if cure and weight and (weight + (weight * (self.power / 100) ) ) <= (missing/count) and (levels.main >= required.main or levels.sub >= required.sub) then
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
                local weight = self.getWeight(bp, v)
                local cure   = res.job_abilities[v]
                
                if cure.levels then
                    required = {main=(cure.levels[player.main_job_id] or 255), sub=(cure.levels[player.sub_job_id] or 255)}
                end
                
                if cure and weight and (weight + (weight * (self.power / 100) ) ) <= (missing/count) and (levels.main >= required.main or levels.sub >= required.sub) then
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
                            
                            for i,v in pairs(weights[player.main_job_id][cure.id]) do

                                if amount > v then
                                    table.insert(weights[player.main_job_id][cure.id], amount)
                                    break

                                end

                            end

                            if #weights[player.main_job_id][cure.id] > store then
                                table.remove(weights[player.main_job_id][id], 1)
                            end

                        elseif not weights[player.main_job_id][cure.id] then
                            weights[player.main_job_id][cure.id] = {}
                            
                            do -- Insert a new cure weight for the current spell.
                                table.insert(weights[player.main_job_id][cure.id], info.min)
                            end

                        end

                    elseif not weights[player.main_job_id] then
                        weights[player.main_job_id] = {[cure.id] = {}}

                        do -- Insert a new cure weight for the current spell.
                            table.insert(weights[player.main_job_id][cure.id], info.min)
                        end

                    end

                end

            elseif self.validAbility(bp, id) then
                local cure = res.job_abilities[id] or false
                local info = self.getCure(bp, cure.id)

                if cure and info then

                    if weights[player.main_job_id] then

                        if weights[player.main_job_id][cure.id] and #weights[player.main_job_id][cure.id] > 0 then

                            for i,v in pairs(weights[player.main_job_id][cure.id]) do

                                if amount > v then
                                    table.insert(weights[player.main_job_id][cure.id], amount)
                                    break

                                end

                            end

                            if #weights[player.main_job_id][cure.id] > store then
                                table.remove(weights[player.main_job_id][id], 1)
                            end

                        elseif not weights[player.main_job_id][cure.id] then
                            weights[player.main_job_id][cure.id] = {}

                            do -- Insert a new cure weight for the current spell.
                                table.insert(weights[player.main_job_id][cure.id], info.min)
                            end

                        end

                    elseif not weights[player.main_job_id] then
                        weights[player.main_job_id] = {[cure.id] = {}}

                        do -- Insert a new cure weight for the current spell.
                            table.insert(weights[player.main_job_id][cure.id], info.min)
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
            local party     = T(self.party)
            local alliance  = T(self.alliance)
            local helpers   = bp.helpers
            local missing   = 0         
            
            if self.mode == 2 and count > 0 then
                local id = false

                if count < 3 and (player.main_job == "WHM" or player.main_job == "RDM" or player.main_job == "SCH" or player.main_job == "PLD" or player.sub_job == "WHM" or player.sub_job == "RDM" or player.sub_job == "SCH" or player.sub_job == "PLD") and player.main_job ~= "DNC" then
                    
                    for _,v in ipairs(party) do
                        local cure   = self.estimateCure(bp, v.missing) or false
                        local target = windower.ffxi.get_mob_by_id(v.id) or false
                        
                        if cure and target and (target.distance):sqrt() < 21 and ((target.distance):sqrt() ~= 0 or target.name == player.name and (target.distance):sqrt() == 0) then

                            if player.main_job_level == 99 and cure.id ~= 1 and cure.id ~= 2 then
                                helpers['queue'].updateCure(bp, cure, target)

                            elseif player.main_job_level < 99 then
                                helpers['queue'].updateCure(bp, cure, target)

                            end

                        end
                        
                    end
                
                elseif count < 3 and (player.main_job == "DNC" or player.sub_job == "DNC") and player.main_job ~= "WHM" then
                    
                    for _,v in ipairs(party) do
                        local cure   = self.estimateWaltz(bp, v.missing) or false
                        local target = windower.ffxi.get_mob_by_id(v.id) or false
                        
                        if cure and target then
                            
                            if cure and target and (target.distance):sqrt() < 21 and ((target.distance):sqrt() ~= 0 or target.name == player.name and (target.distance):sqrt() == 0) then

                                if player.main_job_level == 99 and cure.id ~= 190 then
                                    helpers['queue'].updateCure(bp, cure, target)
    
                                elseif player.main_job_level < 99 then
                                    helpers['queue'].updateCure(bp, cure, target)
    
                                end

                            end
                            
                        end
                        
                    end
                
                end
                
                if count > 2 and (player.main_job == "WHM" or player.sub_job == "WHM") and player.main_job ~= "DNC" then
                    local target = false
                    
                    -- Build total HP missing.
                    for _,v in ipairs(party) do
                        missing = (missing + v.missing)
                        
                        if not target then
                            local temp = windower.ffxi.get_mob_by_id(v.id) or false
                            local jobs = bp.helpers['party'].jobs
                            
                            if temp and jobs and jobs[temp.id] then
                                target = {id=v.id, missing=v.missing, priority=priority[jobs[temp.id].job]}
                            end

                        elseif target then
                            local temp = windower.ffxi.get_mob_by_id(v.id) or false
                            local jobs = bp.helpers['party'].jobs
                            
                            if temp and target and priority[jobs[temp.id].job] and v.missing > target.missing and priority[jobs[temp.id].job] <= target.priority then
                                target = {id=v.id, missing=v.missing, priority=priority[jobs[temp.id].job]}
                            end

                        end                        

                    end
    
                    if missing > 0 then
                        local target    = windower.ffxi.get_mob_by_id(target.id) or false
                        local cure      = self.estimateCuraga(bp, missing, count) or false
                        
                        if cure and target then
                            
                            if (target.distance):sqrt() < 21 and ((target.distance):sqrt() ~= 0 or target.name == player.name and (target.distance):sqrt() == 0) then
                                
                                if player.main_job_level == 99 and (cure.id ~= 7 or cure.id ~= 8) then
                                    helpers['queue'].updateCure(bp, cure, target)
    
                                elseif player.main_job_level < 99 then
                                    helpers['queue'].updateCure(bp, cure, target)
    
                                end

                            end
                            
                        end
                        
                    end
                
                elseif count > 2 and (player.main_job == "DNC" or player.sub_job == "DNC") and player.main_job ~= "WHM" then
                    local target = false
                    
                    -- Build total HP missing.
                    for _,v in ipairs(party) do
                        missing = (missing + v.missing)
                        
                        if not target then
                            local temp = windower.ffxi.get_mob_by_id(v.id) or false
                            local jobs = bp.helpers['party'].jobs
                            
                            if temp and jobs and jobs[temp.id] then
                                target = {id=v.id, missing=v.missing, priority=priority[jobs[temp.id].job]}
                            end

                        elseif target then
                            local temp = windower.ffxi.get_mob_by_id(v.id) or false
                            local jobs = bp.helpers['party'].jobs
                            
                            if temp and target and priority[jobs[temp.id].job] and v.missing > target.missing and priority[jobs[temp.id].job] <= target.priority then
                                target = {id=v.id, missing=v.missing, priority=priority[jobs[temp.id].job]}
                            end

                        end                        

                    end
    
                    if missing > 0 then
                        local cure   = self.estimateWaltzga(bp, missing, count) or false
                        local target = windower.ffxi.get_mob_by_id(id) or false
                        
                        if cure and target then
                            
                            if cure and target and (target.distance):sqrt() < 21 and ((target.distance):sqrt() ~= 0 or target.name == player.name and (target.distance):sqrt() == 0) then
                                
                                if player.main_job_level == 99 and cure.id ~= 195 then
                                    helpers['queue'].updateCure(bp, cure, target)
    
                                elseif player.main_job_level < 99 then
                                    helpers['queue'].updateCure(bp, cure, target)
    
                                end

                            end
                            
                        end
                        
                    end
                    
                end
            
            elseif self.mode == 3 and count > 0 then
                local missing   = 0
                local id        = false
                
                if count < 3 then
                    
                    for _,v in ipairs(alliance) do
                        local cure   = self.estimateCure(bp, v.missing) or false
                        local target = windower.ffxi.get_mob_by_id(v.id) or false
                        
                        if cure and target then
                            
                            if cure and target and (target.distance):sqrt() < 21 and ((target.distance):sqrt() ~= 0 or target.name == player.name and (target.distance):sqrt() == 0) then
                                
                                if player.main_job_level == 99 and cure.id ~= 1 and cure.id ~= 2 then
                                    helpers['queue'].updateCure(bp, cure, target)
    
                                elseif player.main_job_level < 99 then
                                    helpers['queue'].updateCure(bp, cure, target)
    
                                end

                            end
                            
                        end
                        
                    end
                
                elseif count < 3 and (player.main_job == "DNC" or player.sub_job == "DNC") and player.main_job ~= "WHM" then
                    
                    for _,v in ipairs(alliance) do
                        local cure   = self.estimateWaltz(bp, v.missing) or false
                        local target = windower.ffxi.get_mob_by_id(v.id) or false
                        
                        if cure and target then
                            
                            if cure and target and (target.distance):sqrt() < 21 and ((target.distance):sqrt() ~= 0 or target.name == player.name and (target.distance):sqrt() == 0) then
                                
                                if player.main_job_level == 99 and cure.id ~= 190 then
                                    helpers['queue'].updateCure(bp, cure, target)
    
                                elseif player.main_job_level < 99 then
                                    helpers['queue'].updateCure(bp, cure, target)
    
                                end
                                
                            end
                            
                        end
                        
                    end
                
                end
                
                if count > 2 and (player.main_job == "WHM" or player.sub_job == "WHM") and player.main_job ~= "DNC" then
                    local target = false
                    
                    -- Build total HP missing.
                    for _,v in ipairs(party) do
                        missing = (missing + v.missing)
                        
                        if not target then
                            local temp = windower.ffxi.get_mob_by_id(v.id) or false
                            local jobs = bp.helpers['party'].jobs
                            
                            if temp and jobs and jobs[temp.id] then
                                target = {id=v.id, missing=v.missing, priority=priority[jobs[temp.id].job]}
                            end

                        elseif target then
                            local temp = windower.ffxi.get_mob_by_id(v.id) or false
                            local jobs = bp.helpers['party'].jobs
                            
                            if temp and target and priority[jobs[temp.id].job] and v.missing > target.missing and priority[jobs[temp.id].job] <= target.priority then
                                target = {id=v.id, missing=v.missing, priority=priority[jobs[temp.id].job]}
                            end

                        end                        

                    end
    
                    if missing > 0 then
                        local cure   = self.estimateCuraga(bp, missing, count) or false
                        local target = windower.ffxi.get_mob_by_id(id) or false
                        
                        if cure and target then
                            
                            if cure and target and (target.distance):sqrt() < 21 and ((target.distance):sqrt() ~= 0 or target.name == player.name and (target.distance):sqrt() == 0) then
                                
                                if player.main_job_level == 99 and cure.id ~= 7 and cure.id ~= 8 then
                                    helpers['queue'].updateCure(bp, cure, target)
    
                                elseif player.main_job_level < 99 then
                                    helpers['queue'].updateCure(bp, cure, target)
    
                                end

                            end
                            
                        end
                        
                    end
                
                elseif count > 2 and (player.main_job == "DNC" or player.sub_job == "DNC") and player.main_job ~= "WHM" then
                    local target = false
                    
                    -- Build total HP missing.
                    for _,v in ipairs(party) do
                        missing = (missing + v.missing)
                        
                        if not target then
                            local temp = windower.ffxi.get_mob_by_id(v.id) or false
                            local jobs = bp.helpers['party'].jobs
                            
                            if temp and jobs and jobs[temp.id] then
                                target = {id=v.id, missing=v.missing, priority=priority[jobs[temp.id].job]}
                            end

                        elseif target then
                            local temp = windower.ffxi.get_mob_by_id(v.id) or false
                            local jobs = bp.helpers['party'].jobs
                            
                            if temp and target and priority[jobs[temp.id].job] and v.missing > target.missing and priority[jobs[temp.id].job] <= target.priority then
                                target = {id=v.id, missing=v.missing, priority=priority[jobs[temp.id].job]}
                            end

                        end                        

                    end
    
                    if missing > 0 then
                        local cure   = self.estimateWaltzga(bp, missing, count) or false
                        local target = windower.ffxi.get_mob_by_id(id) or false
                        
                        if cure and target then
                            
                            if cure and target and (target.distance):sqrt() < 21 and ((target.distance):sqrt() ~= 0 or target.name == player.name and (target.distance):sqrt() == 0) then
                                
                                if player.main_job_level == 99 and cure.id ~= 195 then
                                    helpers['queue'].updateCure(bp, cure, target)
    
                                elseif player.main_job_level < 99 then
                                    helpers['queue'].updateCure(bp, cure, target)
    
                                end

                            end
                            
                        end
                        
                    end
                
                end
            
            end
            
        end
        
    end

    self.pos = function(bp, x, y)
        local bp    = bp or false
        local x     = tonumber(x) or self.layout.pos.x
        local y     = tonumber(y) or self.layout.pos.y

        if bp and x and y then
            self.display:pos(x, y)
            self.layout.pos.x = x
            self.layout.pos.y = y
            self.writeSettings()
        
        elseif bp and (not x or not y) then
            bp.helpers['popchat'].pop('PLEASE ENTER AN "X" OR "Y" COORDINATE!')

        end

    end
    
    return self

end
return cures.new()