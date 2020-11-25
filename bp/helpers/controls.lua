local controls  = {}
local player    = windower.ffxi.get_player()
local files     = require('files')
local texts     = require('texts')
local f = files.new(string.format('bp/helpers/settings/controls/%s_settings.lua', player.name))

if not f:exists() then
  f:write(string.format('return %s', T({}):tovstring()))
end

function controls.new()
    local self = {}

    -- Private Variables.
    local delays    = {assist=2, distance=0.45, facing=1}
    local times     = {assist=0, distance=0, facing=0}
    local ranges    = {assist=25}

    -- Static Variables.
    self.settings   = dofile(string.format('%sbp/helpers/settings/controls/%s_settings.lua', windower.addon_path, player.name))
    
    -- Public Variables
    self.assist     = self.settings.assist or false
    self.distance   = self.settings.distance or false
    self.facing     = self.settings.facing or false

    -- Private Functions
    local persist = function()

        if self.settings then
            self.settings.assist    = self.assist
            self.settings.distance  = self.distance
            self.settings.facing    = self.facing

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

    -- Public Functions.
    self.assist = function(bp)
        local bp = bp or false

        if bp and self.assist then
            local player = windower.ffxi.get_mob_by_target('me') or false
            local target = helpers['target'].getTarget() or false
        
            if (os.clock()-times.assist) > delays.assist then
            
                if player then
                    local distance = (player.distance):sqrt()
                    
                    if (distance-target.model_size) < assist_range and player.status == 0 then
                        helpers["actions"].doAction(target, 0, 'engage')
                        times.assist = os.clock()
                    end
                    
                end
            
            end

        end
        
    end
    
    self.distance = function(bp)
        local bp = bp or false

        if bp and self.distance then
            local helpers   = bp.helpers
            local target    = helpers['target'].getTarget() or false
        
            if target and (os.clock()-times.distance) > delays.distance then
                local player = windower.ffxi.get_mob_by_target('me') or false
                    
                if player and target and player.status == 1 then
                    local pSize     = player.model_size
                    local variation = (0.75)
                    local maximum   = (3-pSize)
                    local distance  = target.distance:sqrt()
                        
                    if distance > maximum then
                        helpers['actions'].move(target.x, target.y)
                        times.distance = os.clock()
                            
                    elseif distance < maximum and distance > (maximum-variation) then
                        helpers['actions'].stopMovement()
                        times.distance = os.clock()
                            
                    elseif distance < (maximum-variation) then
                        helpers['actions'].stepBackwards()
                        times.distance = os.clock()
                            
                    end
                        
                end
                    
            end

        end
        
    end

    self.face = function(bp)
        local bp = bp or false

        if bp and self.facing then
            local helpers   = bp.helpers
            local target    = helpers['target'].getTarget() or false
        
            if (os.clock()-times.facing) > delays.facing then
                helpers['actions'].face(bp, target)
                times.facing = os.clock()
                
            end
            
        end
        
    end

    self.toggle = function(bp, command)
        local bp = bp or false
        local command = command or ''

        if bp and command ~= '' then

            if command == 'face' then

                if self.facing then
                    self.facing = false

                else
                    self.facing = true

                end
                bp.helpers['popchat'].pop(string.format('AUTO-FACING TARGETS: %s', tostring(self.facing)))

            elseif command == 'distance' then

                if self.distance then
                    self.distance = false

                else
                    self.distance = true

                end
                bp.helpers['popchat'].pop(string.format('AUTO-DISTANCING TARGETS: %s', tostring(self.distance)))

            elseif command == 'assist' then

                if self.assist then
                    self.assist = false

                else
                    self.assist = true

                end
                bp.helpers['popchat'].pop(string.format('AUTO-ASSIST PARTY: %s', tostring(self.facing)))

            end

        end

    end

    self.up = function(bp)
        helpers["actions"].pressUp()
    end
    
    self.down = function(bp)
        helpers["actions"].pressDown()
    end
    
    self.left = function(bp)
        helpers["actions"].pressLeft()
    end
    
    self.right = function(bp)
        helpers["actions"].pressRight()
    end
    
    self.escape = function(bp)
        helpers["actions"].pressEscape()
    end
    
    self.enter = function(bp)
        helpers["actions"].pressEnter()
    end
    
    self.f8 = function(bp)
        helpers["actions"].pressF8()
    end

    self.stop = function(bp)
        windower.send_command("setkey numpad7 down; wait 0.2; setkey numpad7 up")
    end

    return self

end
return controls.new()