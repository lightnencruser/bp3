local core = {}
local files = require('files')
local player = windower.ffxi.get_player()
function core.get()
    local self = {}

    -- Private Variables.
    local bp        = false
    local private   = {events={}, core={}, subs={}, settings=dofile(string.format('%sbp/core/core.lua', windower.addon_path, player.name))}
    local timers    = {hate=0, steps=0}

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

    self.handleAutomation = function()

        if bp and bp.player and bp.helpers['queue'].ready and not bp.helpers['actions'].moving then
            local target = bp.helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
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

                end
                private.core.automate(bp, self.settings)

                if private.subs[player.sub_job] then
                    private.subs[player.sub_job]()
                end

            end

        end

    end

    private.subs['WAR'] = function()

    end

    private.subs['MNK'] = function()

    end

    private.subs['WHM'] = function()

    end

    private.subs['BLM'] = function()

    end

    private.subs['RDM'] = function()

    end

    private.subs['THF'] = function()

    end

    private.subs['PLD'] = function()

    end

    private.subs['DRK'] = function()

    end

    private.subs['BST'] = function()

    end

    private.subs['BRD'] = function()

    end

    private.subs['RNG'] = function()

    end

    private.subs['SMN'] = function()

    end

    private.subs['SAM'] = function()

    end

    private.subs['NIN'] = function()

    end

    private.subs['DRG'] = function()

    end

    private.subs['BLU'] = function()

    end

    private.subs['COR'] = function()

    end

    private.subs['PUP'] = function()

    end

    private.subs['DNC'] = function()

    end

    private.subs['SCH'] = function()

    end

    private.subs['GEO'] = function()

    end

    private.subs['RUN'] = function()

    end

    return self

end
return core.get()
