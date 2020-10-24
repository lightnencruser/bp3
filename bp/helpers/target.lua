local target = {}
local files = require('files')
local texts = require('texts')
local res   = require('resources')
local f     = files.new('bp/helpers/settings/target_settings.lua')

if not f:exists() then
    f:write(string.format('return %s', T({}):tovstring()))
end

function target.new()
    local self = {}

    -- Static Variables.
    self.settings   = dofile(string.format('%sbp/helpers/settings/target_settings.lua', windower.addon_path))
    self.layout     = self.settings.layout or {pos={x=420, y=800}, colors={text={alpha=255, r=100, g=215, b=0}, bg={alpha=0, r=0, g=0, b=0}, stroke={alpha=255, r=0, g=25, b=15}}, font={name='Mulish', size=8}, padding=2, stroke_width=1, draggable=false}
    self.display    = texts.new('', {flags={draggable=self.layout.draggable}})

    -- Private Variables.
    local debug     = false

    -- Public Variables.
    self.targets    = {player=false, party=false, luopan=false, entrust=false}
    self.mode       = 1

    -- Private Functions.
    local persist = function()
        local next = next

        if self.settings and next(self.settings) == nil then
            self.settings.max       = self.max
            self.settings.mode      = self.mode
            self.settings.layout    = self.layout
            self.settings.attempts  = self.attempts

        elseif self.settings and next(self.settings) ~= nil then
            self.settings.max       = self.max
            self.settings.mode      = self.mode
            self.settings.layout    = self.layout
            self.settings.attempts  = self.attempts

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
    self.setTarget = function(bp, target)
        local bp        = bp or false
        local target    = target or false

        if bp and target then
            local helpers = bp.helpers

            if type(target) == 'table' and self.isEnemy(bp, target) then
                target = windower.ffxi.get_mob_by_id(target.id) or false

            elseif type(target) == 'number' and self.isEnemy(bp, target) then
                target = windower.ffxi.get_mob_by_id(target) or false

            elseif windower.ffxi.get_mob_by_target('t') and self.isEnemy(bp, windower.ffxi.get_mob_by_target('t')) then
                target = windower.ffxi.get_mob_by_target('t')

            else
                target = false

            end

        end

        if self.mode == 1 and target and self.canEngage(bp, target) then

            if target.distance:sqrt() < 35 then
                self.targets.player = target
                helpers['popchat'].pop(string.format('SETTING CURRENT PLAYER TARGET TO: %s.', target.name))
            end

        elseif self.mode == 2 and target and self.canEngage(target) then

            if target.distance:sqrt() < 35 then
                self.targets.party = target
                helpers['popchat'].pop(string.format('SETTING CURRENT PARTY TARGET TO: %s.', target.name))
            end

        end

    end

    self.setLuopan = function(bp, target)
        local bp        = bp or false
        local target    = target or false

        if target then

            if type(target) == 'number' then
                target = windower.ffxi.get_mob_by_id(target) or false

            elseif type(target) == 'table' then
                target = windower.ffxi.get_mob_by_id(target.id) or false

            elseif type(target) == 'string' and windower.ffxi.get_mob_by_name(target) then
                target = windower.ffxi.get_mob_by_name(target) or false

            elseif windower.ffxi.get_mob_by_target('t') then
                target = windower.ffxi.get_mob_by_target('t')

            else
                target = false

            end

        end

        if target then

            if (target.distance):sqrt() < 22 and self.castable(bp, target) then
                self.targets.luopan = target
            end

        end

    end

    self.setEntrust = function(bp, target)
        local bp        = bp or false
        local target    = target or false
        local player    = windower.ffxi.get_player()

        if target and target ~= '' then

            if type(target) == 'number' then
                target = windower.ffxi.get_mob_by_id(target) or false

            elseif type(target) == 'table' then
                target = windower.ffxi.get_mob_by_id(target.id) or false

            elseif type(target) == 'string' and windower.ffxi.get_mob_by_name(target) and not self.isEnemy(bp, windower.ffxi.get_mob_by_name(target)) then
                target = windower.ffxi.get_mob_by_name(target) or false

            elseif windower.ffxi.get_mob_by_target('t') then
                target = windower.ffxi.get_mob_by_target('t')

            else
                target = false

            end

        end

        if target and target.id == player.id then
            self.targets.entrust = false

        else

            if (target.distance):sqrt() < 22 and target.name ~= player.name and self.castable(bp, target) then
                self.targets.entrust = target
            end

        end

    end

    self.getTarget = function()
        return self.targets.player or self.targets.party or false
    end

    self.canEngage = function(bp, mob)
        local bp    = bp or false
        local mob   = mob or false

        if bp and mob and mob.spawn_type == 16 and not mob.charmed and (mob.status ~= 2 or mob.status ~= 3) then
            local player    = windower.ffxi.get_player() or false
            local party     = windower.ffxi.get_party()
            local helpers   = bp.helpers

            if player and party then

                if (mob.claim_id == 0 or helpers['party'].isInParty(bp, mob.claim_id, true) or helpers['buffs'].buffActive(603) or helpers['buffs'].buffActive(511) or helpers['buffs'].buffActive(257) or helpers['buffs'].buffActive(267)) then
                    return true
                end

            end

        end
        return false

    end

    self.isEnemy = function(bp, target)
        local bp        = bp or false
        local target    = target or false

        if bp and target then
            local helpers = bp.helpers

            if type(target) == 'table' and target.spawn_type == 16 then
                return true

            elseif type(target) == 'number' and tonumber(target) ~= nil then
                local target = windower.ffxi.get_mob_by_id(target)

                if type(target) == 'table' and target.spawn_type == 16 then
                    return true
                end

            elseif type(target) == 'string' then
                local target = windower.ffxi.get_mob_by_target(target) or windower.ffxi.get_mob_by_name(target) or false

                if type(target) == 'table' and target.spawn_type == 16 then
                    return true
                end

            end

        end
        return false

    end

    self.castable = function(bp, target, spell)
        local bp        = bp or false
        local target    = target or false
        local targets   = spell.targets

        if bp and target then
            local helpers = bp.helpers

            for i,v in pairs(targets) do

                if i == 'Self' and target.name == windower.ffxi.get_player().name then
                    return v

                elseif i == 'Party' and helpers['party'].isInParty(bp, target, false) then
                    return v

                elseif i == 'Ally' and helpers['party'].isInParty(bp, target, true) then
                    return v

                elseif i == 'Player' and not target.is_npc then
                    return v

                elseif i == 'NPC' and target.is_npc then
                    return v

                elseif i == 'Enemy' and target.spawn_type == 16 then
                    return v

                end

            end

        end
        return false

    end

    self.onlySelf = function(bp, spell)
        local bp    = bp or false
        local spell = spell or false

        if spell then
            local targets = T(spell.targets)

            if #targets == 1 and targets[1] == 'Self' and spell.prefix ~= '/song' then
                return true
            end

        end
        return false

    end

    self.isDead = function(bp, target)
        local bp        = bp or false
        local target    = target or false

        if target and type(target) == 'table' and (target.status == 2 or target.status == 3) then
            return true
        end
        return false

    end

    self.allowed = function(bp, target)
        local bp        = bp or false
        local target    = target or false

        if bp and target and type(target) == 'table' then
            local helpers   = bp.helpers
            local target    = windower.ffxi.get_mob_by_id(target.id) or false

            if target and type(target) == 'table' and target.distance ~= nil then
                local distance = (target.distance:sqrt())

                if (distance == 0.089004568755627 or distance > 35) and distance ~= 0 then
                    if debug then print('Distance failure!') end
                    return false
                end

                if not target then
                    if debug then print('Target failure!') end
                    return false
                end

                if target.hpp == 0 then
                    if debug then print('HPP failure!') end
                    return false
                end

                if not target.valid_target then
                    if debug then print('Valid target failure!') end
                    return false
                end

                if not self.isEnemy(bp, target) and not helpers['party'].isInParty(bp, target) then
                    if debug then print('Is enemy failure!') end
                    return false
                end

                if target.charmed then
                    if debug then print('Charmed target failure!') end
                    return false
                end
                return true

            end

        end
        return false

    end

    self.clear = function()
        self.targets.targets.player     = false
        self.targets.targets.party      = false
        self.targets.targets.entrust    = false
        self.targets.targets.luopan     = false

    end

    self.updateTargets = function(bp)

        if self.targets.player and not self.allowed(bp, self.targets.player) then
            self.targets.player = false
        end

        if self.targets.party and not self.allowed(bp, self.targets.party) then
            self.targets.party = false
        end

        if self.targets.entrust and not self.allowed(bp, self.targets.entrust) then
            self.targets.entrust = false
        end

        if self.targets.luopan and not self.allowed(bp, self.targets.luopan) then
            self.targets.luopan = false
        end

    end

    self.render = function(bp)
        local bp        = bp or false
        local player    = windower.ffxi.get_player()
        local update    = {[1]='',[2]='',[3]='',[4]=''}
        local color     = string.format('%s,%s,%s', 25, 165, 200)

        -- Handle Player Target.
        if self.targets.player then
            update[1] = string.format('Player Target:  \\cs(%s)[ %s ]\\cr ', color, self.targets.player.name)

        elseif not self.targets.player then
            update[1] = string.format('Player Target:  \\cs(%s)[ N/A ]\\cr', color)

        end

        -- Handle Party Target.
        if self.targets.party then
            update[2] = string.format('Party Target:  \\cs(%s)[ %s ]\\cr ', color, self.targets.party.name)

        elseif not self.targets.party then
            update[2] = string.format('Party Target:  \\cs(%s)[ N/A ]\\cr', color)

        end

        -- Handle Entrust Target.
        if self.targets.entrust then
            update[3] = string.format('Entrust Target:  \\cs(%s)[ %s ]\\cr ', color, self.targets.entrust.name)

        elseif not self.targets.entrust then
            update[3] = string.format('Entrust Target:  \\cs(%s)[ N/A ]\\cr', color)

        end

        -- Handle Luopan Target.
        if self.targets.luopan then
            update[4] = string.format('Luopan Target:  \\cs(%s)[ %s ]\\cr ', color, self.targets.luopan.name)

        elseif not self.targets.luopan then
            update[4] = string.format('Luopan Target:  \\cs(%s)[ N/A ]\\cr', color)

        end
        self.display:text(table.concat(update, '    '))
        self.display:update()

        if not self.display:visible() then
            self.display:show()
        end

    end

    self.changeMode = function()

        if self.mode == 1 then
            self.mode = 2

        else
            self.mode = 1

        end

    end

    return self

end
return target.new()
