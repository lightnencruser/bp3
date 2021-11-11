local stunner   = {}
local player    = windower.ffxi.get_player()
local files     = require('files')
local texts     = require('texts')
local res       = require('resources')
local f = files.new(string.format('bp/helpers/settings/stunner/%s_settings.lua', player.name))

if not f:exists() then
  f:write(string.format('return %s', T({}):tovstring()))
end

function stunner.new()
    local self = {}

    -- Static Variables.
    self.settings   = dofile(string.format('%sbp/helpers/settings/stunner/%s_settings.lua', windower.addon_path, player.name))
    self.layout     = self.settings.layout or {pos={x=0, y=0}, colors={text={alpha=255, r=245, g=200, b=20}, bg={alpha=200, r=0, g=0, b=0}, stroke={alpha=255, r=150, g=80, b=20}}, font={name='Arial', size=8}, padding=8, stroke_width=2, draggable=false}
    self.display    = texts.new('', {flags={draggable=self.layout.draggable}})
    self.actions    = res.monster_abilities
    self.allowed    = {[8]=true,[4]=true}

    -- Private Variables.
    local bp        = false

    -- Public Variables.
    self.stuns      = self.settings.stuns or {}

    -- Private Functions
    local persist = function()
        local next = next

        if self.settings then
            self.settings.stuns     = self.stuns
            self.settings.layout    = self.layout

        end

    end
    persist()

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

    -- Public Functions.
    self.setSystem = function(buddypal)
        if buddypal then
            bp = buddypal
        end

    end
    
    self.add = function(action)

        if bp and action then
            local helpers = bp.helpers
            
            if type(action) == 'table' then

                for _,v in pairs(self.actions) do

                    if v.id == action.id then

                        if self.stuns and not self.stuns[v.id] then
                            self.stuns[v.id] = v
                            bp.helpers['popchat'].pop(string.format('%s has been added to stuns list.', v.en))
                            self.writeSettings()
                            return true

                        end

                    end

                end

            elseif (type(action) == 'string' or type(action) == 'number') and tonumber(action) ~= nil then

                for _,v in pairs(self.actions) do

                    if v.id == tonumber(action) then

                        if self.stuns and not self.stuns[v.id] then
                            self.stuns[v.id] = v
                            bp.helpers['popchat'].pop(string.format('%s has been added to stuns list.', v.en))
                            self.writeSettings()
                            return true

                        end

                    end

                end

            elseif type(action) == 'string' then

                for _,v in pairs(self.actions) do

                    if v.en:lower() == action:lower() then

                        if self.stuns and not self.stuns[v.id] then
                            self.stuns[v.id] = v
                            bp.helpers['popchat'].pop(string.format('%s has been added to stuns list.', v.en))
                            self.writeSettings()
                            return true

                        end

                    end

                end

            end

        end

    end

    self.remove = function(action)
        local bp        = bp or false
        local action    = action or false
        local temp      = {}

        if bp and action then
            local helpers = bp.helpers
            
            if type(action) == 'table' then

                for _,v in pairs(self.stuns) do

                    if v.id ~= action.id then
                        temp[v.id] = v

                    elseif v.id == action.id then
                        bp.helpers['popchat'].pop(string.format('%s has been removed to stuns list.', v.en))

                    end

                end
                self.stuns = temp

            elseif (type(action) == 'string' or type(action) == 'number') and tonumber(action) ~= nil then

                for _,v in pairs(self.stuns) do

                    if v.id ~= tonumber(action) then
                        temp[v.id] = v

                    elseif v.id == tonumber(action) then
                        bp.helpers['popchat'].pop(string.format('%s has been removed to stuns list.', v.en))

                    end

                end
                self.stuns = temp

            elseif type(action) == 'string' then

                for _,v in pairs(self.stuns) do

                    if v.en:lower() ~= action:lower() then
                        temp[v.id] = v

                    elseif v.en:lower() == action:lower() then
                        bp.helpers['popchat'].pop(string.format('%s has been removed to stuns list.', v.en))

                    end

                end
                self.stuns = temp

            end

        end
        self.writeSettings()

    end

    self.stunnable = function(id)

        if bp and id and self.stuns[id] then
            return true
        end
        return false

    end

    self.stun = function(id, target)
        local target = bp.helpers['target'].getValidTarget(target)

        if bp and id and target then
            local helpers = bp.helpers

            if self.stuns[id] then
                bp.helpers['queue'].clear()
                bp.helpers['queue'].addToFront(bp.MA['Stun'], target.id)
            end

        end

    end

    return self

end
return stunner.new()
