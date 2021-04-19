local enmity    = {}
local player    = windower.ffxi.get_player()
local files     = require('files')
local texts     = require('texts')
local f = files.new(string.format('bp/helpers/settings/enmity/%s_settings.lua', player.name))

if not f:exists() then
  f:write(string.format('return %s', T({}):tovstring()))
end

function enmity.new()
    local self = {}

    -- Private Variable.
    local has_enmity    = false
    local clock         = {last=0, delay=10}

    -- Static Variables.
    self.settings   = dofile(string.format('%sbp/helpers/settings/enmity/%s_settings.lua', windower.addon_path, player.name))
    self.layout     = self.settings.layout or {pos={x=1, y=1}, colors={text={alpha=255, r=245, g=200, b=20}, bg={alpha=0, r=0, g=0, b=0}, stroke={alpha=255, r=0, g=0, b=0}}, font={name='Impact', size=15}, padding=4, stroke_width=1, draggable=false}
    self.display    = texts.new('', {flags={draggable=self.layout.draggable}})
    self.important  = string.format('%s,%s,%s', 25, 165, 200)

    -- Private Functions
    local persist = function()

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
        self.display:hide()
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
    self.catchEnmity = function(bp, data)
        local bp    = bp or false
        local data  = data or false

        if bp and data then
            local packed = bp.packets.parse('incoming', data)

            if packed then
                local player    = windower.ffxi.get_player()
                local actor     = windower.ffxi.get_mob_by_id(packed['Actor'])
                local target    = windower.ffxi.get_mob_by_id(packed['Target 1 ID'])
                local current   = bp.helpers['target'].getTarget()
                local category  = packed['Category']
                local allowed   = T{1,6,7,8,11,12,13,14,15}
                
                if actor and target and current and allowed:contains(category) and actor.id ~= player.id and current.id == actor.id and bp.helpers['party'].isInParty(bp, target, true) and not bp.helpers['party'].isInParty(bp, actor, true) then
                    has_enmity = target
                    clock.last = os.clock()

                end

            end

        end

    end

    self.render = function(bp)
        local bp = bp or false

        -- Reset after 30 seconds of idle actions.
        if (os.clock()-clock.last) > clock.delay then
            has_enmity = false
        end

        if has_enmity then
            self.display:text(string.format('Enmity: \\cs(%s)%s\\cr', self.important, has_enmity.name))
            self.display:update()

            if not self.display:visible() then
                self.display:show()
            end

        elseif not has_enmity then
            self.display:text(string.format('Enmity: \\cs(%s)NONE\\cr', self.important))
            self.display:update()

            if not self.display:visible() then
                self.display:show()
            end
            
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
return enmity.new()