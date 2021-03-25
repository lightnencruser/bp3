local chests  = {}
local player    = windower.ffxi.get_player()
local files     = require('files')
local res       = require('resources').items
local f = files.new(string.format('bp/helpers/settings/items/%s_settings.lua', player.name))

if not f:exists() then
  f:write(string.format('return %s', T({}):tovstring()))
end

function chests.new()
    local self = {}

    -- Private Variables.
    local models    = {965,968,969}
    local types     = {blue=1, red=2, gold=3}
    local special   = {isl=0x11, temps=0x12, cruor=0x13, xp=0x14, te=0x15, ki=0x40, temp2=0x3E, augmented=0x3F, revit=0x41, items=0x3D}

    -- Static Variables.
    self.settings   = dofile(string.format('%sbp/helpers/settings/items/%s_settings.lua', windower.addon_path, player.name))

    -- Public Variables.
    self.keys       = {true, false, false}
    self.busy       = false
    self.open       = {

        isl=false,
        temps=false,
        cruor=true,
        xp=false,
        te=true,
        ki=true,
        gold=false

    }
    self.destroy    = {
        
        isl=true,
        temps=true,
        cruor=false,
        xp=true,
        te=false,
        ki=false,
        gold=false,

    }


    -- Private Functions
    local persist = function()

        if self.settings then
            --self.open       = self.settings.open
            --self.destroy    = self.settings.destroy

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
    self.findChest = function(bp)
        local bp = bp or false

        if bp then
            local mobs = windower.ffxi.get_mob_array()
            local temp = {}

            for i,v in pairs(mobs) do
                local box = v
                
                if (box.distance):sqrt() < 20 and T{965,968,969}:contains(box.models[1]) and box.valid_target then

                    -- BLUE CHEST.
                    if box.models[1] == models[types.blue] then
                        table.insert(temp, {id=box.id, index=box.index, type=types.blue})

                    -- RED CHEST.
                    elseif box.models[1] == models[types.red] then
                        table.insert(temp, {id=box.id, index=box.index, type=types.red})

                    -- GOLD CHEST.
                    elseif box.models[1] == models[types.gold] then
                        table.insert(temp, {id=box.id, index=box.index, type=types.gold})

                    end

                end

            end
            return temp

        end
        return false

    end

    self.openChest = function(bp)
        local bp = bp or false

        if bp then
            local boxes = self.findChest(bp)
            
            if boxes then
                
                bp.helpers['popchat'].pop(string.format('FOUND %d STURDY PYXIS NEARBY.', #boxes))
                for _,v in ipairs(boxes) do
                    local box = v
                    
                    if box and box.type == types.blue then
                        self.busy = true
                        bp.helpers['actions'].doAction(box, 0, 'interact')
                        coroutine.sleep(2)
                    
                    elseif box and box.type == types.red then
                        self.busy = true
                        bp.helpers['actions'].doAction(box, 0, 'interact')
                        coroutine.sleep(2)

                    elseif box and box.type == types.gold then
                        self.busy = true
                        bp.helpers['actions'].doAction(box, 0, 'interact')
                        coroutine.sleep(2)

                    end

                end
                bp.helpers['popchat'].pop('FINISHED OPENING ABYSSEA CHEST!')

            end

        end

    end

    self.handleChest = function(bp, original)
        local bp        = bp or false
        local orginal   = orginal or false

        if bp and original then
            local packed = bp.packets.parse('incoming', original)

            if packed then
                local target    = windower.ffxi.get_mob_by_id(packed['NPC'])
                local menu      = packed['Menu Parameters']

                if target and menu and (target.name):match('Sturdy Pyxis') then
                    local type = menu:sub(3,3):unpack('C')

                    -- KEY BOXES
                    if type == special.te and self.open.te then
                        bp.packets.inject(bp.packets.new('outgoing', 0x05B, {
                            ['Target']              = packed['NPC'],
                            ['Target Index']        = packed['NPC Index'],
                            ['Option Index']        = 111,
                            ['_unknown1']           = 0,
                            ['_unknown2']           = 0,
                            ['Automated Message']   = true,
                            ['Zone']                = packed['Zone'],
                            ['Menu ID']             = packed['Menu ID'],

                        }))
                        bp.packets.inject(bp.packets.new('outgoing', 0x05B, {
                            ['Target']              = packed['NPC'],
                            ['Target Index']        = packed['NPC Index'],
                            ['Option Index']        = 0,
                            ['_unknown1']           = 16384,
                            ['_unknown2']           = 0,
                            ['Automated Message']   = false,
                            ['Zone']                = packed['Zone'],
                            ['Menu ID']             = packed['Menu ID'],

                        }))
                        local open = function()

                            if bp.helpers['inventory'].findItemByName('Forbidden Key') and windower.ffxi.get_mob_by_id(packed['NPC']) then
                                bp.helpers['actions'].tradeItem(bp, windower.ffxi.get_mob_by_id(packed['NPC']), 1, {name='Forbidden Key', count=1})
                            end
    
                        end
                        self.busy = false
                        open:schedule(0.5)
                        return true

                    elseif type == special.xp and self.open.xp then
                        bp.packets.inject(bp.packets.new('outgoing', 0x05B, {
                            ['Target']              = packed['NPC'],
                            ['Target Index']        = packed['NPC Index'],
                            ['Option Index']        = 111,
                            ['_unknown1']           = 0,
                            ['_unknown2']           = 0,
                            ['Automated Message']   = true,
                            ['Zone']                = packed['Zone'],
                            ['Menu ID']             = packed['Menu ID'],

                        }))
                        bp.packets.inject(bp.packets.new('outgoing', 0x05B, {
                            ['Target']              = packed['NPC'],
                            ['Target Index']        = packed['NPC Index'],
                            ['Option Index']        = 0,
                            ['_unknown1']           = 16384,
                            ['_unknown2']           = 0,
                            ['Automated Message']   = false,
                            ['Zone']                = packed['Zone'],
                            ['Menu ID']             = packed['Menu ID'],

                        }))
                        local open = function()

                            if bp.helpers['inventory'].findItemByName('Forbidden Key') and windower.ffxi.get_mob_by_id(packed['NPC']) then
                                bp.helpers['actions'].tradeItem(bp, windower.ffxi.get_mob_by_id(packed['NPC']), 1, {name='Forbidden Key', count=1})
                            end
    
                        end
                        self.busy = false
                        open:schedule(0.5)
                        return true

                    elseif type == special.isl and self.open.isl then
                        bp.packets.inject(bp.packets.new('outgoing', 0x05B, {
                            ['Target']              = packed['NPC'],
                            ['Target Index']        = packed['NPC Index'],
                            ['Option Index']        = 111,
                            ['_unknown1']           = 0,
                            ['_unknown2']           = 0,
                            ['Automated Message']   = true,
                            ['Zone']                = packed['Zone'],
                            ['Menu ID']             = packed['Menu ID'],

                        }))
                        bp.packets.inject(bp.packets.new('outgoing', 0x05B, {
                            ['Target']              = packed['NPC'],
                            ['Target Index']        = packed['NPC Index'],
                            ['Option Index']        = 0,
                            ['_unknown1']           = 16384,
                            ['_unknown2']           = 0,
                            ['Automated Message']   = false,
                            ['Zone']                = packed['Zone'],
                            ['Menu ID']             = packed['Menu ID'],

                        }))
                        local open = function()

                            if bp.helpers['inventory'].findItemByName('Forbidden Key') and windower.ffxi.get_mob_by_id(packed['NPC']) then
                                bp.helpers['actions'].tradeItem(bp, windower.ffxi.get_mob_by_id(packed['NPC']), 1, {name='Forbidden Key', count=1})
                            end
    
                        end
                        self.busy = false
                        open:schedule(0.5)
                        return true

                    elseif type == special.temps and self.open.temps then
                        bp.packets.inject(bp.packets.new('outgoing', 0x05B, {
                            ['Target']              = packed['NPC'],
                            ['Target Index']        = packed['NPC Index'],
                            ['Option Index']        = 111,
                            ['_unknown1']           = 0,
                            ['_unknown2']           = 0,
                            ['Automated Message']   = true,
                            ['Zone']                = packed['Zone'],
                            ['Menu ID']             = packed['Menu ID'],

                        }))
                        bp.packets.inject(bp.packets.new('outgoing', 0x05B, {
                            ['Target']              = packed['NPC'],
                            ['Target Index']        = packed['NPC Index'],
                            ['Option Index']        = 0,
                            ['_unknown1']           = 16384,
                            ['_unknown2']           = 0,
                            ['Automated Message']   = false,
                            ['Zone']                = packed['Zone'],
                            ['Menu ID']             = packed['Menu ID'],

                        }))
                        local open = function()

                            if bp.helpers['inventory'].findItemByName('Forbidden Key') and windower.ffxi.get_mob_by_id(packed['NPC']) then
                                bp.helpers['actions'].tradeItem(bp, windower.ffxi.get_mob_by_id(packed['NPC']), 1, {name='Forbidden Key', count=1})
                            end
    
                        end
                        self.busy = false
                        open:schedule(0.5)
                        return true

                    elseif type == special.cruor and self.open.cruor then
                        bp.packets.inject(bp.packets.new('outgoing', 0x05B, {
                            ['Target']              = packed['NPC'],
                            ['Target Index']        = packed['NPC Index'],
                            ['Option Index']        = 111,
                            ['_unknown1']           = 0,
                            ['_unknown2']           = 0,
                            ['Automated Message']   = true,
                            ['Zone']                = packed['Zone'],
                            ['Menu ID']             = packed['Menu ID'],

                        }))
                        bp.packets.inject(bp.packets.new('outgoing', 0x05B, {
                            ['Target']              = packed['NPC'],
                            ['Target Index']        = packed['NPC Index'],
                            ['Option Index']        = 0,
                            ['_unknown1']           = 16384,
                            ['_unknown2']           = 0,
                            ['Automated Message']   = false,
                            ['Zone']                = packed['Zone'],
                            ['Menu ID']             = packed['Menu ID'],

                        }))
                        local open = function()

                            if bp.helpers['inventory'].findItemByName('Forbidden Key') and windower.ffxi.get_mob_by_id(packed['NPC']) then
                                bp.helpers['actions'].tradeItem(bp, windower.ffxi.get_mob_by_id(packed['NPC']), 1, {name='Forbidden Key', count=1})
                            end
    
                        end
                        self.busy = false
                        open:schedule(0.5)
                        return true

                    elseif type == special.ki and self.open.ki then
                        bp.packets.inject(bp.packets.new('outgoing', 0x05B, {
                            ['Target']              = packed['NPC'],
                            ['Target Index']        = packed['NPC Index'],
                            ['Option Index']        = 111,
                            ['_unknown1']           = 0,
                            ['_unknown2']           = 0,
                            ['Automated Message']   = true,
                            ['Zone']                = packed['Zone'],
                            ['Menu ID']             = packed['Menu ID'],

                        }))
                        bp.packets.inject(bp.packets.new('outgoing', 0x05B, {
                            ['Target']              = packed['NPC'],
                            ['Target Index']        = packed['NPC Index'],
                            ['Option Index']        = 0,
                            ['_unknown1']           = 16384,
                            ['_unknown2']           = 0,
                            ['Automated Message']   = false,
                            ['Zone']                = packed['Zone'],
                            ['Menu ID']             = packed['Menu ID'],

                        }))
                        local open = function()

                            if bp.helpers['inventory'].findItemByName('Forbidden Key') and windower.ffxi.get_mob_by_id(packed['NPC']) then
                                bp.helpers['actions'].tradeItem(bp, windower.ffxi.get_mob_by_id(packed['NPC']), 1, {name='Forbidden Key', count=1})
                            end
    
                        end
                        self.busy = false
                        open:schedule(0.5)
                        return true

                    -- DESTORY BOXES.
                    elseif type == special.te and self.destroy.te then
                        bp.packets.inject(bp.packets.new('outgoing', 0x05B, {
                            ['Target']              = packed['NPC'],
                            ['Target Index']        = packed['NPC Index'],
                            ['Option Index']        = 111,
                            ['_unknown1']           = 0,
                            ['_unknown2']           = 0,
                            ['Automated Message']   = true,
                            ['Zone']                = packed['Zone'],
                            ['Menu ID']             = packed['Menu ID'],

                        }))
                        bp.packets.inject(bp.packets.new('outgoing', 0x05B, {
                            ['Target']              = packed['NPC'],
                            ['Target Index']        = packed['NPC Index'],
                            ['Option Index']        = 999,
                            ['_unknown1']           = 0,
                            ['_unknown2']           = 0,
                            ['Automated Message']   = false,
                            ['Zone']                = packed['Zone'],
                            ['Menu ID']             = packed['Menu ID'],

                        }))
                        local open = function()

                            if bp.helpers['inventory'].findItemByName('Forbidden Key') and windower.ffxi.get_mob_by_id(packed['NPC']) then
                                bp.helpers['actions'].tradeItem(bp, windower.ffxi.get_mob_by_id(packed['NPC']), 1, {name='Forbidden Key', count=1})
                            end
    
                        end
                        self.busy = false
                        open:schedule(0.5)
                        return true

                    elseif type == special.xp and self.destroy.xp then
                        bp.packets.inject(bp.packets.new('outgoing', 0x05B, {
                            ['Target']              = packed['NPC'],
                            ['Target Index']        = packed['NPC Index'],
                            ['Option Index']        = 111,
                            ['_unknown1']           = 0,
                            ['_unknown2']           = 0,
                            ['Automated Message']   = true,
                            ['Zone']                = packed['Zone'],
                            ['Menu ID']             = packed['Menu ID'],

                        }))
                        bp.packets.inject(bp.packets.new('outgoing', 0x05B, {
                            ['Target']              = packed['NPC'],
                            ['Target Index']        = packed['NPC Index'],
                            ['Option Index']        = 999,
                            ['_unknown1']           = 0,
                            ['_unknown2']           = 0,
                            ['Automated Message']   = false,
                            ['Zone']                = packed['Zone'],
                            ['Menu ID']             = packed['Menu ID'],

                        }))
                        local open = function()

                            if bp.helpers['inventory'].findItemByName('Forbidden Key') and windower.ffxi.get_mob_by_id(packed['NPC']) then
                                bp.helpers['actions'].tradeItem(bp, windower.ffxi.get_mob_by_id(packed['NPC']), 1, {name='Forbidden Key', count=1})
                            end
    
                        end
                        self.busy = false
                        open:schedule(0.5)
                        return true

                    elseif type == special.isl and self.destroy.isl then
                        bp.packets.inject(bp.packets.new('outgoing', 0x05B, {
                            ['Target']              = packed['NPC'],
                            ['Target Index']        = packed['NPC Index'],
                            ['Option Index']        = 111,
                            ['_unknown1']           = 0,
                            ['_unknown2']           = 0,
                            ['Automated Message']   = true,
                            ['Zone']                = packed['Zone'],
                            ['Menu ID']             = packed['Menu ID'],

                        }))
                        bp.packets.inject(bp.packets.new('outgoing', 0x05B, {
                            ['Target']              = packed['NPC'],
                            ['Target Index']        = packed['NPC Index'],
                            ['Option Index']        = 999,
                            ['_unknown1']           = 0,
                            ['_unknown2']           = 0,
                            ['Automated Message']   = false,
                            ['Zone']                = packed['Zone'],
                            ['Menu ID']             = packed['Menu ID'],

                        }))
                        local open = function()

                            if bp.helpers['inventory'].findItemByName('Forbidden Key') and windower.ffxi.get_mob_by_id(packed['NPC']) then
                                bp.helpers['actions'].tradeItem(bp, windower.ffxi.get_mob_by_id(packed['NPC']), 1, {name='Forbidden Key', count=1})
                            end
    
                        end
                        self.busy = false
                        open:schedule(0.5)
                        return true

                    elseif type == special.temps and self.destroy.temps then
                        bp.packets.inject(bp.packets.new('outgoing', 0x05B, {
                            ['Target']              = packed['NPC'],
                            ['Target Index']        = packed['NPC Index'],
                            ['Option Index']        = 111,
                            ['_unknown1']           = 0,
                            ['_unknown2']           = 0,
                            ['Automated Message']   = true,
                            ['Zone']                = packed['Zone'],
                            ['Menu ID']             = packed['Menu ID'],

                        }))
                        bp.packets.inject(bp.packets.new('outgoing', 0x05B, {
                            ['Target']              = packed['NPC'],
                            ['Target Index']        = packed['NPC Index'],
                            ['Option Index']        = 999,
                            ['_unknown1']           = 0,
                            ['_unknown2']           = 0,
                            ['Automated Message']   = false,
                            ['Zone']                = packed['Zone'],
                            ['Menu ID']             = packed['Menu ID'],

                        }))
                        local open = function()

                            if bp.helpers['inventory'].findItemByName('Forbidden Key') and windower.ffxi.get_mob_by_id(packed['NPC']) then
                                bp.helpers['actions'].tradeItem(bp, windower.ffxi.get_mob_by_id(packed['NPC']), 1, {name='Forbidden Key', count=1})
                            end
    
                        end
                        self.busy = false
                        open:schedule(0.5)
                        return true

                    elseif type == special.cruor and self.destroy.cruor then
                        bp.packets.inject(bp.packets.new('outgoing', 0x05B, {
                            ['Target']              = packed['NPC'],
                            ['Target Index']        = packed['NPC Index'],
                            ['Option Index']        = 111,
                            ['_unknown1']           = 0,
                            ['_unknown2']           = 0,
                            ['Automated Message']   = true,
                            ['Zone']                = packed['Zone'],
                            ['Menu ID']             = packed['Menu ID'],

                        }))
                        bp.packets.inject(bp.packets.new('outgoing', 0x05B, {
                            ['Target']              = packed['NPC'],
                            ['Target Index']        = packed['NPC Index'],
                            ['Option Index']        = 999,
                            ['_unknown1']           = 0,
                            ['_unknown2']           = 0,
                            ['Automated Message']   = false,
                            ['Zone']                = packed['Zone'],
                            ['Menu ID']             = packed['Menu ID'],

                        }))
                        local open = function()

                            if bp.helpers['inventory'].findItemByName('Forbidden Key') and windower.ffxi.get_mob_by_id(packed['NPC']) then
                                bp.helpers['actions'].tradeItem(bp, windower.ffxi.get_mob_by_id(packed['NPC']), 1, {name='Forbidden Key', count=1})
                            end
    
                        end
                        self.busy = false
                        open:schedule(0.5)
                        return true

                    elseif target and target.models[1] == models[types.red] then
                        
                        bp.packets.inject(bp.packets.new('outgoing', 0x05B, {
                            ['Target']              = packed['NPC'],
                            ['Target Index']        = packed['NPC Index'],
                            ['Option Index']        = 111,
                            ['_unknown1']           = 0,
                            ['_unknown2']           = 0,
                            ['Automated Message']   = true,
                            ['Zone']                = packed['Zone'],
                            ['Menu ID']             = packed['Menu ID'],

                        }))
                        bp.packets.inject(bp.packets.new('outgoing', 0x05B, {
                            ['Target']              = packed['NPC'],
                            ['Target Index']        = packed['NPC Index'],
                            ['Option Index']        = 999,
                            ['_unknown1']           = 0,
                            ['_unknown2']           = 0,
                            ['Automated Message']   = false,
                            ['Zone']                = packed['Zone'],
                            ['Menu ID']             = packed['Menu ID'],

                        }))
                        local open = function()

                            if bp.helpers['inventory'].findItemByName('Forbidden Key') and windower.ffxi.get_mob_by_id(packed['NPC']) then
                                bp.helpers['actions'].tradeItem(bp, windower.ffxi.get_mob_by_id(packed['NPC']), 1, {name='Forbidden Key', count=1})
                            end
    
                        end
                        self.busy = false
                        open:schedule(0.5)
                        return true                    

                    elseif target and target.models[1] == models[types.gold] then
                        bp.packets.inject(bp.packets.new('outgoing', 0x05B, {
                            ['Target']              = packed['NPC'],
                            ['Target Index']        = packed['NPC Index'],
                            ['Option Index']        = 111,
                            ['_unknown1']           = 0,
                            ['_unknown2']           = 0,
                            ['Automated Message']   = true,
                            ['Zone']                = packed['Zone'],
                            ['Menu ID']             = packed['Menu ID'],

                        }))
                        bp.packets.inject(bp.packets.new('outgoing', 0x05B, {
                            ['Target']              = packed['NPC'],
                            ['Target Index']        = packed['NPC Index'],
                            ['Option Index']        = 999,
                            ['_unknown1']           = 0,
                            ['_unknown2']           = 0,
                            ['Automated Message']   = false,
                            ['Zone']                = packed['Zone'],
                            ['Menu ID']             = packed['Menu ID'],

                        }))
                        local open = function()

                            if bp.helpers['inventory'].findItemByName('Forbidden Key') and windower.ffxi.get_mob_by_id(packed['NPC']) then
                                bp.helpers['actions'].tradeItem(bp, windower.ffxi.get_mob_by_id(packed['NPC']), 1, {name='Forbidden Key', count=1})
                            end
    
                        end
                        self.busy = false
                        open:schedule(0.5)
                        return true

                    else
                        bp.packets.inject(bp.packets.new('outgoing', 0x05B, {
                            ['Target']              = packed['NPC'],
                            ['Target Index']        = packed['NPC Index'],
                            ['Option Index']        = 111,
                            ['_unknown1']           = 0,
                            ['_unknown2']           = 0,
                            ['Automated Message']   = true,
                            ['Zone']                = packed['Zone'],
                            ['Menu ID']             = packed['Menu ID'],

                        }))
                        bp.packets.inject(bp.packets.new('outgoing', 0x05B, {
                            ['Target']              = packed['NPC'],
                            ['Target Index']        = packed['NPC Index'],
                            ['Option Index']        = 0,
                            ['_unknown1']           = 16384,
                            ['_unknown2']           = 0,
                            ['Automated Message']   = false,
                            ['Zone']                = packed['Zone'],
                            ['Menu ID']             = packed['Menu ID'],

                        }))
                        self.busy = false
                        return true

                    end

                end

            end
            self.busy = false
            return original

        end

    end

    return self

end
return chests.new()