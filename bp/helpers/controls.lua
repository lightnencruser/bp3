local controls  = {}
local player    = windower.ffxi.get_player()
local files     = require('files')
local texts     = require('texts')
require('vectors')
local f = files.new(string.format('bp/helpers/settings/controls/%s_settings.lua', player.name))

if not f:exists() then
  f:write(string.format('return %s', T({}):tovstring()))
end

function controls.new()
    local self = {}

    -- Private Variables.
    local bp        = false
    local private   = {events={}}
    local delays    = {assist=2, distance=0.45, facing=1}
    local times     = {assist=0, distance=0, facing=0}

    -- Static Variables.
    self.settings   = dofile(string.format('%sbp/helpers/settings/controls/%s_settings.lua', windower.addon_path, player.name))
    
    -- Public Variables
    self.range      = self.settings.range or 13
    self.assist     = self.settings.assist or false
    self.distance   = self.settings.distance or false
    self.facing     = self.settings.facing or false

    -- Private Functions
    local persist = function()

        if self.settings then
            self.settings.range     = self.range
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
    self.setSystem = function(buddypal)
        if buddypal then
            bp = buddypal
        end

    end
    
    self.checkAssisting = function()
        local bp = bp or false

        if bp and self.assist then
            local helpers   = bp.helpers
            local player    = windower.ffxi.get_mob_by_target('me') or false
            local target    = helpers['target'].getTarget() or false
        
            if target and (os.clock()-times.assist) > delays.assist then
                local target = windower.ffxi.get_mob_by_id(target.id) or false
            
                if player and target then
                    local distance = (target.distance):sqrt()
                    
                    if (distance-target.model_size) < self.range and player.status == 0 then
                        helpers['actions'].doAction(target, 0, 'engage')
                        times.assist = os.clock()
                    end
                    
                end
            
            end

        end
        
    end
    
    self.checkDistance = function()
        local bp = bp or false

        if bp and self.distance then
            local helpers   = bp.helpers
            local target    = helpers['target'].getTarget() or false
        
            if target and (os.clock()-times.distance) > delays.distance then
                local player = windower.ffxi.get_mob_by_target('me') or false
                local target = windower.ffxi.get_mob_by_id(target.id) or false
                    
                if player and target and player.status == 1 then
                    local distance  = ((V{player.x, player.y, player.z} - V{target.x, target.y, target.z}):length())
                    local maximum   = ((3-player.model_size) + target.model_size)
                    
                    if distance > maximum then
                        helpers['actions'].move(target.x, target.y)
                        times.distance = os.clock()
                            
                    elseif distance <= (maximum-0.25) and distance >= (maximum-1) then
                        self.stop()
                        times.distance = os.clock()
                            
                    elseif distance < (maximum-1) then
                        self.stepBackwards()
                        times.distance = os.clock()
                            
                    end
                        
                end
                    
            end

        end
        
    end

    self.checkFacing = function()
        local bp = bp or false

        if bp and self.facing then
            local helpers   = bp.helpers
            local target    = helpers['target'].getTarget() or false
        
            if target and (os.clock()-times.facing) > delays.facing then
                local target = windower.ffxi.get_mob_by_id(target.id) or false

                if target then
                    helpers['actions'].face(target)
                    times.facing = os.clock()
                
                end
                
            end
            
        end
        
    end

    self.toggle = function(command)
        local bp = bp or false
        local command = command or ''

        if bp and command ~= '' then

            if (command == 'face' or command == 'f') then
                self.facing = self.facing ~= true and true or false
                bp.helpers['popchat'].pop(string.format('AUTO-FACING TARGETS: %s', tostring(self.facing)))

            elseif (command == 'distance' or command == 'd') then
                self.distance = self.distance ~= true and true or false
                bp.helpers['popchat'].pop(string.format('AUTO-DISTANCING TARGETS: %s', tostring(self.distance)))

            elseif (command == 'assist' or command == 'a') then
                self.assist = self.assist ~= true and true or false
                bp.helpers['popchat'].pop(string.format('AUTO-ASSIST PARTY: %s', tostring(self.assist)))

            end

        end

    end

    self.up = function()
        windower.send_command("setkey up down; wait 0.2; setkey up up")
    end
    
    self.down = function()
        windower.send_command("setkey down down; wait 0.2; setkey down up")
    end
    
    self.left = function()
        windower.send_command("setkey left down; wait 0.2; setkey left up")
    end
    
    self.right = function()
        windower.send_command("setkey right down; wait 0.2; setkey right up")
    end
    
    self.escape = function()
        windower.send_command("setkey escape down; wait 0.2; setkey escape up")
    end
    
    self.enter = function()
        windower.send_command("setkey enter down; wait 0.2; setkey enter up")
    end
    
    self.f8 = function()
        windower.send_command("setkey f8 down; wait 0.2; setkey f8 up")
    end

    self.stepBackwards = function()
        windower.send_command("setkey numpad2 down; wait 0.2; setkey numpad2 up")
    end

    self.stop = function()
        windower.ffxi.run(false)
    end

    -- Private Events.
    private.events.commands = windower.register_event('addon command', function(...)
        local commands = T{...}
        local helper = commands[1]

        if bp and bp.player and helper and helper:lower() == 'controls' then
            table.remove(commands, 1)

            if commands[1] then
                local command = commands[1]:lower()

                if command ~= 'range' then
                    self.toggle(command)
    
                elseif command == 'range' and commands[2] and tonumber(commands[2]) ~= nil then
                    self.range = tonumber(commands[2])
                    bp.helpers['popchat'].pop(string.format('ASSIST RANGE NOW SET TO: %s.', self.range))
    
                end

            end

        end

    end)

    private.events.prerender = windower.register_event('prerender', function()
        self.checkDistance()
        self.checkFacing()
    end)

    return self

end
return controls.new()