local logic = {}
local files = require('files')
local player = windower.ffxi.get_player()
function logic.get()
    local self = {}

    -- Private Variables.
    local bp        = false
    local private   = {events={}, core={}, subs={}, settings=dofile(string.format('%sbp/core/core.lua', windower.addon_path, player.name))}
    local timers    = {hate=0, steps=0, utsusemi={last=0, delay=1.5}}

    -- Public Variables.
    self.settings   = private.settings.getFlags()

    -- Private Functions.
    local loadJob = function(job)
        
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

        if name and value then
            private.settings.set(name, value)
        end

    end

    self.handleAutomation = function()

        if bp and bp.player and bp.helpers['queue'].ready and not bp.helpers['actions'].moving then
            local target = bp.helpers['target'].getTarget() or false
            local helpers = bp.helpers
            local player = bp.player

            do
                bp.helpers['cures'].handleCuring()
                bp.helpers['status'].fixStatus()

                do -- Handle Skillup.
                    local skillup = private.settings.get('skillup')[1]
                    local skill = private.settings.get('skillup')[2]

                    if skillup then
                        local food = helpers['inventory'].findItemByName("B.E.W. Pitaru")
                        
                        if not helpers['queue'].inQueue(food) and not helpers['buffs'].buffActive(251) then
                            helpers['queue'].add(food, 'me')
                            
                        else
                                                        
                            if bp.skillup and bp.skillup[skill] then
                                local selected = bp.skillup[skill]

                                for _,v in pairs(selected.list) do
                                    
                                    if helpers['actions'].isReady('MA', v) and not helpers['queue'].inQueue(bp.MA[v]) then

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
                    if private.settings.get('ra').enabled and #helpers['queue'].queue.data == 0 and helpers['equipment'].ammo and helpers['equipment'].ammo.en ~= 'Gil' then
                        helpers['queue'].add(helpers['actions'].unique.ranged, target)
                    end

                end
                private.core.automate(bp, self.settings)

                if private.subs[player.sub_job] then
                    private.subs[player.sub_job]()
                end

            end
            helpers['queue'].handle()

        end

    end

    private.subs['WAR'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('ja') and _act then

            end

            if get('hate').enabled and target then

                -- PROVOKE.
                if target and get('provoke') and helpers['actions'].canAct() and helpers['actions'].isReady('JA', "Provoke") then
                    helpers['queue'].add(bp.JA["Provoke"], target)
                end

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

            end

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false

            if get('hate').enabled and target then

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

            end

        end

    end

    private.subs['MNK'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('ja') and _act then

            end

            if get('hate').enabled and target then

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

            end

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false

            if get('hate').enabled and target then

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

            end

        end

    end

    private.subs['WHM'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('ja') and _act then

                if get('convert').enabled and player['vitals'].hpp >= get('convert').hpp and player['vitals'].mpp <= get('convert').mpp then
                    
                end

            end

            if get('hate').enabled and target then

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

            end

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false

            if get('hate').enabled and target then

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

            end

        end

    end

    private.subs['BLM'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('ja') and _act then

            end

            if get('hate').enabled and target then

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

            end

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false

            if get('hate').enabled and target then

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

            end

        end

    end

    private.subs['RDM'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()
            
            if get('ja') and helpers['actions'].canAct() then

                if get('convert').enabled and player['vitals'].hpp >= get('convert').hpp and player['vitals'].mpp <= get('convert').mpp then
                                
                    if helpers['actions'].isReady('JA', "Convert") then
                        helpers['queue'].add(bp.JA["Convert"], player)
                        helpers['queue'].add(bp.MA["Cure IV"], player)
                        
                    end
                    
                end

            end

            if get('buffs') and helpers['actions'].canCast() then
                local enspells = T{94,95,96,97,98,99,277,278,279,280,281,282}
                local enspell_active = false

                -- Check to see if we have any Enspells active.
                for _,v in ipairs(bp.player.buffs) do
                    
                    if enspells:contains(v) then
                        enspell_active = true
                        break

                    end
                    
                end
                
                -- HASTE.
                if helpers['actions'].isReady('MA', "Haste") and not helpers['buffs'].buffActive(33) then
                    helpers['queue'].add(bp.MA["Haste"], player)
                
                -- PHALANX.
                elseif helpers['actions'].isReady('MA', "Phalanx") and not helpers['buffs'].buffActive(116) then
                    helpers['queue'].add(bp.MA["Phalanx"], player)
                    
                -- REFRESH.
                elseif not get('sublimation') and helpers['actions'].isReady('MA', "Refresh") and not helpers['buffs'].buffActive(43) then
                    helpers['queue'].add(bp.MA["Refresh"], player)

                -- ENSPELLS.
                elseif get('en').enabled and not enspell_active then
                        
                    if helpers['actions'].isReady('MA', get('en').name) and not helpers['buffs'].buffActive(94) then
                        helpers['queue'].add(bp.MA[get('en').name], player)
                    end
                    
                -- STONESKIN.
                elseif get('stoneskin') and not helpers['buffs'].buffActive(37) and helpers['actions'].isReady('MA', "Stoneskin") then
                    helpers['queue'].add(bp.MA["Stoneskin"], player)

                -- AQUAVEIL.
                elseif get('aquaveil') and not helpers['buffs'].buffActive(37) and helpers['actions'].isReady('MA', "Aquaveil") then
                    helpers['queue'].add(bp.MA["Aquaveil"], player)

                -- BLINK.
                elseif get('blink') and not helpers['buffs'].buffActive(37) and helpers['actions'].isReady('MA', "Blink") then
                    helpers['queue'].add(bp.MA["Blink"], player)
                    
                -- SPIKES.
                elseif helpers['actions'].isReady('MA', get('spikes').name) and (not helpers['buffs'].buffActive(34) or not helpers['buffs'].buffActive(35) or not helpers['buffs'].buffActive(38)) then
                    helpers['queue'].add(bp.MA[get('spikes')], player)
                    
                end 

            end

            if get('debuffs') and helpers['actions'].canAct() and target then
                helpers['debufs'].cast()
            end

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windowr.ffxi.get_mob_by_target('t') or false

            if get('ja') and helpers['actions'].canAct() then

                if get('convert').enabled and player['vitals'].hpp >= get('convert').hpp and player['vitals'].mpp <= get('convert').mpp then
                                
                    if helpers['actions'].isReady('JA', "Convert") then
                        helpers['queue'].add(bp.JA["Convert"], player)
                        helpers['queue'].add(bp.MA["Cure IV"], player)
                        
                    end
                    
                end

            end

            if get('buffs') and helpers['actions'].canCast() then
                local enspells = T{94,95,96,97,98,99,277,278,279,280,281,282}
                local enspell_active = false

                -- Check to see if we have any Enspells active.
                for _,v in ipairs(bp.player.buffs) do
                    
                    if enspells:contains(v) then
                        enspell_active = true
                        break

                    end
                    
                end
                
                -- HASTE.
                if helpers['actions'].isReady('MA', "Haste") and not helpers['buffs'].buffActive(33) then
                    helpers['queue'].add(bp.MA["Haste"], player)
                
                -- PHALANX.
                elseif helpers['actions'].isReady('MA', "Phalanx") and not helpers['buffs'].buffActive(116) then
                    helpers['queue'].add(bp.MA["Phalanx"], player)
                    
                -- REFRESH.
                elseif not get('sublimation') and helpers['actions'].isReady('MA', "Refresh") and not helpers['buffs'].buffActive(43) then
                    helpers['queue'].add(bp.MA["Refresh"], player)

                -- ENSPELLS.
                elseif get('en').enabled and not enspell_active then
                        
                    if helpers['actions'].isReady('MA', get('en').name) and not helpers['buffs'].buffActive(94) then
                        helpers['queue'].add(bp.MA[get('en').name], player)
                    end
                    
                -- STONESKIN.
                elseif get('stoneskin') and not helpers['buffs'].buffActive(37) and helpers['actions'].isReady('MA', "Stoneskin") then
                    helpers['queue'].add(bp.MA["Stoneskin"], player)

                -- AQUAVEIL.
                elseif get('aquaveil') and not helpers['buffs'].buffActive(37) and helpers['actions'].isReady('MA', "Aquaveil") then
                    helpers['queue'].add(bp.MA["Aquaveil"], player)

                -- BLINK.
                elseif get('blink') and not helpers['buffs'].buffActive(37) and helpers['actions'].isReady('MA', "Blink") then
                    helpers['queue'].add(bp.MA["Blink"], player)
                    
                -- SPIKES.
                elseif helpers['actions'].isReady('MA', get('spikes').name) and (not helpers['buffs'].buffActive(34) or not helpers['buffs'].buffActive(35) or not helpers['buffs'].buffActive(38)) then
                    helpers['queue'].add(bp.MA[get('spikes')], player)
                    
                end 

            end

            if get('debuffs') and helpers['actions'].canAct() and target then
                helpers['debufs'].cast()
            end

        end

    end

    private.subs['THF'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('ja') and _act then

                if get('convert').enabled and player['vitals'].hpp >= get('convert').hpp and player['vitals'].mpp <= get('convert').mpp then
                                
                    if helpers['actions'].isReady('JA', "Convert") then
                        helpers['queue'].add(bp.JA["Convert"], player)
                        helpers['queue'].add(bp.MA["Cure IV"], player)
                        
                    end
                    
                end

            end

            if get('hate').enabled and target then

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

            end

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false

            if get('hate').enabled and target then

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

            end

        end

    end

    private.subs['PLD'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('ja') and _act then

            end

            if get('hate').enabled and target then

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

            end

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false

            if get('hate').enabled and target then

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

            end

        end

    end

    private.subs['DRK'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('ja') and _act then

            end

            if get('hate').enabled and target then

                -- STUN.
                if target and helpers['actions'].canCast() and helpers['actions'].isReady('MA', "Stun") then
                    helpers['queue'].addToFront(bp.MA["Stun"], target)                            
                end
                
                if helpers['actions'].canAct() and (os.clock()-timers.hate) > self.getSetting('HATE DELAY') then
                
                    -- SOULEATER.
                    if target and not helpers['buffs'].buffActive(64) and helpers['actions'].isReady('JA', "Souleater") then
                        helpers['queue'].addToFront(bp.JA["Souleater"], player)
                        timers.hate = os.clock()
                        
                        if self.getSetting('TANK MODE') then
                            windower.send_command("wait 1; cancel 63")
                        end
                        
                    -- LAST RESORT.
                    elseif target and not helpers['buffs'].buffActive(64) and helpers['actions'].isReady('JA', "Last Resort") then
                        helpers['queue'].addToFront(bp.JA["Last Resort"], player)
                        timers.hate = os.clock()
                        
                        if self.getSetting('TANK MODE') then
                            windower.send_command("wait 1; cancel 64")
                        end
                        
                    end
                    
                end

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

            end

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false

            if get('hate').enabled and target then

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

            end

        end

    end

    private.subs['BST'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('ja') and _act then

            end

            if get('hate').enabled and target then

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

            end

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false

            if get('hate').enabled and target then

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

            end

        end

    end

    private.subs['BRD'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('ja') and _act then

            end

            if get('hate').enabled and target then

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

            end

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false

            if get('hate').enabled and target then

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

            end

        end

    end

    private.subs['RNG'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('ja') and _act then

            end

            if get('hate').enabled and target then

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

            end

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false

            if get('hate').enabled and target then

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

            end

        end

    end

    private.subs['SMN'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('ja') and _act then

            end

            if get('hate').enabled and target then

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

            end

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false

            if get('hate').enabled and target then

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

            end

        end

    end

    private.subs['SAM'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('ja') and _act then

            end

            if get('hate').enabled and target then

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

            end

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false

            if get('hate').enabled and target then

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

            end

        end

    end

    private.subs['NIN'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('ja') and _act then

            end

            if get('hate').enabled and target then

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

            end

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false

            if get('hate').enabled and target then

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

            end

        end

    end

    private.subs['DRG'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('ja') and _act then

                -- JUMP.
                if target and get('jump') and helpers['actions'].isReady('JA', "Jump") then
                    helpers['queue'].add(bp.JA["Jump"], target)
                    
                -- HIGH JUMP.
                elseif target and get('high jump') and helpers['actions'].isReady('JA', "High Jump") then
                    helpers['queue'].add(bp.JA["High Jump"], target)
                    
                end

            end

            if get('hate').enabled and target then

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

            end

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false

            if get('hate').enabled and target then

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

            end

        end

    end

    private.subs['BLU'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('ja') and _act then

            end

            if get('hate').enabled and target then

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

            end

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false

            if get('hate').enabled and target then

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

            end

        end

    end

    private.subs['COR'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('ja') and _act then

            end

            if get('hate').enabled and target then

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

            end

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false

            if get('hate').enabled and target then

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

            end

        end

    end

    private.subs['PUP'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('ja') and _act then

            end

            if get('hate').enabled and target then

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

            end

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false

            if get('hate').enabled and target then

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

            end

        end

    end

    private.subs['DNC'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('ja') and _act then

                -- FLOURISHES.
                if target and get('flourishes').enabled then -- UPDATE**
                    local flourish_1 = get('flourishes').cat_1
                    local flourish_2 = get('flourishes').cat_2

                end

            end

            if get('hate').enabled and target then

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

            end

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false

            if get('hate').enabled and target then

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

            end

        end

    end

    private.subs['SCH'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('ja') and _act then

                -- SUBLIMATION LOGIC.
                if get('sublimation') then --UPDATE**
                            
                    if not helpers['buffs'].buffActive(187) and not helpers['buffs'].buffActive(188) and helpers['actions'].isReady('JA', "Sublimation") then
                        helpers['queue'].add(bp.JA["Sublimation"], player)
                    
                    elseif not helpers['buffs'].buffActive(187) and helpers['buffs'].buffActive(188) and helpers['actions'].isReady('JA', "Sublimation") then
                        helpers['queue'].add(bp.JA["Sublimation"], player)

                    end
                    
                end

            end

            if get('hate').enabled and target then

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

            end

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false

            if get('hate').enabled and target then

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

            end

        end

    end

    private.subs['GEO'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()

            if get('ja') and _act then

            end

            if get('hate').enabled and target then

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

            end

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false

            if get('hate').enabled and target then

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

            end

        end

    end

    private.subs['RUN'] = function()
        local player    = bp.player
        local helpers   = bp.helpers
        local get       = private.settings.get

        if player.status == 0 then
            local target = helpers['target'].getTarget() or false
            local _cast  = helpers['actions'].canCast()
            local _act   = helpers['actions'].canAct()
            local active = helpers['runes'].getActive()

            if get('ja') and _act then

            end

            if get('hate').enabled and target then

                -- FLASH.
                if _cast and helpers['actions'].isReady('MA', "Flash") then
                    helpers['queue'].addToFront(bp.MA["Flash"], target)                            
                end
                
                -- DELAYED HATE ACTIONS.
                if _act and (os.clock()-timers.hate) > get('hate').delay and active > 0 then
                
                    -- VALLATION.
                    if get('vallation') and helpers['actions'].isReady('JA', "Vallation") then
                        helpers['queue'].addToFront(bp.JA["Vallation"], player)
                        timers.hate = os.clock()
                        
                    -- PFLUG.
                    elseif get('pflug') and helpers['actions'].isReady('JA', "Pflug") then
                        helpers['queue'].addToFront(bp.JA["Pflug"], player)
                        timers.hate = os.clock()
                        
                    end
                    
                end

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

            end

        elseif player.status == 1 then
            local target = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false

            if get('hate').enabled and target then

            end

            if get('buffs') and target then

            end

            if get('debuffs') and target then

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

    return self

end
return logic.get()
