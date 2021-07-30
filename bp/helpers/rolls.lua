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
    self.layout     = self.settings.layout or {pos={x=500, y=75}, colors={text={alpha=255, r=245, g=200, b=20}, bg={alpha=200, r=0, g=0, b=0}, stroke={alpha=255, r=0, g=0, b=0}}, font={name='Lucida Console', size=9}, padding=5, stroke_width=1, draggable=true}
    self.display    = texts.new('', {flags={draggable=self.layout.draggable}})
    self.important  = string.format('%s,%s,%s', 25, 165, 200)
    self.blink      = string.format('%s,%s,%s', 110, 235, 50)
    self.unlucky    = string.format('%s,%s,%s', 255, 0, 80)

    -- Public Variables.
    self.enabled    = false
    self.rolls      = self.settings.rolls or {self.allowed[109], self.allowed[105]}
    self.crooked    = self.settings.crooked or false
    self.cap        = self.settings.cap or 7
    self.last       = 0
    self.rolled     = 0
    self.rolling    = false
    self.active     = {false, false}

    -- Private Variables.
    local colors = {[true]=string.format('%s,%s,%s', 21, 184, 0), [false]=string.format('%s,%s,%s', 255, 0, 80)}
    local blink  = false
    local valid  = {309,310,311,312,313,314,315,316,317,318,319,320,321,322,323,324,325,326,327,328,329,330,331,332,333,334,335,336,337,338,339,600}
    local short  = {

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
        self.active = {false, false}
        self.enabled = false
    end

    self.jobChange = function()
        self.writeSettings()
        self.active = {false, false}
        resetDisplay()

    end

    -- Public Functions.
    self.setRoll = function(bp, dice1, dice2)
        local bp    = bp or false
        local dice1 = dice1 or false
        local dice2 = dice2 or false

        if bp then
            
            if dice1 then

                if type(dice1) == 'table' and dice1.id and self.allowed[dice1.id] and self.rolls[1].en ~= dice1.en and self.rolls[2].en ~= dice1.en then
                    self.rolls[1] = dice1

                elseif (type(dice1) == 'number' or tonumber(dice1) ~= nil) and self.allowed[dice1] and self.rolls[1].id ~= dice1 and self.rolls[2].id ~= dice1 then
                    self.rolls[1] = self.allowed[dice1]

                elseif type(dice1) == 'string' and bp.JA[dice1] and self.rolls[1].en:lower() ~= dice1 and self.rolls[2].en:lower() ~= dice1 then
                    self.rolls[1] = bp.JA[dice1]

                elseif type(dice1) == 'string' and short[dice1] and self.rolls[1].en ~= bp.JA[short[dice1]] and self.rolls[2].en ~= bp.JA[short[dice1]] then
                    self.rolls[1] = bp.JA[short[dice1]]

                end

            end

            if dice2 then

                if type(dice2) == 'table' and dice2.id and self.allowed[dice2.id] and self.rolls[1].en ~= dice2.en and self.rolls[2].en ~= dice2.en then
                    self.rolls[2] = dice2

                elseif (type(dice2) == 'number' or tonumber(dice2) ~= nil) and self.allowed[dice2] and self.rolls[1].id ~= dice2 and self.rolls[2].id ~= dice2 then
                    self.rolls[2] = self.allowed[dice2]

                elseif type(dice2) == 'string' and bp.JA[dice2] and self.rolls[1].en:lower() ~= dice2 and self.rolls[2].en:lower() ~= dice2 then
                    self.rolls[2] = bp.JA[dice2]

                elseif type(dice2) == 'string' and short[dice2] and self.rolls[1].en ~= bp.JA[short[dice2]] and self.rolls[2].en ~= bp.JA[short[dice2]] then
                    self.rolls[2] = bp.JA[short[dice2]]

                end

            end
            self.writeSettings()
            bp.helpers['popchat'].pop(string.format('ROLLS NOW TO: %s & %s.', self.rolls[1].en, self.rolls[2].en))

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

    end

    self.checkRolling = function(bp)

        if windower.ffxi.get_player().buffs then

            for _,v in ipairs(windower.ffxi.get_player().buffs) do
                    
                if v == 308 then
                    return true
                end

            end
            return false

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
                    
                elseif self.getShort(bp, name) then

                    if self.getShort(bp, name).en == v.en then
                        return v
                    end
                    
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

    self.add = function(bp, roll, rolled)
        local bp        = bp or false
        local roll      = roll or false
        local rolled    = rolled or false
        
        if bp and roll and rolled and type(roll) == 'table' and type(rolled) == 'number' then
            
            if not self.rolling and not bp.helpers['buffs'].buffActive(roll.id) then
                self.rolling = true

                if not self.active[1] and self.rolls[1].id == roll.id then

                    if rolled > 11 then
                        self.active[1]  = {roll=bp.res.buffs[309], dice=rolled}
                        self.rolling    = false
                        self.last       = 1

                    elseif (rolled == lucky[roll.en] or rolled == 11) then
                        self.active[1]  = {roll=roll, dice=rolled}
                        self.rolling    = false
                        self.last       = 1

                    elseif rolled >= self.cap then
                        self.active[1]  = {roll=roll, dice=rolled}
                        self.rolling    = false
                        self.last       = 1

                    else
                        self.active[1]  = {roll=roll, dice=rolled}
                        self.last       = 1

                    end

                elseif not self.active[2] and self.rolls[2].id == roll.id then
                    
                    if rolled > 11 then
                        self.active[2]  = {roll=bp.res.buffs[309], dice=rolled}
                        self.rolling    = false
                        self.last       = 2

                    elseif (rolled == lucky[roll.en] or rolled == 11) then
                        self.active[2]  = {roll=roll, dice=rolled}
                        self.rolling    = false
                        self.last       = 2

                    elseif rolled >= self.cap then
                        self.active[2]  = {roll=roll, dice=rolled}
                        self.rolling    = false
                        self.last       = 2

                    else
                        self.active[2]  = {roll=roll, dice=rolled}
                        self.last       = 2

                    end

                end

            elseif self.rolling and self.active[self.last] and self.active[self.last].roll.id == roll.id then
                    
                if rolled > 11 then
                    self.active[self.last] = {roll=bp.res.buffs[309], dice=rolled}
                    self.rolling = false

                elseif (rolled == lucky[roll.en] or rolled == 11) then
                    self.active[self.last] = {roll=roll, dice=rolled}
                    self.rolling = false

                elseif rolled >= self.cap then
                    self.active[self.last] = {roll=roll, dice=rolled}

                    if bp.core.getSetting('JA') and bp.helpers['actions'].isReady(bp, 'JA', 'Snake Eye') then
                        self.rolling = true

                    else
                        self.rolling = false

                    end

                else
                    self.active[self.last] = {roll=roll, dice=rolled}

                end

            end

        end
        
    end

    self.remove = function(bp, id)
        local bp = bp or false
        local id = id or false

        if bp and id and self.validBuff(bp, id) then
            
            if self.active[1] and self.getBuff(bp, self.active[1].roll.en).id == id then
                self.active[1] = false
        
            elseif self.active[2] and self.getBuff(bp, self.active[2].roll.en).id == id then
                self.active[2] = false

            end

        end

    end

    self.roll = function(bp)
        local bp = bp or false
        local player = windower.ffxi.get_player()

        if bp and #self.active <= 2 then
            
            if (not self.rolling and not self.active[1] and not bp.helpers['buffs'].buffActive(self.getBuff(bp, self.rolls[1].en).id)) or (self.active[1] and self.active[1].roll.id ~= self.rolls[1].id and self.active[1].roll.en ~= 'Bust' and not bp.helpers['buffs'].buffActive(self.getBuff(bp, self.rolls[1].en).id) and not bp.helpers['buffs'].buffActive(308)) then
                local roll = self.rolls[1] or false

                if roll and bp.helpers['actions'].isReady(bp, 'JA', roll.en) then

                    if self.crooked and bp.helpers['actions'].isReady(bp, 'JA', 'Crooked Cards') and not bp.helpers['buffs'].buffActive(601) then
                        bp.helpers['queue'].add(bp, bp.JA['Crooked Cards'], windower.ffxi.get_player())
                    end
                    bp.helpers['queue'].add(bp, bp.JA[roll.en], windower.ffxi.get_player())
                    
                end

            elseif (not self.rolling and not self.active[2] and not bp.helpers['buffs'].buffActive(self.getBuff(bp, self.rolls[2].en).id) and player.main_job == 'COR') or (self.active[2] and self.active[2].roll.id ~= self.rolls[2].id and self.active[2].roll.en ~= 'Bust' and not bp.helpers['buffs'].buffActive(self.getBuff(bp, self.rolls[2].en).id) and not bp.helpers['buffs'].buffActive(308)) and player.main_job == 'COR' then
                local roll = self.rolls[2] or false
            
                if roll and bp.helpers['actions'].isReady(bp, 'JA', roll.en) then
                    bp.helpers['queue'].add(bp, bp.JA[roll.en], windower.ffxi.get_player())
                end

            elseif not self.rolling and self.active[1] and not bp.helpers['buffs'].buffActive(self.getBuff(bp, self.rolls[1].en).id) and self.active[1].roll.en == 'Bust' and not bp.helpers['buffs'].buffActive(308) and not bp.helpers['buffs'].buffActive(309) then
                local roll = self.rolls[1] or false

                if roll and bp.helpers['actions'].isReady(bp, 'JA', roll.en) then

                    if self.crooked and bp.helpers['actions'].isReady(bp, 'JA', 'Crooked Cards') and not bp.helpers['buffs'].buffActive(601) then
                        bp.helpers['queue'].add(bp, bp.JA['Crooked Cards'], windower.ffxi.get_player())
                    end
                    bp.helpers['queue'].add(bp, bp.JA[roll.en], windower.ffxi.get_player())
                    
                end

            elseif not self.rolling and self.active[2] and not bp.helpers['buffs'].buffActive(self.getBuff(bp, self.rolls[2].en).id) and self.active[2].roll.en == 'Bust' and not bp.helpers['buffs'].buffActive(308) and not bp.helpers['buffs'].buffActive(309) and player.main_job == 'COR' then
                local roll = self.rolls[2] or false

                if roll and bp.helpers['actions'].isReady(bp, 'JA', roll.en) then
                    bp.helpers['queue'].add(bp, bp.JA[roll.en], windower.ffxi.get_player())                    
                end

            elseif self.rolling and self.active[1] and bp.helpers['buffs'].buffActive(308) and self.active[1].roll.en == self.rolls[1].en and self.active[1].roll.en ~= 'Bust' and self.active[1].dice <= self.cap then
                local roll = self.rolls[1] or false
                
                if roll and bp.helpers['actions'].isReady(bp, 'JA', 'Double-Up') then
                    bp.helpers['queue'].add(bp, bp.JA['Double-Up'], windower.ffxi.get_player())
                end

            elseif self.rolling and self.active[2] and bp.helpers['buffs'].buffActive(308) and self.active[2].roll.en == self.rolls[2].en and self.active[2].roll.en ~= 'Bust' and self.active[2].dice <= self.cap and player.main_job == 'COR' then
                local roll = self.rolls[2] or false
                
                if roll and bp.helpers['actions'].isReady(bp, 'JA', 'Double-Up') then
                    bp.helpers['queue'].add(bp, bp.JA['Double-Up'], windower.ffxi.get_player())
                end

            elseif self.rolling and self.active[1] and bp.helpers['buffs'].buffActive(308) and self.active[1].roll.en == self.rolls[1].en and self.active[1].roll.en ~= 'Bust' and self.active[1].dice < 11 and self.active[1].dice > self.cap and bp.helpers['actions'].isReady(bp, 'JA', 'Snake Eye') then
                local roll = self.rolls[1] or false
                
                if roll and bp.helpers['actions'].isReady(bp, 'JA', 'Double-Up') then
                    bp.helpers['queue'].add(bp, bp.JA['Snake Eye'], windower.ffxi.get_player())
                    bp.helpers['queue'].add(bp, bp.JA['Double-Up'], windower.ffxi.get_player())
                end

            elseif self.rolling and self.active[2] and bp.helpers['buffs'].buffActive(308) and self.active[2].roll.en == self.rolls[2].en and self.active[2].roll.en ~= 'Bust' and self.active[2].dice < 11 and self.active[2].dice > self.cap and bp.helpers['actions'].isReady(bp, 'JA', 'Snake Eye') and player.main_job == 'COR' then
                local roll = self.rolls[2] or false
                
                if roll and bp.helpers['actions'].isReady(bp, 'JA', 'Double-Up') then
                    bp.helpers['queue'].add(bp, bp.JA['Snake Eye'], windower.ffxi.get_player())
                    bp.helpers['queue'].add(bp, bp.JA['Double-Up'], windower.ffxi.get_player())
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

    self.render = function(bp)
        local bp        = bp or false
        local player    = windower.ffxi.get_player()
        local render    = {}
        local trigger   = false
        local count     = 1

        if (player.main_job == 'COR' or player.sub_job == 'COR') then
            table.insert(render, string.format('Corsair Rolls - Status: [ \\cs(%s)%s\\cr ]', colors[self.enabled], tostring(self.enabled):upper()))

            if player.main_job == 'COR' then
                table.insert(render, string.format('\\cs(%s)Crooked Cards\\cr | \\cs(%s)Rolling\\cr\n', colors[self.crooked], colors[self.rolling]))
                count = 2
            
            elseif player.sub_job == 'COR' then
                table.insert(render, string.format('\\cs(%s)Rolling\\cr\n', colors[self.rolling]))
                count = 1

            end

            for i=1, count do

                if self.active[i] then

                    if blink and (self.active[i].dice == 11 or self.active[i].dice == lucky[self.active[i].roll.en]) then
                        table.insert(render, string.format('Roll #%d ► \\cs(%s)[%02d] %s\\cr', i, self.blink, self.active[i].dice, self.active[i].roll.en))
                        trigger = true

                    elseif (self.active[i].dice == unlucky[self.active[i].roll.en] or self.active[i].dice > 11) then
                        table.insert(render, string.format('Roll #%d ► \\cs(%s)[%02d] %s\\cr', i, self.unlucky, self.active[i].dice, self.active[i].roll.en))

                    else
                        table.insert(render, string.format('Roll #%d ► \\cs(%s)[%02d] %s\\cr', i, self.important, self.active[i].dice, self.active[i].roll.en))

                    end

                elseif self.rolls[i] then
                    table.insert(render, string.format('Roll #%d ► \\cs(%s)%s\\cr', i, self.unlucky, self.rolls[i].en))

                end

            end

            if render then
                self.display:text(table.concat(render, '\n'))
                self.display:update()

                if not self.display:visible() and #self.active > 0 then
                    self.display:show()
                end

            end

            if not trigger then
                blink = true
            else
                blink = false            
            end

        elseif self.display:visible() then
            self.display:text('')
            self.display:update()
            self.display:hide()

        end
        self.checkRolling()

    end

    self.toggle = function(bp)
        local bp = bp or false

        if bp then

            if self.enabled then
                self.enabled = false

            else
                self.enabled = true

            end
            bp.helpers['popchat'].pop(string.format('CORSAIR ROLLS: %s', tostring(self.enabled)))

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
