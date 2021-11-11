local drops     = {}
local player    = windower.ffxi.get_player()
local files     = require('files')
local texts     = require('texts')
local images    = require('images')
                  require('queues')
local f = files.new(string.format('bp/helpers/settings/drops/%s_settings.lua', player.name))

if not f:exists() then
  f:write(string.format('return %s', T({}):tovstring()))
end

function drops.new()
    local self = {}

    -- Static Variables.
    self.settings       = dofile(string.format('%sbp/helpers/settings/drops/%s_settings.lua', windower.addon_path, player.name))
    self.layout         = self.settings.layout or {pos={x=1, y=1}, colors={text={alpha=255, r=245, g=200, b=20}, bg={alpha=0, r=0, g=0, b=0}, stroke={alpha=255, r=0, g=0, b=0}}, font={name='Impact', size=15}, padding=4, stroke_width=1, draggable=false}
    self.important      = string.format('%s,%s,%s', 25, 165, 200)

    -- Private Variable.
    local bp            = false
    local private       = {events={}}
    local timer         = {last=0, delay=1, fade=30}
    local drops         = Q{}

    -- Private Functions
    private.persist = function()

        if self.settings then
            self.settings.layout    = self.layout
            self.settings.important = self.important

        end

    end
    private.persist()

    -- Static Functions.
    self.writeSettings = function()
        private.persist()

        if f:exists() then
            f:write(string.format('return %s', T(self.settings):tovstring()))

        elseif not f:exists() then
            f:write(string.format('return %s', T({}):tovstring()))

        end

    end
    self.writeSettings()

    private.render = function()

        if (os.clock()-timer.last) > timer.delay and drops:length() > 0 then

            for index,item in ipairs(drops.data) do

                if item.time and item.data and item.display then
                    private.updateImage(item, index)
                end
            
            end
            timer.last = os.clock()

        end

    end

    private.newImage = function()
        return {

            back    = images.new({color={alpha = 255}, texture={fit = false}, draggable=false}),
            text    = texts.new('', {flags={draggable=false}}),
            icon    = images.new({color={alpha = 255}, texture={fit = false}, draggable=false}),
            border  = images.new({color={alpha = 255}, texture={fit = false}, draggable=false}),

        }

    end

    private.updateImage = function(item, index)
        local count = drops:length()

        if item and index and count > 0 then

            if (os.time()-item.time) > timer.fade then
                private.destroy(index)

            else
                
                if not drops.data[index].display.border:visible() then
                    private.visible(index)
                end

            end

        end

    end

    private.deleteImage = function(index)

    end

    private.visible = function(index)

        if drops.data[index] then
            local x = drops.data[index].display.border:pos_x()
            local y = drops.data[index].display.border:pos_y()

            do -- Background Stuff.
                drops.data[index].display.back:path(string.format("%sbp/resources/images/fake.png", windower.addon_path))
                drops.data[index].display.back:transparency(0)
                drops.data[index].display.back:pos(x+2, y+2)
                drops.data[index].display.back:size(100, 25)
                drops.data[index].display.back:color(0,0,0)
                drops.data[index].display.back:show()

            end

            do -- Icon Stuff.

            end

            do -- Text Calculations.
                drops.data[index].display.text:show()

            end

            do -- Border Stuff.
                drops.data[index].display.border:path(string.format("%sbp/resources/images/outline2.png", windower.addon_path))
                drops.data[index].display.border:transparency(0)
                drops.data[index].display.border:size(200, 36)
                drops.data[index].display.border:show()

            end

        end

    end

    private.destroy = function(index)

        if drops.data[index] then
            drops.data[index].display.border:destroy()
            drops.data[index].display.back:destroy()
            drops.data[index].display.text:destroy()
            drops:remove(index)

        end

    end

    private.dropExist = function(id)

        if id and bp.res.items[id] and drops:length() > 0 then

            for index,item in ipairs(drops.data) do

                if item.data and item.data.id == id then
                    return index
                end

            end

        end
        return false

    end

    -- Public Functions.
    self.setSystem = function(buddypal)
        if buddypal then
            bp = buddypal
        end

    end

    self.pos = function(x, y)
        local x = tonumber(x) or self.layout.pos.x
        local y = tonumber(y) or self.layout.pos.y

        if bp and x and y then
            self.layout.pos.x = x
            self.layout.pos.y = y
            self.writeSettings()
        
        elseif bp and (not x or not y) then
            bp.helpers['popchat'].pop('PLEASE ENTER AN "X" OR "Y" COORDINATE!')

        end

    end
    
    -- Private Events.
    
    private.events.prerender = windower.register_event('prerender', function()
        private.render()

    end)

    private.events.incoming = windower.register_event('incoming chunk', function(id, original, modified, injected, blocked)

        if id == 0x0D2 then
            local parsed = bp.packets.parse('incoming', original)

            if parsed then
                local item = parsed['Item'] and bp.res.items[parsed['Item']] or false
                local exist = private.dropExist(item.id)

                if item and not exist then
                    drops:push({time=os.time(), data=item, count=1, display=private.newImage()})

                elseif item and exist then
                    drops.data[exist].time = os.time()
                    drops.data[exist].count = (drops.data[exist].count + 1)

                end

            end

        end
    
    end)
    
    private.events.command = windower.register_event('addon command', function(...)
        local a = T{...}
        local c = a[1] and a[1]:lower() or false
        
        if c and c == 'drops' and a[2] then
            local command = a[2]:lower()
            
            if command == 'pop' then
                
            end

        end
    
    end)

    return self

end
return drops.new()