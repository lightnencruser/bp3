local paths = {}
local files = require('files')
local images = require('images')

function paths.new()
    local self = {}

    -- Private Variables.
    local bp        = {}
    local private   = {events={}}
    local timer     = {last=0, delay=0.2}
    local map       = {data={}, mobs={}}
    local path      = {}
    local radius    = 3
    local stop      = false
    local loader    = {

        outline = images.new({color={alpha = 255}, texture={fit = false}, draggable=false}),
        bar_top = images.new({color={alpha = 255}, texture={fit = false}, draggable=false}),
        bar_mid = images.new({color={alpha = 255}, texture={fit = false}, draggable=false}),
        bar_low = images.new({color={alpha = 255}, texture={fit = false}, draggable=false}),

    }

    -- Public Variables.
    self.busy       = false

    -- Private Functions.
    private.save = function()
        local zone = bp.info.zone
        local f = files.new(('bp/helpers/settings/maps/%s/%s.lua'):format(zone, zone))
        
        if #map.data > 0 then
            f:write(('return %s'):format(T(map):tovstring()))

            do
                private.unregister('recording')
                bp.helpers['popchat'].pop(('MAP: %s; SAVED.'):format(bp.res.zones[zone].en))
            end

        end

    end

    private.load = function()
        local zone = bp.info.zone
        local f = files.new(('bp/helpers/settings/maps/%s/%s.lua'):format(zone, zone))

        if f:exists() then
            map = T(dofile(('%sbp/helpers/settings/maps/%s/%s.lua'):format(windower.addon_path, zone, zone)))

            do
                bp.helpers['popchat'].pop(('%s LOADED.'):format(bp.res.zones[zone].en))
                private.unregister('recording')

            end

        elseif not f:exists() then
            f:write(('return %s'):format(T({data={}, mobs={}}):tovstring()))
            coroutine.schedule(function()
                private.load()
            
            end, 1)

        end

    end

    private.unregister = function(event)
        local killed = false

        if private.events[event] then
            killed = windower.unregister_event(private.events[event])
            private.events[event] = false

        end
        return killed

    end

    private.record = function()

        if not private.events['recording'] then

            bp.helpers['popchat'].pop('MAP RECORDING NOW ENABLED!')
            private.events['recording'] = windower.register_event('prerender', function()
                local player = bp.me

                if player and (os.clock()-timer.last) > timer.delay then
                    local pos = {x=player.x, y=player.y, z=player.z}

                    if #map.data > 0 then
                        local pass = true

                        for _,v in ipairs(map.data) do
                            local coords = {x=v.x, y=v.y}
                        
                            if bp.helpers['target'].inRange(coords, radius, false) then
                                pass = false
                                break

                            end

                        end

                        if pass then
                            table.insert(map.data, {x=pos.x, y=pos.y, z=pos.z})
                            bp.helpers['popchat'].pop(('NEW POS RECORDED: [ %03d / %03d ]'):format(pos.x, pos.y))

                        end

                    elseif #map.data == 0 then
                        table.insert(map.data, {x=pos.x, y=pos.y, z=pos.z})
                        bp.helpers['popchat'].pop(('NEW POS RECORDED: [ %03d / %03d ]'):format(pos.x, pos.y))

                    end
                    timer.last = os.clock()

                end

            end)

        elseif private.events['recording'] then
            private.unregister('recording')
            private.save()

        end

    end

    private.loading = function(x, y)

        if x and y then
            loader.outline:path(string.format("%sbp/resources/images/outline.png", windower.addon_path))
            loader.outline:size(115, 15)
            loader.outline:transparency(0)
            loader.outline:pos_x(x)
            loader.outline:pos_y(y)
            loader.outline:show()

            loader.bar_top:path(string.format("/null", windower.addon_path))
            loader.bar_top:size(0, 2)
            loader.bar_top:pos_x(loader.outline:pos_x()+3)
            loader.bar_top:pos_y(loader.outline:pos_y()+3)
            loader.bar_top:color(0,255,0)
            loader.bar_top:show()

            loader.bar_mid:path(string.format("/null", windower.addon_path))
            loader.bar_mid:size(0, 5)
            loader.bar_mid:pos_x(loader.outline:pos_x()+3)
            loader.bar_mid:pos_y(loader.outline:pos_y()+5)
            loader.bar_mid:color(0,200,0)
            loader.bar_mid:show()

            loader.bar_low:path(string.format("/null", windower.addon_path))
            loader.bar_low:size(0, 2)
            loader.bar_low:pos_x(loader.outline:pos_x()+3)
            loader.bar_low:pos_y(loader.outline:pos_y()+10)
            loader.bar_low:color(0,150,0)
            loader.bar_low:show()

        end

    end

    private.updateloading = function(value, complete)

        if value and (type(value) == 'number' or tonumber(value) ~= nil) then
            local value = math.floor(value)

            if not complete then
                loader.bar_top:width(109-value)
                loader.bar_mid:width(109-value)
                loader.bar_low:width(109-value)

            elseif complete then
                loader.bar_top:width(109)
                loader.bar_mid:width(109)
                loader.bar_low:width(109)

                coroutine.schedule(function()
                    loader.outline:hide()
                    loader.bar_top:hide()
                    loader.bar_mid:hide()
                    loader.bar_low:hide()
                end, 2)
                bp.helpers['popchat'].pop('PATH CALCULATION COMPLETE!')

            end

        end

    end

    -- Public Functions.
    self.setSystem = function(buddypal)
        if buddypal then
            bp = buddypal
        end

    end

    self.stop = function()
        stop = true
    end

    self.build = function(target)
        
        if map and map.data and #map.data > 0 and target and target.x and target.y then
            private.map = T(map.data):copy()
            private.path = {}
            local previous = {c=false, f=false}

            private.loading((windower.get_windower_settings().x_res/2)-math.floor(115/2), (windower.get_windower_settings().y_res/2)+math.floor(15*4))

            local building = true
            while building do
                local temp = {}
                local last = {}

                if #private.path == 0 then

                    for _,v in ipairs(private.map) do

                        if bp.helpers['target'].inRange(v, radius + 10) and math.abs(bp.me.z-v.z) <= 1 then
                            table.insert(temp, v)
                        end

                    end

                    for i=1, #temp do
                        
                        if i == 1 then
                            table.insert(private.path, temp[i])

                        elseif i > 1 then
                            
                            if bp.helpers['target'].distance(temp[i], target) < bp.helpers['target'].distance(private.path[#private.path], target) then
                                private.path[#private.path] = temp[i]
                            end

                        end

                    end

                elseif #private.path > 0 then

                    -- FIND ALL NODES NEAR BY THAT ARE A SPECIFIC DISTANCE AND ADD THEM TO TEMP LIST.
                    for _,v in ipairs(private.map) do
                        
                        if v.x ~= private.path[#private.path].x and v.y ~= private.path[#private.path].y and math.abs(v.z-private.path[#private.path].z) <= 2.5 then
                            
                            if bp.helpers['target'].distance(v, private.path[#private.path]) <= (radius * 2) then
                                table.insert(temp, v)
                            end

                        end

                    end

                    --print(('%s/%s [%s] -- > %s'):format(#private.path, #private.map, #temp, bp.helpers['target'].distance(private.path[#private.path], target)))

                    -- CHECK IF IT FOUND ANY NODES, IF NOT THEN HANDLE REMOVING THE LAST ENTRY.
                    if #temp > 0 then
                        local chosen = false

                        for i,v in ipairs(temp) do

                            if i == 1 then
                                chosen = v
                            else

                                if bp.helpers['target'].distance(v, target) < bp.helpers['target'].distance(chosen, target) then
                                    chosen = v
                                end

                            end
                        
                        end

                        -- IF THE NEXT NODE IS CLOSER THEN INSERT, ELSE HANDLE WHAT TO DO WHEN IT IS FARTHER.
                        if bp.helpers['target'].distance(chosen, target) < bp.helpers['target'].distance(private.path[#private.path], target) then

                            if bp.helpers['target'].distance(chosen, target) <= 6 then
                                building = false
                                private.updateloading(0, true)
                                return target

                            else
                                
                                if previous.c and T(previous.c):sum() == T(chosen):sum() then
                                    
                                    for i,v in ipairs(private.map) do

                                        if T(v):sum() == T(chosen):sum() then
                                            table.remove(private.map, i)
                                            table.remove(private.path, i)
                                            previous.c = private.path[#private.path]
                                            break

                                        end
                
                                    end

                                else
                                    table.insert(private.path, chosen)
                                    previous.c = chosen

                                end

                            end

                        else
                            
                            if previous.f and T(previous.f):sum() == T(chosen):sum() then
                                    
                                for i,v in ipairs(private.map) do

                                    if T(v):sum() == T(chosen):sum() then
                                        table.remove(private.map, i)
                                        table.remove(private.path, i)
                                        previous.f = private.path[#private.path]
                                        break

                                    end
            
                                end

                            else
                                table.insert(private.path, chosen)
                                previous.f = chosen

                            end

                        end

                    else
                        building = false
                        private.updateloading(0, true)
                        return target

                    end

                end
                private.updateloading(((bp.helpers['target'].distance(private.path[#private.path], target)/bp.helpers['target'].distance(bp.me, target)) * 100)%109)
                coroutine.sleep(0.02)

            end
            
        end

    end

    
    self.run = function(target)
        
        if private.path and #private.path > 0 then
            self.busy = true

            private.events['run'] = windower.register_event('prerender', function()
                local moving = bp.helpers['actions'].moving

                if stop then
                    private.unregister('run')
                    bp.helpers['actions'].stop()
                    private.path = {}
                    self.busy = false

                end
                
                if not moving then

                    if bp.helpers['target'].inRange(private.path[1], 15) then
                        bp.helpers['actions'].move(private.path[1].x, private.path[1].y)
                        private.path.removed = table.remove(private.path, 1)

                    end

                elseif moving then

                    if bp.helpers['target'].inRange(private.path[1], (radius)*2) and math.abs(bp.me.z-private.path[1].z) <= 2.5 then
                        bp.helpers['actions'].move(private.path[1].x, private.path[1].y)
                        private.path.removed = table.remove(private.path, 1)

                    end

                end

                if (#private.path == 0 or not private.path) then
                    
                    if bp.helpers['target'].inRange(private.path.removed, radius) then
                        bp.helpers['actions'].move(target.x, target.y)
                        private.unregister('run')

                        if target and target.id then

                            private.events['find_target'] = windower.register_event('prerender', function()
                                local target = windower.ffxi.get_mob_by_id(target.id)

                                if bp.helpers['target'].inRange(target, math.random(2,5)) then
                                    bp.helpers['actions'].stop()
                                    private.unregister('find_target')
                                    private.path = {}
                                    self.busy = false

                                end

                            end)

                        else
                            bp.helpers['actions'].stop()
                            private.path = {}
                            self.busy = false

                        end

                    end

                end

            end)

        end

    end

    -- Private Events.
    private.events.commands = windower.register_event('addon command', function(...)
        local a = T{...}
        local name = a[1] or false

        if name and name == 'paths' and a[2] then
            local c = a[2]

            if c == 'record' then
                private.record()

            elseif c == 'save' then
                private.save()

            elseif c == 'stop' then
                private.stopPath()

            elseif c == 'test' then
                self.run(self.build({id=17735991, x=20, y=-115, z=0}))

            end

        end

    end)

    private.events.zone = windower.register_event('zone change', function(new, old)
        private.load()

    end)

    coroutine.schedule(function()
        private.load()
    end, 3)
    
    return self

end
return paths.new()
