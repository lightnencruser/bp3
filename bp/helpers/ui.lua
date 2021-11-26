local ui        = {}
local player    = windower.ffxi.get_player()
local files     = require('files')
local images    = require('images')
local f = files.new(string.format('bp/helpers/settings/ui/%s_settings.lua', player.name))

if not f:exists() then
  f:write(string.format('return %s', T({}):tovstring()))
end

function ui.new()
    local self = {}

    -- Private Variables.
    local bp        = false
    local private   = {events={}, enabled=true, icons={}, castbar={}, background=images.new({color={alpha = 255}, texture={fit=false}, draggable=false})}
    local settings  = dofile(string.format('%sbp/helpers/settings/ui/%s_settings.lua', windower.addon_path, player.name))
    local current   = {}

    do -- Set the image data and build icon resource.
        private.background:path(string.format("%sbp/resources/ui/ui_main.png", windower.addon_path))
        private.background:size(670, 202)
        private.background:pos(5, 5)
        private.background:update()

    end

    -- Public Variables.

    -- Private Funcitons.
    private.writeSettings = function()

        if f:exists() then
            f:write(string.format('return %s', T(settings):tovstring()))

        elseif not f:exists() then
            f:write(string.format('return %s', T({}):tovstring()))

        end

    end

    private.toggle = function()
        
        if private.enabled then
            private.background:show()

        else
            private.background:hide()

        end

    end

    private.buildIcons = function()
        private.background:show()

        if bp and bp.player and private.background then
            local x, y = private.background:size()
            local pos = {x=private.background:pos_x(), y=private.background:pos_y()}

            for i,v in ipairs(current) do

                if settings[v] then
                    table.insert(private.icons, {id=i, icon=images.new({color={alpha = 255}, texture={fit=false}, draggable=false}), border=images.new({color={alpha = 255}, texture={fit=false}, draggable=false})})

                    if i == 1 then
                        local offset = {x=(pos.x + ((i-1)*21) + 6), y=(pos.y + 6)}

                        private.icons[i].icon:path(string.format("%sbp/resources/icons/buffs/%s.png", windower.addon_path, settings[v]))
                        private.icons[i].icon:size(21, 21)
                        private.icons[i].icon:pos(offset.x, offset.y)
                        private.icons[i].icon:show()
                        private.icons[i].icon:update()

                        private.icons[i].border:path(string.format("%sbp/resources/ui/icon_true.png", windower.addon_path))
                        private.icons[i].border:size(21, 21)
                        private.icons[i].border:pos(offset.x, offset.y)
                        private.icons[i].border:show()
                        private.icons[i].border:update()

                    else
                        local offset = {x=(private.icons[i-1].icon:pos_x() + 30), y=(private.icons[i-1].icon:pos_y())}

                        private.icons[i].icon:path(string.format("%sbp/resources/icons/buffs/%s.png", windower.addon_path, settings[v]))
                        private.icons[i].icon:size(21, 21)
                        private.icons[i].icon:pos(offset.x, offset.y)
                        private.icons[i].icon:show()
                        private.icons[i].icon:update()

                        private.icons[i].border:path(string.format("%sbp/resources/ui/icon_true.png", windower.addon_path))
                        private.icons[i].border:size(21, 21)
                        private.icons[i].border:pos(offset.x, offset.y)
                        private.icons[i].border:show()
                        private.icons[i].border:update()

                    end
                    table.insert(private.castbar, {id=1, image=images.new({color={alpha = 255}, texture={fit=false}, draggable=false})})
                    table.insert(private.castbar, {id=2, image=images.new({color={alpha = 255}, texture={fit=false}, draggable=false})})
                    table.insert(private.castbar, {id=3, image=images.new({color={alpha = 255}, texture={fit=false}, draggable=false})})

                end

            end

        end

    end

    private.handleDelay = function()

    end

    -- Public Functions.
    self.setSystem = function(buddypal)
        if buddypal then
            bp = buddypal
        end

    end

    -- Private Events.
    private.events.commands = windower.register_event('addon command', function(...)
        local commands = T{...}
        local helper = table.remove(commands, 1)
        
        if bp and bp.player and helper and helper:lower() == 'ui' then

            if commands[1] then
                local command = commands[1]:lower()

            elseif not commands[1] then
                private.enabled = private.enabled ~= true and true or false
                private.toggle()

            end            

        end

    end)

    private.events.prerender = windower.register_event('prerender', function()

        if bp and bp.player then
            local timer = (bp.helpers['queue'].ready-os.clock()) > 0 and (bp.helpers['queue']-os.clock()) or 0

        end
    
    end)

    --[[
    private.events.load = windower.register_event('load', function()

        coroutine.schedule(function()

            if bp and bp.player then

                for name, value in pairs(bp.core.settings) do

                    if T{'WAR','MNK','WHM','BLM','RDM','THF','PLD','DRK','BST','BRD','RNG','SMN','SAM','NIN','DRG','BLU','COR','PUP','DNC','SCH','GEO','RUN'}:contains(name) then

                        if name == bp.player.sub_job then
                            table.insert(current, name)

                            if not settings[name] then
                                settings[name] = 1
                            end

                        end

                    else
                        table.insert(current, name)

                        if not settings[name] then
                            settings[name] = 1
                        end

                    end

                end
                private.writeSettings()
                private.buildIcons()

            end

        end, 2)

    end)
    ]]

    return self

end
return ui.new()