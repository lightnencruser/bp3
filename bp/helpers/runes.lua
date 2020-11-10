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
    self.allowed  = require('resources').job_abilities:type('Rune')
    self.settings = dofile(string.format('%sbp/helpers/settings/runes/%s_settings.lua', windower.addon_path, player.name))
    self.layout     = self.settings.layout or {pos={x=0, y=0}, colors={text={alpha=255, r=245, g=200, b=20}, bg={alpha=200, r=0, g=0, b=0}, stroke={alpha=255, r=0, g=0, b=0}}, font={name='Lucida Console', size=9}, padding=4, stroke_width=1, draggable=false}
    self.display    = texts.new('', {flags={draggable=self.layout.draggable}})

    -- Public Variables.
    self.runes    = self.settings.runes or {self.allowed[365], self.allowed[365], self.allowed[365]}
    self.active   = Q{}

    -- Private Functions.
    local valid  = {523,524,525,526,527,528,529,530}
    local runes  = {
        
        ["fire"]        = "Ignis",          ["f"]   = "Ignis",
        ["ice"]         = "Gelus",          ["i"]   = "Gelus",
        ["wind"]        = "Flabra",         ["w"]   = "Flabra",
        ["earth"]       = "Tellus",         ["e"]   = "Tellus",
        ["thunder"]     = "Sulpor",         ["t"]   = "Sulpor",
        ["water"]       = "Unda",           ["w"]   = "Unda",
        ["light"]       = "Lux",            ["l"]   = "Lux",
        ["dark"]        = "Tenebrae",       ["d"]   = "Tenebrae",
        
    }

    -- Private Functions.
    local persist = function()
        local next = next

        if self.settings then
            self.settings.runes   = self.runes
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
        self.writeSettings()

    end

    self.remove = function()

        if self.active:length() > 0 then
            self.active:remove(1)
        end

    end

    -- Public Functions.
    self.setRune = function(bp, position, rune)
        local bp        = bp or false
        local position  = tonumber(position) or false
        local rune      = rune or false
        
        if bp and position and rune and (type(position) == 'number' or tonumber(position) ~= nil) then
            
            if type(rune) == 'table' and runes[rune.en] then
                self.runes[position] = rune
                 helpers['popchat'].pop(string.format('Rune %d is now set to %s', position, rune.en))

            elseif (type(rune) == 'number' or tonumber(rune) ~= nil) and self.allowed[tonumber(rune)] then
                self.runes[position] = self.allowed[tonumber(rune)]
                 helpers['popchat'].pop(string.format('Rune %d is now set to %s', position, self.allowed[tonumber(rune)].en))

            elseif type(rune) == 'string' and runes[rune] then
                self.runes[position] = self.allowed[bp.JA[runes[rune]].id]
                 helpers['popchat'].pop(string.format('Rune %d is now set to %s', position, runes[rune]))

            end

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
            local buffs     = player.buffs
            local count     = 0
            
            for _,v in ipairs(buffs) do
                
                if self.validBuff(v) then
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
    
    self.add = function(bp, rune)
        local bp    = bp or false
        local rune  = rune or false

        if bp and rune and type(rune) == 'table' then
            
            if self.active:length() == 0 then
                self.active:push({rune=rune, position=1})
                
            elseif self.active:length() > 0 and self.active:length() < 3 then
                local last = self.active[self.active:length()]
                
                if last.position == 1 then
                    self.active:push({rune=rune, position=2})
                    
                elseif last.position == 2 then
                    self.active:push({rune=rune, position=3})
                    
                elseif last.position == 3 then
                    self.active:push({rune=rune, position=1})
                    
                end

            elseif self.active:length() == 3 then
                self.active:push({rune=rune, position=1})
                self.remove()
                
            end

        end
        
    end

    return self

end
return runes.new()
