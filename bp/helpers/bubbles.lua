--// BUBBLE OFFSET BUILDER WRITTEN BY DARKDOOM22: https://github.com/Darkdoom22/BubbleOffset/blob/main/bubbleoffset.lualocal //
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
    self.layout     = self.settings.layout or {pos={x=500, y=350}, colors={text={alpha=255, r=245, g=200, b=20}, bg={alpha=200, r=0, g=0, b=0}, stroke={alpha=255, r=0, g=0, b=0}}, font={name='Lucida Console', size=9}, padding=3, stroke_width=1, draggable=true}
    self.display    = texts.new('', {flags={draggable=self.layout.draggable}})
    self.important  = string.format('%s,%s,%s', 25, 165, 200)

    -- Public Variables.
    self.bubbles    = self.settings.debuffs or {self.allowed[772], self.allowed[780], self.allowed[818]}

    -- Private Variables.
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

    -- Private Variables.
    local math      = math
    local placement = 1
    local map       = {

        directions  = {'East','Southeast','South','Southwest','West','Northwest','North','Northeast'},
        placement   = {'Front','Side'},

    }

    -- Private Functions
    local persist = function()
        local next = next

        if self.settings then
            self.settings.bubbles = self.bubbles
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

        do -- Handle job sepcifics.
            local player = windower.ffxi.get_player()

            if player.main_job == 'GEO' then
                self.display:show()

            else
                self.display:hide()

            end

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
        self.writeSettings()

    end

    self.jobChange = function()
        self.writeSettings()
        persist()
        resetDisplay()

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
    self.render = function(bp)
        local bp = bp or false

        if bp and self.display:visible() then
            local targets   = bp.helpers['target'].targets
            local update    = {}

            for i,v in ipairs(self.bubbles) do

                if i == 1 then
                    table.insert(update, string.format('Current Luopan Placement: \\cs(%s)%s\\cr\n\n[I]: \\cs(%s)%s\\cr', self.important, map.placement[placement]:upper(), self.important, self.bubbles[i].en))
                
                elseif i == 2 then

                    if targets.luopan then
                        table.insert(update, string.format('[G]: \\cs(%s)%s\\cr%s► %s', self.important, self.bubbles[i].en, (''):lpad(' ', (15-self.bubbles[i].en:len())), tostring(targets.luopan.name)))

                    else
                        table.insert(update, string.format('[G]: \\cs(%s)%s\\cr%s► %s', self.important, self.bubbles[i].en, (''):lpad(' ', (15-self.bubbles[i].en:len())), tostring('NONE')))

                    end

                elseif i == 3 then

                    if targets.entrust then
                        table.insert(update, string.format('[E]: \\cs(%s)%s\\cr%s► %s', self.important, self.bubbles[i].en, (''):lpad(' ', (15-self.bubbles[i].en:len())), tostring(targets.entrust.name)))
                        
                    else
                        table.insert(update, string.format('[E]: \\cs(%s)%s\\cr%s► %s', self.important, self.bubbles[i].en, (''):lpad(' ', (15-self.bubbles[i].en:len())), tostring('NONE')))

                    end

                end

            end
            self.display:text(table.concat(update, '\n'))
            self.display:update()

        end

    end

    self.isGeoSpell = function(bp, id)
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

    self.valid = function(bp, id)
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

    self.setBubbles = function(bp, b1, b2, b3)
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

                elseif type(b2) == 'string' and short.self[b2] then
                    self.bubbles[2] = bp.MA[short.self[b2]]

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

    self.togglePlacement = function(bp)
        local bp = bp or false

        if bp then

            if placement == 1 then
                placement = 2

            elseif placement == 2 then
                placement = 1

            end
            bp.helpers['popchat'].pop(string.format('BUBBLE PLACEMENT IS NOW SET TO: %s', map.placement[placement]))

        end

    end

    self.offsetBubble = function(bp, target, param, category)
        local bp        = bp or false
        local target    = target or false
        local param     = param or false
        local category  = category or false

        if bp and target and param and category then
            local action    = bp.packets.new('outgoing', 0x01a)
            local mob       = windower.ffxi.get_mob_by_id(target) or false
            local offset    = {x=0, y=0}

            if mob and mob.facing then
                local direction = self.getDirection(bp, mob.facing)

                if map.placement[placement] == 'Front' then
                    offset = self.buildFrontOffset(bp, direction, mob.model_size, mob.model_scale)

                elseif map.placement[placement] == 'Side' then
                    offset = self.buildSideOffset(bp, direction, mob.model_size, mob.model_scale)

                end
                print(mob.facing, map.directions[direction] , direction)
                do -- Update the positions.
                    action["Target"]        = mob.id
			        action["Target Index"]  = mob.index
			        action["Category"]      = category
			        action["Param"]         = param
                    action['X Offset']      = offset.x
                    action['Y Offset']      = offset.y

                end
                bp.helpers['popchat'].pop('PLACING BUBBLE AT %s: [ %2.2f, %2.2f ]', (map.placement[placement]):upper(), offset.x, offset.y)
                return action

            end

        end
        return false

    end

    self.buildSideOffset = function(bp, direction, size, scale)
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

    self.buildFrontOffset = function(bp, direction, size, scale)
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

    self.getDirection = function(bp, rotation)
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
return bubbles.new()
