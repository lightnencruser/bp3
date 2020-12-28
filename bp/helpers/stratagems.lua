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
    self.settings   = dofile(string.format('%sbp/helpers/settings/stratagems/%s_settings.lua', windower.addon_path, player.name))
    self.layout     = self.settings.layout or {pos={x=100, y=800}, colors={text={alpha=255, r=245, g=200, b=20}, bg={alpha=0, r=0, g=0, b=0}, stroke={alpha=255, r=0, g=0, b=0}}, font={name='Impact', size=12}, padding=5, stroke_width=2, draggable=true}
    self.display    = texts.new('', {flags={draggable=self.layout.draggable}})
    self.important  = self.settings.important or string.format('%s,%s,%s', 25, 165, 200)

    -- Public Variables.
    self.gems       = {current=0, max=0}

    --Private Variables.
    local icon          = images.new({color={alpha = 255},texture={fit = false},draggable=false})
    local recharge      = 0
    local math          = math
    local icon_offset   = {x=15,y=13}
    local wp            = {last=2, delay=60}

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
            icon:path(string.format("%sbp/resources/icons/stratagems/stratagems.png", windower.addon_path))
            icon:size(50, 50)
            icon:transparency(0)
            icon:pos_x(self.layout.pos.x-icon_offset.x)
            icon:pos_y(self.layout.pos.y-icon_offset.y)
            icon:show()

        end

        do -- Handle job sepcifics.
            local player = windower.ffxi.get_player()

            if (player.main_job == 'SCH' or player.sub_job == 'SCH') then
                self.display:show()
                icon:show()

            else
                self.display:hide()
                icon:hide()

            end

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

    self.zoneChange = function()
        self.writeSettings()
    end

    self.jobChange = function()
        self.writeSettings()
        persist()
        resetDisplay()

    end

    self.render = function()

        if self.display:visible() then
            local timer = windower.ffxi.get_ability_recasts()[231] or 0

            do  
                self.gems.current = ((self.gems.max-math.ceil(timer/recharge)))
                self.display:text(tostring(self.gems.current))
                self.display:update()

            end

        end

    end

    self.calculate = function()
        local player = windower.ffxi.get_player()
            
        if player.main_job == "SCH" then
            
            if (player.main_job_level >= 10 and player.main_job_level <= 29) then
                self.gems.max, recharge = 1, 240

            elseif (player.main_job_level >= 30 and player.main_job_level <= 49) then
                self.gems.max, recharge = 2, 120

            elseif (player.main_job_level >= 50 and player.main_job_level <= 69) then
                self.gems.max, recharge = 3, 80

            elseif (player.main_job_level >= 70 and player.main_job_level <= 89) then
                self.gems.max, recharge = 4, 60

            elseif (player.main_job_level >= 90 and player.main_job_level < 99) then
                self.gems.max, recharge = 5, 48
                    
            elseif player.main_job_level == 99 then

                if windower.ffxi.get_player()["job_points"][windower.ffxi.get_player().main_job:lower()].jp_spent >= 550 then
                    self.gems.max, recharge = 5, 33

                else
                    self.gems.max, recharge = 5, 48

                end
                    
            end
                
        elseif player.sub_job == "SCH" then
            self.gems.max, recharge = 2, 120
                
        else
            self.gems.max, recharge = 0, 255
                
        end
    
    end
    self.calculate()

    self.updatePosition = function(x, y)
        self.display:pos(x, y)
        icon:pos(x-icon_offset.x, y-icon_offset.y)
        self.display:update()
        self.layout.pos.x = x
        self.layout.pos.y = y
        icon:update()
        
    end

    return self

end
return stratagems.new()