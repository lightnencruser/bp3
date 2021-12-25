local job = {}
function job.get()
    local self = {}

    -- Private Variables.
    local private   = {events={}}
    local timers    = {}

    self.automate = function(bp)
        local player    = bp.player
        local helpers   = bp.helpers
        local isReady   = helpers['actions'].isReady
        local inQueue   = helpers['queue'].inQueue
        local buff      = helpers['buffs'].buffActive
        local add       = helpers['queue'].add
        local get       = bp.core.get
        local pet       = windower.ffxi.get_mob_by_target('pet') or false

        if not private.bp then
            private.bp = bp
        end

        do
            private.items()
            if bp and bp.player and bp.player.status == 1 then
                local target  = helpers['target'].getTarget() or windower.ffxi.get_mob_by_target('t') or false
                local _act    = bp.helpers['actions'].canAct()
                local _cast   = bp.helpers['actions'].canCast()

                if get('ja') and _act then

                    if pet then

                        -- 1HR.
                        if get('1hr') and get('assault') then
                            add(bp.JA["Astral Flow"], target)
                            add(bp.JA["Astral Conduit"], target)

                        end

                        -- ASSAULT.
                        if get('assault') and pet.status == 0 and isReady('JA', "Assault") then
                            add(bp.JA["Assault"], target)

                        elseif pet.status == 1 then

                            if not buff(504) and get('bpr').pacts[pet.name] and get('bpw').pacts[pet.name] then
                                local rage = bp.JA[get('bpr').pacts[pet.name]] or false
                                local ward = bp.JA[get('bpw').pacts[pet.name]] or false

                                -- RAGES.
                                if rage and get('bpr').enabled and isReady('JA', rage.en) then

                                    -- APOGEE.
                                    if get('apogee') and isReady('JA', "Apogee") then
                                        add(bp.JA["Apogee"], player)
                                    end

                                    -- MANA CEDE.
                                    if get('mana cede') and isReady('JA', "Mana Cede") then
                                        add(bp.JA["Mana Cede"], player)
                                    end
                                    add(bp.JA[rage.en], target)

                                -- WARDS.
                                elseif ward and get('bpw').enabled and isReady('JA', ward.en) then

                                    if not helpers['target'].castable(target, ward) and helpers['target'].castable(player, ward) and get('buffs') then
                                        add(bp.JA[ward.en], player)

                                    elseif helpers['target'].castable(target, ward) then
                                        add(bp.JA[ward.en], target)

                                    end

                                end

                            elseif buff(504) and get('bpr').pacts[pet.name] and get('bpw').pacts[pet.name] then
                                local rage = bp.JA[get('bpr').pacts[pet.name]] or false
                                local ward = bp.JA[get('bpw').pacts[pet.name]] or false

                                if ward.en ~= 'Mewing Lullaby' then
                                    
                                    -- RAGES.
                                    if rage and get('bpr').enabled and isReady('JA', rage.en) then
                                        add(bp.JA[rage.en], target)
                                    end

                                elseif ward.en == 'Mewing Lullaby' then

                                    -- MEWING LULLABY.
                                    if ward and get('bpw').enabled and isReady('JA', ward.en) then
                                        add(bp.JA[ward.en], target)
                                    end

                                end

                            end

                        end

                    end

                end

                -- SUMMONING.
                if (not pet or not T{2,3}:contains(pet.status)) and get('summon').enabled and isReady('MA', get('summon').name) and _cast then
                    add(bp.MA[get('summon').name], player)
                end

            elseif bp and bp.player and bp.player.status == 0 then
                local target  = helpers['target'].getTarget() or false
                local _act    = bp.helpers['actions'].canAct()
                local _cast   = bp.helpers['actions'].canCast()

                if get('ja') and _act then

                    if pet then

                        -- 1HR.
                        if target and get('1hr') and get('assault') then
                            add(bp.JA["Astral Flow"], target)
                            add(bp.JA["Astral Conduit"], target)

                        end

                        -- ASSAULT.
                        if target and get('assault') and pet.status == 0 and isReady('JA', "Assault") then
                            add(bp.JA["Assault"], target)

                        elseif pet.status == 1 then

                            if not buff(504) and get('bpr').pacts[pet.name] and get('bpw').pacts[pet.name] then
                                local rage = bp.JA[get('bpr').pacts[pet.name]] or false
                                local ward = bp.JA[get('bpw').pacts[pet.name]] or false

                                -- RAGES.
                                if target and rage and get('bpr').enabled and isReady('JA', rage.en) then

                                    -- APOGEE.
                                    if get('apogee') and isReady('JA', "Apogee") then
                                        add(bp.JA["Apogee"], player)
                                    end

                                    -- MANA CEDE.
                                    if get('mana cede') and isReady('JA', "Mana Cede") then
                                        add(bp.JA["Mana Cede"], player)
                                    end
                                    add(bp.JA[rage.en], target)

                                -- WARDS.
                                elseif ward and get('bpw').enabled and isReady('JA', ward.en) then

                                    if not helpers['target'].castable(target, ward) and helpers['target'].castable(player, ward) and get('buffs') then
                                        add(bp.JA[ward.en], player)

                                    elseif target and helpers['target'].castable(target, ward) then
                                        add(bp.JA[ward.en], target)

                                    end

                                end

                            elseif target and buff(504) and get('bpr').pacts[pet.name] and get('bpw').pacts[pet.name] then
                                local rage = bp.JA[get('bpr').pacts[pet.name]] or false
                                local ward = bp.JA[get('bpw').pacts[pet.name]] or false

                                if ward.en ~= 'Mewing Lullaby' then
                                    
                                    -- RAGES.
                                    if rage and get('bpr').enabled and isReady('JA', rage.en) then
                                        add(bp.JA[rage.en], target)
                                    end

                                elseif ward.en == 'Mewing Lullaby' then

                                    -- MEWING LULLABY.
                                    if ward and get('bpw').enabled and isReady('JA', ward.en) then
                                        add(bp.JA[ward.en], target)
                                    end

                                end

                            end

                        end

                    end

                end

                -- SUMMONING.
                if (not pet or not T{2,3}:contains(pet.status)) and get('summon').enabled and isReady('MA', get('summon').name) and _cast then
                    add(bp.MA[get('summon').name], player)
                end

            end

        end
        
    end

    private.items = function()

    end

    return self

end
return job.get()