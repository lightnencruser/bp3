local stratagems    = {}
local player        = windower.ffxi.get_player()
local files         = require('files')
local texts         = require('texts')
local images        = require('images')
local res           = require('resources')
local f = files.new(string.format('bp/helpers/settings/stratagems/%s_settings.lua', player.name))

if not f:exists() then
    f:write(string.format('return %s', T({}):tovstring()))
end

function stratagems.new()
    local self = {}

    -- Static Variables.
    self.settings       = dofile(string.format('%sbp/helpers/settings/stratagems/%s_settings.lua', windower.addon_path, player.name))
    self.layout         = self.settings.layout or {pos={x=100, y=800}, colors={text={alpha=255, r=245, g=200, b=20}, bg={alpha=0, r=0, g=0, b=0}, stroke={alpha=255, r=0, g=0, b=0}}, font={name='Impact', size=12}, padding=5, stroke_width=2, draggable=true}
    self.display        = texts.new('', {flags={draggable=self.layout.draggable}})
    self.important      = self.settings.important or string.format('%s,%s,%s', 25, 165, 200)

    -- Private Variables.
    local bp            = false
    local private       = {events={}}
    local icon          = images.new({color={alpha = 255},texture={fit = false},draggable=false})
    local recharge      = 0
    local math          = math
    local icon_offset   = {x=15,y=13}
    local wp            = {last=2, delay=60}

    -- Public Variables.
    self.gems           = {current=0, max=0}

    -- Private Functions.
    local persist = function()
        local next = next

        if self.settings then
            self.settings.layout    = self.layout
            self.settings.important = self.important

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

        if icon then
            icon:path(string.format("%sbp/resources/icons/buffs/62.png", windower.addon_path))
            icon:size(32, 32)
            icon:transparency(0)
            icon:pos_x(self.layout.pos.x-7)
            icon:pos_y(self.layout.pos.y+2)

        end

    end
    resetDisplay()

    -- Static Functions.
    self.writeSettings = function()

        if (os.clock()-wp.last) > wp.delay then
            persist()

            if f:exists() then
                f:write(string.format('return %s', T(self.settings):tovstring()))

            elseif not f:exists() then
                f:write(string.format('return %s', T({}):tovstring()))
            end
            wp.last = os.clock()

        end

    end
    self.writeSettings()

    private.zoneChange = function()
        self.writeSettings()
    end

    private.jobChange = function()
        self.writeSettings()
        resetDisplay()

    end

    private.render = function()

        if bp and bp.hideUI then
            
            if self.display:visible() then
                self.display:hide()
                icon:hide()
            end
            return

        end

        if bp and bp.player then

            if self.display:visible() then
                local timer = windower.ffxi.get_ability_recasts()[231] or 0
                local current = ((self.gems.max-math.ceil(timer/recharge)))

                do  
                    self.gems.current = current > -math.huge and current < math.huge and current or 0
                    self.display:text(tostring(self.gems.current))
                    self.display:update()

                end

            elseif not self.display:visible() and (bp.player.main_job == 'SCH' or bp.player.sub_job == 'SCH') then
                self.display:show()

                if not icon:visible() then
                    icon:show()
                end

            end

        end

    end

    private.calculate = function()

        if bp and bp.player and bp.player.main_job and bp.player.sub_job then
            local main = {job=bp.player.main_job, lvl=bp.player.main_job_level}
            local sub = {job=bp.player.sub_job, lvl=bp.player.sub_job_level}

            if main.job == 'SCH' then
            
                if (main.lvl >= 10 and main.lvl <= 29) then
                    self.gems.max, recharge = 1, 240

                elseif (main.lvl >= 30 and main.lvl <= 49) then
                    self.gems.max, recharge = 2, 120

                elseif (main.lvl >= 50 and main.lvl <= 69) then
                    self.gems.max, recharge = 3, 80

                elseif (main.lvl >= 70 and main.lvl <= 89) then
                    self.gems.max, recharge = 4, 60

                elseif (main.lvl >= 90 and main.lvl < 99) then
                    self.gems.max, recharge = 5, 48
                        
                elseif main.lvl == 99 then

                    if bp.player['job_points'][main.job:lower()].jp_spent >= 550 then
                        self.gems.max, recharge = 5, 33

                    else
                        self.gems.max, recharge = 5, 48

                    end
                        
                end
                
            elseif sub.job == 'SCH' then
                
                if (sub.lvl >= 10 and sub.lvl <= 29) then
                    self.gems.max, recharge = 1, 240

                elseif (sub.lvl >= 30 and sub.lvl <= 49) then
                    self.gems.max, recharge = 2, 120

                elseif (sub.lvl >= 50 and sub.lvl <= 69) then
                    self.gems.max, recharge = 3, 80

                end            
                    
            else
                self.gems.max, recharge = 0, 255
                    
            end

        end
    
    end

    -- Public Functions.
    self.setSystem = function(buddypal)
        if buddypal then
            bp = buddypal
        end

    end

    self.updatePosition = function(x, y)
        self.display:pos(x, y)
        icon:pos(x-icon_offset.x, y-icon_offset.y)
        self.display:update()
        self.layout.pos.x = x
        self.layout.pos.y = y
        icon:update()
        
    end

    -- Private Events.
    private.events.prerender = windower.register_event('prerender', function()
        private.render()

    end)

    private.events.login = windower.register_event('login', function()
        coroutine.schedule(function()
            private.calculate()

        end, 1)

    end)

    private.events.load = windower.register_event('load', function()
        coroutine.schedule(function()
            private.calculate()
            
        end, 0.5)

    end)

    private.events.jobchange = windower.register_event('job change', function(new, old)
        private.jobChange()
    
    end)

    private.events.zonechange = windower.register_event('zone change', function(new, old)
        private.zoneChange()
    
    end)

    private.events.actions = windower.register_event('incoming chunk', function(id, original, modified, injected, blocked)
        
        if bp and id == 0x028 then
            local parsed    = bp.packets.parse('incoming', original)
            local player    = bp.player
            local actor     = windower.ffxi.get_mob_by_id(parsed['Actor'])
            local target    = windower.ffxi.get_mob_by_id(parsed['Target 1 ID'])
            local category  = parsed['Category']
            local param     = parsed['Param']
            
            if player and actor and target then

                if parsed['Category'] == 6 and actor.id == player.id then
                    private.calculate()
                end
    
            end
    
        end
        
    end)

    return self

end
return stratagems.new()