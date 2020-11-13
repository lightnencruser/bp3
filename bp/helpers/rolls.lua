local rolls     = {}
local player    = windower.ffxi.get_player()
local files     = require('files')
local texts 	= require('texts')
local f = files.new(string.format('bp/helpers/settings/rolls/%s_settings.lua', player.name))

if not f:exists() then
    f:write(string.format('return %s', T({}):tovstring()))
end

function rolls.new()
    local self = {}

    --Static Variables.
    self.allowed    = require('resources').job_abilities:type('CorsairRoll')
    self.settings   = dofile(string.format('%sbp/helpers/settings/rolls/%s_settings.lua', windower.addon_path, player.name))
    self.layout     = self.settings.layout or {pos={x=500, y=75}, colors={text={alpha=255, r=245, g=200, b=20}, bg={alpha=200, r=0, g=0, b=0}, stroke={alpha=255, r=0, g=0, b=0}}, font={name='Lucida Console', size=9}, padding=3, stroke_width=1, draggable=true}
    self.display    = texts.new('', {flags={draggable=self.layout.draggable}})
    self.important  = string.format('%s,%s,%s', 25, 165, 200)
    self.blink      = string.format('%s,%s,%s', 110, 235, 50)
    self.unlucky    = string.format('%s,%s,%s', 235, 30, 60)

    -- Public Variables.
    self.rolls      = self.settings.rolls or {self.allowed[109], self.allowed[105]}
    self.crooked    = self.settings.crooked or false
    self.cap        = self.settings.cap or 7
    self.rolled     = 0
    self.rolling    = false
    self.active     = Q{}

    -- Private Variables.
    local blink = false
    local valid = {309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,600}
    local short = {

        ['sam']         = "Samurai Roll",       ['stp']         = "Samurai Roll",       ['att']         = "Chaos Roll",         ['at']          = "Chaos Roll",
        ['atk']         = "Chaos Roll",         ['da']          = "Fighter's Roll",     ['dbl']         = "Fighter's Roll",     ['sc']          = "Allies' Roll",
        ['acc']         = "Hunter's Roll",      ['mab']         = "Wizard's Roll",      ['matk']        = "Wizard's Roll",      ['macc']        = "Warlock's Roll",
        ['regain']      = "Tactician's Roll",   ['tp']          = "Tactician's Roll",   ['mev']         = "Runeist's Roll",     ['meva']        = "Runeist's Roll",
        ['mdb']         = "Magus's Roll",       ['patt']        = "Beast Roll",         ['patk']        = "Beast Roll",         ['pacc']        = "Drachen Roll",
        ['pmab']        = "Puppet Roll",        ['pmatk']       = "Puppet Roll",        ['php']         = "Companion's Roll",   ['php+']        = "Companion's Roll",
        ['pregen']      = "Companion's Roll",   ['comp']        = "Companion's Roll",   ['refresh']     = "Evoker's Roll",      ['mp']          = "Evoker's Roll",
        ['mp+']         = "Evoker's Roll",      ['xp']          = "Corsair's Roll",     ['exp']         = "Corsair's Roll",     ['cp']          = "Corsair's Roll",
        ['crit']        = "Rogue's Roll",       ['def']         = "Gallant's Roll",     ['eva']         = "Ninja's Roll",       ['sb']          = "Monk's Roll",
        ['conserve']    = "Scholar's Roll",     ['fc']          = "Caster's Roll",      ['snapshot']    = "Courser's Roll",     ['delay']       = "Blitzer's Roll",
        ['counter']     = "Avenger's Roll",     ['savetp']      = "Miser's Roll",       ['speed']       = "Bolter's Roll",      ['enhancing']   = "Naturalist's Roll",
        ['regen']       = "Dancer's Roll",      ['sird']        = "Choral's Roll",      ['cure']        = "Healer's Roll",

    }

    local lucky = {

        ["Samurai Roll"]        = 2,    ["Chaos Roll"]          = 4,
        ["Hunter's Roll"]       = 4,    ["Fighter's Roll"]      = 5,
        ["Wizard's Roll"]       = 5,    ["Tactician's Roll"]    = 5,
        ["Runeist's Roll"]      = 4,    ["Beast Roll"]          = 4,
        ["Puppet Roll"]         = 3,    ["Corsair's Roll"]      = 5,
        ["Evoker's Roll"]       = 5,    ["Companion's Roll"]    = 2,
        ["Warlock's Roll"]      = 4,    ["Magus's Roll"]        = 2,
        ["Drachen Roll"]        = 4,    ["Allies' Roll"]        = 3,
        ["Rogue's Roll"]        = 5,    ["Gallant's Roll"]      = 3,
        ["Healer's Roll"]       = 3,    ["Ninja's Roll"]        = 4,
        ["Choral Roll"]         = 2,    ["Monk's Roll"]         = 3,
        ["Dancer's Roll"]       = 3,    ["Scholar's Roll"]      = 2,
        ["Naturalist's Roll"]   = 3,    ["Avenger's Roll"]      = 4,
        ["Bolter's Roll"]       = 3,    ["Caster's Roll"]       = 2,
        ["Courser's Roll"]      = 3,    ["Blitzer's Roll"]      = 4,
        ["Miser's Roll"]        = 5,

    }

    local unlucky = {

        ["Samurai Roll"]        = 6,    ["Chaos Roll"]          = 8,
        ["Hunter's Roll"]       = 8,    ["Fighter's Roll"]      = 9,
        ["Wizard's Roll"]       = 9,    ["Tactician's Roll"]    = 8,
        ["Runeist's Roll"]      = 8,    ["Beast Roll"]          = 8,
        ["Puppet Roll"]         = 7,    ["Corsair's Roll"]      = 9,
        ["Evoker's Roll"]       = 9,    ["Companion's Roll"]    = 10,
        ["Warlock's Roll"]      = 8,    ["Magus's Roll"]        = 6,
        ["Drachen Roll"]        = 8,    ["Allies' Roll"]        = 10,
        ["Rogue's Roll"]        = 9,    ["Gallant's Roll"]      = 7,
        ["Healer's Roll"]       = 7,    ["Ninja's Roll"]        = 8,
        ["Choral Roll"]         = 6,    ["Monk's Roll"]         = 7,
        ["Dancer's Roll"]       = 7,    ["Scholar's Roll"]      = 6,
        ["Naturalist's Roll"]   = 7,    ["Avenger's Roll"]      = 8,
        ["Bolter's Roll"]       = 9,    ["Caster's Roll"]       = 7,
        ["Courser's Roll"]      = 9,    ["Blitzer's Roll"]      = 9,
        ["Miser's Roll"]        = 7,

    }

    -- Private Functions.
    local persist = function()
        local next = next

        if self.settings then
            self.settings.rolls     = self.rolls
            self.settings.cap       = self.cap
            self.settings.crooked   = self.crooked
            self.settings.layout    = self.layout
            self.settings.important = self.important
            self.settings.blink     = self.blink

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

            if (player.main_job == 'COR' or player.sub_job == 'COR') then
                self.display:show()

            else
                self.display:hide()

            end

        end

    end
    resetDisplay()

    -- Static Functions.
    self.writeSettings = function()

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
        local render    = {}
        local trigger   = false

        for i=1, (self.active:length()) do

            if self.active[i] then

                if blink and (self.active[i].dice == 11 or self.active[i].dice == lucky[self.active[i].roll.en]) then
                    table.insert(render, string.format('%s► Roll #%d: \\cs(%s)[%02d] %s\\cr', (''):lpad(' ', 2), (i), self.blink, self.active[i].dice, self.active[i].roll.en))
                    trigger = true

                elseif (self.active[i].dice == unlucky[self.active[i].roll.en] or self.active[i].dice == 0) then
                    table.insert(render, string.format('%s► Roll #%d: \\cs(%s)[%02d] %s\\cr', (''):lpad(' ', 2), (i), self.unlucky, self.active[i].dice, self.active[i].roll.en))

                else
                    table.insert(render, string.format('%s► Roll #%d: \\cs(%s)[%02d] %s\\cr', (''):lpad(' ', 2), (i), self.important, self.active[i].dice, self.active[i].roll.en))

                end

            end

        end

        if render then
            self.display:text(table.concat(render, '\n'))
            self.display:update()

            if not self.display:visible() and self.active:length() > 0 then
                self.display:show()

            elseif self.active:length() == 0 then
                self.display:hide()

            end

        end

        if not trigger then
            blink = true

        else
            blink = false
        
        end

    end

    -- Public Functions.
    self.setRoll = function(bp, dice1, dice2)
        local bp    = bp or false
        local dice1 = dice1 or false
        local dice2 = dice2 or false

        if bp and dice1 then

            if dice1 and not dice2 then
                
                if type(dice1) == 'table' and dice1.id and self.allowed[dice1.id] then
                    self.rolls[1] = dice1
                    bp.helpers['popchat'].pop(string.format('ROLL #1 IS NOW SET TO: %s!', self.rolls[1].en or 'ERROR'))

                elseif (type(dice1) == 'number' or tonumber(dice1) ~= nil) and self.allowed[dice1] then
                    self.rolls[1] = self.allowed[dice1]
                    bp.helpers['popchat'].pop(string.format('ROLL #1 IS NOW SET TO: %s!', self.rolls[1].en or 'ERROR'))

                elseif type(dice1) == 'string' and bp.JA[dice1] then
                    self.rolls[1] = bp.JA[dice1]
                    bp.helpers['popchat'].pop(string.format('ROLL #1 IS NOW SET TO: %s!', self.rolls[1].en or 'ERROR'))

                elseif type(dice1) == 'string' and short[dice1] then
                    self.rolls[1] = bp.JA[short[dice1]]
                    bp.helpers['popchat'].pop(string.format('ROLL #1 IS NOW SET TO: %s!', self.rolls[1].en or 'ERROR'))

                end
                self.writeSettings()

            elseif dice1 and dice2 then

                if type(dice1) == 'table' and type(dice2) == 'table' and dice1.id and dice2.id and self.allowed[dice1.id] and self.allowed[dice2.id] then
                    self.rolls[1] = dice1
                    self.rolls[2] = dice2
                    bp.helpers['popchat'].pop(string.format('ROLL #1 & #2 IS NOW SET TO: %s & %s!', self.rolls[1].en or 'ERROR', self.rolls[2].en or 'ERROR'))

                elseif (type(dice1) == 'number' or tonumber(dice1) ~= nil) and (type(dice2) == 'number' or tonumber(dice2) ~= nil) and self.allowed[dice1] and self.allowed[dice2] then
                    self.rolls[1] = self.allowed[dice1]
                    self.rolls[2] = self.allowed[dice2]
                    bp.helpers['popchat'].pop(string.format('ROLL #1 & #2 IS NOW SET TO: %s & %s!', self.rolls[1].en or 'ERROR', self.rolls[2].en or 'ERROR'))

                elseif type(dice1) == 'string' and bp.JA[dice1] and type(dice2) == 'string' and bp.JA[dice2] then
                    self.rolls[1] = bp.JA[dice1]
                    self.rolls[2] = bp.JA[dice2]
                    bp.helpers['popchat'].pop(string.format('ROLL #1 & #2 IS NOW SET TO: %s & %s!', self.rolls[1].en or 'ERROR', self.rolls[2].en or 'ERROR'))

                elseif type(dice1) == 'string' and short[dice1] and type(dice2) == 'string' and short[dice2] then
                    self.rolls[1] = bp.JA[short[dice1]]
                    self.rolls[2] = bp.JA[short[dice2]]
                    bp.helpers['popchat'].pop(string.format('ROLL #1 & #2 IS NOW SET TO: %s & %s!', self.rolls[1].en or 'ERROR', self.rolls[2].en or 'ERROR'))

                end
                self.writeSettings()

            end

        end
    
    end

    self.setCap = function(bp, cap)
        local bp    = bp or false
        local cap   = tonumber(cap) or false

        if bp and cap and cap ~= nil and cap > 0 and cap < 11 then
            self.cap = cap
            bp.helpers['popchat'].pop(string.format('NEW ROLL CAP IS %d!', self.cap))
            self.writeSettings()
        
        else
            bp.helpers['popchat'].pop('ROLL CAP CAN ONLY BE 1 THROUGH 11')

        end

    end

    self.toggleCrooked = function(bp)
        local bp = bp or false

        if bp then

            if self.crooked then
                self.crooked = false
                bp.helpers['popchat'].pop(string.format('CROOKED ROLLS: %s', tostring(self.crooked):upper()))
            else
                self.crooked = true
                bp.helpers['popchat'].pop(string.format('CROOKED ROLLS: %s', tostring(self.crooked):upper()))
            end
            self.writeSettings()

        end

    end

    self.diceTotal = function(bp, amount)
        local bp        = bp or false
        local amount    = tonumber(amount) or false

        if bp and amount and amount <= 11 then
            self.rolled = amount
            
            if self.active[self.active:length()] then    
                self.active[self.active:length()].dice = amount
            end

        end

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

    self.getShort = function(bp, name)
        local name = name or false
        
        if name and type(name) == 'string' and short[name] then
            
            for _,v in pairs(self.allowed) do
                
                if short[name] == v.en then
                    return v
                end
                
            end
            
        end
        return false
        
    end

    self.getRoll = function(bp, name)
        local bp    = bp or false
        local name  = name or false
        
        if bp and name and type(name) == 'string' then
            local helpers   = bp.helpers
            local list      = self.allowed
            local name      = name:lower()
            
            for _,v in pairs(list) do
                
                if v and (v.en):lower() == (name):lower() then
                    return v
                    
                elseif v and (v.en):lower() == self.getShort(bp, name) then
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
                local buff = bp.res.buffs[v]
                
                if buff and buff.en == name then
                    return buff                    
                end
                
            end            
            
        end
        return false
        
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

    self.add = function(bp, roll)
        local bp    = bp or false
        local roll  = roll or false
        
        if bp and roll and type(roll) == 'table' and roll.en ~= 'Bust' then
            local count = self.getActive(bp)
            
            if not bp.helpers['rolls'].rolling and not bp.helpers['buffs'].buffActive(self.getBuff(bp, roll.en)) and count < 2 then
                self.active:push({roll=roll, dice=self.rolled})
            end

        elseif bp and roll and type(roll) == 'table' and roll.en == 'Bust' then
            self.active:push({roll=roll, dice=0})

        end
        
    end

    self.remove = function(bp, id)
        local bp = bp or false
        local id = id or false

        if bp and id then

            for i,v in ipairs(self.active.data) do
                local buff = bp.res.buffs[self.getBuff(bp, v.roll.en).id]
                
                if buff.id == id then
                    self.active:remove(i)
                end
            
            end

        end

    end

    self.getLucky = function(bp, name)
        local bp    = bp or false
        local name  = name or false

        if bp and name and type(name) == 'string' and name ~= '' then
            return lucky[name]
        end

    end

    self.hide = function()

        if self.display and self.display:visible() then
            self.display:hide()
        end

    end

    self.show = function()

        if self.display[i] and not self.display:visible() then
            self.display:show()
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
return rolls.new()
