local logic = {}
local files = require('files')
local player = windower.ffxi.get_player()
function logic.get()
    local self = {}

    -- Private Variables.
    local bp        = false
    local private   = {events={}, core={}, subs={}, settings=dofile(string.format('%sbp/core/core.lua', windower.addon_path, player.name))}
    local timers    = {hate=0, steps=0, sublimation=0, meditate=0, konzen=0, utsusemi=0}

    -- Public Variables.
    self.settings   = private.settings.getFlags()

    -- Private Functions.
    local loadJob = function(job)
        local player = windower.ffxi.get_player()
        private.core = {}
        
        if files.new(string.format('bp/core/%s/%s.lua', player.main_job:lower(), player.main_job)):exists() then
            private.core = dofile(string.format('%sbp/core/%s/%s.lua', windower.addon_path, player.main_job:lower(), player.main_job))
        end

    end
    loadJob(player.main_job)

    -- Public Functions.
    self.setSystem = function(buddypal)
        if buddypal then
            bp = buddypal
            private.settings.setSystem(bp)            
        end

    end

    self.get = function(name)
        return private.settings.get(name)
    end

    self.set = function(name, value)
        
        if name and value ~= nil then
            private.settings.set(name, value)
        end

    end

    self.hasShadows = function()
        local shadows = T{444,445,446}

        if bp and bp.player then
        
            for _,v in ipairs(bp.player.buffs) do
                        
                if shadows:contains(v) then
                    return true
                end
                
            end
        
        end
        return false

    end

    self.hasEnspell = function()
        local enspells = T{94,95,96,97,98,99,277,278,279,280,281,282}

        if bp and bp.player then
        
            for _,v in ipairs(bp.player.buffs) do
                        
                if enspells:contains(v) then
                    return true
                end
                
            end
        
        end
        return false

    end

    self.hasSpikes = function()
        local spikes = T{34,35,38,173}

        if bp and bp.player then
        
            for _,v in ipairs(bp.player.buffs) do
                        
                if spikes:contains(v) then
                    return true
                end
                
            end
        
        end
        return false

    end

    self.hasStorm = function()
        local storms = T{178,179,180,181,182,183,184,185}

        if bp and bp.player then
        
            for _,v in ipairs(bp.player.buffs) do
                        
                if storms:contains(v) then
                    return true
                end
                
            end
        
        end
        return false

    end

    self.hasBoost = function()
        local boosts = T{119,120,121,122,123,124,125}

        if bp and bp.player then
        
            for _,v in ipairs(bp.player.buffs) do
                        
                if boosts:contains(v) then
                    return true
                end
                
            end
        
        end
        return false

    end

    self.hasAftermath = function()
        local levels = T{270,271,272}

        if bp and bp.player then
        
            for _,v in ipairs(bp.player.buffs) do
                        
                if levels:contains(v) then
                    return true
                end
                
            end
        
        end
        return false

    end

    self.handleAutomation = function()
        
        if bp and bp.player and bp.helpers['queue'].checkReady() and not bp.helpers['actions'].moving then
            local target    = bp.helpers['target'].getTarget() or false
            local helpers   = bp.helpers
            local player    = bp.player

            do
                bp.helpers['cures'].handleCuring()
                bp.helpers['status'].fixStatus()

                do -- Handle Skillup.
                    local skillup = private.settings.get('skillup').enabled
                    local skill = private.settings.get('skillup').skill

                    if skillup then
                        local food = helpers['inventory'].findItemByName("B.E.W. Pitaru")
                        
                        if not helpers['queue'].inQueue(food) and not helpers['buffs'].buffActive(251) then
                            helpers['queue'].add(food, 'me')
                            
                        else
                                                        
                            if bp.skillup and bp.skillup[skill] then
                                local selected = bp.skillup[skill]

                                for _,v in pairs(selected.list) do
                                    
                                    if isReady('MA', v) and not helpers['queue'].inQueue(bp.MA[v]) then

                                        if selected.target == 't' and target then
                                            helpers['queue'].add(bp.MA[v], target)

                                        elseif selected.target == 'me' then
                                            helpers['queue'].add(bp.MA[v], player)

                                        end

                                    end
                                
                                end

                            end
                        
                        end
                        
                    end

                    -- Handle using ranged attacks.
                    if private.settings.get('ra').enabled and #helpers['queue'].queue.data == 0 and helpers['equipment'].ammo and helpers['equipment'].ammo.en ~= 'Gil' and helpers['equipment'].ammo.damage > 0 then
                        helpers['queue'].add(helpers['actions'].unique.ranged, target)
                    end

                end
                private.core.automate(bp)
                private.handleWeaponskills(bp, target)

                if self.get('buffs') then
                    helpers['buffs'].cast()
                end

                if self.get('debuffs') then
                    helpers['debuffs'].cast()
                end

                if private.subs[player.sub_job] then
                    private.subs[player.sub_job]()
                end

            end
            helpers['queue'].handle()

        end

    end

    private.handleWeaponskills = function(bp)
        local target    = bp.helpers['target'].targets.player or false
        local player    = bp.player
        local helpers   = bp.helpers
        local add       = bp.helpers['queue'].add
        local inQueue   = helpers['queue'].inQueue
        local isReady   = helpers['actions'].isReady
        local get       = private.settings.get

        if target and player.status == 1 and bp.helpers['actions'].canAct() and get('ws').enabled and player['vitals'].tp >= 1000 then
            local distance = helpers['distance'].getDistance(target)
            
            if target and distance < 6 and distance ~= 0 then
                local current = {tp=player['vitals'].tp, hpp=player['vitals'].hpp, mpp=player['vitals'].mpp, main=helpers['equipment'].main, ranged=helpers['equipment'].ranged, ammo=helpers['equipment'].ammo}

                if ((get('am').enabled and self.hasAftermath()) or not get('am').enabled) then

                    if get('sanguine blade') and get('sanguine blade').enabled and current.hpp <= get('sanguine blade').hpp and current.tp >= get('ws').tp and isReady('WS', "Sanguine Blade") then
                        add(bp.WS["Sanguine Blade"], target)

                    elseif get('moonlight') and get('moonlight').enabled and current.mpp <= get('moonlight').mpp and current.tp >= get('ws').tp and isReady('WS', "Moonlight") then
                        add(bp.WS["Moonlight"], player)

                    elseif get('myrkr') and get('myrkr').enabled and current.mpp <= get('myrkr').mpp and current.tp >= get('ws').tp and isReady('WS', "Myrkr") then
                        add(bp.WS["Myrkr"], player)

                    elseif current.tp >= get('ws').tp and isReady('WS', get('ws').name) then
                        add(bp.WS[get('ws').name], target)

                    end

                elseif get('am').enabled and not self.hasAftermath() and current.tp >= get('am').tp and current.main then
                    local aftermath = bp.helpers['aftermath'].getWeaponskill(current.main.en)
                    
                    if aftermath and isReady('WS', aftermath) then
                        add(bp.WS[aftermath], target)
                    end

                end

            elseif distance > 8 then
                local current = {tp=player['vitals'].tp, hpp=player['vitals'].hpp, mpp=player['vitals'].mpp, main=helpers['equipment'].main, ranged=helpers['equipment'].ranged, ammo=helpers['equipment'].ammo}
                
                if ((get('am').enabled and self.hasAftermath()) or not get('am').enabled) then

                    if get('moonlight') and get('moonlight').enabled and current.mpp <= get('moonlight').mpp and current.tp >= get('ws').tp and isReady('WS', "Moonlight") then
                        add(bp.WS["Moonlight"], player)

                    elseif get('myrkr') and get('myrkr').enabled and current.mpp <= get('myrkr').mpp and current.tp >= get('ws').tp and isReady('WS', "Myrkr") then
                        add(bp.WS["Myrkr"], player)

                    elseif get('ra').name == "Mistral Axe" and current.main and current.main.skill == 5 and current.tp >= get('ra').tp and isReady('WS', "Mistral Axe") then
                        add(bp.WS["Mistral Axe"], target)

                    elseif current.ranged and current.ammo and current.tp >= get('ra').tp and current.ammo.en ~= 'Gil' and isReady('WS', get('ra').name) then
                        add(bp.WS[get('ra').name], target)

                    end

                elseif get('am').enabled and not self.hasAftermath() and current.tp >= get('am').tp and current.main then
                    local aftermath = bp.helpers['aftermath'].getWeaponskill(current.main.en)

                    if aftermath and isReady('WS', aftermath) then
                        add(bp.WS[aftermath], target)
                    end

                end

            end

        elseif target and player.status == 0 and bp.helpers['actions'].canAct() and get('ws').enabled and helpers['target'].getTarget() then
            local target = helpers['target'].getTarget()
            local distance = helpers['distance'].getDistance(target)
            
            if target and distance < 6 and distance ~= 0 then
                local current = {tp=player['vitals'].tp, hpp=player['vitals'].hpp, mpp=player['vitals'].mpp, main=helpers['equipment'].main, ranged=helpers['equipment'].ranged, ammo=helpers['equipment'].ammo}

                if ((get('am').enabled and self.hasAftermath()) or not get('am').enabled) then

                    if get('sanguine blade') and get('sanguine blade').enabled and current.hpp <= get('sanguine blade').hpp and current.tp >= get('ws').tp and isReady('WS', "Sanguine Blade") then
                        add(bp.WS["Sanguine Blade"], target)

                    elseif get('moonlight') and get('moonlight').enabled and current.mpp <= get('moonlight').mpp and current.tp >= get('ws').tp and isReady('WS', "Moonlight") then
                        add(bp.WS["Moonlight"], player)

                    elseif get('myrkr') and get('myrkr').enabled and current.mpp <= get('myrkr').mpp and current.tp >= get('ws').tp and isReady('WS', "Myrkr") then
                        add(bp.WS["Myrkr"], player)

                    elseif current.tp >= get('ws').tp and isReady('WS', get('ws').name) then
                        add(bp.WS[get('ws').name], target)

                    end

                elseif get('am').enabled and not self.hasAftermath() and current.tp >= get('am').tp and current.main then
                    local aftermath = bp.helpers['aftermath'].getWeaponskill(current.main.en)

                    if aftermath and isReady('WS', aftermath) then
                        add(bp.WS[aftermath], target)
                    end

                end

            elseif distance > 8 and get('ra').enabled then
                local current = {tp=player['vitals'].tp, hpp=player['vitals'].hpp, mpp=player['vitals'].mpp, main=helpers['equipment'].main, ranged=helpers['equipment'].ranged, ammo=helpers['equipment'].ammo}

                if ((get('am').enabled and self.hasAftermath()) or not get('am').enabled) then

                    if get('moonlight') and get('moonlight').enabled and current.mpp <= get('moonlight').mpp and current.tp >= get('ws').tp and isReady('WS', "Moonlight") then
                        add(bp.WS["Moonlight"], player)

                    elseif get('myrkr') and get('myrkr').enabled and current.mpp <= get('myrkr').mpp and current.tp >= get('ws').tp and isReady('WS', "Myrkr") then
                        add(bp.WS["Myrkr"], player)

                    elseif get('ra').name == "Mistral Axe" and current.main and current.main.skill == 5 and current.tp >= get('ra').tp and isReady('WS', "Mistral Axe") then
                        add(bp.WS["Mistral Axe"], target)

                    elseif current.ranged and current.ammo and current.tp >= get('ra').tp and current.ammo.en ~= 'Gil' and isReady('WS', get('ra').name) then
                        add(bp.WS[get('ra').name], target)

                    end

                elseif get('am').enabled and not self.hasAftermath() and current.tp >= get('am').tp and current.main then
                    local aftermath = bp.helpers['aftermath'].getWeaponskill(current.main.en)

                    if aftermath and isReady('WS', aftermath) then
                        add(bp.WS[aftermath], target)
                    end

                end

            end

        end

    end

    private.subs['WAR'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local buff      = helpers['buffs'].buffActive
        local isReady   = helpers['actions'].isReady
        local inQueue   = helpers['queue'].inQueue
        local buff      = helpers['buffs'].buffActive
        local add       = helpers['queue'].add
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('hate').enabled and target then

                -- PROVOKE.
                if target and get('provoke') and _act and isReady('JA', "Provoke") then
                    add(bp.JA["Provoke"], target)
                end

            end

            if get('buffs') and target and _act then

                -- BERSERK.
                if target and not get('tank') and get('berserk') and isReady('JA', "Berserk") and not inQueue(bp.JA["Defender"]) and not buff(56) then
                    add(bp.JA["Berserk"], player)

                -- DEFENDER.
                elseif target and get('tank') and get('defender') and isReady('JA', "Defender") and not inQueue(bp.JA["Berserk"]) and not buff(57) then
                    add(bp.JA["Defender"], player)

                -- WARCRY.
                elseif target and get('warcry') and isReady('JA', "Warcry") and not buff(68) then
                    add(bp.JA["Warcry"], player)

                -- AGGRESSOR.
                elseif target and get('aggressor') and isReady('JA', "Aggressor") and not buff(58) then
                    add(bp.JA["Aggressor"], player)

                -- RETALIATION.
                elseif target and get('retaliation') and isReady('JA', "Retaliation") and not buff(405) then
                    add(bp.JA["Retaliation"], player)

                end

            end

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('hate').enabled then

                -- PROVOKE.
                if get('provoke') and _act and isReady('JA', "Provoke") then
                    add(bp.JA["Provoke"], target)
                end

            end

            if get('buffs') and _act then

                -- BERSERK.
                if not get('tank') and get('berserk') and isReady('JA', "Berserk") and not inQueue(bp.JA["Defender"]) and not buff(56) then
                    add(bp.JA["Berserk"], player)

                -- DEFENDER.
                elseif get('tank') and get('defender') and isReady('JA', "Defender") and not inQueue(bp.JA["Berserk"]) and not buff(57) then
                    add(bp.JA["Defender"], player)

                -- WARCRY.
                elseif get('warcry') and isReady('JA', "Warcry") and not buff(68) then
                    add(bp.JA["Warcry"], player)

                -- AGGRESSOR.
                elseif get('aggressor') and isReady('JA', "Aggressor") and not buff(58) then
                    add(bp.JA["Aggressor"], player)

                -- RETALIATION.
                elseif get('retaliation') and isReady('JA', "Retaliation") and not buff(405) then
                    add(bp.JA["Retaliation"], player)

                end

            end

        end

    end

    private.subs['MNK'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local buff      = helpers['buffs'].buffActive
        local isReady   = helpers['actions'].isReady
        local inQueue   = helpers['queue'].inQueue
        local buff      = helpers['buffs'].buffActive
        local add       = helpers['queue'].add
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('ja') and _act then

                -- CHAKRA.
                if get('chakra').enabled and isReady('JA', "Chakra") and player['vitals'].hpp <= get('chakra').hpp then
                    add(bp.JA["Chakra"], player)

                -- CHI BLAST.
                elseif target and get('chi blast') and isReady('JA', "Chi Blast") then
                    add(bp.JA["Chi Blast"], target)

                end

            end

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('ja') and _act then

                -- CHAKRA.
                if get('chakra').enabled and isReady('JA', "Chakra") and player['vitals'].hpp <= get('chakra').hpp then
                    add(bp.JA["Chakra"], player)

                -- CHI BLAST.
                elseif get('chi blast') and isReady('JA', "Chi Blast") then
                    add(bp.JA["Chi Blast"], target)

                end

            end

            if get('buffs') and _act then

                -- FOCUS.
                if get('focus') and isReady('JA', "Focus") and not buff(59) then
                    add(bp.JA["Focus"], player)

                -- DODGE.
                elseif get('dodge') and isReady('JA', "Dodge") and not buff(60) then
                    add(bp.JA["Dodge"], player)

                -- COUNTERSTANCE.
                elseif get('counterstance') and isReady('JA', "Counterstance") and not buff(61) then
                    add(bp.JA["Counterstance"], player)

                -- FOOTWORK.
                elseif get('footwork') and isReady('JA', "Footwork") and not buff(406) then
                    add(bp.JA["Footwork"], player)

                end

            end

        end

    end

    private.subs['WHM'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local isReady   = helpers['actions'].isReady
        local inQueue   = helpers['queue'].inQueue
        local buff      = helpers['buffs'].buffActive
        local add       = helpers['queue'].add
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            -- RERAISE.
            if not buff(113) and _cast then

                if isReady('MA', "Reraise III") then
                    add(bp.MA["Reraise III"], player)

                elseif isReady('MA', "Reraise II") then
                    add(bp.MA["Reraise II"], player)

                elseif isReady('MA', "Reraise") then
                    add(bp.MA["Reraise"], player)

                end

            end

            if get('buffs') and _cast then

                -- STONESKIN.
                if get('stoneskin') and not helpers['buffs'].buffActive(37) and isReady('MA', "Stoneskin") then
                    add(bp.MA["Stoneskin"], player)

                -- BLNK.
                elseif get('blink') and not get('utsusemi') and not helpers['buffs'].buffActive(36) and isReady('MA', "Blink") and target then
                    add(bp.MA["Blink"], player)

                -- AQUAVEIL.
                elseif get('aquaveil') and isReady('MA', "Aquaveil") then
                    add(bp.MA["Aquaveil"], player)

                end

            end

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            -- RERAISE.
            if not buff(113) and _cast then

                if isReady('MA', "Reraise III") then
                    add(bp.MA["Reraise III"], player)

                elseif isReady('MA', "Reraise II") then
                    add(bp.MA["Reraise II"], player)

                elseif isReady('MA', "Reraise") then
                    add(bp.MA["Reraise"], player)

                end

            end

            if get('buffs') and _cast then

                -- STONESKIN.
                if get('stoneskin') and not helpers['buffs'].buffActive(37) and isReady('MA', "Stoneskin") then
                    add(bp.MA["Stoneskin"], player)

                -- BLNK.
                elseif get('blink') and not get('utsusemi') and not helpers['buffs'].buffActive(36) and isReady('MA', "Blink") then
                    add(bp.MA["Blink"], player)

                -- AQUAVEIL.
                elseif get('aquaveil') and isReady('MA', "Aquaveil") then
                    add(bp.MA["Aquaveil"], player)

                end

            end

        end

    end

    private.subs['BLM'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local isReady   = helpers['actions'].isReady
        local inQueue   = helpers['queue'].inQueue
        local buff      = helpers['buffs'].buffActive
        local add       = helpers['queue'].add
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('buffs') and _cast then

                -- SPIKES.
                if get('spikes').enabled and not self.hasSpikes() and isReady('MA', get('spikes').name) then
                    add(bp.MA[get('spikes').name], player)
                end

            end

            -- DRAIN.
            if target and get('drain').enabled and player['vitals'].hpp <= get('drain').hpp and isReady('MA', "Drain") and _cast then
                add(bp.MA["Drain"], target)
            end

            -- ASPIR.
            if target and get('aspir').enabled and player['vitals'].mpp <= get('aspir').mpp and isReady('MA', "Aspir") and _cast then
                add(bp.MA["Aspir"], target)
            end

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            -- SPIKES.
            if get('buffs') and _cast then

                if get('spikes').enabled and not self.hasSpikes() and isReady('MA', get('spikes').name) then
                    add(bp.MA[get('spikes').name], player)
                end

            end

            -- DRAIN.
            if get('drain').enabled and player['vitals'].hpp <= get('drain').hpp and isReady('MA', "Drain") and _cast then
                add(bp.MA["Drain"], target)
            end

            -- ASPIR.
            if get('aspir').enabled and player['vitals'].mpp <= get('aspir').mpp and isReady('MA', "Aspir") and _cast then
                add(bp.MA["Aspir"], target)
            end

        end

    end

    private.subs['RDM'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local isReady   = helpers['actions'].isReady
        local inQueue   = helpers['queue'].inQueue
        local buff      = helpers['buffs'].buffActive
        local add       = helpers['queue'].add
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()
            
            if get('ja') and _act then

                -- CONVERT.
                if get('convert').enabled and player['vitals'].hpp >= get('convert').hpp and player['vitals'].mpp <= get('convert').mpp then
                                
                    if isReady('JA', "Convert") then
                        add(bp.JA["Convert"], player)                        
                    end
                    
                end

            end

            if get('buffs') and _cast then
                
                -- HASTE.
                if isReady('MA', "Haste") and not helpers['buffs'].buffActive(33) then
                    add(bp.MA["Haste"], player)
                
                -- PHALANX.
                elseif isReady('MA', "Phalanx") and not helpers['buffs'].buffActive(116) then
                    add(bp.MA["Phalanx"], player)
                    
                -- REFRESH.
                elseif isReady('MA', "Refresh") and not helpers['buffs'].buffActive(43) and (not helpers['buffs'].buffActive(187) or not helpers['buffs'].buffActive(188)) then
                    add(bp.MA["Refresh"], player)

                -- ENSPELLS.
                elseif get('en').enabled and not self.hasEnspell() then
                        
                    if isReady('MA', get('en').name) then
                        add(bp.MA[get('en').name], player)
                    end
                    
                -- STONESKIN.
                elseif get('stoneskin') and isReady('MA', "Stoneskin") and not helpers['buffs'].buffActive(37) then
                    add(bp.MA["Stoneskin"], player)

                -- AQUAVEIL.
                elseif get('aquaveil') and isReady('MA', "Aquaveil") and not helpers['buffs'].buffActive(39) then
                    add(bp.MA["Aquaveil"], player)

                -- BLINK.
                elseif get('blink') and isReady('MA', "Blink") and not get('utsusemi') and not helpers['buffs'].buffActive(36) then
                    add(bp.MA["Blink"], player)
                    
                -- SPIKES.
                elseif isReady('MA', get('spikes').name) and not self.hasSpikes() then
                    add(bp.MA[get('spikes')], player)
                    
                end 

            end

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('ja') and _act then

                -- CONVERT.
                if get('convert').enabled and player['vitals'].hpp >= get('convert').hpp and player['vitals'].mpp <= get('convert').mpp then
                                
                    if isReady('JA', "Convert") then
                        add(bp.JA["Convert"], player)                        
                    end
                    
                end

            end

            if get('buffs') and _cast then
                
                -- HASTE.
                if isReady('MA', "Haste") and not helpers['buffs'].buffActive(33) then
                    add(bp.MA["Haste"], player)
                
                -- PHALANX.
                elseif isReady('MA', "Phalanx") and not helpers['buffs'].buffActive(116) then
                    add(bp.MA["Phalanx"], player)
                    
                -- REFRESH.
                elseif isReady('MA', "Refresh") and not helpers['buffs'].buffActive(43) and (not helpers['buffs'].buffActive(187) or not helpers['buffs'].buffActive(188)) then
                    add(bp.MA["Refresh"], player)

                -- ENSPELLS.
                elseif get('en').enabled and not self.hasEnspell() then
                        
                    if isReady('MA', get('en').name) then
                        add(bp.MA[get('en').name], player)
                    end
                    
                end 

            end

        end

    end

    private.subs['THF'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local isReady   = helpers['actions'].isReady
        local inQueue   = helpers['queue'].inQueue
        local buff      = helpers['buffs'].buffActive
        local add       = helpers['queue'].add
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            -- FLEE.
            if not target and get('flee') and isReady('JA', "Flee") and not buff(32) then
                add(bp.JA["Flee"], player)
            end

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()
            
            if get('ja') and _act then
                
                -- STEAL.
                if get('steal') and isReady('JA', "Steal") then
                    add(bp.JA["Steal"], target)

                -- MUG.
                elseif get('mug') and isReady('JA', "Mug") then
                    add(bp.JA["Mug"], target)

                end

            end

            if get('buffs') and _act then
                local behind = helpers['actions'].isBehind(target)
                local facing = helpers['actions'].isFacing(target)
                
                -- SNEAK ATTACK.
                if get('sneak attack') and isReady('JA', 'Sneak Attack') and not helpers['buffs'].buffActive(65) and player['vitals'].tp < get('ws').tp and (not get('am') or self.hasAftermath()) then
                    
                    if isReady('JA', 'Hide') then
                        add(bp.JA["Hide"], player)
                        add(bp.MA["Sneak Attack"], player)

                    elseif behind then
                        add(bp.JA["Sneak Attack"], player)

                    end

                -- TRICK ATTACK.
                elseif get('trick attack') and isReady('JA', 'Trick Attack') and not helpers['buffs'].buffActive(87) and player['vitals'].tp < get('ws').tp and (not get('am') or self.hasAftermath()) then

                    if behind then
                        add(bp.JA["Trick Attack"], player)
                    end

                end

            end

        end

    end

    private.subs['PLD'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local isReady   = helpers['actions'].isReady
        local inQueue   = helpers['queue'].inQueue
        local buff      = helpers['buffs'].buffActive
        local add       = helpers['queue'].add
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('ja') and _act then

                -- COVER.
                if get('cover').enabled and isReady('JA', "Cover") and helpers['party'].isInParty(windower.ffxi.get_mob_by_name(get('cover').target)) and helpers['enmity'].hasEnmity(windower.ffxi.get_mob_by_name(get('cover').target)) then
                    add(bp.MA["Cover"], windower.ffxi.get_mob_by_name(get('cover').target))

                -- SHIELD BASH.
                elseif target and get('shield bash') and isReady('JA', "Shield Bash") then
                    add(bp.JA["Shield Bash"], target)

                end

            end

            if get('hate').enabled and target then

                -- FLASH.
                if isReady('MA', "Flash") and _cast then
                    addToFront(bp.MA["Flash"], target)

                -- SHIELD BASH.
                elseif get('shield bash') and isReady('JA', "Shield Bash") and _act then
                    add(bp.JA["Shield Bash"], target)

                end

            end

            if get('buffs') and _act and target then

                -- REPRISAL.
                if isReady('MA', "Reprisal") and not helpers['buffs'].buffActive(403) then
                    add(bp.MA["Reprisal"], player)

                -- SENTINEL.
                elseif get('sentinel') and isReady('JA', "Sentinel") and not helpers['buffs'].buffActive(62) and (get('hate') or helpers['enmity'].hasEnmity(player)) then
                    add(bp.JA["Sentinel"], player)

                -- RAMPART.
                elseif get('rampart') and isReady('JA', "Rampart") and not helpers['buffs'].buffActive(623) then
                    add(bp.MA["Rampart"], player)

                end

            end

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('ja') and _act then
                local cover = get('cover').target ~= "" and windower.ffxi.get_mob_by_name(get('cover').target) or false

                -- COVER.
                if get('cover').enabled and isReady('JA', "Cover") and cover and helpers['party'].isInParty(cover) and helpers['enmity'].hasEnmity(cover) then
                    add(bp.JA["Cover"], cover)

                -- SHIELD BASH.
                elseif get('shield bash') and isReady('JA', "Shield Bash") then
                    add(bp.JA["Shield Bash"], target)

                end

            end

            if get('hate').enabled then

                -- FLASH.
                if isReady('MA', "Flash") and _cast then
                    addToFront(bp.MA["Flash"], target)

                -- SHIELD BASH.
                elseif get('shield bash') and isReady('JA', "Shield Bash") and _act then
                    add(bp.JA["Shield Bash"], target)

                end

            end

            if get('buffs') and _act then

                -- REPRISAL.
                if isReady('MA', "Reprisal") and not helpers['buffs'].buffActive(403) then
                    add(bp.MA["Reprisal"], player)

                -- SENTINEL.
                elseif get('sentinel') and isReady('JA', "Sentinel") and not helpers['buffs'].buffActive(62) and (get('hate') or helpers['enmity'].hasEnmity(player)) then
                    add(bp.JA["Sentinel"], player)

                -- RAMPART.
                elseif get('rampart') and isReady('JA', "Rampart") and not helpers['buffs'].buffActive(623) then
                    add(bp.MA["Rampart"], player)

                end

            end

        end

    end

    private.subs['DRK'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local isReady   = helpers['actions'].isReady
        local inQueue   = helpers['queue'].inQueue
        local buff      = helpers['buffs'].buffActive
        local add       = helpers['queue'].add
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('tank') and ((bp.player.buffs):contains(63) or (bp.player.buffs):contains(64)) then
                windower.send_command("cancel 63")
                windower.send_command("cancel 64")
            end

            if get('hate').enabled and target then

                -- STUN.
                if isReady('MA', "Stun") and _cast then
                    addToFront(bp.MA["Stun"], target)                            
                end
                
                if (os.clock()-timers.hate) > get('hate').delay then
                
                    -- SOULEATER.
                    if get('souleater') and isReady('JA', "Souleater") and not helpers['buffs'].buffActive(63) and not helpers['buffs'].buffActive(64) then
                        add(bp.JA["Souleater"], player)
                        timers.hate = os.clock()
                        
                    -- LAST RESORT.
                    elseif get('last resort') and isReady('JA', "Last Resort") and not helpers['buffs'].buffActive(63) and not helpers['buffs'].buffActive(64) then
                        add(bp.JA["Last Resort"], player)
                        timers.hate = os.clock()
                        
                    end
                    
                end

            end

            if get('buffs') and target then

                -- SOULEATER.
                if get('souleater') and not get('hate').enabled and isReady('JA', "Souleater") and not helpers['buffs'].buffActive(63) and not helpers['buffs'].buffActive(64) then
                    add(bp.JA["Souleater"], player)
                
                -- LAST RESORT.
                elseif get('last resort') and not get('hate').enabled and isReady('JA', "Last Resort") and not helpers['buffs'].buffActive(63) and not helpers['buffs'].buffActive(64) then
                    add(bp.JA["Last Resort"], player)

                -- CONSUME MANA.
                elseif get('consume mana') and isReady('JA', "Consume Mana") and not helpers['buffs'].buffActive(599) then
                    add(bp.JA["Consume Mana"], player)

                end

            end

            -- DRAIN.
            if target and get('drain').enabled and player['vitals'].hpp <= get('drain').hpp and isReady('MA', "Drain") and _cast then
                add(bp.MA["Drain"], target)
            end

            -- ASPIR.
            if target and get('aspir').enabled and player['vitals'].mpp <= get('aspir').mpp and isReady('MA', "Aspir") and _cast then
                add(bp.MA["Aspir"], target)
            end

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('tank') and ((bp.player.buffs):contains(63) or (bp.player.buffs):contains(64)) then
                windower.send_command("cancel 63")
                windower.send_command("cancel 64")
            end

            if get('hate').enabled and target then

                -- STUN.
                if isReady('MA', "Stun") and _cast then
                    addToFront(bp.MA["Stun"], target)                            
                end
                
                if (os.clock()-timers.hate) > get('hate').delay then
                
                    -- SOULEATER.
                    if get('souleater') and isReady('JA', "Souleater") and not helpers['buffs'].buffActive(63) and not helpers['buffs'].buffActive(64) then
                        add(bp.JA["Souleater"], player)
                        timers.hate = os.clock()
                        
                    -- LAST RESORT.
                    elseif get('last resort') and isReady('JA', "Last Resort") and not helpers['buffs'].buffActive(63) and not helpers['buffs'].buffActive(64) then
                        add(bp.JA["Last Resort"], player)
                        timers.hate = os.clock()
                        
                    end
                    
                end

            end

            if get('buffs') and target then

                -- SOULEATER.
                if get('souleater') and not get('hate').enabled and isReady('JA', "Souleater") and not helpers['buffs'].buffActive(63) and not helpers['buffs'].buffActive(64) then
                    add(bp.JA["Souleater"], player)
                
                -- LAST RESORT.
                elseif get('last resort') and not get('hate').enabled and isReady('JA', "Last Resort") and not helpers['buffs'].buffActive(63) and not helpers['buffs'].buffActive(64) then
                    add(bp.JA["Last Resort"], player)

                -- CONSUME MANA.
                elseif get('consume mana') and isReady('JA', "Consume Mana") and not helpers['buffs'].buffActive(599) then
                    add(bp.JA["Consume Mana"], player)

                end

            end

            -- DRAIN.
            if get('drain').enabled and player['vitals'].hpp <= get('drain').hpp and isReady('MA', "Drain") and _cast then
                add(bp.MA["Drain"], target)
            end

            -- ASPIR.
            if get('aspir').enabled and player['vitals'].mpp <= get('aspir').mpp and isReady('MA', "Aspir") and _cast then
                add(bp.MA["Aspir"], target)
            end

        end

    end

    private.subs['BST'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local isReady   = helpers['actions'].isReady
        local inQueue   = helpers['queue'].inQueue
        local buff      = helpers['buffs'].buffActive
        local add       = helpers['queue'].add
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

        end

    end

    private.subs['BRD'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local isReady   = helpers['actions'].isReady
        local inQueue   = helpers['queue'].inQueue
        local buff      = helpers['buffs'].buffActive
        local add       = helpers['queue'].add
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

        end

    end

    private.subs['RNG'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local isReady   = helpers['actions'].isReady
        local inQueue   = helpers['queue'].inQueue
        local buff      = helpers['buffs'].buffActive
        local add       = helpers['queue'].add
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('ja') and _act then

                -- SCAVENGE.
                if get('scavenge') and isReady('JA', "Scavenge") then
                    add(bp.JA["Scavenge"], player)
                end

            end

            if get('buffs') and target and _act then

                -- SHARPSHOT.
                if get('sharpshot') and isReady('JA', "Sharpshot") then
                    add(bp.JA["Sharpshot"], player)

                -- BARRAGE.
                elseif get('barrage') and isReady('JA', "Barrage") then

                    if get('camouflage') and isReady('JA', "Camouflage") then
                        add(bp.JA["Camouflage"], player)
                        add(bp.JA["Barrage"], player)

                    else
                        add(bp.JA["Barrage"], player)

                    end

                -- VELOCITY SHOT.
                elseif get('velocity shot') and isReady('JA', "Velocity Shot") then
                    add(bp.JA["Velocity Shot"], player)

                -- UNLIMITED SHOT.
                elseif get('unlimited shot') and isReady('JA', "Unlimited Shot") then
                    add(bp.JA["Unlimited Shot"], player)

                end

            end

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('ja') and _act then

                -- SCAVENGE.
                if get('scavenge') and isReady('JA', "Scavenge") then
                    add(bp.JA["Scavenge"], player)
                end

            end

            if get('buffs') and _act then

                -- SHARPSHOT.
                if get('sharpshot') and isReady('JA', "Sharpshot") then
                    add(bp.JA["Sharpshot"], player)

                -- BARRAGE.
                elseif get('barrage') and isReady('JA', "Barrage") then

                    if get('camouflage') and isReady('JA', "Camouflage") then
                        add(bp.JA["Camouflage"], player)
                        add(bp.JA["Barrage"], player)

                    else
                        add(bp.JA["Barrage"], player)

                    end

                -- VELOCITY SHOT.
                elseif get('velocity shot') and isReady('JA', "Velocity Shot") then
                    add(bp.JA["Velocity Shot"], player)

                -- UNLIMITED SHOT.
                elseif get('unlimited shot') and isReady('JA', "Unlimited Shot") then
                    add(bp.JA["Unlimited Shot"], player)

                end

            end

        end

    end

    private.subs['SMN'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local isReady   = helpers['actions'].isReady
        local inQueue   = helpers['queue'].inQueue
        local buff      = helpers['buffs'].buffActive
        local add       = helpers['queue'].add
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('ja') and _act then
                local pet = windower.ffxi.get_mob_by_target('pet') or false
                
                if pet and pet.status == 1 then

                    if get('bpr').enabled and get('bpr').pacts[pet.name] and isReady('JA', "Blood Pact: Rage") then
                        
                        if get('mana cede') and isReady('JA', "Mana Cede") then
                            add(bp.JA["Mana Cede"], player)
                        end

                        if get('apogee') and isReady('JA', "Apogee") then
                            add(bp.JA["Apogee"], player)
                        end
                        add(bp.JA[get('bpr').pacts[pet.name]], target)
                    
                    elseif get('bpw').enabled and get('bpw').pacts[pet.name] and isReady('JA', "Blood Pact: Ward") then
                        local ward = bp.JA[get('bpw').pacts[pet.name]]

                        if get('buffs') and helpers['target'].castable(player, ward) then
                            add(bp.JA[get('bpw').pacts[pet.name]], player)
    
                        else
                            add(bp.JA[get('bpw').pacts[pet.name]], target)
    
                        end

                    end

                elseif pet and (target or pet.status == 0) then
                    
                    if get('assault') and isReady('JA', "Blood Pact: Rage") and target then
                        add(bp.JA["Assault"], target)
                        
                    else
                        
                        if get('bpr').enabled and get('bpr').pacts[pet.name] and isReady('JA', "Blood Pact: Rage") and target then
                            
                            if get('mana cede') and isReady('JA', "Mana Cede") then
                                add(bp.JA["Mana Cede"], player)
                            end
    
                            if get('apogee') and isReady('JA', "Apogee") then
                                add(bp.JA["Apogee"], player)
                            end
                            add(bp.JA[get('bpr').pacts[pet.name]], target)

                        elseif get('bpw').enabled and get('bpw').pacts[pet.name] and isReady('JA', "Blood Pact: Ward") then
                            local ward = bp.JA[get('bpw').pacts[pet.name]]

                            if get('buffs') and helpers['target'].castable(player, ward) then
                                add(bp.JA[get('bpw').pacts[pet.name]], player)
        
                            else
                                add(bp.JA[get('bpw').pacts[pet.name]], target)
        
                            end
    
                        end

                    end

                end

            end

            if get('summon').enabled and _cast then
                local pet = windower.ffxi.get_mob_by_target('pet') or false

                if not pet and isReady('MA', get('summon').name) and player['vitals'].mpp >= 5 then
                    add(bp.MA[get('summon').name], player)
                end

            end

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('ja') and _act then
                local pet = windower.ffxi.get_mob_by_target('pet') or false
                
                if pet and pet.status == 1 then

                    if get('bpr').enabled and get('bpr').pacts[pet.name] and isReady('JA', "Blood Pact: Rage") then
                        
                        if get('mana cede') and isReady('JA', "Mana Cede") then
                            add(bp.JA["Mana Cede"], player)
                        end

                        if get('apogee') and isReady('JA', "Apogee") then
                            add(bp.JA["Apogee"], player)
                        end
                        add(bp.JA[get('bpr').pacts[pet.name]], target)

                    elseif get('bpw').enabled and get('bpw').pacts[pet.name] and isReady('JA', "Blood Pact: Ward") then
                        local ward = bp.JA[get('bpw').pacts[pet.name]]

                        if get('buffs') and helpers['target'].castable(player, ward) then
                            add(bp.JA[get('bpw').pacts[pet.name]], player)
    
                        else
                            add(bp.JA[get('bpw').pacts[pet.name]], target)
    
                        end

                    end

                elseif pet and pet.status == 0 then
                    
                    if get('assault') and isReady('JA', "Blood Pact: Rage") then
                        add(bp.JA["Assault"], target)
                        
                    else
                        
                        if get('bpr').enabled and get('bpr').pacts[pet.name] and isReady('JA', "Blood Pact: Rage") then
                            
                            if get('mana cede') and isReady('JA', "Mana Cede") then
                                add(bp.JA["Mana Cede"], player)
                            end
    
                            if get('apogee') and isReady('JA', "Apogee") then
                                add(bp.JA["Apogee"], player)
                            end
                            add(bp.JA[get('bpr').pacts[pet.name]], target)

                        elseif get('bpw').enabled and get('bpw').pacts[pet.name] and isReady('JA', "Blood Pact: Ward") then
                            local ward = bp.JA[get('bpw').pacts[pet.name]]

                            if get('buffs') and helpers['target'].castable(player, ward) then
                                add(bp.JA[get('bpw').pacts[pet.name]], player)
        
                            else
                                add(bp.JA[get('bpw').pacts[pet.name]], target)
        
                            end
    
                        end

                    end

                end

            end

            if get('summon').enabled and _cast then
                local pet = windower.ffxi.get_mob_by_target('pet') or false

                if not pet and isReady('MA', get('summon').name) and player['vitals'].mpp >= 5 then
                    add(bp.MA[get('summon').name], player)
                end

            end

        end

    end

    private.subs['SAM'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local isReady   = helpers['actions'].isReady
        local inQueue   = helpers['queue'].inQueue
        local buff      = helpers['buffs'].buffActive
        local add       = helpers['queue'].add
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('ja') and _act then

                -- MEDITATE
                if get('meditate') and isReady('JA', "Meditate") and (os.clock()-timers.meditate) > 30 then
                    add(bp.JA["Meditate"], player)
                    timers.meditate = os.clock()
                    
                end

            end

            if get('buffs') and _act then
                local weapon = bp.helpers['equipment'].main
                            
                -- HASSO & SEIGAN.
                if (get('hasso') or get('seigan')) and weapon then

                    if get('hasso') and isReady('JA', "Hasso") and not helpers['buffs'].buffActive(353) and not get('tank') and T{4,6,7,8,10,12}:contains(weapon.skill) then
                        add(bp.JA["Hasso"], player)

                    elseif get('seigan') and isReady('JA', "Seigan") and not helpers['buffs'].buffActive(354) and get('tank') and T{4,6,7,8,10,12}:contains(weapon.skill) then
                        add(bp.JA["Seigan"], player)

                    end

                end

                if (not get('hasso') and not get('seigan')) or (helpers['buffs'].buffActive(353) or helpers['buffs'].buffActive(354)) and target then

                    -- THIRD EYE.
                    if get('third eye') and isReady('JA', "Third Eye") and not helpers['buffs'].buffActive(67) and not helpers['buffs'].buffActive(36) and target and not self.hasShadows() then
                        add(bp.JA["Third Eye"], player)
                    end

                    -- SEKKANOKI.
                    if get('sekkanoki') and isReady('JA', "Sekkanoki") and not helpers['buffs'].buffActive(408) and player['vitals'].tp >= 2000 then
                        add(bp.JA["Sekkanoki"], player)
                    end

                    -- KONZEN-ITTAI.
                    if get('konzen-ittai') and isReady('JA', "Konzen-Ittai") and player['vitals'].tp >= math.floor((get('ws').tp/3)*2) and (os.clock()-timers.konzen) > 60 then
                        add(bp.JA["Konzen-Ittai"])
                        timers.konzen = os.clock()

                    end

                end

            end

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('ja') and _act then

                -- MEDITATE
                if get('meditate') and isReady('JA', "Meditate") and (os.clock()-timers.meditate) > 30 then
                    add(bp.JA["Meditate"], player)
                    timers.meditate = os.clock()
                    
                end

            end

            if get('buffs') and _act then
                local weapon = bp.helpers['equipment'].main
                            
                -- HASSO & SEIGAN.
                if (get('hasso') or get('seigan')) and weapon then

                    if get('hasso') and isReady('JA', "Hasso") and not helpers['buffs'].buffActive(353) and not get('tank') and T{4,6,7,8,10,12}:contains(weapon.skill) then
                        add(bp.JA["Hasso"], player)

                    elseif get('seigan') and isReady('JA', "Seigan") and not helpers['buffs'].buffActive(354) and get('tank') and T{4,6,7,8,10,12}:contains(weapon.skill) then
                        add(bp.JA["Seigan"], player)

                    end

                end

                if (not get('hasso') and not get('seigan')) or (helpers['buffs'].buffActive(353) or helpers['buffs'].buffActive(354)) then

                    -- THIRD EYE.
                    if get('third eye') and isReady('JA', "Third Eye") and not helpers['buffs'].buffActive(67) and not helpers['buffs'].buffActive(36) and not self.hasShadows() then
                        add(bp.JA["Third Eye"], player)
                    end

                    -- SEKKANOKI.
                    if get('sekkanoki') and isReady('JA', "Sekkanoki") and not helpers['buffs'].buffActive(408) and player['vitals'].tp >= 2000 then
                        add(bp.JA["Sekkanoki"], player)
                    end

                    -- KONZEN-ITTAI.
                    if get('konzen-ittai') and isReady('JA', "Konzen-Ittai") and player['vitals'].tp >= math.floor((get('ws').tp/3)*2) and (os.clock()-timers.konzen) > 60 then
                        add(bp.JA["Konzen-Ittai"])
                        timers.konzen = os.clock()

                    end

                end

            end

        end

    end

    private.subs['NIN'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local isReady   = helpers['actions'].isReady
        local inQueue   = helpers['queue'].inQueue
        local buff      = helpers['buffs'].buffActive
        local add       = helpers['queue'].add
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('buffs') and target then

                -- INNIN & YONIN.
                if get('tank') and get('yonin') and isReady('JA', "Yonin") and not helpers['buffs'].buffActive(420) and helpers['actions'].isFacing() and _act then
                    add(bp.JA["Yonin"], player)

                elseif not get('tank') and get('innin') and isReady('JA', "Innin") and not helpers['buffs'].buffActive(421) and helpers['actions'].isBehind() and _act then
                    add(bp.JA["Innin"], player)

                end

                -- UTSUSEMI.
                if get('utsusemi') and (os.clock()-timers.utsusemi) > 1.5 and _cast then
                    local tools = helpers['inventory'].findItemByName("Shihei")

                    if tools and not self.hasShadows() then
                        local queue = helpers['queue'].queue
                        local check = false
                        
                        for _,v in ipairs(queue) do
                            if v.action.en:match('Utsusemi') then
                                check = true
                                break

                            end
                        end

                        if not check then
                            
                            if helpers['actions'].isReady('MA', "Utsusemi: San") then
                                helpers['queue'].addToFront(bp.MA["Utsusemi: San"], player)

                            elseif helpers['actions'].isReady('MA', "Utsusemi: Ni") then
                                helpers['queue'].addToFront(bp.MA["Utsusemi: Ni"], player)
                                    
                            elseif helpers['actions'].isReady('MA', "Utsusemi: Ichi") then
                                helpers['queue'].addToFront(bp.MA["Utsusemi: Ichi"], player)
                                    
                            end
                        
                        end

                    elseif not tools then
                        local toolbag = helpers['inventory'].findItemByName("Toolbag (Shihe)")

                        if toolbag and helpers['inventory'].hasSpace() and helpers['actions'].canItem() then
                            helpers['queue'].addToFront(bp.IT["Toolbag (Shihe)"], player)
                        end

                    end

                end

            end

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('buffs') then

                -- INNIN & YONIN.
                if get('tank') and get('yonin') and isReady('JA', "Yonin") and not helpers['buffs'].buffActive(420) and helpers['actions'].isFacing() and _act then
                    add(bp.JA["Yonin"], player)

                elseif not get('tank') and get('innin') and isReady('JA', "Innin") and not helpers['buffs'].buffActive(421) and helpers['actions'].isBehind() and _act then
                    add(bp.JA["Innin"], player)

                end

                -- UTSUSEMI.
                if get('utsusemi') and (os.clock()-timers.utsusemi) > 1.5 and _cast then
                    local tools = helpers['inventory'].findItemByName("Shihei")

                    if tools and not self.hasShadows() then
                        local queue = helpers['queue'].queue.data
                        local check = false
                        
                        for _,v in ipairs(queue) do
                            if v.action.en:match('Utsusemi') then
                                check = true
                                break

                            end
                        end

                        if not check then
                            
                            if helpers['actions'].isReady('MA', "Utsusemi: San") then
                                helpers['queue'].addToFront(bp.MA["Utsusemi: San"], player)

                            elseif helpers['actions'].isReady('MA', "Utsusemi: Ni") then
                                helpers['queue'].addToFront(bp.MA["Utsusemi: Ni"], player)
                                    
                            elseif helpers['actions'].isReady('MA', "Utsusemi: Ichi") then
                                helpers['queue'].addToFront(bp.MA["Utsusemi: Ichi"], player)
                                    
                            end
                        
                        end

                    elseif not tools then
                        local toolbag = helpers['inventory'].findItemByName("Toolbag (Shihe)")

                        if toolbag and helpers['inventory'].hasSpace() and helpers['actions'].canItem() then
                            helpers['queue'].addToFront(bp.IT["Toolbag (Shihe)"], player)
                        end

                    end

                end

            end

        end

    end

    private.subs['DRG'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local isReady   = helpers['actions'].isReady
        local inQueue   = helpers['queue'].inQueue
        local buff      = helpers['buffs'].buffActive
        local add       = helpers['queue'].add
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('ja') and target and _act then

                -- JUMP.
                if get('jump') and isReady('JA', "Jump") then
                    add(bp.JA["Jump"], target)
                    
                -- HIGH JUMP.
                elseif get('high jump') and isReady('JA', "High Jump") then
                    add(bp.JA["High Jump"], target)
                    
                end

                -- SUPER JUMP.
                if get('super jump') and isReady('JA', "Super Jump") and helpers['enmity'].hasEnmity(player) then
                    add(bp.JA["Super Jump"], target)
                end

            end

            if get('buffs') and _act and target then

                -- ANCIENT CIRCLE.
                --if target and not helpers['buffs'].buffActive(118) and helpers['actions'].isReady('JA', "Ancient Circle") then
                    --helpers['queue'].add(bp.JA["Ancient Circle"], player)                            
                --end

            end

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('ja') and _act then

                -- JUMP.
                if get('jump') and isReady('JA', "Jump") then
                    add(bp.JA["Jump"], target)
                    
                -- HIGH JUMP.
                elseif get('high jump') and isReady('JA', "High Jump") then
                    add(bp.JA["High Jump"], target)
                    
                end

                -- SUPER JUMP.
                if get('super jump') and isReady('JA', "Super Jump") and helpers['enmity'].hasEnmity(player) then
                    add(bp.JA["Super Jump"], target)
                end

            end

            if get('buffs') and _act then

                -- ANCIENT CIRCLE.
                --if target and not helpers['buffs'].buffActive(118) and helpers['actions'].isReady('JA', "Ancient Circle") then
                    --helpers['queue'].add(bp.JA["Ancient Circle"], player)                            
                --end

            end

        end

    end

    private.subs['BLU'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local isReady   = helpers['actions'].isReady
        local inQueue   = helpers['queue'].inQueue
        local buff      = helpers['buffs'].buffActive
        local add       = helpers['queue'].add
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('hate').enabled and target and _cast then

                -- JETTATURA.
                if isReady('MA', "Jettatura") then
                    add(bp.MA["Jettatura"], target)
                    
                -- BLANK GAZE.
                elseif isReady('MA', "Blank Gaze") then
                    add(bp.MA["Blank Gaze"], target)
                    
                end
                
                if get('hate').aoe and (os.clock()-timers.hate) > get('hate').delay then
                    
                    -- SOPORIFIC.
                    if isReady('MA', "Soporific") then
                        add(bp.MA["Soporific"], target)
                        timers.hate = os.clock()
                    
                    -- GEIST WALL.
                    elseif isReady('MA', "Geist Wall") then
                        add(bp.MA["Geist Wall"], target)
                        timers.hate = os.clock()
                    
                    -- SHEEP SONG.
                    elseif isReady('MA', "Sheep Song") then
                        add(bp.MA["Sheep Song"], target)
                        timers.hate = os.clock()

                    -- STINKING GAS.
                    elseif isReady('MA', "Stinking Gas") then
                        add(bp.MA["Stinking Gas"], target)
                        timers.hate = os.clock()
                    
                    end
                    
                end

            end

            if get('buffs') and target and _cast then

                -- HASTE.
                if not buff(93) then

                    if player.main_job_level >= 99 and isReady('MA', "Erratic Flutter") then
                        add(bp.MA["Erratic Flutter"], player)

                    elseif player.main_job_level >= 99 and isReady('MA', "Animating Wail") then
                        add(bp.MA["Animating Wail"], player)

                    elseif player.main_job_level <= 48 and isReady('MA', "Refueling") then
                        add(bp.MA["Refueling"], player)

                    end

                end

                -- COCOON.
                if isReady('MA', "Cocoon") and not helpers['buffs'].buffActive(93) then
                    add(bp.MA["Cocoon"], player)
                end

            end

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('hate').enabled and _cast then

                -- JETTATURA.
                if isReady('MA', "Jettatura") then
                    add(bp.MA["Jettatura"], target)
                    
                -- BLANK GAZE.
                elseif isReady('MA', "Blank Gaze") then
                    add(bp.MA["Blank Gaze"], target)
                    
                end
                
                if get('hate').aoe and (os.clock()-timers.hate) > get('hate').delay then
                    
                    -- SOPORIFIC.
                    if isReady('MA', "Soporific") then
                        add(bp.MA["Soporific"], target)
                        timers.hate = os.clock()
                    
                    -- GEIST WALL.
                    elseif isReady('MA', "Geist Wall") then
                        add(bp.MA["Geist Wall"], target)
                        timers.hate = os.clock()
                    
                    -- SHEEP SONG.
                    elseif isReady('MA', "Sheep Song") then
                        add(bp.MA["Sheep Song"], target)
                        timers.hate = os.clock()

                    -- STINKING GAS.
                    elseif isReady('MA', "Stinking Gas") then
                        add(bp.MA["Stinking Gas"], target)
                        timers.hate = os.clock()
                    
                    end
                    
                end

            end

            if get('buffs') and _cast then

                -- HASTE.
                if not buff(93) then

                    if player.main_job_level >= 99 and isReady('MA', "Erratic Flutter") then
                        add(bp.MA["Erratic Flutter"], player)

                    elseif player.main_job_level >= 99 and isReady('MA', "Animating Wail") then
                        add(bp.MA["Animating Wail"], player)

                    elseif player.main_job_level <= 48 and isReady('MA', "Refueling") then
                        add(bp.MA["Refueling"], player)

                    end

                end

                -- COCOON.
                if isReady('MA', "Cocoon") and not helpers['buffs'].buffActive(93) then
                    add(bp.MA["Cocoon"], player)
                end

            end

        end

    end

    private.subs['COR'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local isReady   = helpers['actions'].isReady
        local inQueue   = helpers['queue'].inQueue
        local buff      = helpers['buffs'].buffActive
        local add       = helpers['queue'].add
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('ja') and _act then

                -- QUICK DRAW.
                if get('quick draw').enabled and isReady('JA', get('quick draw').name) then
                    add(bp.JA[get('quick draw').name], player)

                -- RANDOM DEAL.
                elseif get('random deal') and isReady('JA', "Random Deal") then
                    add(bp.JA["Random Deal"], player)

                end

            end

            if get('buffs') and _act then
                local active = bp.helpers['rolls'].getActive()

                -- ROLLS.
                if bp.helpers['rolls'].enabled and active < 1 then
                    bp.helpers['rolls'].roll()

                -- TRIPLE SHOT.
                elseif get('ra').enabled and isReady('JA', "Triple Shot") and not helpers['buffs'].buffActive(467) and target then
                    add(bp.JA["Triple Shot"], player)

                end

            end

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('ja') and _act then

                -- QUICK DRAW.
                if get('quick draw').enabled and isReady('JA', get('quick draw').name) then
                    add(bp.JA[get('quick draw').name], player)

                -- RANDOM DEAL.
                elseif get('random deal') and isReady('JA', "Random Deal") then
                    add(bp.JA["Random Deal"], player)

                end

            end

            if get('buffs') and _act then
                local active = bp.helpers['rolls'].getActive()

                -- ROLLS.
                if bp.helpers['rolls'].enabled and active < 1 then
                    bp.helpers['rolls'].roll()

                -- TRIPLE SHOT.
                elseif get('ra').enabled and isReady('JA', "Triple Shot") and not helpers['buffs'].buffActive(467) and target then
                    add(bp.JA["Triple Shot"], player)

                end

            end

        end

    end

    private.subs['PUP'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local isReady   = helpers['actions'].isReady
        local inQueue   = helpers['queue'].inQueue
        local buff      = helpers['buffs'].buffActive
        local add       = helpers['queue'].add
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

        end

    end

    private.subs['DNC'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local isReady   = helpers['actions'].isReady
        local inQueue   = helpers['queue'].inQueue
        local add       = helpers['queue'].add
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()
            local moves  = helpers['buffs'].getFinishingMoves()

            if get('ja') and _act and target then

                -- FLOURISHES.
                if get('flourishes').enabled then
                    local f1 = get('flourishes').cat_1
                    local f2 = get('flourishes').cat_2
                    local f3 = get('flourishes').cat_3

                    if moves > 0 then

                        if isReady('JA', f1) and f1 ~= 'Animated Flourish' then
                            add(bp.JA[f1], target)
                        
                        elseif isReady('JA', f2) then
                            add(bp.JA[f2], target)

                        elseif isReady('JA', f3) then
                            add(bp.JA[f3], target)

                        end

                    end

                end

                -- STEPS.
                if get('steps').enabled and isReady('JA', get('steps').name) then
                    add(bp.JA[get('steps').name], target)
                end

            end

            if get('hate').enabled and _act and target then

                -- ANIMATED FLOURISH.
                if moves > 0 and isReady('JA', f1) and f1 == 'Animated Flourish' then
                    add(bp.JA[f1], target)
                end

            end

            if get('buffs') and _act and target then

                -- SAMBAS.
                if get('sambas').enabled and isReady('JA', get('sambas').name) then
                    add(bp.JA[get('sambas').name], player)
                end

            end

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()
            local moves  = helpers['buffs'].getFinishingMoves()

            if get('ja') and _act then

                -- FLOURISHES.
                if get('flourishes').enabled then
                    local f1 = get('flourishes').cat_1
                    local f2 = get('flourishes').cat_2
                    local f3 = get('flourishes').cat_3

                    if moves > 0 then

                        if isReady('JA', f1) and f1 ~= 'Animated Flourish' then
                            add(bp.JA[f1], target)
                        
                        elseif isReady('JA', f2) then
                            add(bp.JA[f2], target)

                        elseif isReady('JA', f3) then
                            add(bp.JA[f3], target)

                        end

                    end

                end

                -- STEPS.
                if get('steps').enabled and isReady('JA', get('steps').name) then
                    add(bp.JA[get('steps').name], target)
                end

            end

            if get('hate').enabled and _act then

                -- ANIMATED FLOURISH.
                if moves > 0 and isReady('JA', f1) and f1 == 'Animated Flourish' then
                    add(bp.JA[f1], target)
                end

            end

            if get('buffs') and _act then

                -- SAMBAS.
                if get('sambas').enabled and isReady('JA', get('sambas').name) then
                    add(bp.JA[get('sambas').name], player)
                end

            end

        end

    end

    private.subs['SCH'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local isReady   = helpers['actions'].isReady
        local inQueue   = helpers['queue'].inQueue
        local buff      = helpers['buffs'].buffActive
        local add       = helpers['queue'].add
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('ja') and _act then

                -- SUBLIMATION.
                if get('sublimation').enabled and _act then
                            
                    if player['vitals'].mpp <= get('sublimation').mpp and isReady('JA', "Sublimation") and helpers['buffs'].buffActive(188) and (os.clock()-timers.sublimation) > 60 then
                        add(bp.JA["Sublimation"], player)
                        timers.sublimation = os.clock()

                    elseif player['vitals'].mpp <= 20 and isReady('JA', "Sublimation") and (helpers['buffs'].buffActive(187) or helpers['buffs'].buffActive(188)) and (os.clock()-timers.sublimation) > 60 then
                        add(bp.JA["Sublimation"], player)
                        timers.sublimation = os.clock()

                    elseif isReady('JA', "Sublimation") and not helpers['buffs'].buffActive(187) and not helpers['buffs'].buffActive(188) then
                        add(bp.JA["Sublimation"], player)
                        timers.sublimation = os.clock()

                    end
                    
                end

                -- LIBRA.
                if get('libra') and isReady('JA', "Libra") and target then
                    add(bp.JA["Libra"], target)
                end

            end

            if get('buffs') then

                if (not helpers['buffs'].buffActive(358) or not helpers['buffs'].buffActive(359)) and (get('light arts') or get('dark arts')) then

                    -- LIGHT ARTS.
                    if get('light arts') and isReady('JA', "Light Arts") and not helpers['buffs'].buffActive(358) and _act then
                        add(bp.JA["Light Arts"], player)

                    -- DARK ARTS.
                    elseif get('dark arts') and isReady('JA', "Dark Arts") and not helpers['buffs'].buffActive(359) and _act then
                        add(bp.JA["Light Arts"], player)

                    end

                elseif (not get('light arts') and not get('dark arts')) or (not helpers['buffs'].buffActive(358) or not helpers['buffs'].buffActive(359)) and _cast then

                    -- STORMS.
                    if get('storms').enabled and _cast then

                        if helpers['buffs'].buffActive(358) and not self.hasStorm() then
                            add(bp.MA["Aurorastorm"], player)

                        elseif helpers['buffs'].buffActive(359) and not self.hasStorm() then
                            add(bp.MA[get('storms').name], player)

                        end

                    end

                    -- KLIMAFORM
                    if get('dark arts') and isReady('MA', "Klimaform") and not helpers['buffs'].buffActive(407) and target then
                        add(bp.MA["Klimaform"], player)

                    -- STONESKIN.
                    elseif get('stoneskin') and isReady('MA', "Stoneskin") and not helpers['buffs'].buffActive(37) then
                        add(bp.MA["Stoneskin"], player)

                    -- AQUAVEIL.
                    elseif get('aquaveil') and isReady('MA', "Aquaveil") and not helpers['buffs'].buffActive(39) then
                        add(bp.MA["Aquaveil"], player)

                    -- BLINK.
                    elseif get('blink') and isReady('MA', "Blink") and not get('utsusemi') and not helpers['buffs'].buffActive(36) then
                        add(bp.MA["Blink"], player)
                        
                    -- SPIKES.
                    elseif isReady('MA', get('spikes').name) and self.hasSpikes() and target then
                        add(bp.MA[get('spikes')], player)
                        
                    end

                end

            end

            -- DRAIN.
            if target and get('drain').enabled and player['vitals'].hpp <= get('drain').hpp and isReady('MA', "Drain") and _cast then
                add(bp.MA["Drain"], target)
            end

            -- ASPIR.
            if target and get('aspir').enabled and player['vitals'].mpp <= get('aspir').mpp and isReady('MA', "Aspir") and _cast then
                add(bp.MA["Aspir"], target)
            end

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('ja') and _act then

                -- SUBLIMATION.
                if get('sublimation').enabled and _act then
                            
                    if player['vitals'].mpp <= get('sublimation').mpp and isReady('JA', "Sublimation") and helpers['buffs'].buffActive(188) and (os.clock()-timers.sublimation) > 60 then
                        add(bp.JA["Sublimation"], player)
                        timers.sublimation = os.clock()

                    elseif player['vitals'].mpp <= 20 and isReady('JA', "Sublimation") and (helpers['buffs'].buffActive(187) or helpers['buffs'].buffActive(188)) and (os.clock()-timers.sublimation) > 60 then
                        add(bp.JA["Sublimation"], player)
                        timers.sublimation = os.clock()

                    elseif isReady('JA', "Sublimation") and not helpers['buffs'].buffActive(187) and not helpers['buffs'].buffActive(188) then
                        add(bp.JA["Sublimation"], player)
                        timers.sublimation = os.clock()

                    end
                    
                end

                -- LIBRA.
                if get('libra') and isReady('JA', "Libra") then
                    add(bp.JA["Libra"], target)
                end

            end

            if get('buffs') then

                if (not helpers['buffs'].buffActive(358) or not helpers['buffs'].buffActive(359)) and (get('light arts') or get('dark arts')) then

                    -- LIGHT ARTS.
                    if get('light arts') and isReady('JA', "Light Arts") and not helpers['buffs'].buffActive(358) and _act then
                        add(bp.JA["Light Arts"], player)

                    -- DARK ARTS.
                    elseif get('dark arts') and isReady('JA', "Dark Arts") and not helpers['buffs'].buffActive(359) and _act then
                        add(bp.JA["Light Arts"], player)

                    end

                elseif (not get('light arts') and not get('dark arts')) or (not helpers['buffs'].buffActive(358) or not helpers['buffs'].buffActive(359)) and _cast then

                    -- STORMS.
                    if get('storms').enabled and _cast then

                        if helpers['buffs'].buffActive(358) and not self.hasStorm() then
                            add(bp.MA["Aurorastorm"], player)

                        elseif helpers['buffs'].buffActive(359) and not self.hasStorm() then
                            add(bp.MA[get('storms').name], player)

                        end

                    end

                    -- KLIMAFORM
                    if get('dark arts') and isReady('MA', "Klimaform") and not helpers['buffs'].buffActive(407) then
                        add(bp.MA["Klimaform"], player)

                    -- STONESKIN.
                    elseif get('stoneskin') and isReady('MA', "Stoneskin") and not helpers['buffs'].buffActive(37) then
                        add(bp.MA["Stoneskin"], player)

                    -- AQUAVEIL.
                    elseif get('aquaveil') and isReady('MA', "Aquaveil") and not helpers['buffs'].buffActive(39) then
                        add(bp.MA["Aquaveil"], player)

                    -- BLINK.
                    elseif get('blink') and isReady('MA', "Blink") and not get('utsusemi') and not helpers['buffs'].buffActive(36) then
                        add(bp.MA["Blink"], player)
                        
                    -- SPIKES.
                    elseif isReady('MA', get('spikes').name) and self.hasSpikes() then
                        add(bp.MA[get('spikes')], player)
                        
                    end

                end

            end

            -- DRAIN.
            if get('drain').enabled and player['vitals'].hpp <= get('drain').hpp and isReady('MA', "Drain") and _cast then
                add(bp.MA["Drain"], target)
            end

            -- ASPIR.
            if get('aspir').enabled and player['vitals'].mpp <= get('aspir').mpp and isReady('MA', "Aspir") and _cast then
                add(bp.MA["Aspir"], target)
            end

        end

    end

    private.subs['GEO'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local isReady   = helpers['actions'].isReady
        local inQueue   = helpers['queue'].inQueue
        local buff      = helpers['buffs'].buffActive
        local add       = helpers['queue'].add
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            -- DRAIN.
            if get('drain').enabled and player['vitals'].hpp <= get('drain').hpp and isReady('MA', "Drain") and _cast then
                add(bp.MA["Drain"], target)
            end

            -- ASPIR.
            if get('aspir').enabled and player['vitals'].mpp <= get('aspir').mpp and isReady('MA', "Aspir") and _cast then
                add(bp.MA["Aspir"], target)
            end

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            -- DRAIN.
            if get('drain').enabled and player['vitals'].hpp <= get('drain').hpp and isReady('MA', "Drain") and _cast then
                add(bp.MA["Drain"], target)
            end

            -- ASPIR.
            if get('aspir').enabled and player['vitals'].mpp <= get('aspir').mpp and isReady('MA', "Aspir") and _cast then
                add(bp.MA["Aspir"], target)
            end

        end

    end

    private.subs['RUN'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local isReady   = helpers['actions'].isReady
        local inQueue   = helpers['queue'].inQueue
        local buff      = helpers['buffs'].buffActive
        local add       = helpers['queue'].add
        local get       = private.settings.get
        
        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()
            local active = helpers['runes'].getActive()
            
            if get('hate').enabled and target then

                -- FLASH.
                if isReady('MA', "Flash") and isReady('MA', "Flash") and _cast then
                    bp.helpers['queue'].addToFront(bp.MA["Flash"], target)

                -- FOIL.
                elseif isReady('MA', "Foil") and isReady('MA', "Foil") and _cast then
                    bp.helpers['queue'].addToFront(bp.MA["Foil"], target)

                end
                
                -- DELAYED HATE ACTIONS.
                if (os.clock()-timers.hate) > get('hate').delay and active > 0 then
                
                    -- VALLATION.
                    if get('vallation') and isReady('JA', "Vallation") and not bp.helpers['buffs'].buffActive(531) and not bp.helpers['buffs'].buffActive(535) and active == helpers['runes'].maxRunes() and _act then
                        add(bp.JA["Vallation"], player)
                        timers.hate = os.clock()

                    -- VALIANCE.
                    elseif get('valiance') and isReady('JA', "Valiance") and not bp.helpers['buffs'].buffActive(531) and not bp.helpers['buffs'].buffActive(535) and active == helpers['runes'].maxRunes() and _act then
                        add(bp.JA["Valiance"], player)
                        timers.hate = os.clock()
                        
                    -- PFLUG.
                    elseif get('pflug') and isReady('JA', "Pflug") and not bp.helpers['buffs'].buffActive(533) and active == helpers['runes'].maxRunes() and _act then
                        add(bp.JA["Pflug"], player)
                        timers.hate = os.clock()
                        
                    end
                    
                end

            end

            if get('buffs') then

                -- RUNE ENCHANMENTS.
                if get('runes') then
                    helpers['runes'].handleRunes()
                end

                if get('embolden').enabled and isReady('JA', "Embolden") and not helpers['buffs'].buffActive(534) and _act and _cast and target then

                    if isReady('MA', get('embolden').name) then
                        add(bp.JA["Embolden"], player)
                        add(bp.MA[get('embolden').name], player)
                    end

                end

                -- PHALANX.
                if isReady('MA', "Phalanx") and not helpers['buffs'].buffActive(116) and _cast and target then
                    add(bp.MA["Phalanx"], player)

                -- SWORDPLAY.
                elseif get('swordplay') and isReady('JA', "Swordplay") and not helpers['buffs'].buffActive(532) and _act and target then
                    add(bp.JA["Swordplay"], player)

                -- STONESKIN.
                elseif get('stoneskin') and isReady('MA', "Stoneskin") and not helpers['buffs'].buffActive(37) and _cast then
                    add(bp.MA["Stoneskin"], player)

                -- AQUAVEIL.
                elseif get('aquaveil') and isReady('MA', "Aquaveil") and not helpers['buffs'].buffActive(39) and _cast then
                    add(bp.MA["Aquaveil"], player)

                -- BLINK.
                elseif get('blink') and isReady('MA', "Blink") and not get('utsusemi') and not helpers['buffs'].buffActive(36) and _cast then
                    add(bp.MA["Blink"], player)
                    
                -- SPIKES.
                elseif get('spikes').enabled and isReady('MA', get('spikes').name) and self.hasSpikes() and _cast then
                    add(bp.MA[get('spikes')], player)

                end
            
            end

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('hate').enabled and target then

                -- FLASH.
                if isReady('MA', "Flash") and isReady('MA', "Flash") and _cast then
                    bp.helpers['queue'].addToFront(bp.MA["Flash"], target)

                -- FOIL.
                elseif isReady('MA', "Foil") and isReady('MA', "Foil") and _cast then
                    bp.helpers['queue'].addToFront(bp.MA["Foil"], target)

                end
                
                -- DELAYED HATE ACTIONS.
                if (os.clock()-timers.hate) > get('hate').delay and active > 0 then
                
                    -- VALLATION.
                    if get('vallation') and isReady('JA', "Vallation") and not bp.helpers['buffs'].buffActive(531) and not bp.helpers['buffs'].buffActive(535) and active == helpers['runes'].maxRunes() and _act then
                        add(bp.JA["Vallation"], player)
                        timers.hate = os.clock()

                    -- VALIANCE.
                    elseif get('valiance') and isReady('JA', "Valiance") and not bp.helpers['buffs'].buffActive(531) and not bp.helpers['buffs'].buffActive(535) and active == helpers['runes'].maxRunes() and _act then
                        add(bp.JA["Valiance"], player)
                        timers.hate = os.clock()
                        
                    -- PFLUG.
                    elseif get('pflug') and isReady('JA', "Pflug") and not bp.helpers['buffs'].buffActive(533) and active == helpers['runes'].maxRunes() and _act then
                        add(bp.JA["Pflug"], player)
                        timers.hate = os.clock()
                        
                    end
                    
                end

            end

            if get('buffs') then

                -- RUNE ENCHANMENTS.
                if get('runes') then
                    helpers['runes'].handleRunes()
                end

                if get('embolden').enabled and isReady('JA', "Embolden") and not helpers['buffs'].buffActive(534) and _act and _cast then

                    if isReady('MA', get('embolden').name) then
                        add(bp.JA["Embolden"], player)
                        add(bp.MA[get('embolden').name], player)
                    end

                end

                -- PHALANX.
                if isReady('MA', "Phalanx") and not helpers['buffs'].buffActive(116) and _cast then
                    add(bp.MA["Phalanx"], player)

                -- SWORDPLAY.
                elseif get('swordplay') and isReady('JA', "Swordplay") and not helpers['buffs'].buffActive(532) and _act then
                    add(bp.JA["Swordplay"], player)

                -- STONESKIN.
                elseif get('stoneskin') and isReady('MA', "Stoneskin") and not helpers['buffs'].buffActive(37) and _cast then
                    add(bp.MA["Stoneskin"], player)

                -- AQUAVEIL.
                elseif get('aquaveil') and isReady('MA', "Aquaveil") and not helpers['buffs'].buffActive(39) and _cast then
                    add(bp.MA["Aquaveil"], player)

                -- BLINK.
                elseif get('blink') and isReady('MA', "Blink") and not get('utsusemi') and not helpers['buffs'].buffActive(36) and _cast then
                    add(bp.MA["Blink"], player)
                    
                -- SPIKES.
                elseif get('spikes').enabled and isReady('MA', get('spikes').name) and self.hasSpikes() and _cast then
                    add(bp.MA[get('spikes')], player)

                end
            
            end

        end

    end

    -- Private Events.
    private.events.actions = windower.register_event('incoming chunk', function(id, original, modified, injected, blocked)

        if bp and id == 0x028 then
            local pack      = bp.packets.parse('incoming', original)
            local player    = bp.player
            local actor     = windower.ffxi.get_mob_by_id(pack['Actor'])
            local target    = windower.ffxi.get_mob_by_id(pack['Target 1 ID'])
            local category  = pack['Category']
            local param     = pack['Param']
            
            if player and actor and target and player.id == actor.id and actor.id == target.id then

                if pack['Category'] == 4 then
                    local spell = bp.res.spells[param] or false

                    if spell and type(spell) == 'table' and spell.type then
                        local is_nin = (player.main_job == 'NIN' or player.sub_job == 'NIN') and true or false

                        if is_nin and (spell.en):match('Utsusemi') then
                            timers.utsusemi.last = os.clock()
                        end

                    end

                end

            end

        end

    end)

    private.events.jobchange = windower.register_event('job change', function()
        loadJob()
    end)

    return self

end
return logic.get()
