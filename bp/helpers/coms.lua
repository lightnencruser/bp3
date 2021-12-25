local coms      = {}
local player    = windower.ffxi.get_player()
local files     = require('files')
local texts     = require('texts')
local f = files.new(string.format('bp/helpers/settings/coms/%s_settings.lua', player.name))

if not f:exists() then
  f:write(string.format('return %s', T({}):tovstring()))
end

function coms.new()
    local self = {}

    -- Static Variables.
    self.settings   = dofile(string.format('%sbp/helpers/settings/coms/%s_settings.lua', windower.addon_path, player.name))
    self.layout     = self.settings.layout or {pos={x=500, y=350}, colors={text={alpha=255, r=245, g=200, b=20}, bg={alpha=200, r=0, g=0, b=0}, stroke={alpha=255, r=0, g=0, b=0}}, font={name='Lucida Console', size=8}, padding=3, stroke_width=1, draggable=true}
    self.display    = texts.new('', {flags={draggable=self.layout.draggable}})
    self.important  = string.format('%s,%s,%s', 25, 165, 200)

    -- Private Variables.
    local bp        = false
    local private   = {events={}}
    local actions   = {}
    local timer     = {last=0, decay=10}

    -- Public Variables.
    self.enabled    = true    

    -- Private Functions
    private.persist = function()

        if self.settings then
            self.settings.enabled   = self.enabled
            self.settings.layout    = self.layout

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

    end
    private.resetDisplay()

    private.writeSettings = function()
        private.persist()

        if f:exists() then
            f:write(string.format('return %s', T(self.settings):tovstring()))

        elseif not f:exists() then
            f:write(string.format('return %s', T({}):tovstring()))

        end

    end
    private.writeSettings()

    private.render = function()

        if self.enabled then
            local update = {}

            if (os.clock()-timer.last) < timer.decay then

                for _,v in pairs(actions) do
                    table.insert(update, v)
                end
                self.display:text(table.concat(update, '\n'))
                self.display:update()

                if not self.display:visible() then
                    self.display:show()
                end


            else
                self.display:text('')
                self.display:update()
                self.display:hide()
                actions = {}

            end

        elseif not self.enabled and self.display:visible() then
            self.display:text('')
            self.display:update()
            self.display:hide()

        end

    end

    private.receive = function(message)

        if message then
            message = message:split(':::')

            if message and message[1] == 'coms' then
                local name      = message[2]
                local action    = message[3]
                local attempts  = message[4] or 1
                
                if name and action then
                    actions[name]   = string.format('%s:%s► [ \\cs(%s)%s (%s)\\cr ]', name:upper(), (''):rpad('-', (20-name:len())), self.important, action, attempts)
                    timer.last      = os.clock()
                    
                end

            end

        end

    end

    -- Public Functions.
    self.setSystem = function(buddypal)
        if buddypal then
            bp = buddypal
        end

    end
    
    self.send = function(action, name, attempts)
        local attempts = attempts or 1

        if bp and action and name and attempts then
            windower.send_ipc_message(string.format('coms:::%s:::%s:::%s', name, action.en, attempts))
        end

    end

    self.pos = function(x, y)
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
    
    -- Private Events.
    private.events.commands = windower.register_event('addon command', function(...)
        local commands = T{...}
        local helper = commands[1] or false

        if bp and helper and helper == 'coms' then
            table.remove(commands, 1)
            
            if commands[1] then
                local command = commands[1]:lower()

                if command == 'pos' and commands[2] then
                    self.pos(commands[2], commands[3] or false)
                end
    
            else
                self.enabled = self.enabled ~= true and true or false
                bp.helpers['popchat'].pop(string.format('COMS ENABLED: %s', tostring(self.enabled)))
    
            end
            private.writeSettings()

        end

    end)

    private.events.prerender = windower.register_event('prerender', function()
        private.render()        
    end)

    private.events.jobchange = windower.register_event('job change', function()
        private.resetDisplay()        
    end)

    private.events.ipc = windower.register_event('ipc message', function(message)

        if message and message:sub(1,4) == 'coms' then
            private.receive(message)
        end
    
    end)

    return self

end
return coms.new()
