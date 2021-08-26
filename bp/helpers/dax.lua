local dax       = {}
local player    = windower.ffxi.get_player()
local files     = require('files')
local texts     = require('texts')
local f = files.new(string.format('bp/helpers/settings/dax/%s_settings.lua', player.name))

if not f:exists() then
  f:write(string.format('return %s', T({}):tovstring()))
end

function dax.new()
    local self = {}

    -- Static Variables.
    self.settings   = dofile(string.format('%sbp/helpers/settings/dax/%s_settings.lua', windower.addon_path, player.name))
    self.layout     = self.settings.layout or {pos={x=500, y=350}, colors={text={alpha=255, r=245, g=200, b=20}, bg={alpha=200, r=0, g=0, b=0}, stroke={alpha=255, r=0, g=0, b=0}}, font={name='Lucida Console', size=8}, padding=3, stroke_width=1, draggable=true}
    self.display    = texts.new('', {flags={draggable=self.layout.draggable}})
    self.important  = string.format('%s,%s,%s', 25, 165, 200)

    -- Private Variables.
    local bp        = false
    local allowed   = self.settings.allowed or {

        ['WAR'] = {},
        ['MNK'] = {},
        ['WHM'] = {},
        ['BLM'] = {},
        ['RDM'] = {},
        ['THF'] = {},
        ['PLD'] = {},
        ['DRK'] = {},
        ['BST'] = {},
        ['BRD'] = {},
        ['RNG'] = {},
        ['SMN'] = {},
        ['SAM'] = {},
        ['NIN'] = {},
        ['DRG'] = {},
        ['BLU'] = {},
        ['COR'] = {},
        ['PUP'] = {},
        ['DNC'] = {},
        ['SCH'] = {},
        ['GEO'] = {},
        ['RUN'] = {},

    }

    -- Public Variables.
    self.enabled    = self.settings.enabled or true

    -- Private Functions
    local persist = function()
        local next = next

        if self.settings then
            self.settings.enabled   = self.enabled
            self.settings.allowed   = allowed
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

    local isAllowed = function(name)
        local player = windower.ffxi.get_player()

        if allowed[player.main_job] then

            for _,v in ipairs(allowed[player.main_job]) do

                if v == name:upper() then
                    return false
                end

            end

        end
        return true

    end

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
    self.setSystem = function(buddypal)
        if buddypal then
            bp = buddypal
        end

    end
    
    self.list = function()
        local bp = bp or false

        if bp then
            local core = bp.core

            if core and core.settings then

            end

        end

    end

    self.add = function(name)
        local bp    = bp or false
        local name  = name or ''
        
        if bp then
            local core      = bp.core
            local player    = windower.ffxi.get_player()

            if core and core.settings then

                if core.settings[name:upper()] and isAllowed(name:upper()) then

                    if type(core.settings[name:upper()]) == 'table' and core.settings[name:upper()][2] then
                        table.insert(allowed[player.main_job], name:upper())
                        bp.helpers['popchat'].pop(string.format('%s ADDED TO SETTINGS WINDOW!', name:upper()))
                        self.writeSettings()

                    else
                        table.insert(allowed[player.main_job], name:upper())
                        bp.helpers['popchat'].pop(string.format('%s ADDED TO SETTINGS WINDOW!', name:upper()))
                        self.writeSettings()

                    end

                else
                    bp.helpers['popchat'].pop(string.format('%s IS NOT A VALID SETTING!', name:upper()))

                end

            end

        end

    end

    self.remove = function(name)
        local bp   = bp or false
        local name = name or ''

        if bp then
            local core      = bp.core
            local player    = windower.ffxi.get_player()

            if core and core.settings then

                if core.settings[name:upper()] and not isAllowed(name:upper()) then

                    if type(core.settings[name:upper()]) == 'table' and core.settings[name:upper()][2] then

                        for i,v in ipairs(allowed[player.main_job]) do

                            if v:upper() == name:upper() then
                                table.remove(allowed[player.main_job], i)
                                bp.helpers['popchat'].pop(string.format('%s REMOVED FROM SETTINGS WINDOW!', name:upper()))
                                self.writeSettings()
                                break
                            
                            end

                        end

                    else
                        
                        for i,v in ipairs(allowed[player.main_job]) do

                            if v:upper() == name:upper() then
                                table.remove(allowed[player.main_job], i)
                                bp.helpers['popchat'].pop(string.format('%s REMOVED FROM SETTINGS WINDOW!', name:upper()))
                                self.writeSettings()
                                break
                            
                            end
    
                        end

                    end                    

                else
                    bp.helpers['popchat'].pop(string.format('%s IS NOT A VALID SETTING!', name:upper()))

                end

            end

        end

    end

    self.render = function()
        local bp = bp or false
        
        if bp then
            local core      = bp.core
            local player    = windower.ffxi.get_player()
            
            if core and core.settings and T(allowed[player.main_job]):length() > 0 and self.enabled then
                local update = {}
                
                for _, name in pairs(allowed[player.main_job]) do
                    table.insert(update, string.format('%s%s : \\cs(%s)%s\\cr', name:upper(), (''):rpad(' ', (15-name:len())), self.important, tostring(core.getSetting(name:upper())):upper()))        
                end
                self.display:text(table.concat(update, '\n'))
                self.display:update()

                if not self.display:visible() then
                    self.display:show()
                end

            elseif (T(allowed[player.main_job]):length() < 1 or self.display:visible()) then
                self.display:text('')
                self.display:update()
                self.display:hide()

            end

        end        

    end

    self.pos = function(x, y)
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

    self.toggle = function()
        local bp = bp or false

        if self.enabled then
            self.enabled = false
            
            if bp then
                bp.helpers['popchat'].pop(string.format('DAX MENUS ENABLED: %s', tostring(self.enabled)))
            end

        else
            self.enabled = true

            if bp then
                bp.helpers['popchat'].pop(string.format('DAX MENUS ENABLED: %s', tostring(self.enabled)))
            end

        end

    end

    return self

end
return dax.new()
