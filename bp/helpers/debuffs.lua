local debuffs   = {}
local player    = windower.ffxi.get_player()
local files     = require('files')
local texts     = require('texts')
local res       = require('resources')
local f = files.new(string.format('bp/helpers/settings/debuffs/%s_settings.lua', player.name))

if not f:exists() then
  f:write(string.format('return %s', T({}):tovstring()))
end

function debuffs.new()
    local self = {}

    -- Private Variables.
    local bp            = false
    local private       = {events={}}

    -- Static Variables.
    self.settings       = dofile(string.format('%sbp/helpers/settings/debuffs/%s_settings.lua', windower.addon_path, player.name))
    self.layout         = self.settings.layout or {pos={x=300, y=400}, colors={text={alpha=255, r=100, g=215, b=0}, bg={alpha=0, r=0, g=0, b=0}, stroke={alpha=255, r=0, g=25, b=15}}, font={name='Lucida Console', size=8}, padding=2, stroke_width=2, draggable=false}
    self.update         = self.settings.update or {delay=2, last=0}
    self.display        = texts.new('', {flags={draggable=self.layout.draggable}})

    -- Public Variables.
    self.debuffs        = self.settings.debuffs or {}
    self.update.last    = 0

    -- Private Functions
    private.persist = function()

        if self.settings then
            self.settings.debuffs = self.debuffs
            self.settings.layout  = self.layout

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
        self.display:hide()
        self.display:update()

    end
    private.resetDisplay()

    -- Private Functions.
    private.writeSettings = function()
        private.persist()

        if f:exists() then
            f:write(string.format('return %s', T(self.settings):tovstring()))

        elseif not f:exists() then
            f:write(string.format('return %s', T({}):tovstring()))

        end

    end
    private.writeSettings()

    private.clear = function()

        if bp and bp.player and self.debuffs[bp.player.main_job_id] then
            helpers['popchat'].pop(string.format('Clearing all debuffs from %s!', res.jobs[player.main_job_id].en))
            self.debuffs[bp.player.main_job_id] = {}
            private.writeSettings()

        end

    end

    private.reset = function(spell)
        
        if not spell then

            if bp and bp.player and self.debuffs[bp.player.main_job_id] then

                for i in pairs(self.debuffs[bp.player.main_job_id]) do
                    self.debuffs[bp.player.main_job_id][i].last = 0
                end

            end

        else

            if bp and bp.player and self.debuffs[bp.player.main_job_id] then

                if type(spell) == 'table' and spell.id then

                    for _,v in pairs(self.debuffs[bp.player.main_job_id]) do
                        
                        if v.id == spell.id then
                            v.last = 0
                            break

                        end

                    end

                elseif tonumber(spell) ~= nil then

                    for _,v in pairs(self.debuffs[bp.player.main_job_id]) do
                        
                        if v.id == spell then
                            v.last = 0
                            break

                        end

                    end

                end

            end

        end

    end
    private.reset()

    private.getDelay = function(spell)

        if bp and spell and type(spell) == 'table' then
            local player = windower.ffxi.get_player()

            if self.debuffs[player.main_job_id] then

                for _,v in pairs(self.debuffs[player.main_job_id]) do

                    if v.delay and v.id and spell.id and v.id == spell.id then
                        return v.delay
                    end

                end

            end

        elseif bp and spell and (type(spell) == 'string' or type(spell) == 'number') and tonumber(spell) ~= nil then
            local player = windower.ffxi.get_player()

            if self.debuffs[player.main_job_id] then

                for _,v in pairs(self.debuffs[player.main_job_id]) do

                    if v.delay and v.id and v.id == spell then
                        return v.delay
                    end

                end

            end

        elseif bp and spell and type(spell) == 'string' and tonumber(spell) == nil then
            local player = windower.ffxi.get_player()

            if self.debuffs[player.main_job_id] then

                for _,v in pairs(self.debuffs[player.main_job_id]) do

                    if v.delay and v.name and v.name == spell then
                        return v.delay
                    end

                end

            end

        end
        return false

    end

    private.render = function()
        
        if bp and bp.helpers['target'].getTarget() and (os.clock()-self.update.last) > self.update.delay then
            local player    = bp.player
            local helpers   = bp.helpers
            local next      = next
            local math      = math
            
            if self.debuffs[player.main_job_id] and self.debuffs[player.main_job_id][T(self.debuffs):length()] ~= nil then
                local update = {}

                for _,spell in pairs(self.debuffs[player.main_job_id]) do
                    local timer     = (spell.delay-(os.clock()-spell.last)) > 0 and (spell.delay-(os.clock()-spell.last)) or 0
                    local color     = string.format('%s,%s,%s', math.abs(self.layout.colors.text.r/0.2), math.abs(self.layout.colors.text.g/0.2), math.abs(self.layout.colors.text.b/0.2))
                    
                    if color and timer and spell then
                        table.insert(update, string.format(' \\cs(%s)%s[%.1f]\\cr: %s', color, (''):rpad(' ', (7-#tostring(math.floor(timer)))), timer, spell.name))
                    end

                end

                if update and next(update) ~= nil then
                    self.display:text(table.concat(update, '\n'))
                    self.display:update()

                    if not self.display:visible() then
                        self.display:show()
                    end

                end

            elseif self.debuffs[player.main_job_id] and self.debuffs[player.main_job_id][T(self.debuffs):length()] == nil then
                self.display:text('')
                self.display:update()

                if self.display:visible() then
                    self.display:hide()
                end

            end
            self.update.last = os.clock()

        elseif not bp.helpers['target'].getTarget() and os.clock()-self.update.last > self.update.delay then
            local next = next

            if self.display:visible() then
                self.display:hide()

            end
            self.update.last = os.clock()

        end

    end

    private.exists = function(spell)

        if bp and spell and type(spell) == 'table' then
            local player = windower.ffxi.get_player()

            if self.debuffs[player.main_job_id] then

                for _,v in pairs(self.debuffs[player.main_job_id]) do

                    if v.id == spell.id then
                        return true
                    end

                end

            end

        elseif bp and spell and (type(spell) == 'string' or type(spell) == 'number') and tonumber(spell) ~= nil then
            local player = windower.ffxi.get_player()

            if self.debuffs[player.main_job_id] then

                for _,v in pairs(self.debuffs[player.main_job_id]) do

                    if v.delay and v.id and v.id == spell then
                        return true
                    end

                end

            end

        elseif bp and spell and type(spell) == 'string' and tonumber(spell) == nil then
            local player = windower.ffxi.get_player()

            if self.debuffs[player.main_job_id] then

                for _,v in pairs(self.debuffs[player.main_job_id]) do

                    if v.delay and v.name and v.name == spell then
                        return true
                    end

                end

            end

        end
        return false

    end

    private.cast = function()

        if bp and bp.core.get('debuffs') then
            local player = bp.player

            if self.debuffs[player.main_job_id] and self.debuffs[player.main_job_id][T(self.debuffs):length()] ~= nil then
                
                for _,spell in pairs(self.debuffs[player.main_job_id]) do
                    local timer     = (spell.delay-(os.clock()-spell.last)) > 0 and (spell.delay-(os.clock()-spell.last)) or 0
                    local target    = bp.helpers['target'].getTarget()

                    if target and timer <= 0 and not bp.helpers['queue'].inQueue(spell) and bp.helpers['actions'].isReady('MA', spell.name) and bp.helpers['target'].castable(target, bp.MA[spell.name]) then
                        bp.helpers['queue'].add(bp.MA[spell.name], target)
                    end

                end

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

    self.cast = function()
        private.cast()
    end

    self.reset = function()
        private.reset()
    end

    self.add = function(spell, delay)
        local delay = delay or 180

        if bp and bp.player and spell and type(spell) == 'table' and tonumber(delay) ~= nil then
            local player = bp.player

            if spell and self.debuffs[player.main_job_id] and not private.exists(spell) then
                table.insert(self.debuffs[player.main_job_id], {id=spell.id, name=spell.en, delay=delay, last=0})
                helpers['popchat'].pop(string.format('Adding %s to debuffs list.', spell.en))

            elseif spell and not private.exists(spell) then
                self.debuffs[player.main_job_id] = {}
                table.insert(self.debuffs[player.main_job_id], {id=spell.id, name=spell.en, delay=delay, last=0})
                helpers['popchat'].pop(string.format('Adding %s to debuffs list.', spell.en))

            end

        elseif bp and bp.player and spell and (type(spell) == 'number' or type(spell) == 'string') and tonumber(spell) ~= nil and tonumber(delay) ~= nil then
            local player = bp.player
            local spell = res.spells[tonumber(spell)]

            if spell and self.debuffs[player.main_job_id] and not private.exists(spell) then
                table.insert(self.debuffs[player.main_job_id], {id=spell.id, name=spell.en, delay=delay, last=0})
                helpers['popchat'].pop(string.format('Adding %s to debuffs list.', spell.en))

            elseif spell and not private.exists(spell) then
                self.debuffs[player.main_job_id] = {}
                table.insert(self.debuffs[player.main_job_id], {id=spell.id, name=spell.en, delay=delay, last=0})
                helpers['popchat'].pop(string.format('Adding %s to debuffs list.', spell.en))

            end

        elseif bp and bp.player and spell and type(spell) == 'string' then
            local player = bp.player
            local spell = bp.MA[spell]

            if spell and self.debuffs[player.main_job_id] and not private.exists(spell) then
                table.insert(self.debuffs[player.main_job_id], {id=spell.id, name=spell.en, delay=delay, last=0})
                bp.helpers['popchat'].pop(string.format('Adding %s to debuffs list.', spell.en))

            elseif spell and not private.exists(spell) then
                self.debuffs[player.main_job_id] = {}
                table.insert(self.debuffs[player.main_job_id], {id=spell.id, name=spell.en, delay=delay, last=0})
                bp.helpers['popchat'].pop(string.format('Adding %s to debuffs list.', spell.en))

            end

        end

    end

    self.remove = function(spell)

        if bp and spell and type(spell) == 'table' then
            local player  = bp.player
            local helpers = bp.helpers

            if player and helpers then

                for i,v in pairs(self.debuffs[player.main_job_id]) do

                    if v.id == spell.id and private.exists(spell) then
                        local removed = table.remove(self.debuffs[player.main_job_id], i)

                        if removed then
                            helpers['popchat'].pop(string.format('Removing %s to debuffs list.', res.spells[spell.id].en))
                            return removed

                        end

                    end

                end

            end

        elseif bp and spell and (type(spell) == 'number' or type(spell) == 'string') and tonumber(spell) ~= nil then
            local player  = bp.player
            local helpers = bp.helpers

            if player and helpers and res.spells[spell] then
                local spell = res.spells[spell]

                for i,v in pairs(self.debuffs[player.main_job_id]) do

                    if v.id == spell.id and private.exists(spell) then
                        local removed = table.remove(self.debuffs[player.main_job_id], i)

                        if removed then
                            helpers['popchat'].pop(string.format('Removing %s to debuffs list.', res.spells[spell.id].en))
                            return removed

                        end

                    end

                end

            end

        elseif bp and spell and type(spell) == 'string' then
            local player  = bp.player
            local helpers = bp.helpers

            if player and helpers and bp.MA[spell] then
                local spell = bp.MA[spell]

                for i,v in pairs(self.debuffs[player.main_job_id]) do

                    if v.id == spell.id and private.exists(spell) then
                        local removed = table.remove(self.debuffs[player.main_job_id], i)

                        if removed then
                            helpers['popchat'].pop(string.format('Removing %s to debuffs list.', res.spells[spell.id].en))
                            return removed

                        end

                    end

                end

            end

        end

    end

    -- Private Events.
    private.events.commands = windower.register_event('addon command', function(...)
        local commands = T{...}
        local helper = commands[1] or false

        if helper and helper == 'debuffs' then
            table.remove(commands, 1)
        
            if commands[1] then
                local command = commands[1]:lower()

                if command then
                    local target = windower.ffxi.get_mob_by_target('t') or false

                    if command == '+' and commands[2] then
                        local spell = {}
                        local delay = tonumber(commands[#commands]) or 180

                        for i=2, #commands do

                            if commands[i] and tonumber(commands[i]) == nil then
                                table.insert(spell, commands[i])
                            end

                        end
                        self.add(table.concat(spell, ' '), delay)

                    elseif command == '-' and commands[2] then
                        self.remove(table.concat(commands, ' '):sub(11))

                    elseif command == 'reset' then
                        private.reset()

                    elseif command == 'clear' then
                        private.clear()

                    elseif command == 'show' then
                        self.display:show()

                    elseif command == 'hide' then
                        self.display:hide()

                    elseif command == 'pos' and commands[2] then
                        private.pos(commands[2], commands[3] or false)

                    end

                end

            else
                windower.send_command('bp set debuffs')

            end
            private.writeSettings()

        end
        

    end)

    private.events.prerender = windower.register_event('prerender', function()
        private.render()
    
    end)

    private.events.statuschange = windower.register_event('status change', function(new, old)
        
        if new == 0 then
            private.reset()
        end
    
    end)

    private.events.actions = windower.register_event('incoming chunk', function(id, original, modified, injected, blocked)
        
        if bp and id == 0x028 then
            local pack      = bp.packets.parse('incoming', original)
            local player    = bp.player
            local actor     = windower.ffxi.get_mob_by_id(pack['Actor'])
            local target    = windower.ffxi.get_mob_by_id(pack['Target 1 ID'])
            local category  = pack['Category']
            local param     = pack['Param']
            
            if player and actor and target then

                -- Finish Casting.
                if pack['Category'] == 4 and actor.id == player.id and bp.res.spells[param] and self.debuffs[player.main_job_id] and private.exists(bp.res.spells[param]) then
                    local spell = bp.res.spells[param]

                    for _,v in ipairs(self.debuffs[player.main_job_id]) do

                        if spell.id == v.id then
                            v.last = os.clock()
                            break
                        
                        end

                    end

                end
    
            end
    
        end
        
    end)

    private.events.commands = windower.register_event('time change', function(new, old)

        if bp and bp.core and bp.core.get('debuffs') then

            if bp.player and bp.player.main_job ~= 'RDM' then
                private.cast()
            end

        end

    end)

    return self

end
return debuffs.new()
