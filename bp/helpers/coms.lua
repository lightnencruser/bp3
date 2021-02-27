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

    -- Public Variables.
    self.enabled    = true

    -- Private Variables.
    local actions   = {}
    local timer     = {last=0, decay=15}
    

    -- Private Functions
    local persist = function()
        local next = next

        if self.settings then
            self.settings.enabled   = self.enabled
            self.settings.layout    = self.layout

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

    end

    self.jobChange = function()
        self.writeSettings()
        persist()
        resetDisplay()

    end

    -- Public Functions.
    self.send = function(bp, action, name, attempts)
        local bp        = bp or false
        local action    = action or false
        local name      = name or false
        local attempts  = attempts or 1

        if bp and action and name and attempts then
            windower.send_ipc_message(string.format('coms:::%s:::%s:::%s', name, action.en, attempts))
        end

    end

    self.catch = function(message)
        local message = message or false

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

    self.render = function(bp)
        local bp = bp or false

        if bp then
            local core = bp.core

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

    end

    self.toggle = function(bp)
        local bp = bp or false

        if bp then

            if self.enabled then
                self.enabled = false

            else
                self.enabled = true

            end
            bp.helpers['popchat'].pop(string.format('COMS ENABLED: %s', tostring(self.enabled)))
            self.writeSettings()

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
return coms.new()
