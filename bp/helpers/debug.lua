local debug     = {}
local player    = windower.ffxi.get_player()
local files     = require('files')
local texts     = require('texts')
local f = files.new(string.format('bp/helpers/settings/debug/%s_settings.lua', player.name))

if not f:exists() then
  f:write(string.format('return %s', T({}):tovstring()))
end

function debug.new()
    local self = {}

    -- Static Variables.
    local extend        = {x=windower.get_windower_settings().x_res, y=windower.get_windower_settings().y_res}
    local settings      = dofile(string.format('%sbp/helpers/settings/debug/%s_settings.lua', windower.addon_path, player.name))
    local layout        = {pos={x=0, y=0}, colors={text={alpha=255, r=245, g=200, b=20}, bg={alpha=255, r=0, g=0, b=0}, stroke={alpha=255, r=0, g=0, b=0}}, font={name='Arial', size=10}, padding=5, stroke_width=1, draggable=false}
    local display       = texts.new('', {flags={draggable=layout.draggable}})
    local calibration   = {'          '}
    local logs          = settings.logs or {}
    local colors        = {stamp='100,200,50', message='10,200,155'}

    -- Private Functions
    local persist = function()
        local next = next

        if settings then
            settings.logs = logs
        end

    end
    persist()

    local resetDisplay = function()
        display:pos(layout.pos.x, layout.pos.y)
        display:font(layout.font.name)
        display:color(layout.colors.text.r, layout.colors.text.g, layout.colors.text.b)
        display:alpha(layout.colors.text.alpha)
        display:size(layout.font.size)
        display:pad(layout.padding)
        display:bg_color(layout.colors.bg.r, layout.colors.bg.g, layout.colors.bg.b)
        display:bg_alpha(layout.colors.bg.alpha)
        display:stroke_width(layout.stroke_width)
        display:stroke_color(layout.colors.stroke.r, layout.colors.stroke.g, layout.colors.stroke.b)
        display:stroke_alpha(layout.colors.stroke.alpha)
        display:update()

    end
    resetDisplay()

    -- Static Functions.
    self.writeSettings = function()
        persist()

        if f:exists() then
            f:write(string.format('return %s', T(settings):tovstring()))

        elseif not f:exists() then
            f:write(string.format('return %s', T({}):tovstring()))

        end

    end
    self.writeSettings()

    self.updateLogs = function()
        local update = {}
        local start = #logs > 50 and (#logs-50) or 1
        
        for i=start, #logs do

            if i == start and logs[i] then
                table.insert(update, string.format('%s\n\nBuddypal V3 System Logger.\n', table.concat(calibration, '')))
                table.insert(update, string.format(' \\cs(%s)%s\\cr► \\cs(%s)%s\\cr', colors.stamp, logs[i].timestamp, colors.message, logs[i].message))

            else
                table.insert(update, string.format(' \\cs(%s)%s\\cr► \\cs(%s)%s\\cr', colors.stamp, logs[i].timestamp, colors.message, logs[i].message))

            end
            display:text(table.concat(update, '\n'))
            display:update()
                
        end

    end

    self.calibrate = function()

        for i=1, 1000 do
            local x, y = display:extents()
            
            if x > extend.x then
                self.log('Calibration was successfully completed!')
                break
            
            else
                table.insert(calibration, '          ')
                display:text(table.concat(calibration, ''))
                display:update()
                coroutine.sleep(0.1)

            end

        end
        self.updateLogs()

    end

    self.log = function(message)
        local message = message or false
        local size = #logs

        if message then
            table.insert(logs, {timestamp=os.date(), message=message})
            self.writeSettings()
            self.updateLogs()

        end

    end

    self.toggle = function()
        
        if display:visible() then
            display:hide()
        
        else
            display:show()

        end

    end


    return self

end
return debug.new()
