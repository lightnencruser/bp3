local runes     = {}
local player    = windower.ffxi.get_player()
local files     = require('files')
local texts     = require('texts')
local res       = require('resources')
local f = files.new(string.format('bp/helpers/settings/runes/%s_settings.lua', player.name))
require('queues')

if not f:exists() then
  f:write(string.format('return %s', T({}):tovstring()))
end

function runes.new()
    local self = {}

    -- Static Variables.
    self.allowed    = require('resources').job_abilities:type('Rune')
    self.settings   = dofile(string.format('%sbp/helpers/settings/runes/%s_settings.lua', windower.addon_path, player.name))
    self.layout     = self.settings.layout or {pos={x=900, y=800}, colors={text={alpha=255, r=245, g=200, b=20}, bg={alpha=0, r=0, g=0, b=0}, stroke={alpha=255, r=0, g=0, b=0}}, font={name='Impact', size=11}, padding=0, stroke_width=2, draggable=false}
    self.display    = texts.new('', {flags={draggable=self.layout.draggable}})
    self.important  = string.format('%s,%s,%s', 25, 165, 200)
    
    -- Public Variables.
    self.runes      = self.settings.runes or {self.allowed[365], self.allowed[365], self.allowed[365]}
    self.mode       = self.settings.mode or 1

    -- Private Functions.
    local timer     = {last=2, delay=30}
    local modes     = {'RESISTANCE','DAMAGE'}
    local valid     = {523,524,525,526,527,528,529,530}
    local runes     = {
        
        ["fire"]        = "Ignis",          ["f"]   = "Ignis",
        ["ice"]         = "Gelus",          ["i"]   = "Gelus",
        ["wind"]        = "Flabra",         ["w"]   = "Flabra",
        ["earth"]       = "Tellus",         ["e"]   = "Tellus",
        ["thunder"]     = "Sulpor",         ["t"]   = "Sulpor",
        ["water"]       = "Unda",           ["w"]   = "Unda",
        ["light"]       = "Lux",            ["l"]   = "Lux",
        ["dark"]        = "Tenebrae",       ["d"]   = "Tenebrae",
        
    }

    local colors    = {
        
        ['Ignis']       = {string.format('%s,%s,%s', 100, 190, 255),    string.format('%s,%s,%s', 195, 25, 35)},
        ['Gelus']       = {string.format('%s,%s,%s', 100, 190, 30),     string.format('%s,%s,%s', 100, 190, 255)},
        ['Flabra']      = {string.format('%s,%s,%s', 170, 145, 75),     string.format('%s,%s,%s', 100, 190, 30)},
        ['Tellus']      = {string.format('%s,%s,%s', 110, 10, 195),     string.format('%s,%s,%s', 25, 165, 200)},
        ['Sulpor']      = {string.format('%s,%s,%s', 25, 35, 195),      string.format('%s,%s,%s', 110, 10, 195)},
        ['Unda']        = {string.format('%s,%s,%s', 195, 25, 35),      string.format('%s,%s,%s', 25, 35, 195)},
        ['Lux']         = {string.format('%s,%s,%s', 230, 235, 250),    string.format('%s,%s,%s', 155, 0, 60)},
        ['Tenebrae']    = {string.format('%s,%s,%s', 155, 0, 60),       string.format('%s,%s,%s', 230, 235, 250)},
    
    }

    -- Private Functions.
    local persist = function()
        local next = next

        if self.settings then
            self.settings.runes   = self.runes
            self.settings.mode    = self.mode
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

            if (player.main_job == 'RUN' or player.sub_job == 'RUN') then
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

    self.render = function()
        local player = windower.ffxi.get_player()
        local update = {}
        
        if (player.main_job == 'RUN' or player.sub_job == 'RUN') then

            for i,v in ipairs(self.runes) do
                    
                if v.en then
                    table.insert(update, string.format(' \\cs(%s)%s\\cr', colors[v.en][self.mode], v.en))
                end

            end
            self.display:text(string.format('{%s%s%s}', (''):lpad(' ', 3), table.concat(update, '  + '), (''):rpad(' ', 3)))
            self.display:update()
            self.display:show()

        elseif self.display:visible() then
            self.display:text('')
            self.display:update()
            self.display:hide()

        end

    end

    -- Public Functions.

    self.setRune = function(bp, r1, r2, r3)
        local bp = bp or false
        local r1 = r1 or false
        local r2 = r2 or false
        local r3 = r3 or false
        
        if bp and r1 then

            if r1 and r1 ~= nil then
            
                if type(r1) == 'table' and r1.en then
                    self.runes[1] = r1

                elseif (type(r1) == 'number' or tonumber(r1) ~= nil) and self.allowed[r1] then
                    self.runes[1] = self.allowed[r1]

                elseif type(r1) == 'string' and bp.JA[r1] then
                    self.runes[1] = bp.JA[r1]

                elseif type(r1) == 'string' and bp.JA[runes[r1]] then
                    self.runes[1] = bp.JA[runes[r1]]

                end

            end

            if r2 and r2 ~= nil then
            
                if type(r2) == 'table' and r2.en then
                    self.runes[2] = r2

                elseif (type(r2) == 'number' or tonumber(r2) ~= nil) and self.allowed[r2] then
                    self.runes[2] = self.allowed[r2]

                elseif type(r2) == 'string' and bp.JA[r2] then
                    self.runes[2] = bp.JA[r2]

                elseif type(r2) == 'string' and bp.JA[runes[r2]] then
                    self.runes[2] = bp.JA[runes[r2]]

                end

            end

            if r3 and r3 ~= nil then
            
                if type(r3) == 'table' and r3.en then
                    self.runes[3] = r3

                elseif (type(r3) == 'number' or tonumber(r3) ~= nil) and self.allowed[r3] then
                    self.runes[3] = self.allowed[r3]

                elseif type(r3) == 'string' and bp.JA[r3] then
                    self.runes[3] = bp.JA[r3]

                elseif type(r3) == 'string' and bp.JA[runes[r3]] then
                    self.runes[3] = bp.JA[runes[r3]]

                end

            end
            bp.helpers['popchat'].pop(string.format('RUNES NOW SET TO: %s, %s, & %s.', self.runes[1].en, self.runes[2].en, self.runes[3].en))
            self.writeSettings()

        end

    end

    self.getShort = function(short)
        local short = short or false
        
        if short and type(short) == 'string' then
            
            for i,v in pairs(runes) do
                
                if #short > 0 and (i):match(short) then
                    return v
                end
                
            end
            
        end
        return false
        
    end
    
    self.getRune = function(bp, name)
        local bp    = bp or false
        local name  = name or false
        
        if bp and name and type(name) == 'string' then
            local helpers   = bp.helpers
            local list      = self.allowed
            local name      = name:lower()
            
            for _,v in pairs(list) do
                
                if v and (v.en):lower() == (name):lower() then
                    return v
                    
                elseif v and (v.en):lower() == self.getShort(name) then
                    return v
                    
                end
                
            end            
            
        end
        return false
        
    end
    
    self.getBuff = function(bp, name)
        local bp    = bp or false
        local name  = name or false
        
        if bp and name and type(name) == 'string' then
            local helpers = bp.helpers
            
            for _,v in pairs(valid) do
                local buff = res.buffs[v]
                
                if buff and (buff.en):lower() == (name):lower() then
                    return buff                    
                end
                
            end            
            
        end
        return false
        
    end
    
    self.getActive = function(bp)
        local bp        = bp or false
        local player    = windower.ffxi.get_player() or false
    
        if bp and player then
            local helpers   = bp.helpers
            local buffs     = windower.ffxi.get_player().buffs
            local count     = 0
            
            for _,v in ipairs(buffs) do
                
                if self.validBuff(bp, v) then
                    count = (count + 1)
                end
            
            end
            return count
        
        end
        return 0
        
    end
    
    self.validBuff = function(bp, id)
        local bp = bp or false
        local id = id or false
        
        if bp and id then
            
            for _,v in ipairs(valid) do

                if v == id then
                    return true
                end
                
            end
            
        end
        return false
        
    end

    self.handleRunes = function(bp)
        local bp = bp or false

        if bp then
            local buffs     = windower.ffxi.get_player().buffs
            local active    = self.getActive(bp)

            if active < 3 then

                if (os.clock()-timer.last) > timer.delay then

                    for i=1, 3 do
                        local rune = self.runes[i]

                        if rune then
                            helpers['queue'].add(bp, bp.JA[rune.en], 'me')
                        end

                    end
                    timer.last = os.clock()

                end

            elseif active == 0 then

                for i=1, 3 do
                    local rune = self.runes[i]

                    if rune then
                        helpers['queue'].add(bp, bp.JA[rune.en], 'me')
                    end

                end
                timer.last = os.clock()
                
            end

        end

    end

    self.toggleMode = function(bp)
        self.mode = ( self.mode == 1 and 2 or 1 )
        bp.helpers['popchat'].pop(string.format('RUNES MODE: %s', modes[self.mode]))

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
return runes.new()
