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
    self.settings       = dofile(string.format('%sbp/helpers/settings/cures/%s_settings.lua', windower.addon_path, player.name))
    self.layout         = self.settings.layout or {pos={x=1400, y=900}, colors={text={alpha=255, r=245, g=200, b=20}, bg={alpha=200, r=0, g=0, b=0}, stroke={alpha=255, r=0, g=0, b=0}}, font={name='Lucida Console', size=8}, padding=3, stroke_width=1, draggable=true}
    self.display        = texts.new('', {flags={draggable=self.layout.draggable}})
    self.important      = string.format('%s,%s,%s', 25, 165, 200)

    -- Private Variables.
    local bp            = false
    local weights       = self.settings.weights or {}
    local spells        = {1,2,3,4,5,6,7,8,9,10,11}
    local abilities     = {190,191,192,193,311,195,262}
    local jobs          = {3,4,5,7,10,15,19,20,21}
    local modes         = {'OFF','PARTY','ALLIANCE'}
    local timers        = {last=0, delay=3600}
    local store         = 50
    local math          = math
    local needed        = {}
    local priorities    = {}
    local allowed       = {
        
        {{id=1,priority=false,min=65},{id=2,priority=false,min=145},{id=3,priority=false,min=340},{id=4,priority=true,min=640},{id=5,priority=true,min=780},{id=6,priority=true,min=1010}},
        {{id=7,priority=false,min=90},{id=8,priority=false,min=130},{id=9,priority=true,min=270},{id=10,priority=true,min=450},{id=011,priority=true,min=900}},
        {{id=190,priority=false,min=100},{id=191,priority=false,min=300},{id=192,priority=false,min=600},{id=193,priority=true,min=700},{id=311,priority=true,min=1000}},
        {{id=195,priority=false,min=130},{id=262,priority=true,min=270}},
        
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

    self.setPriority = function(target, urgency)
        local bp        = bp or false
        local target    = target or false
        local urgency   = urgency or false

        if bp and target and urgency then

            if tonumber(urgency) ~= nil and tonumber(urgency) >= 0 and tonumber(urgency) <= 100 then
                priorities[target.id] = tonumber(urgency)
                bp.helpers['popchat'].pop(string.format('%s\'s cure priority now set to %d.', target.name, urgency))
                
            else
                bp.helpers['popchat'].pop('PLEASE ENTER A NUMBER BETWEEN 0 & 100!')

            end

        end

    end

    self.getPriority = function(target)
        local target = target or false

        if target then

            if type(target) == 'table' and target.id then
                return priorities[target.id] or 0

            elseif type(target) == 'number' or tonumber(target) ~= nil then
                return priorities[tonumber(target)] or 0

            elseif type(target) == 'string' and tonumber(target) == nil then
                return priorities[windower.ffxi.get_mob_by_name(target).id] or 0

            end

        end
        return 0

    end
    
    -- Public Functions.
    self.setSystem = function(buddypal)
        if buddypal then
            bp = buddypal
        end

    end
    
    self.render = function()
        local bp = bp or false

        if bp and (os.clock()-timers.last) > 15 then
            
            if self.display:visible() then
                local update = {}
                
                for i,v in pairs(weights) do
                    local player    = windower.ffxi.get_player()
                    local jobs      = S{'White Mage','Bard','Geomancer','Paladin','Scholar','Red Mage','Dancer','Summoner'}
                    local job       = bp.res.jobs[player.main_job_id]

                    if job and jobs:contains(job.en) and i == player.main_job_id and weights[job.id] then
                        table.insert(update, "[ Avg. Cure Weights ]\n")

                        for id, spells in pairs(weights[job.id]) do
                            local avg = 0

                            if type(spells) == 'table' then
                                
                                for _, weight in ipairs(spells) do
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

            elseif not self.display:visible() then
                local player    = windower.ffxi.get_player()
                local jobs      = S{'White Mage','Bard','Geomancer','Paladin','Scholar','Red Mage','Dancer','Summoner'}
                local job       = bp.res.jobs[player.main_job_id]

                for i,v in pairs(weights) do
                
                    if job and jobs:contains(job.en) and i == player.main_job_id and weights[job.id] then
                        
                        for id, spells in pairs(weights[job.id]) do
                            
                            if type(spells) == 'table' then
                                self.display:show()
                                break
                            
                            end

                        end

                    end

                end

            end

        end

    end

    self.changeMode = function()
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

    self.off = function()
        local bp = bp or false

        if bp then
            self.mode = 1

            do
                bp.helpers['popchat'].pop(string.format('CURE MODE: %s', modes[self.mode]))
                self.writeSettings()

            end

        end

    end

    self.validSpell = function(id)
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

    self.validAbility = function(id)
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

    self.getCure = function(id)
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

    self.getWeight = function(id)
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
            local spell = self.getCure(id)

            if spell and spell.min then
                return spell.min
            end
            
        end
        
    end
    
    self.estimateCure = function(missing)
        local bp        = bp or false
        local player    = windower.ffxi.get_player()
        local levels    = {main=player.main_job_level, sub=player.sub_job_level}
        local missing   = missing or false
        local spell     = false
        local required
        
        if bp and missing then
            
            for _,v in ipairs({1,2,3,4,5,6}) do
                local weight = self.getWeight(v)
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
    
    self.estimateWaltz = function(missing)
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
                
                if cure and weight and (weight + (weight * (self.power / 100) ) ) <= missing and (levels.main >= required.main or levels.sub >= required.sub) then
                    spell = cure
                end
                
            end
            
        end
        return spell
        
    end
    
    self.estimateCuraga = function(missing, count)
        local bp        = bp or false
        local player    = windower.ffxi.get_player()
        local levels    = {main=player.main_job_level, sub=player.sub_job_level}
        local missing   = missing or false
        local count     = count or false
        local spell     = false
        local required
        
        if bp and missing and count then
            
            for _,v in ipairs({7,8,9,10,11}) do
                local weight = self.getWeight(v)
                local cure   = res.spells[v]

                if cure.levels then
                    required = {main=(cure.levels[player.main_job_id] or 255), sub=(cure.levels[player.sub_job_id] or 255)}
                end

                if cure and weight and (weight + (weight * ((self.power+20) / 100) ) ) <= (missing/count) and (levels.main >= required.main or levels.sub >= required.sub) then
                    spell = cure
                end
                
            end
            
        end
        return spell
        
    end
    
    self.estimateWaltzga = function(missing, count)
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
                
                if cure and weight and (weight + (weight * (self.power / 100) ) ) <= (missing/count) and (levels.main >= required.main or levels.sub >= required.sub) then
                    spell = cure
                end
                
            end
            
        end
        return spell
        
    end

    self.updateWeight = function(data)
        local packets   = packets.parse("incoming", data)
        local id        = packets["Param"] or false
        local targets   = packets["Target Count"] or false
        local amount    = packets["Target 1 Action 1 Param"]
        local bp        = bp or false

        if id and targets and bp and amount then
            local helpers = bp.helpers
            local player  = windower.ffxi.get_player()

            if self.validSpell(id) then
                local cure = res.spells[id] or false
                local info = self.getCure(cure.id)

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

            elseif self.validAbility(id) then
                local cure = res.job_abilities[id] or false
                local info = self.getCure(cure.id)

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

    self.handleCuring = function()
        local bp = bp or false
        
        if bp and self.party and self.alliance and self.mode ~= 1 and bp.helpers['queue'].checkReady(bp) then
            local count     = self.curesNeeded()
            local player    = windower.ffxi.get_player() or false
            local party     = T(self.party)
            local alliance  = T(self.alliance)
            local helpers   = bp.helpers
            local missing   = 0
            
            if self.mode == 2 and count > 0 and player['vitals'].mpp > 5 then

                if count < 3 and (T{'WHM','RDM','SCH','PLD'}:contains(player.main_job) or T{'WHM','RDM','SCH','PLD'}:contains(player.sub_job)) and player.main_job ~= 'DNC' then

                    for _,v in ipairs(party) do
                        local cure   = self.estimateCure(v.missing) or false
                        local target = windower.ffxi.get_mob_by_id(v.id) or false

                        if cure and target and not helpers['queue'].inQueue(bp.MA[cure.en], target) then

                            if (target.distance):sqrt() < 21 and (target.distance):sqrt() ~= 0 then

                                if v.missing > (v.max * 0.08) then

                                    if player.main_job_level == 99 and not T{1,2}:contains(cure.id) then
                                        helpers['queue'].updateCure(cure, target)
        
                                    elseif player.main_job_level < 99 then
                                        helpers['queue'].updateCure(cure, target)
        
                                    end

                                end                                

                            elseif target.name == player.name and (target.distance):sqrt() == 0 then

                                if v.missing > (v.max * 0.08) then

                                    if player.main_job_level == 99 and not T{1,2}:contains(cure.id) then
                                        helpers['queue'].updateCure(cure, target)
        
                                    elseif player.main_job_level < 99 then
                                        helpers['queue'].updateCure(cure, target)
        
                                    end

                                end

                            end

                        end
                        
                    end
                
                elseif count > 2 and (player.main_job == "WHM" or player.sub_job == "WHM") and player.main_job ~= "DNC" then
                    local target = false
                    
                    for _,v in ipairs(party) do
                        local dead = T{2,3}

                        if v and v.missing then
                            
                            if not target then
                                local temp      = windower.ffxi.get_mob_by_id(v.id) or false
                                local priority  = self.getPriority(temp)
                                
                                if temp and priority and not dead:contains(temp.status) then
                                    missing = (missing + v.missing)
                                    target  = {id=temp.id, missing=v.missing, priority=priority, distance=temp.distance}
                                end

                            elseif target then
                                local temp      = windower.ffxi.get_mob_by_id(v.id) or false
                                local priority  = self.getPriority(temp)

                                if target and temp and target.priority and temp.id and not dead:contains(temp.status) and priority >= target.priority then
                                    
                                    if v.missing > target.missing then
                                        
                                        if (target.distance):sqrt() < 21 and ((target.distance):sqrt() ~= 0 or target.name == player.name and (target.distance):sqrt() == 0) then
                                            missing = (missing + v.missing)
                                            target  = {id=temp.id, missing=v.missing, priority=priority, distance=temp.distance}
                                        end

                                    end

                                end

                            end

                        end

                    end

                    if missing > 0 and target and target.id then
                        local target    = windower.ffxi.get_mob_by_id(target.id) or false
                        local cure      = self.estimateCuraga(missing, count) or false
                        
                        if cure and target then
                            
                            if player.main_job_level == 99 and not T{7}:contains(cure.id) then
                                helpers['queue'].updateCure(cure, target)
    
                            elseif player.main_job_level < 99 then
                                helpers['queue'].updateCure(cure, target)
    
                            end
                            
                        end
                        
                    end

                end
            
            elseif self.mode == 3 and count > 0 and player['vitals'].mpp > 5 then

                if count < 3 and (T{'WHM','RDM','SCH','PLD'}:contains(player.main_job) or T{'WHM','RDM','SCH','PLD'}:contains(player.sub_job)) and player.main_job ~= 'DNC' then

                    for _,v in ipairs(party) do
                        local cure   = self.estimateCure(v.missing) or false
                        local target = windower.ffxi.get_mob_by_id(v.id) or false

                        if cure and target and not helpers['queue'].inQueue(bp.MA[cure.en], target) then

                            if (target.distance):sqrt() < 21 and (target.distance):sqrt() ~= 0 then

                                if v.missing > (v.max * 0.08) then

                                    if player.main_job_level == 99 and not T{1,2}:contains(cure.id) then
                                        helpers['queue'].updateCure(cure, target)
        
                                    elseif player.main_job_level < 99 then
                                        helpers['queue'].updateCure(cure, target)
        
                                    end

                                end                                

                            elseif target.name == player.name and (target.distance):sqrt() == 0 then

                                if v.missing > (v.max * 0.08) then

                                    if player.main_job_level == 99 and not T{1,2}:contains(cure.id) then
                                        helpers['queue'].updateCure(cure, target)
        
                                    elseif player.main_job_level < 99 then
                                        helpers['queue'].updateCure(cure, target)
        
                                    end

                                end

                            end

                        end
                        
                    end

                end
                
                if count > 2 and (player.main_job == "WHM" or player.sub_job == "WHM") and player.main_job ~= "DNC" then
                    local target = false
                    
                    for _,v in ipairs(party) do
                        local dead = T{2,3}

                        if v and v.missing then
                            
                            if not target then
                                local temp      = windower.ffxi.get_mob_by_id(v.id) or false
                                local priority  = self.getPriority(temp)
                                
                                if temp and priority and not dead:contains(temp.status) then
                                    missing = (missing + v.missing)
                                    target  = {id=temp.id, missing=v.missing, priority=priority, distance=temp.distance}
                                end

                            elseif target then
                                local temp      = windower.ffxi.get_mob_by_id(v.id) or false
                                local priority  = self.getPriority(temp)

                                if target and temp and target.priority and temp.id and not dead:contains(temp.status) and priority >= target.priority then
                                    
                                    if v.missing > target.missing then
                                        
                                        if (target.distance):sqrt() < 21 and ((target.distance):sqrt() ~= 0 or target.name == player.name and (target.distance):sqrt() == 0) then
                                            missing = (missing + v.missing)
                                            target  = {id=temp.id, missing=v.missing, priority=priority, distance=temp.distance}
                                        end

                                    end

                                end

                            end

                        end

                    end

                    if missing > 0 and target and target.id then
                        local target    = windower.ffxi.get_mob_by_id(target.id) or false
                        local cure      = self.estimateCuraga(missing, count) or false
                        
                        if cure and target then
                            
                            if player.main_job_level == 99 and not T{7}:contains(cure.id) then
                                helpers['queue'].updateCure(cure, target)
    
                            elseif player.main_job_level < 99 then
                                helpers['queue'].updateCure(cure, target)
    
                            end
                            
                        end
                        
                    end
                
                end
            
            end
            
        end
        
    end

    self.pos = function(x, y)
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