local mount     = {}
local player    = windower.ffxi.get_player()
local files     = require('files')
local f = files.new(string.format('bp/helpers/settings/mount/%s_settings.lua', player.name))

if not f:exists() then
  f:write(string.format('return %s', T({}):tovstring()))
end

function mount.new()
    local self = {}

    -- Static Variables.
    self.settings   = dofile(string.format('%sbp/helpers/settings/mount/%s_settings.lua', windower.addon_path, player.name))
    self.allowed    = require('resources').mounts

    -- Public Variables.
    self.name       = self.settings.name or 'Raptor'

    -- Static Functions.
    self.mount = function()
        local player = windower.ffxi.get_player()

        if player and player.status == 85 then
            windower.send_command('input \/dismount')

        else
            windower.send_command(string.format('input \/%s', self.name))

        end

    end

    -- Public Functions
    self.change = function(bp, name)
        local bp = bp or false
        local name = name or false

        if bp and name then
            local name = name:lower()

            for _,v in ipairs(self.allowed) do

                if v.en:lower() == name then
                    self.name = v.en
                    bp.helpers['popchat'].pop(string.format('MOUNT NOW SET TO %s', self.name))
                    return true

                end

            end

        end
        return false

    end

    return self

end
return mount.new()