--// BUBBLE OFFSET BUILDER WRITTEN BY DARKDOOM22: https://github.com/Darkdoom22/BubbleOffset/blob/main/bubbleoffset.lualocal
local bubbles   = {}
local player    = windower.ffxi.get_player()
local files     = require('files')
local texts     = require('texts')
local f = files.new(string.format('bp/helpers/settings/bubbles/%s_settings.lua', player.name))

if not f:exists() then
  f:write(string.format('return %s', T({}):tovstring()))
end

function bubbles.new()
    local self = {}

    -- Static Variables.
    self.allowed    = require('resources').spells:type('Geomancy')
    self.settings   = dofile(string.format('%sbp/helpers/settings/bubbles/%s_settings.lua', windower.addon_path, player.name))
    self.layout     = self.settings.layout or {pos={x=500, y=350}, colors={text={alpha=255, r=245, g=200, b=20}, bg={alpha=200, r=0, g=0, b=0}, stroke={alpha=255, r=0, g=0, b=0}}, font={name='Lucida Console', size=8}, padding=3, stroke_width=1, draggable=true}
    self.display    = texts.new('', {flags={draggable=self.layout.draggable}})
    self.important  = string.format('%s,%s,%s', 25, 165, 200)

    -- Private Variables.
    local bp        = false
    local private   = {events={}}
    local buffs     = {'Ecliptic Attrition', 'Lasting Emanation'}
    local buff      = 2
    local math      = math
    local placement = 1
    local map       = {directions={'East','Southeast','South','Southwest','West','Northwest','North','Northeast'}, placement={'Front','Side'}}
    local short = {
        
        self = {
            
            ["str"]    = "Indi-STR",         ["dex"]     = "Indi-DEX",
            ["agi"]    = "Indi-AGI",         ["int"]     = "Indi-INT",
            ["mnd"]    = "Indi-MND",         ["chr"]     = "Indi-CHR",
            ["vit"]    = "Indi-VIT",         ["refresh"] = "Indi-Refresh",
            ["regen"]  = "Indi-Regen",       ["haste"]   = "Indi-Haste",
            ["eva"]    = "Indi-Voidance",    ["acc"]     = "Indi-Precision",
            ["mev"]    = "Indi-Attunement",  ["macc"]    = "Indi-Focus",
            ["def"]    = "Indi-Barrier",     ["att"]     = "Indi-Fury",
            ["mdb"]    = "Indi-Fend",        ["mab"]     = "Indi-Acumen",
            ["para"]   = "Indi-Paralysis",   ["grav"]    = "Indi-Gravity",
            ["poison"] = "Indi-Poison",      ["Slow"]    = "Indi-Slow",
            ["macc-"]  = "Indi-Vex",         ["eva-"]    = "Indi-Torpor",
            ["acc-"]   = "Indi-Slip",        ["mev-"]    = "Indi-Languor",
            ["def-"]   = "Indi-Frailty",     ["att-"]    = "Indi-Wilt",
            ["mdb-"]   = "Indi-Malaise",     ["mab-"]    = "Indi-Fade",
            
        },

        target = {

            ["str"]    = "Geo-STR",         ["dex"]     = "Geo-DEX",
            ["agi"]    = "Geo-AGI",         ["int"]     = "Geo-INT",
            ["mnd"]    = "Geo-MND",         ["chr"]     = "Geo-CHR",
            ["vit"]    = "Geo-VIT",         ["refresh"] = "Geo-Refresh",
            ["regen"]  = "Geo-Regen",       ["haste"]   = "Geo-Haste",
            ["eva"]    = "Geo-Voidance",    ["acc"]     = "Geo-Precision",
            ["mev"]    = "Geo-Attunement",  ["macc"]    = "Geo-Focus",
            ["def"]    = "Geo-Barrier",     ["att"]     = "Geo-Fury",
            ["mdb"]    = "Geo-Fend",        ["mab"]     = "Geo-Acumen",
            ["para"]   = "Geo-Paralysis",   ["grav"]    = "Geo-Gravity",
            ["poison"] = "Geo-Poison",      ["Slow"]    = "Geo-Slow",
            ["macc-"]  = "Geo-Vex",         ["eva-"]    = "Geo-Torpor",
            ["acc-"]   = "Geo-Slip",        ["mev-"]    = "Geo-Languor",
            ["def-"]   = "Geo-Frailty",     ["att-"]    = "Geo-Wilt",
            ["mdb-"]   = "Geo-Malaise",     ["mab-"]    = "Geo-Fade",

        }

    }

    -- Public Variables.
    self.bubbles        = self.settings.bubbles or {self.allowed[772], self.allowed[818], self.allowed[780]}
    self.flags          = self.settings.flags or {indi=true, geo=true, entrust=true, ecliptic=true, dematerialize=true, circle=true, glory=true, lifecycle=true, distance=22}

    -- Private Functions
    private.persist = function()
        local next = next

        if self.settings then
            self.settings.bubbles       = self.bubbles
            self.settings.flags         = self.flags
            self.settings.layout        = self.layout

        end

    end
    private.persist()

    private.resetDisplay = function()
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

        if windower.ffxi.get_player() and windower.ffxi.get_player().main_job == 'GEO' then
            self.display:show()

        else
            self.display:hide()

        end

    end
    private.resetDisplay()

    private.render = function()
        
        if bp and self.display:visible() then
            local luopan    = bp.helpers['target'].targets.luopan
            local entrust   = bp.helpers['target'].targets.entrust
            local target    = bp.helpers['target'].getTarget()
            local update    = {}

            for i,v in ipairs(self.bubbles) do

                if i == 1 then
                    table.insert(update, string.format('Current Luopan Placement: \\cs(%s)%s\\cr\n\n[I]: \\cs(%s)%s\\cr', self.important, map.placement[placement]:upper(), self.important, self.bubbles[i].en))
                
                elseif i == 2 then

                    if luopan then
                        table.insert(update, string.format('[G]: \\cs(%s)%s\\cr%s► %s', self.important, self.bubbles[i].en, (''):lpad(' ', (15-self.bubbles[i].en:len())), tostring(luopan.name)))

                    elseif target then
                        table.insert(update, string.format('[G]: \\cs(%s)%s\\cr%s► %s', self.important, self.bubbles[i].en, (''):lpad(' ', (15-self.bubbles[i].en:len())), tostring(target.name)))

                    else
                        table.insert(update, string.format('[G]: \\cs(%s)%s\\cr%s► %s', self.important, self.bubbles[i].en, (''):lpad(' ', (15-self.bubbles[i].en:len())), tostring('NONE')))

                    end

                elseif i == 3 then

                    if entrust then
                        table.insert(update, string.format('[E]: \\cs(%s)%s\\cr%s► %s', self.important, self.bubbles[i].en, (''):lpad(' ', (15-self.bubbles[i].en:len())), tostring(entrust.name)))
                        
                    else
                        table.insert(update, string.format('[E]: \\cs(%s)%s\\cr%s► %s', self.important, self.bubbles[i].en, (''):lpad(' ', (15-self.bubbles[i].en:len())), tostring('NONE')))

                    end

                end

            end
            self.display:text(table.concat(update, '\n'))
            self.display:update()

        end

    end

    -- Static Functions.
    self.writeSettings = function()
        private.persist()

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
        private.persist()
        private.resetDisplay()

    end

    self.getPlacement = function()
        return map.placement[placement]
    end

    self.toggleDisplay = function()

        if self.display:visible() then
            self.display:hide()

        else
            self.display:show()

        end

    end

    -- Public Functions.
    self.setSystem = function(buddypal)
        if buddypal then
            bp = buddypal
        end

    end

    self.isGeoSpell = function(id)
        local bp = bp or false
        local id = id or false

        if bp and id then

            for _,v in pairs(self.allowed) do

                if bp.res.spells[id] and (bp.res.spells[id].en):contains('Geo-') then
                    return true
                end

            end

        end
        return false

    end

    self.valid = function(id)
        local bp = bp or false
        local id = id or false

        if bp and id then

            for _,v in pairs(self.allowed) do

                if bp.res.spells[id] then
                    return true
                end

            end

        end
        return false

    end

    self.setBubbles = function(b1, b2, b3)
        local bp = bp or false
        local b1 = b1 or false
        local b2 = b2 or false
        local b3 = b3 or false

        if bp and b1 then

            if b1 then
                
                if type(b1) == 'table' and b1.id and self.allowed[b1.id] then
                    self.bubbles[1] = b1

                elseif (type(b1) == 'number' or tonumber(b1) ~= nil) and self.allowed[b1] then
                    self.bubbles[1] = self.allowed[b1]

                elseif type(b1) == 'string' and bp.MA[b1] then
                    self.bubbles[1] = bp.MA[b1]

                elseif type(b1) == 'string' and short.self[b1] then
                    self.bubbles[1] = bp.MA[short.self[b1]]

                end

            end

            if b2 then

                if type(b2) == 'table' and b2.id and self.allowed[b2.id] then
                    self.bubbles[2] = b2

                elseif (type(b2) == 'number' or tonumber(b2) ~= nil) and self.allowed[b2] then
                    self.bubbles[2] = self.allowed[b2]

                elseif type(b2) == 'string' and bp.MA[b2] then
                    self.bubbles[2] = bp.MA[b2]

                elseif type(b2) == 'string' and short.target[b2] then
                    self.bubbles[2] = bp.MA[short.target[b2]]

                end

            end

            if b3 then

                if type(b3) == 'table' and b3.id and self.allowed[b3.id] then
                    self.bubbles[3] = b3

                elseif (type(b3) == 'number' or tonumber(b3) ~= nil) and self.allowed[b3] then
                    self.bubbles[3] = self.allowed[b3]

                elseif type(b3) == 'string' and bp.MA[b3] then
                    self.bubbles[3] = bp.MA[b3]

                elseif type(b3) == 'string' and short.self[b3] then
                    self.bubbles[3] = bp.MA[short.self[b3]]

                end

            end
            self.writeSettings()

        end

    end

    self.togglePlacement = function()

        if bp then

            if placement == 1 then
                placement = 2

            elseif placement == 2 then
                placement = 1

            end
            bp.helpers['popchat'].pop(string.format('BUBBLE PLACEMENT IS NOW SET TO: %s', map.placement[placement]))

        end

    end

    self.offsetBubble = function(target, param, category)
        local target    = target or false
        local param     = param or false
        local category  = category or false

        if bp and target and param and category then
            local action    = bp.packets.new('outgoing', 0x01a)
            local mob       = windower.ffxi.get_mob_by_id(target) or false
            local offset    = {x=0, y=0}

            if mob and mob.facing then
                local direction = self.getDirection(mob.facing)

                if map.placement[placement] == 'Front' then
                    offset = self.buildFrontOffset(direction, mob.model_size, mob.model_scale)

                elseif map.placement[placement] == 'Side' then
                    offset = self.buildSideOffset(direction, mob.model_size, mob.model_scale)

                end
                
                do -- Update the positions.
                    action["Target"]        = mob.id
			        action["Target Index"]  = mob.index
			        action["Category"]      = category
			        action["Param"]         = param
                    action['X Offset']      = offset.x
                    action['Y Offset']      = offset.y

                end
                bp.helpers['popchat'].pop(string.format('PLACING BUBBLE AT %s: %05.2f, %05.2f', (map.placement[placement]):upper(), offset.x, offset.y))
                return action

            end

        end
        return false

    end

    self.buildSideOffset = function(direction, size, scale)
        local bp        = bp or false
        local direction = direction or false
        local size      = size or false
        local scale     = scale or false

        if bp and direction and size and scale then
            local adjust = ( (size/2) * scale )

            if map.directions[direction] == 'East' then
                return {x=0, y=(1+adjust+math.random())}

            elseif map.directions[direction] == 'Northeast' then
                return {x=(1+adjust+math.random()), y=(-1+((adjust+math.random())*-1))}

            elseif map.directions[direction] == 'North' then
                return {x=(1+adjust+math.random()), y=0}

            elseif map.directions[direction] == 'Northwest' then
                return {x=(1+adjust+math.random()), y=(1+adjust+math.random())}

            elseif map.directions[direction] == 'West' then
                return {x=0, y=(1+adjust+math.random())}

            elseif map.directions[direction] == 'Southwest' then
                return {x=(-1+((adjust+math.random())*-1)), y=(1+adjust+math.random())}

            elseif map.directions[direction] == 'South' then
                return {x=(-1+((adjust+math.random())*-1)), y=0}

            elseif map.directions[direction] == 'Southeast' then
                return {x=(-1+((adjust+math.random())*-1)), y(-1+((adjust+math.random())*-1))}

            end

        end
        return {x=0, y=0}

    end

    self.buildFrontOffset = function(direction, size, scale)
        local bp        = bp or false
        local direction = direction or false
        local size      = size or false
        local scale     = scale or false

        if bp and direction and size and scale then
            local adjust = ( (size/2) * scale )

            if map.directions[direction] == 'East' then
                return {x=(1+adjust+math.random()), y=0}

            elseif map.directions[direction] == 'Northeast' then
                return {x=(1+adjust+math.random()), y=(1+adjust+math.random())}

            elseif map.directions[direction] == 'North' then
                return {x=0, y=(1+adjust+math.random())}

            elseif map.directions[direction] == 'Northwest' then
                return {x=(-1+((adjust+math.random())*-1)), y=(1+adjust+math.random())}

            elseif map.directions[direction] == 'West' then
                return {x=(-1+((adjust+math.random())*-1)), y=0}

            elseif map.directions[direction] == 'Southwest' then
                return {x=(-1+((adjust+math.random())*-1)), y=(-1+((adjust+math.random())*-1))}

            elseif map.directions[direction] == 'South' then
                return {x=0, y=(-1+((adjust+math.random())*-1))}

            elseif map.directions[direction] == 'Southeast' then
                return {x=(1+adjust+math.random()), y=(-1+((adjust+math.random())*-1))}

            end

        end
        return {x=0, y=0}

    end

    self.getDirection = function(rotation)
        local bp        = bp or false
        local rotation  = rotation or 0

        if bp then

            if rotation >= 0 and rotation <= 0.785 then
                return 1

            elseif rotation > 0.785 and rotation <= 1.570 then
                return 2

            elseif rotation > 1.570 and rotation <= 2.355 then
                return 3

            elseif rotation > 2.355 and rotation <= 3.140 then
                return 4

            elseif rotation > 3.140 and rotation <= 3.925 then
                return 5

            elseif rotation > 3.925 and rotation <= 4.710 then
                return 6

            elseif rotation > 4.710 and rotation <= 5.495 then
                return 7

            elseif rotation > 5.495 and rotation <= 6.280 then
                return 8

            end

        end
        return 1

    end

    self.handle = function(target)
        local bp        = bp or false
        local target    = target or false
        local pet       = windower.ffxi.get_mob_by_target('pet') or false

        if bp then
            local bubbles = self.bubbles
            
            -- HANDLE GEO-SPELLS.
            if not pet and target then
                
                if self.flags.geo and bubbles[2] and bp.helpers['actions'].isReady('MA', bubbles[2].en) and not bp.helpers['queue'].inQueue(bp.MA[bubbles[2].en]) then
                    
                    if self.flags.glory and bp.helpers['actions'].isReady('JA', "Blaze of Glory") then
                        bp.helpers['queue'].add(bp.JA['Blaze of Glory'], 'me')
                        bp.helpers['queue'].add(bp.MA[bubbles[2].en], target)

                    else
                        bp.helpers['queue'].add(bp.MA[bubbles[2].en], target)

                    end

                end
            
            elseif pet and (pet.distance):sqrt() > (self.flags.distance+5) and self.flags.circle and bp.helpers['actions'].isReady('JA', "Full Circle") and not bp.helpers['queue'].inQueue(bp.JA['Full Circle'], 'me') then
                bp.helpers['queue'].clear()
                bp.helpers['queue'].addToFront(bp.JA['Full Circle'], 'me')

            elseif pet and (pet.distance):sqrt() < self.flags.distance and pet.hpp >= 80 and self.flags.ecliptic and bp.helpers['actions'].isReady('JA', "Ecliptic Attrition") and not bp.helpers['queue'].inQueue(bp.JA['Ecliptic Attrition'], 'me') then
                bp.helpers['queue'].addToFront(bp.JA['Ecliptic Attrition'], 'me')

            elseif pet and (pet.distance):sqrt() < self.flags.distance and pet.hpp <= 60 and self.flags.lifecycle and bp.helpers['actions'].isReady('JA', "Life Cycle") and not bp.helpers['queue'].inQueue(bp.JA['Life Cycle'], 'me') then
                bp.helpers['queue'].addToFront(bp.JA['Life Cycle'], 'me')

            elseif pet and (pet.distance):sqrt() < self.flags.distance and pet.hpp >= 60 and self.flags.dematerialize and bp.helpers['actions'].isReady('JA', "Dematerialize") and not bp.helpers['queue'].inQueue(bp.JA['Dematerialize'], 'me') then
                bp.helpers['queue'].addToFront(bp.JA['Dematerialize'], 'me')

            end

            -- HANDLE INDI-SPELLS.
            if self.flags.indi and not bp.helpers['buffs'].buffActive(612) and bubbles[1] and bp.helpers['actions'].isReady('MA', bubbles[1].en) and not bp.helpers['queue'].inQueue(bp.MA[bubbles[1].en]) then
                bp.helpers['queue'].add(bp.MA[bubbles[1].en], 'me')
            end

            -- HANDLE ENTRUST SPELLS.
            if self.flags.entrust and bp.helpers['actions'].isReady('JA', "Entrust") and not bp.helpers['queue'].inQueue(bp.MA[bubbles[3].en]) and bp.helpers['target'].targets.entrust and bp.helpers['target'].getTarget() then
                bp.helpers['queue'].add(bp.MA[bubbles[3].en], bp.helpers['target'].targets.entrust)

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

    self.toggleBOG = function()
        local bp = bp or false

        if bp then
        
            if self.flags.glory then
                self.flags.glory = false

            else
                self.flags.glory = true

            end
            bp.helpers['popchat'].pop(string.format('BLAZE OF GLORY: %s', tostring(self.flags.glory)))
            self.writeSettings()

        end

    end

    self.toggleEnhancements = function()
        local bp = bp or false

        if bp then
        
            if self.flags.ecliptic then
                self.flags.ecliptic = false

            else
                self.flags.ecliptic = true

            end
            bp.helpers['popchat'].pop(string.format('%s: %s', buffs[buff], tostring(self.flags.ecliptic)))
            self.writeSettings()

        end

    end

    self.toggleBuff = function()
        local n = #buffs

        if buff < n then
            buff = (buff + 1)

        elseif buff >= n then
            buff = 1

        end
        bp.helpers['popchat'].pop(string.format('ENHANCEMENTS NOW SET TO: %s', tostring(buffs[buff])))
        self.writeSettings()

    end

    self.toggleIndi = function()

        if bp then

            if self.flags.indi then
                self.flags.indi = false

            else
                self.flags.indi = true

            end
            bp.helpers['popchat'].pop(string.format('INDI-SPELLS: %s', tostring(self.flags.indi)))
            self.writeSettings()

        end

    end

    self.toggleGeo = function()

        if bp then

            if self.flags.geo then
                self.flags.geo = false

            else
                self.flags.geo = true

            end
            bp.helpers['popchat'].pop(string.format('GEO-SPELLS: %s', tostring(self.flags.geo)))
            self.writeSettings()

        end

    end

    self.toggleEntrust = function()

        if bp then

            if self.flags.entrust then
                self.flags.entrust = false

            else
                self.flags.entrust = true

            end
            bp.helpers['popchat'].pop(string.format('ENTRUST-SPELLS: %s', tostring(self.flags.entrust)))
            self.writeSettings()

        end

    end

    self.toggleDematerialize = function()

        if bp then

            if self.flags.dematerialize then
                self.flags.dematerialize = false

            else
                self.flags.dematerialize = true

            end
            bp.helpers['popchat'].pop(string.format('DEMATERIALIZE: %s', tostring(self.flags.dematerialize)))
            self.writeSettings()

        end

    end

    self.toggleLifeCycle = function()

        if bp then

            if self.flags.lifecycle then
                self.flags.lifecycle = false

            else
                self.flags.lifecycle = true

            end
            bp.helpers['popchat'].pop(string.format('LIFE CYCLE: %s', tostring(self.flags.lifecycle)))
            self.writeSettings()

        end

    end

    self.toggleFullCircle = function()

        if bp then

            if self.flags.circle then
                self.flags.circle = false

            else
                self.flags.circle = true

            end
            bp.helpers['popchat'].pop(string.format('FULL CIRCLE: %s', tostring(self.flags.circle)))
            self.writeSettings()

        end

    end

    self.setDistance = function(distance)
        local distance = distance or false

        if bp and distance and tonumber(distance) ~= nil then
            self.flags.distance = tonumber(distance)

            do -- Display message and save current settings.
                bp.helpers['popchat'].pop(string.format('FULL CIRCLE DISTANCE SET TO: %02d', self.flags.distance))
                self.writeSettings()
                
            end

        end

    end

    -- Private Events.
    private.events.prerender = windower.register_event('prerender', function()
        private.render()

    end)

    private.events.actions = windower.register_event('outgoing chunk', function(id, original, modified, injected, blocked)
        
        if id == 0x01a then
            local parsed = bp.packets.parse('outgoing', original)
    
            if parsed and parsed['Category'] == 3 then
    
                if self.isGeoSpell(parsed['Param']) then
                    return bp.packets.build(self.offsetBubble(parsed['Target'], parsed['Param'], parsed['Category']))    
                end
                return original
    
            end

        end
    
    end)

    return self

end
return bubbles.new()
