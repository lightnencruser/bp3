local assist   = {}
local player    = windower.ffxi.get_player()
local files     = require('files')
local texts     = require('texts')
local images    = require('images')
local f = files.new(string.format('bp/helpers/settings/assist/%s_settings.lua', player.name))

if not f:exists() then
  f:write(string.format('return %s', T({}):tovstring()))
end

function assist.new()
    local self = {}

    -- Static Variables.
    self.settings       = dofile(string.format('%sbp/helpers/settings/assist/%s_settings.lua', windower.addon_path, player.name))
    self.layout         = self.settings.layout or {pos={x=500, y=350}, colors={text={alpha=255, r=245, g=200, b=20}, bg={alpha=200, r=0, g=0, b=0}, stroke={alpha=255, r=0, g=0, b=0}}, font={name='Lucida Console', size=9}, padding=4, stroke_width=1, draggable=true}
    self.display        = texts.new('', {flags={draggable=self.layout.draggable}})
    self.important      = string.format('%s,%s,%s', 25, 165, 200)

    -- Private Variables.
    local bp            = false
    local private       = {events={}, assist=false, engage=false, icon=images.new({color={alpha = 255}, texture={fit=false}, draggable=false})}
    local timer         = {last=0, delay=0.75}

    -- Private Functions
    local persist = function()
        local next = next

        if self.settings then
            self.settings.layout = self.layout

        end

    end
    persist()
    private.icon:path(string.format("%sbp/resources/icons/buffs/532.png", windower.addon_path))

    -- Update Icon Color.
    if private.engage then
        private.icon:color(255,255,255)

    else
        private.icon:color(100,100,100)

    end

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

    -- Public Functions.
    self.setSystem = function(buddypal)
        if buddypal then
            bp = buddypal
        end

    end
    
    private.act = function()
        
        if bp and bp.player and private.assist and bp.player.status == 0 and private.assist.status == 1 then
            local ally = windower.ffxi.get_mob_by_id(private.assist.id) or false

            if ally and (ally.distance):sqrt() < 25 and (ally.distance):sqrt() ~= 0 then

                if ally.target_index then
                    local mob = windower.ffxi.get_mob_by_index(ally.target_index)
                    
                    if mob and bp.helpers['target'].canEngage(mob) then
                        bp.helpers['target'].setTarget(mob)
                    end

                end

            end

        end

    end

    private.engaging = function()
        private.engage = private.engage ~= true and true or false

        if private.engage then
            private.icon:color(255,255,255)

        else
            private.icon:color(100,100,100)

        end

    end

    private.set = function(target)
        local target = target or false
        
        if bp and bp.player and target then
            local player = bp.player

            if target.id and target.id ~= player.id and bp.helpers['party'].isInParty(target, true) then
                
                if (os.clock()-timer.last) < timer.delay then
                    windower.send_ipc_message(string.format('assist:::%s', target.id))
                
                else
                    private.assist = target

                end

            elseif target.id and target.id == player.id then
                private.assist = false

            elseif bp and not target then
                private.assist = false

            end
            timer.last = os.clock()

        end

    end

    private.catch = function(message)

        if bp and bp.player and message then
            local player = bp.player
            local message = string.split(message, ':::') or false

            if message and player and message[1] and message[1] == 'assist' then
                local target = windower.ffxi.get_mob_by_id(message[2])

                if target then

                    if target.id and target.id ~= player.id and bp.helpers['party'].isInParty(target, true) and (target.distance):sqrt() < 15 then
                        private.assist = target

                    elseif target.id and target.id == player.id then
                        private.assist = false

                    end

                elseif not target then
                    private.assist = false

                end

            end
            
        end

    end

    private.render = function()

        if bp then
            
            if bp.hideUI then
            
                if self.display:visible() then
                    self.display:hide()
                    private.icon:hide()
                end
                return
    
            end

            if private.assist then
                self.display:text(string.format('[ ASSISTING: \\cs(%s)%s\\cr ]', self.important, private.assist.name:upper()))
                self.display:update()

                local x, y = self.display:extents()
                if not self.display:visible() then
                    self.display:show()
                    private.icon:show()
                    private.icon:pos((self.display:pos_x()-1) - y, self.display:pos_y())

                    if private.icon:height() ~= y then
                        private.icon:size(y, y)
                    end

                elseif private.icon:visible() then
                    private.icon:pos((self.display:pos_x()-1) - y, self.display:pos_y())

                    if private.icon:height() ~= y then
                        private.icon:size(y, y)
                    end

                end
                private.icon:update()

            elseif not private.assist then
                self.display:text(string.format('[ ASSISTING: \\cs(%s)NONE\\cr ]', self.important))
                self.display:update()

                local x, y = self.display:extents()
                if not self.display:visible() then
                    self.display:show()
                    private.icon:show()
                    private.icon:pos((self.display:pos_x()-1) - y, self.display:pos_y())

                    if private.icon:height() ~= y then
                        private.icon:size(y, y)
                    end

                elseif private.icon:visible() then
                    private.icon:pos((self.display:pos_x()-1) - y, self.display:pos_y())

                    if private.icon:height() ~= y then
                        private.icon:size(y, y)
                    end

                end
                private.icon:update()

            end

        end

    end

    self.pos = function(x, y)
        local x = tonumber(x) or self.layout.pos.x
        local y = tonumber(y) or self.layout.pos.y

        if bp and x and y then
            self.display:pos(x, y)
            self.layout.pos.x = x
            self.layout.pos.y = y
            self.writeSettings()
        
        elseif bp and (not x or not y) then
            bp.helpers['popchat'].pop('PLEASE ENTER AN "X" OR "Y" COORDINATE!')

        end

    end

    -- Private Events.
    private.events.commands = windower.register_event('addon command', function(...)
        local a = T{...}
        local c = a[1] or false
    
        if c and c == 'assist' then
            local command = a[2] or false

            if command then
                command = command:lower()
            
                if command == 'pos' and a[3] then
                    private.pos(a[3], a[4] or false)

                elseif command == 'engage' then
                    private.engaging()

                end
            
            elseif not command then
                private.set(windower.ffxi.get_mob_by_target('t') or false)

            end

        end
        

    end)

    private.events.prerender = windower.register_event('prerender', function()
        private.render()

    end)

    private.events.ipc = windower.register_event('ipc message', function(message)
            
        if message and message:sub(1,6) == 'assist' then
            private.catch(message)    
        end
    
    end)

    private.events.timechange = windower.register_event('time change', function(new, old)
        private.act()

        if bp and private.engage and private.assist then
            local target = bp.helpers['target'].getTarget()

            if target and bp.player.status == 0 and bp.helpers['target'].canEngage(target) then
                bp.helpers['actions'].engage(target)
            end

        end
    
    end)

    private.events.mouse = windower.register_event('mouse', function(param, x, y, delta, blocked)
        
        if private.icon:hover(x, y) then

            if param == 1 then
                private.engaging()
                return true

            elseif param == 2 then
                return true

            end

        end

    end)

    return self

end
return assist.new()
