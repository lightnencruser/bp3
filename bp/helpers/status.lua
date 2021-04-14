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
    self.layout     = self.settings.layout or {pos={x=500, y=350}, colors={text={alpha=255, r=245, g=200, b=20}, bg={alpha=200, r=0, g=0, b=0}, stroke={alpha=255, r=0, g=0, b=0}}, font={name='Lucida Console', size=8}, padding=2, stroke_width=1, draggable=false}
    self.display    = texts.new('', {flags={draggable=self.layout.draggable}})
    self.important  = string.format('%s,%s,%s', 25, 165, 200)
    self.priority   = string.format('%s,%s,%s', 215, 0, 255)

    -- Public Variables.
    self.statuses   = {}    

    -- Private Variables.
    local timer     = {last=0, delay=2}
    local icons     = Q{}
    local map       = {'Gained','Lost','Failed'}
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
        {7},
        {259,253,471,463,98},
        {0},
        {0},
    
    }
    local messages  = {
        
        {82,127,128,141,166,186,194,203,205,230,236,237,242,243,266,267,268,269,270,271,272,277,278,279,280,319,320,321,412,453,645,754,755,804},
        {7,64,83,123,159,168,204,206,263,322,341,342,343,344,350,378,531,647,805,806},
        {75,48},

    }
        

    -- Private Functions
    local persist = function()
        local next = next

        if self.settings then
            self.settings.layout  = self.layout

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
        self.statuses = {}
        self.writeSettings()

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
        
        if bp and player and T(self.statuses):length() > 0 and (player.main_job == 'WHM' or player.sub_job == 'WHM') then
            local update = {}

            for i,v in pairs(self.statuses) do
                local s = {}

                if v.statuses then

                    for _,vv in ipairs(v.statuses) do

                        if bp.res.buffs[vv] and bp.res.buffs[vv].en ~= 'Doom' then
                            table.insert(s, string.format('%s', bp.res.buffs[vv].en:sub(1,5)))

                        elseif bp.res.buffs[vv] and bp.res.buffs[vv].en == 'Doom' then
                            table.insert(s, string.format(' \\cs(%s)%s\\cr', self.priority, bp.res.buffs[vv].en:sub(1,5)))

                        end

                    end
                    table.insert(update, string.format(' %s:%s[ \\cs(%s)%s\\cr ]', v.name:upper(), (''):rpad(' ', (15-v.name:len())), self.important, table.concat(s, ', '):upper()))

                end

            end
            self.display:text(table.concat(update, '\n'))            
            self.display:update()

            if not self.display:visible() then
                self.display:show()
            end

        elseif bp and T(self.statuses):length() <= 0 then

            if self.display:visible() then
                self.display:hide()
            end

        end

    end

    self.catchStatus = function(bp, data)
        local bp    = bp or false
        local data  = data or false

        if bp and data then
            local packed    = bp.packets.parse('incoming', data)
            local helpers   = bp.helpers

            if packed then
                local actor     = windower.ffxi.get_mob_by_id(packed["Actor"])
                local target    = windower.ffxi.get_mob_by_id(packed["Target 1 ID"])
                local targets   = packed["Target Count"]
                local category  = packed["Category"]
                local param     = packed["Param"]

                if actor and target and helpers['party'].isInParty(bp, target, true) then
                    
                    -- Melee Attacks.
                    if category == 1 then
                        local spell = param
                        
                        for i=1, targets do
                            local target  = windower.ffxi.get_mob_by_id(packed[string.format("Target %s ID", i)])
                            local param   = string.format("Target %s Action 1 Param", i)
                            local message = string.format("Target %s Action 1 Message", i)

                            if packed[message] and packed[param] then
                                local event = self.getEvent(bp, packed[message])

                                if map[event] == 'Gained' then
                                    self.handleStatus(bp, actor, target, packed[param], spell, self.getCategory(bp, packed[param]), false)

                                elseif map[event] == 'Lost' then
                                    self.handleStatus(bp, actor, target, packed[param], spell, self.getCategory(bp, packed[param]), true)

                                elseif map[event] == 'Failed' then
                                    self.handleStatus(bp, actor, target, packed[param], spell, self.getCategory(bp, packed[param]), true)
                                        
                                end

                            end

                        end

                    -- Ranged Attacks.
                    elseif category == 2 then
                        local spell = param
                        
                        for i=1, targets do
                            local target  = windower.ffxi.get_mob_by_id(packed[string.format("Target %s ID", i)])
                            local param   = string.format("Target %s Action 1 Param", i)
                            local message = string.format("Target %s Action 1 Message", i)

                            if packed[message] and packed[param] then
                                local event = self.getEvent(bp, packed[message])

                                if map[event] == 'Gained' then
                                    self.handleStatus(bp, actor, target, packed[param], spell, self.getCategory(bp, packed[param]), false)

                                elseif map[event] == 'Lost' then
                                    self.handleStatus(bp, actor, target, packed[param], spell, self.getCategory(bp, packed[param]), true)

                                elseif map[event] == 'Failed' then
                                    self.handleStatus(bp, actor, target, packed[param], spell, self.getCategory(bp, packed[param]), true)
                                        
                                end

                            end

                        end

                    -- Finish Weaponskill.
                    elseif category == 3 then
                        local spell = param
                        
                        for i=1, targets do
                            local target  = windower.ffxi.get_mob_by_id(packed[string.format("Target %s ID", i)])
                            local param   = string.format("Target %s Action 1 Param", i)
                            local message = string.format("Target %s Action 1 Message", i)

                            if packed[message] and packed[param] then
                                local event = self.getEvent(bp, packed[message])

                                if map[event] == 'Gained' then
                                    self.handleStatus(bp, actor, target, packed[param], spell, self.getCategory(bp, packed[param]), false)

                                elseif map[event] == 'Lost' then
                                    self.handleStatus(bp, actor, target, packed[param], spell, self.getCategory(bp, packed[param]), true)

                                elseif map[event] == 'Failed' then
                                    self.handleStatus(bp, actor, target, packed[param], spell, self.getCategory(bp, packed[param]), true)
                                        
                                end

                            end

                        end

                    -- Finish Spell Casting.
                    elseif category == 4 then
                        local spell = param
                        
                        for i=1, targets do
                            local target  = windower.ffxi.get_mob_by_id(packed[string.format("Target %s ID", i)])
                            local param   = string.format("Target %s Action 1 Param", i)
                            local message = string.format("Target %s Action 1 Message", i)
                            
                            if packed[message] and packed[param] then
                                local event = self.getEvent(bp, packed[message])
                                
                                if map[event] == 'Gained' then
                                    self.handleStatus(bp, actor, target, packed[param], spell, self.getCategory(bp, packed[param]), false)

                                elseif map[event] == 'Lost' then
                                    self.handleStatus(bp, actor, target, packed[param], spell, self.getCategory(bp, packed[param]), true)

                                elseif map[event] == 'Failed' then
                                    self.handleStatus(bp, actor, target, packed[param], spell, self.getCategory(bp, packed[param]), true)
                                        
                                end

                            end

                        end

                    -- Use a Job Ability.
                    elseif category == 6 then
                        local spell = param
                        
                        for i=1, targets do
                            local target  = windower.ffxi.get_mob_by_id(packed[string.format("Target %s ID", i)])
                            local param   = string.format("Target %s Action 1 Param", i)
                            local message = string.format("Target %s Action 1 Message", i)
                            
                            if packed[message] and packed[param] then
                                local event = self.getEvent(bp, packed[message])

                                if map[event] == 'Gained' then
                                    self.handleStatus(bp, actor, target, packed[param], spell, self.getCategory(bp, packed[param]), false)

                                elseif map[event] == 'Lost' then
                                    self.handleStatus(bp, actor, target, packed[param], spell, self.getCategory(bp, packed[param]), true)

                                elseif map[event] == 'Failed' then
                                    self.handleStatus(bp, actor, target, packed[param], spell, self.getCategory(bp, packed[param]), true)
                                        
                                end

                            end

                        end

                    -- Use a Weaponskill.
                    elseif category == 7 then
                        local spell = param
                            
                        for i=1, targets do
                            local target  = windower.ffxi.get_mob_by_id(packed[string.format("Target %s ID", i)])
                            local param   = string.format("Target %s Action 1 Param", i)
                            local message = string.format("Target %s Action 1 Message", i)
                                
                            if packed[message] and packed[param] then
                                local event = self.getEvent(bp, packed[message])

                                if map[event] == 'Gained' then
                                    self.handleStatus(bp, actor, target, packed[param], spell, self.getCategory(bp, packed[param]), false)

                                elseif map[event] == 'Lost' then
                                    self.handleStatus(bp, actor, target, packed[param], spell, self.getCategory(bp, packed[param]), true)

                                elseif map[event] == 'Failed' then
                                    self.handleStatus(bp, actor, target, packed[param], spell, self.getCategory(bp, packed[param]), true)
                                        
                                end

                            end

                        end

                    -- NPC TP Move.
                    elseif category == 11 then
                        local spell = param
                        
                        for i=1, targets do
                            local target  = windower.ffxi.get_mob_by_id(packed[string.format("Target %s ID", i)])
                            local param   = string.format("Target %s Action 1 Param", i)
                            local message = string.format("Target %s Action 1 Message", i)
                                
                            if packed[message] and packed[param] then
                                local event = self.getEvent(bp, packed[message])

                                if map[event] == 'Gained' then
                                    self.handleStatus(bp, actor, target, packed[param], spell, self.getCategory(bp, packed[param]), false)

                                elseif map[event] == 'Lost' then
                                    self.handleStatus(bp, actor, target, packed[param], spell, self.getCategory(bp, packed[param]), true)

                                elseif map[event] == 'Failed' then
                                    self.handleStatus(bp, actor, target, packed[param], spell, self.getCategory(bp, packed[param]), true)
                                        
                                end

                            end

                        end

                    -- Finish a Pet Move.
                    elseif category == 13 then
                        local spell = param
                            
                        for i=1, targets do
                            local target  = windower.ffxi.get_mob_by_id(packed[string.format("Target %s ID", i)])
                            local param   = string.format("Target %s Action 1 Param", i)
                            local message = string.format("Target %s Action 1 Message", i)
                                
                            if packed[message] and packed[param] then
                                local event = self.getEvent(bp, packed[message])

                                if map[event] == 'Gained' then
                                    self.handleStatus(bp, actor, target, packed[param], spell, self.getCategory(bp, packed[param]), false)

                                elseif map[event] == 'Lost' then
                                    self.handleStatus(bp, actor, target, packed[param], spell, self.getCategory(bp, packed[param]), true)

                                elseif map[event] == 'Failed' then
                                    self.handleStatus(bp, actor, target, packed[param], spell, self.getCategory(bp, packed[param]), true)
                                        
                                end

                            end

                        end

                    -- DNC Abilities.
                    elseif category == 14 then
                        local spell = param
                            
                        for i=1, targets do
                            local target  = windower.ffxi.get_mob_by_id(packed[string.format("Target %s ID", i)])
                            local param   = string.format("Target %s Action 1 Param", i)
                            local message = string.format("Target %s Action 1 Message", i)
                                
                            if packed[message] and packed[param] then
                                local event = self.getEvent(bp, packed[message])

                                if map[event] == 'Gained' then
                                    self.handleStatus(bp, actor, target, packed[param], spell, self.getCategory(bp, packed[param]), false)

                                elseif map[event] == 'Lost' then
                                    self.handleStatus(bp, actor, target, packed[param], spell, self.getCategory(bp, packed[param]), true)

                                elseif map[event] == 'Failed' then
                                    self.handleStatus(bp, actor, target, packed[param], spell, self.getCategory(bp, packed[param]), true)
                                        
                                end

                            end

                        end

                    -- RUN Abilities.
                    elseif category == 15 then
                        local spell = param
                            
                        for i=1, targets do
                            local target  = windower.ffxi.get_mob_by_id(packed[string.format("Target %s ID", i)])
                            local param   = string.format("Target %s Action 1 Param", i)
                            local message = string.format("Target %s Action 1 Message", i)
                                
                            if packed[message] and packed[param] then
                                local event = self.getEvent(bp, packed[message])

                                if map[event] == 'Gained' then
                                    self.handleStatus(bp, actor, target, packed[param], spell, self.getCategory(bp, packed[param]), false)

                                elseif map[event] == 'Lost' then
                                    self.handleStatus(bp, actor, target, packed[param], spell, self.getCategory(bp, packed[param]), true)

                                elseif map[event] == 'Failed' then
                                    self.handleStatus(bp, actor, target, packed[param], spell, self.getCategory(bp, packed[param]), true)
                                        
                                end

                            end

                        end

                    end

                end

            end

        end

    end

    self.handleStatus = function(bp, actor, target, buff, spell, category, lost)
        local bp        = bp or false
        local actor     = actor or false
        local target    = target or false
        local buff      = buff or false
        local spell     = spell or false
        local category  = category or false
        local lost      = lost or false
        
        if bp and actor and target and category and buff then
            local player = windower.ffxi.get_player()
            
            if not lost and buff and removal[category] and buff ~= 255 then
                local remove = removal[category]
                local target = windower.ffxi.get_mob_by_id(target.id) or false

                if target and target.status ~= 2 and target.status ~= 3 and ((target.distance):sqrt() < 35 or (target.distance):sqrt() == 0 and target.id == player.id) then

                    -- Na.
                    if category == 1 then
                        self.add(bp, target, buff)

                    -- Erase.
                    elseif category == 2 then
                        
                        if bp.helpers['party'].isInParty(bp, target, false) then
                            self.add(bp, target, buff)
                        end

                    -- Healing Waltz.
                    elseif category == 3 then

                        if bp.helpers['party'].isInParty(bp, target, false) then
                            self.add(bp, target, buff)
                        end

                    -- Wake.
                    elseif category == 4 then

                        if bp.helpers['party'].isInParty(bp, target, false) then
                            self.add(bp, target, buff)
                        end

                    -- Sleep.
                    elseif category == 5 then

                        if bp.helpers['party'].isInParty(bp, target, true) then
                            self.add(bp, target, buff)
                        end

                    -- Misery.
                    elseif category == 6 then

                        if bp.helpers['party'].isInParty(bp, target, false) then
                            self.add(bp, target, buff)
                        end

                    -- Kill Player.
                    elseif category == 7 then

                        if bp.helpers['party'].isInParty(bp, target, true) then
                            self.add(bp, target, buff)
                        end

                    end

                else
                    local remove = removal[category]
                
                    if T{1,2,3,4,5,6,7}:contains(category) then
                        self.remove(bp, target, buff)
                    end

                end

            elseif lost and buff and removal[category] and buff ~= 255 then
                local remove = removal[category]
                
                if T{1,2,3,4,5,6,7}:contains(category) then
                    self.remove(bp, target, buff)
                end

            end

        elseif bp and actor and target and not category and buff and spell then
            local buff = self.getBuffBySpell(bp, spell)
            
            if buff and buff ~= spell and self.statuses[target.id] then
                
                for _,v in ipairs(self.statuses[target.id].statuses) do

                    if T(na):contains(v) then
                        self.remove(bp, target, v)
                    end

                end

            elseif buff and buff == spell then
                
                if T(removal[2]):contains(spell) and self.statuses[target.id] then

                    for _,v in ipairs(self.statuses[target.id].statuses) do

                        if T(erase):contains(v) then
                            self.remove(bp, target, v)
                        end

                    end

                elseif T(removal[3]):contains(spell) and self.statuses[target.id] then

                    for _,v in ipairs(self.statuses[target.id].statuses) do

                        if T(waltz):contains(v) then
                            self.remove(bp, target, v)
                        end

                    end

                elseif T(removal[4]):contains(spell) and self.statuses[target.id] then
                    local party = bp.helpers['party'].getMembers(bp, false)

                    for _,v in ipairs(self.statuses[target.id].statuses) do
                        
                        if T(wake):contains(v) then
                            self.remove(bp, target, v)
                        end
                        
                    end

                elseif T(removal[5]):contains(spell) and self.statuses[target.id] then

                    for _,v in ipairs(self.statuses[target.id].statuses) do

                        if T(sleep):contains(v) then
                            self.remove(bp, target, v)
                        end

                    end

                elseif T(removal[6]):contains(spell) and self.statuses[target.id] then

                    for _,v in ipairs(self.statuses[target.id].statuses) do

                        if T(misery):contains(v) then
                            self.remove(bp, target, v)
                        end

                    end

                elseif T(removal[7]):contains(spell) and self.statuses[target.id] then

                    for _,v in ipairs(self.statuses[target.id].statuses) do

                        if T(kill):contains(v) then
                            self.remove(bp, target, v)
                        end

                    end

                end

            end

        end

    end

    self.lostStatus = function(bp, data)
        local bp    = bp or false
        local data  = data or false

        if bp and data then
            local packed    = bp.packets.parse('incoming', data)
            local actor     = windower.ffxi.get_mob_by_id(packed['Actor'])
            local target    = windower.ffxi.get_mob_by_id(packed['Target'])

            if packed and actor and target and actor.id == target.id then
                local buff      = packed['Param 1']
                local message   = packed['Message']
                
                if buff and message then
                    local event = self.getEvent(bp, message)

                    if map[event] == 'Lost' then
                        self.handleStatus(bp, actor, target, buff, false, self.getCategory(bp, buff), true)

                    elseif map[event] == 'Failed' then
                        self.handleStatus(bp, actor, target, buff, false, self.getCategory(bp, buff), true)
                            
                    end

                end

            end

        end

    end

    self.fixStatus = function(bp)
        local bp    = bp or false
        local s     = T(self.statuses)

        if bp and s and s:length() > 0 then

            for i,v in pairs(s) do
                
                if v and v.statuses then

                    for _,buff in ipairs(v.statuses) do
                        local category  = self.getCategory(bp, buff)
                        local remove    = removal[category]
                        
                        if category and remove then
                            local player    = windower.ffxi.get_player()
                            local target    = windower.ffxi.get_mob_by_id(v.id)
                            local spell     = bp.res.spells[remove[buff]]
                            local priority  = T{'Cursna'}
                            local dead      = T{2,3}

                            if target and not dead:contains(target.status) then
                            
                                if spell and remove[buff] and target and not bp.helpers['queue'].inQueue(bp, spell, target) and not priority:contains(spell.en) and (player.main_job == 'WHM' or player.sub_job == 'WHM') then
                                    bp.helpers['queue'].add(bp, spell, target)

                                elseif spell and remove[buff] and target and not bp.helpers['queue'].inQueue(bp, spell, target) and priority:contains(spell.en) and (player.main_job == 'WHM' or player.sub_job == 'WHM') then
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

                                elseif category and not remove[buff] and category == 4 and (player.main_job == 'WHM' or player.sub_job == 'WHM') then
                                    local spell = bp.res.spells[remove[1]]

                                    if spell and target and not bp.helpers['queue'].inQueue(bp, spell, target) then
                                        bp.helpers['queue'].add(bp, spell, target)
                                    end

                                elseif category and not remove[buff] and category == 5 then
                                            
                                    for _,spell in ipairs(remove) do

                                        if bp.res.spells[spell] then
                                            local spell = bp.res.spells[spell]

                                            if spell and target and not bp.helpers['queue'].inQueue(bp, spell, target) then
                                                bp.helpers['queue'].addToFront(bp, spell, target)
                                                break
                                            end

                                        end
                                                
                                    end

                                end

                            elseif target and dead:contains(target.status) then
                                self.statuses[i] = {}

                            end

                        end

                    end

                end

            end

        end

    end

    self.build = function(bp, data)
        local bp    = bp or false
        local data  = data or false

        if bp and data then
            local packed = bp.packets.parse('incoming', data)

            if packed and packed['ID'] then

                if (os.clock()-timer.last) >= timer.delay then
                    self.statuses = {}
                    coroutine.sleep(1)
                end

                if bp.helpers['party'].findByName(bp, packed['Name'], true) and packed['Index'] ~= 0 then
                    self.statuses[packed['ID']] = {name=packed['Name'], id=packed['ID'], statuses={}}
                    timer.last = os.clock()

                end

            end

        end

    end

    self.add = function(bp, target, buff)
        local bp        = bp or false
        local target    = target or false
        local buff      = buff or false
        
        if bp and target and buff then
            local s = T(self.statuses) 
            
            if s and s:length() > 0 and not self.hasStatus(bp, target, buff) and s[target.id] and s[target.id].statuses then
                table.insert(s[target.id].statuses, buff)
            
            elseif s and s:length() == 0 and target and target.name and target.id then
                s[target.id] = {}

                do  -- Insert new table for player.
                    s[target.id] = {name=target.name, id=target.id, statuses={buff}}
                end

            end
            
        end
        
    end

    self.remove = function(bp, target, buff)
        local bp        = bp or false
        local target    = target or false
        local buff      = buff or false
        
        if bp and target and buff then
            local t = T(self.statuses)

            if t:length() > 0 and t[target.id] then
                local s = T(t[target.id].statuses)
                
                if s and (s):contains(buff) then
                    
                    for i, status in ipairs(s) do
                        
                        if status == buff then
                            table.remove(s, i)
                            break

                        end

                    end

                end

            end
            
        end

    end

    self.hasStatus = function(bp, target, buff)
        local bp        = bp or false
        local target    = target or false
        local buff      = buff or false

        if bp and target and buff then
            local t = T(self.statuses)

            if t:length() > 0 and t[target.id] then
                local s = T(t[target.id].statuses)

                if s and (s):contains(buff) then
                    return true
                end

            end

        end
        return false

    end


    self.getEvent = function(bp, message)
        local bp        = bp or false
        local message   = message or false

        if bp and message then

            for event,list in ipairs(messages) do
                
                if type(list) == 'table' then

                    for _,id in ipairs(list) do
                        
                        if message == id then
                            return event
                        end

                    end

                end

            end

        end
        return false

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

    self.getBuffBySpell = function(bp, spell)
        local bp    = bp or false
        local spell = spell or false
        
        if spell then
            
            for i,v in pairs(removal[1]) do
                
                if v == spell then
                    return i
                end
                
            end
            
            for _,v in ipairs(removal[2]) do
                
                if v == spell then
                    return v
                end
                
            end
            
            for _,v in ipairs(removal[3]) do
                
                if v == spell then
                    return v
                end
                
            end
            
            for _,v in ipairs(removal[4]) do
                
                if v == spell then
                    return v
                end
                
            end
            
            for _,v in ipairs(removal[5]) do
                
                if v == spell then
                    return v
                end
                
            end
            
            for _,v in ipairs(removal[6]) do
                
                if v == spell then
                    return v
                end
                
            end
            
            for _,v in ipairs(removal[7]) do
                
                if v == spell then
                    return v
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
