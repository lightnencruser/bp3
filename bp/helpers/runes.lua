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

    -- Private Functions.
    local bp        = false
    local private   = {events={}}
    local timer     = {last=0, delay=30}
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

    -- Public Variables.
    private.runes       = self.settings.runes or {self.allowed[365], self.allowed[365], self.allowed[365]}
    private.mode        = self.settings.mode or 1 

    -- Private Functions.
    local persist = function()
        local next = next

        if self.settings then
            self.settings.layout  = self.layout
            self.settings.runes   = private.runes
            self.settings.mode    = private.mode

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
    private.writeSettings = function()
        persist()

        if f:exists() then
            f:write(string.format('return %s', T(self.settings):tovstring()))

        elseif not f:exists() then
            f:write(string.format('return %s', T({}):tovstring()))
        end

    end
    private.writeSettings()

    private.render = function()

        if bp and bp.player then
            local player = bp.player
            local update = {}

            if bp.hideUI then
                
                if self.display:visible() then
                    self.display:hide()
                end
                return

            end
            
            if player.main_job == 'RUN' then

                for i,v in ipairs(private.runes) do

                    if v.en then
                        table.insert(update, string.format(' \\cs(%s)%s\\cr', colors[v.en][private.mode], v.en))
                    end

                end
                self.display:text(string.format('{%s%s%s}', (''):lpad(' ', 3), table.concat(update, '  + '), (''):rpad(' ', 3)))
                self.display:update()
                self.display:show()

            elseif player.sub_job == 'RUN' then
                
                for i=1, 1 do
                    table.insert(update, string.format(' \\cs(%s)%s\\cr', colors[private.runes[i].en][private.mode], private.runes[i].en))
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

    end

    private.pos = function(x, y)
        local x = tonumber(x) or self.layout.pos.x
        local y = tonumber(y) or self.layout.pos.y

        if bp and x and y then
            self.display:pos(x, y)
            self.layout.pos.x = x
            self.layout.pos.y = y
            private.writeSettings()
        
        elseif bp and (not x or not y) then
            bp.helpers['popchat'].pop('PLEASE ENTER AN "X" OR "Y" COORDINATE!')

        end

    end

    -- Public Functions.
    self.setSystem = function(buddypal)
        if buddypal then
            bp = buddypal
        end

    end
    

    self.setRune = function(r1, r2, r3)
        
        if bp and r1 then

            if r1 and r1 ~= nil then
            
                if type(r1) == 'table' and r1.en then
                    private.runes[1] = r1

                elseif (type(r1) == 'number' or tonumber(r1) ~= nil) and self.allowed[r1] then
                    private.runes[1] = self.allowed[r1]

                elseif type(r1) == 'string' and bp.JA[r1] then
                    private.runes[1] = bp.JA[r1]

                elseif type(r1) == 'string' and bp.JA[runes[r1]] then
                    private.runes[1] = bp.JA[runes[r1]]

                end

            end

            if r2 and r2 ~= nil then
            
                if type(r2) == 'table' and r2.en then
                    private.runes[2] = r2

                elseif (type(r2) == 'number' or tonumber(r2) ~= nil) and self.allowed[r2] then
                    private.runes[2] = self.allowed[r2]

                elseif type(r2) == 'string' and bp.JA[r2] then
                    private.runes[2] = bp.JA[r2]

                elseif type(r2) == 'string' and bp.JA[runes[r2]] then
                    private.runes[2] = bp.JA[runes[r2]]

                end

            end

            if r3 and r3 ~= nil then
            
                if type(r3) == 'table' and r3.en then
                    private.runes[3] = r3

                elseif (type(r3) == 'number' or tonumber(r3) ~= nil) and self.allowed[r3] then
                    private.runes[3] = self.allowed[r3]

                elseif type(r3) == 'string' and bp.JA[r3] then
                    private.runes[3] = bp.JA[r3]

                elseif type(r3) == 'string' and bp.JA[runes[r3]] then
                    private.runes[3] = bp.JA[runes[r3]]

                end

            end
            bp.helpers['popchat'].pop(string.format('RUNES NOW SET TO: %s, %s, & %s.', private.runes[1].en, private.runes[2].en, private.runes[3].en))
            private.writeSettings()

        end

    end

    self.getShort = function(short)
        
        if short and type(short) == 'string' then
            
            for i,v in pairs(runes) do
                
                if #short > 0 and (i):match(short) then
                    return v
                end
                
            end
            
        end
        return false
        
    end
    
    self.getRune = function(name)
        
        if bp and name and type(name) == 'string' then
            local name = name:lower()
            
            for _,v in pairs(self.allowed) do
                
                if v and (v.en):lower() == name then
                    return v
                    
                elseif v and (v.en):lower() == self.getShort(name) then
                    return v
                    
                end
                
            end            
            
        end
        return false
        
    end
    
    self.getBuff = function(name)
        
        if bp and name and type(name) == 'string' then
            
            for _,v in pairs(valid) do
                local buff = res.buffs[v]
                
                if buff and (buff.en):lower() == (name):lower() then
                    return buff                    
                end
                
            end            
            
        end
        return false
        
    end
    
    self.getActive = function()
    
        if bp and bp.player then
            local buffs = bp.player.buffs
            local count = 0
            
            for _,v in ipairs(buffs) do
                
                if self.validBuff(v) then
                    count = (count + 1)
                end
            
            end
            return count
        
        end
        return 0
        
    end
    
    self.validBuff = function(id)
        
        if bp and id then
            
            for _,v in ipairs(valid) do

                if v == id then
                    return true
                end
                
            end
            
        end
        return false
        
    end

    self.maxRunes = function()

        if bp and bp.player then

            if bp.player.main_job_level < 35 then
                return 1

            elseif bp.player.main_job_level >= 35 and bp.player.main_job_level < 65 then
                return 2

            elseif bp.player.main_job_level >= 65 then
                return 3

            end

        end
        return 0

    end

    self.handleRunes = function()
        local current = {}
        local allowed = self.maxRunes()

        if bp and bp.player then
            local buffs = bp.player.buffs
            local active = self.getActive()

            if bp.player.main_job == 'RUN' then
                
                if active > 0 and active < allowed and bp.helpers['actions'].isReady('JA', "Ignis") then
                    
                    -- Get current runes activated.
                    for _,v in ipairs(buffs) do
                        if self.validBuff(v) then
                            table.insert(current, v)
                        end
                    end

                    for _,v in ipairs(private.runes) do

                        if #current > 0 then

                            for i, buff in ipairs(current) do

                                if bp.BUFFS[v.en] and bp.BUFFS[v.en].id == buff then
                                    table.remove(current, i)
                                end

                            end

                        else

                            if not bp.helpers['queue'].inQueue(bp.JA[v.en]) and bp.helpers['actions'].isReady('JA', "Ignis") then
                                bp.helpers['queue'].add(bp.JA[v.en], bp.player)
                            end

                        end

                    end

                elseif active == 0 and bp.helpers['actions'].isReady('JA', "Ignis") then
                    
                    if not bp.helpers['queue'].inQueue(bp.JA[private.runes[1].en]) then
                        bp.helpers['queue'].add(bp.JA[private.runes[1].en], bp.player)
                    end

                end

            elseif bp.player.sub_job == 'RUN' then
                
                if not T(buffs):contains(self.getBuff(private.runes[1].en).id) then
                    
                    if not bp.helpers['queue'].inQueue(private.runes[1]) and bp.helpers['actions'].isReady('JA', private.runes[1].en) then
                        bp.helpers['queue'].add(bp.JA[private.runes[1].en], bp.player)                        
                    end

                end

            end

        end

    end

    -- Private Events.
    private.events.commands = windower.register_event('addon command', function(...)
        local commands = T{...}
        local helper = table.remove(commands, 1)

        if bp and bp.player and helper and helper:lower() == 'runes' then

            if commands[1] then
                local command = commands[1]:lower()

                if command == 'pos' and commands[2] then
                    private.pos(commands[2], commands[3] or false)

                elseif command == 'mode' then
                    private.mode = private.mode == 1 and 2 or 1
                    bp.helpers['popchat'].pop(string.format('RUNES MODE: %s', modes[private.mode]))
                    private.writeSettings()

                else
                    self.setRune(commands[2] or false, commands[3] or false, commands[4] or false)

                end


            end

        end

    end)

    private.events.prerender = windower.register_event('prerender', function()
        private.render()
    end)

    return self

end
return runes.new()
