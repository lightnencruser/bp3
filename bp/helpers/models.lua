local models    = {}
local player    = windower.ffxi.get_player()
local packets   = require('packets')
local files     = require('files')
local f         = files.new(string.format('bp/helpers/settings/models/%s_settings.lua', player.name))

if not f:exists() then
    f:write(string.format('return %s', T({}):tovstring()))
end

function models.new()
    local self = {}

    -- Static Variables.
    self.settings = dofile(string.format('%sbp/helpers/settings/models/%s_settings.lua', windower.addon_path, player.name))

    -- Public Variables.
    self.models     = self.settings.models or {}
    self.enabled    = self.settings.enabled or true

    -- Private Functions
    local persist = function()
        local next = next

        if self.settings and next(self.settings) == nil then
            self.settings.models    = self.models
            self.settings.enabled   = self.enabled

        elseif self.settings and next(self.settings) ~= nil then
            self.settings.models    = self.models
            self.settings.enabled   = self.enabled

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

    self.adjustModel = function(bp, data)
        local p = packets.parse('incoming', data)

        if p and p['NPC'] then
            local target    = windower.ffxi.get_mob_by_id(p['NPC'])
            local model     = p['Model']
            local mask      = p['Mask']

            if self.enabled and target and model and self.models[target.name] and (mask == 15 or mask == 8) then
                p['Model'] = self.models[target.name]
                return packets.build(p)

            else
                return original

            end

        else
            return original

        end

    end

    self.setModel = function(bp, target, model)
        local bp        = bp or false
        local target    = target or false
        local model     = tonumber(model) or false

        if bp and target and model then

            if self.models[target.name] then
                helpers['popchat'].pop(string.format('New Model for %s is: %s!', target.name, model))
                self.models[target.name] = model
                self.writeSettings()

            elseif not self.models[target.name] then
                self.models[target.name] = {}

                if self.models[target.name] then
                    helpers['popchat'].pop(string.format('New Model for %s is: %s!', target.name, model))
                    self.models[target.name] = model
                    self.writeSettings()

                end

            end

        end

    end

    self.remove = function(bp, name)
        local bp = bp or false
        local name = name or false

        if bp and name and name ~= '' and self.models[name] then
            local updated = {}

            for i,v in pairs(self.models) do

                if i ~= name then
                    updated[i] = v

                elseif i == name then
                    helpers['popchat'].pop(string.format('Removing Model %s from tables!', name))

                end

            end
            self.models = updated

        end
        self.writeSettings()

    end

    return self

end
return models.new()
