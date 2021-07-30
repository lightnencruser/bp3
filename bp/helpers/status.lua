local status    = {}
local player    = windower.ffxi.get_player()
local files     = require('files')
local texts     = require('texts')
local images    = require('images')
local f = files.new(string.format('bp/helpers/settings/status/%s_settings.lua', player.name))
require('queues')
require('tables')

if not f:exists() then
  f:write(string.format('return %s', T({}):tovstring()))
end

function status.new()
    local self = {}

    -- Static Variables.
    self.settings   = dofile(string.format('%sbp/helpers/settings/status/%s_settings.lua', windower.addon_path, player.name))
    self.layout     = self.settings.layout or {pos={x=100, y=100}, colors={text={alpha=255, r=100, g=215, b=0}, bg={alpha=0, r=0, g=0, b=0}, stroke={alpha=255, r=0, g=25, b=15}}, font={name='Lucida Console', size=10}, padding=2, stroke_width=2, draggable=false}
    self.display    = texts.new('', {flags={draggable=self.layout.draggable}})
    self.important  = string.format('%s,%s,%s', 25, 165, 200)
    self.priority   = string.format('%s,%s,%s', 215, 0, 255)

    -- Public Variables.
    self.statuses   = {}

    -- Private Variables.
    local debug     = {}
    local timer     = {last=0, delay=2}
    local watching  = {1,2,3,4,5,6,7,8,9,10,11,14,15,16,17,18,19,20,23,24,25,26,27,33,34,35,36,37,56,58,59,79,80,98,143,220,221,222,223,224,225,226,227,228,229,230,231,232,233,234,235,236,237,238,239,240,253,254,255,256,257,258,259,273,274,276,286,341,342,343,344,345,346,347,348,349,350,351,352,356,357,359,361,362,363,364,365,366,368,369,370,371,372,373,374,375,376,377,421,422}
    local na        = {3,4,5,6,7,8,9,15,20,566}
    local erase     = {11,12,13,21,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,144,145,146,147,148,149,167,174,175,186,192,194,217,223,404,557,558,559,560,561,562,563,564,567,572}
    local waltz     = {11,12,13,21,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,144,145,146,147,148,149,174,175,186,404,557,558,559,560,561,562,563,564,567,572}
    local wake      = {2,19,193}
    local sleep     = {14,17}
    local misery    = {}
    local kill      = {14,17}
    local removal = {
        
        {[3]=14,[4]=15,[5]=16,[6]=17,[7]=18,[8]=19,[9]=20,[15]=20,[20]=20,[31]=19,[566]=15},
        {143},
        {194},
        {1,2,3,4,5,6,7,8,9,10,11},
        {259,253,471,463,98},
        {0},
        {0},
    
    }
    local messages  = {
        
        {82,127,128,141,160,164,166,186,194,203,205,230,236,237,242,243,266,267,268,269,270,271,272,277,278,279,280,319,320,321,412,453,645,754,755,804},
        {7,64,83,123,159,168,204,206,263,322,341,342,343,344,350,378,531,647,805,806},
        {75,48},
        {2},

    }
        
    -- Build Party Data.
    for i,v in pairs(windower.ffxi.get_party()) do

        if (i:sub(1,1) == "p" or i:sub(1,1) == "a") and tonumber(i:sub(2)) ~= nil then

            if v.mob and ((v.mob.distance):sqrt() < 50 or (v.mob.distance):sqrt() > 0) then
                table.insert(self.statuses, {name=v.mob.name, id=v.mob.id, list={}})
            end

        end

    end

    -- Private Functions
    local persist = function()
        local next = next

        if self.settings then
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

    self.zoneChange = function()
        self.writeSettings()

        coroutine.schedule(function()
            self.statuses = {}

            for i,v in pairs(windower.ffxi.get_party()) do

                if (i:sub(1,1) == "p" or i:sub(1,1) == "a") and tonumber(i:sub(2)) ~= nil then
        
                    if v.mob then
                        table.insert(self.statuses, {name=v.mob.name, id=v.mob.id, list={}})
                    end
        
                end
        
            end
        
        end, 15)

    end

    self.jobChange = function()
        self.statuses = {}
        self.writeSettings()
        persist()
        resetDisplay()

    end

    -- Public Functions.
    self.render = function(bp)
        local bp        = bp or false
        local player    = windower.ffxi.get_player()
        local statuses  = self.statuses
        
        if #statuses > 0 and (player.main_job == 'WHM' or player.sub_job == 'WHM') then
            local update = {'-- STATUS EFFECTS --\n'}

            for i=1, #statuses do
                local player = statuses[i] or false

                if player and windower.ffxi.get_mob_by_id(statuses[i].id) then
                    local player    = windower.ffxi.get_mob_by_id(statuses[i].id)
                    local effects   = {}

                    if statuses[i].list and #statuses[i].list > 0 then

                        for _,v in ipairs(statuses[i].list) do
                            local buff = bp.res.buffs[v] or false
                                
                            if buff then
                                table.insert(effects, string.format('%s%s', buff.name:sub(1,1):upper(), buff.name:sub(2)))
                            end

                        end
                        table.insert(update, string.format('%s\\cs(%s)%s[ %s ]\\cr', windower.ffxi.get_mob_by_id(statuses[i].id).name, self.important, (' '):rpad(' ', 25-tostring(player.name):len()), table.concat(effects, ' ')))

                    else
                        table.insert(update, string.format('%s\\cs(%s)%s[  ]\\cr', windower.ffxi.get_mob_by_id(statuses[i].id).name, self.important, (' '):rpad(' ', 25-tostring(player.name):len())))

                    end

                end

            end
            self.display:text(table.concat(update, '\n'))
            self.display:update()

            if not self.display:visible() then
                self.display:show()
            end

        elseif #statuses < 1 then

            if self.display:visible() then
                self.display:hide()
            end

        end

    end

    self.catchStatus = function(bp, data)
        local bp        = bp or false
        local data      = data or false
        local player    = windower.ffxi.get_player()

        if bp and data and (player.main_job == 'WHM' or player.sub_job == 'WHM') then
            local packed    = bp.packets.parse('incoming', data)
            local helpers   = bp.helpers

            if packed then
                local actor     = windower.ffxi.get_mob_by_id(packed["Actor"])
                local target    = windower.ffxi.get_mob_by_id(packed["Target 1 ID"])
                local targets   = packed["Target Count"]
                local category  = packed["Category"]
                local param     = packed["Param"]

                if actor and target and helpers['party'].isInParty(bp, target, true) then
                    local spell = param
                        
                    for i=1, targets do
                        local target  = windower.ffxi.get_mob_by_id(packed[string.format("Target %s ID", i)])
                        local param   = string.format("Target %s Action 1 Param", i)
                        local message = string.format("Target %s Action 1 Message", i)
                        
                        if packed[message] and bp.helpers['party'].isInParty(bp, target, false) and T(watching):contains(spell) then
                            self.handleStatus(bp, actor, target, spell, packed[param], packed[message])
                        end

                    end

                end

            end

        end

    end

    self.handleStatus = function(bp, actor, target, spell, buff, message)
        local player    = windower.ffxi.get_player()
        local bp        = bp or false

        if bp and player and actor and target and spell and message then
            debug.message = false
            
            -- Gained a status effect.
            if T(messages[1]):contains(message) then

                if buff then
                    self.add(bp, target, buff)
                end

            -- Lost a status effect.
            elseif T(messages[2]):contains(message) then

                if buff then

                    if T{1,2,3,4,5,6,7,8,9,10,11}:contains(spell) and message == 7 then

                        for i=1, #self.statuses do
                            local player = self.statuses[i] or false
        
                            if player and player.list and target.id == player.id then

                                for _,debuff in ipairs(player.list) do

                                    if T{2,19}:contains(debuff) then
                                        self.remove(bp, target, debuff)

                                        if actor.id ~= player.id and bp.res.spells[spell] then
                                            bp.helpers['queue'].remove(bp, bp.res.spells[spell], target)
                                        end
                                        break

                                    end

                                end
        
                            end
        
                        end

                    else
                        self.remove(bp, target, debuff)

                        if actor.id ~= player.id and bp.res.spells[spell] then
                            bp.helpers['queue'].remove(bp, bp.res.spells[spell], target)
                        end

                    end
                
                else
                    self.clearStatuses(bp, target)

                end

            -- Spell had no effect.
            elseif T(messages[3]):contains(message) then

                if T{14,15,16,17,18,19,20,143}:contains(spell) then
                    local removals = {[14]={3,540},[15]={4,566},[16]={5},[17]={6},[18]={7},[19]={8,31},[20]={9,15,20,30},[143]={11,12,13,21,128,129,130,131,132,133,134,135,136,137,138,139,140,141,142,144,145,146,147,148,149,174,175,192,194,217,223,565,567,572}}                    

                    if removals[spell] then

                        for i=1, #self.statuses do
                            local player = self.statuses[i] or false
        
                            if player and player.list and target.id == player.id then

                                for _,debuff in ipairs(player.list) do

                                    if T(removals[spell]):contains(debuff) then
                                        self.remove(bp, target, debuff)

                                        if actor.id ~= player.id and bp.res.spells[spell] then
                                            bp.helpers['queue'].remove(bp, bp.res.spells[spell], target)
                                        end
                                        break

                                    end

                                end
        
                            end
        
                        end

                    end

                end

            -- Action has no Buff ID.
            elseif T(messages[4]):contains(message) then
                local special = T{[23]=134,[24]=134,[25]=134,[26]=134,[27]=134,[33]=134,[34]=134,[35]=134,[36]=134,[37]=134,[220]=3,[221]=3,[222]=3,[223]=3,[224]=3,[225]=3,[226]=3,[227]=3,[228]=3,[229]=3,[230]=135,[231]=135,[232]=135,[233]=135,[234]=135}

                if special[spell] then
                    self.add(bp, target, special[spell])
                end

            end

        end       

    end

    self.fixStatus = function(bp)
        local bp = bp or false
        local statuses = self.statuses

        if bp and statuses and #statuses then
            
            for i=1, #statuses do
                
                if statuses[i] and statuses[i].list then
                    
                    for _,buff in ipairs(statuses[i].list) do
                        local category  = self.getCategory(bp, buff)
                        local remove    = removal[category]
                        
                        if category and remove then
                            local player    = windower.ffxi.get_player()
                            local target    = windower.ffxi.get_mob_by_id(statuses[i].id)
                            local spell     = bp.res.spells[remove[buff]]
                            local priority  = T{'Cursna'}
                            local dead      = T{2,3}
                            
                            if target and not dead:contains(target.status) then
                            
                                if spell and category == 1 and remove[buff] and target and not bp.helpers['queue'].inQueue(bp, spell, target) and not priority:contains(spell.en) and (player.main_job == 'WHM' or player.sub_job == 'WHM') then
                                    bp.helpers['queue'].add(bp, spell, target)

                                elseif spell and category == 1 and remove[buff] and target and not bp.helpers['queue'].inQueue(bp, spell, target) and priority:contains(spell.en) and (player.main_job == 'WHM' or player.sub_job == 'WHM') then
                                    bp.helpers['queue'].addToFront(bp, spell, target)

                                elseif category and not remove[buff] and category == 2 and (player.main_job == 'WHM' or player.sub_job == 'WHM') then
                                    local spell = bp.res.spells[remove[1]]

                                    if spell and target and not bp.helpers['queue'].inQueue(bp, spell, target) then
                                        bp.helpers['queue'].add(bp, spell, target)
                                    end

                                elseif category and not remove[buff] and category == 3 and (player.main_job == 'DNC' or player.sub_job == 'DNC') then
                                    local spell = bp.res.job_abilities[remove[1]]

                                    if spell and target and not bp.helpers['queue'].inQueue(bp, spell, target) then
                                        bp.helpers['queue'].add(bp, spell, target)
                                    end

                                -- WAKE FROM SLEEP.
                                elseif category and category == 4 then

                                    if target then

                                        if (player.main_job == 'WHM' or player.sub_job == 'WHM') and bp.helpers['party'].isInParty(bp, target, false) then
                                            local spell = bp.MA['Curaga']

                                            if spell and not bp.helpers['queue'].inQueue(bp, spell) then
                                                bp.helpers['queue'].addToFront(bp, spell, target)
                                            end

                                        elseif bp.helpers['party'].isInParty(bp, target, true) then
                                            local spell = bp.MA['Cure']

                                            if spell and not bp.helpers['queue'].inQueue(bp, spell, target) then
                                                bp.helpers['queue'].addToFront(bp, spell, target)
                                            end

                                        end

                                    end

                                -- SLEEP TARGET!
                                elseif category and not remove[buff] and category == 5 then
                                            
                                    for _,spell in ipairs(remove) do

                                        if bp.res.spells[spell] then
                                            local spell = bp.res.spells[spell]

                                            if spell and target and not bp.helpers['queue'].inQueue(bp, spell) then
                                                bp.helpers['queue'].addToFront(bp, spell, target)
                                                break
                                            end

                                        end
                                                
                                    end

                                end

                            elseif target and dead:contains(target.status) then
                                self.clearStatuses(bp, target)

                            end

                        end

                    end

                end

            end

        end

    end

    self.getCategory = function(bp, id)
        local bp = bp or false
        local id = id or false
        
        if id then
            
            for _,v in ipairs(na) do
                
                if v == id then
                    return 1
                end
                
            end
            
            for _,v in ipairs(erase) do
                
                if v == id then
                    return 2
                end
                
            end
            
            for _,v in ipairs(waltz) do
                
                if v == id then
                    return 3
                end
                
            end
            
            for _,v in ipairs(wake) do
                
                if v == id then
                    return 4
                end
                
            end
            
            for _,v in ipairs(sleep) do
                
                if v == id then
                    return 5
                end
                
            end
            
            for _,v in ipairs(misery) do
                
                if v == id then
                    return 6
                end
                
            end
            
            for _,v in ipairs(kill) do
                
                if v == id then
                    return 7
                end
                
            end
            
        end
        return false
        
    end

    self.build = function(bp, data)
        local bp    = bp or false
        local data  = data or false
        
        if bp and data then
            local packed = bp.packets.parse('incoming', data)

            if packed then
                
                coroutine.schedule(function()
                    self.statuses = {}

                    for i,v in pairs(windower.ffxi.get_party()) do

                        if (i:sub(1,1) == "p" or i:sub(1,1) == "a") and tonumber(i:sub(2)) ~= nil then
                
                            if v.mob and ((v.mob.distance):sqrt() < 50 or (v.mob.distance):sqrt() > 0) then
                                table.insert(self.statuses, {name=v.mob.name, id=v.mob.id, list={}})
                            end
                
                        end
                
                    end
                    
                end, 2)

            end

        end        

    end

    self.add = function(bp, target, buff)
        local bp        = bp or false
        local buff      = buff or false
        
        if bp and buff then
            local target = bp.convertTarget(target)
            
            if target then
                local statuses = self.statuses
                
                if statuses and not self.hasStatus(bp, target, buff) then
                    
                    for i=1, #statuses do
                        local player = statuses[i]

                        if statuses[i] and statuses[i].id and statuses[i].list and statuses[i].id == target.id then
                            table.insert(statuses[i].list, buff)
                            break

                        end

                    end

                end

            end
            
        end
        
    end

    self.remove = function(bp, target, buff)
        local bp    = bp or false
        local buff  = buff or false
        
        if bp and buff then
            local target    = bp.convertTarget(target) or false
            local statuses  = self.statuses

            if #statuses > 0 and target and target.id then

                for i=1, #statuses do
                    local player = statuses[i] or false
                    
                    if player and player.list and T(player.list):contains(buff) and target.id == player.id then
                        
                        for ii, status in ipairs(statuses[i].list) do
                            
                            if status == buff then
                                table.remove(self.statuses[i].list, ii)
                                break

                            end

                        end

                    end

                end

            end
            
        end

    end

    self.clearStatuses = function(bp, target)
        local bp = bp or false

        if bp then
            local target = bp.convertTarget(target) or false

            for i=1, #self.statuses do
                local player = self.statuses[i] or false

                if player and player.id and target.id and player.id == target.id then
                    self.statuses[i].list = {}
                    break

                end

            end

        end

    end

    self.hasStatus = function(bp, target, buff)
        local bp    = bp or false
        local buff  = buff or false

        if bp and buff then
            local target    = bp.convertTarget(target)
            local statuses  = self.statuses

            if target and statuses and #statuses > 0 and target.id then

                for i=1, #statuses do
                    local player = statuses[i] or false

                    if player and player.id == target.id and T(player.list):contains(buff) then
                        return true
                    end

                end

            end

        end
        return false

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
return status.new()
