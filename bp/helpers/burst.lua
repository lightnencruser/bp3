local burst = {}
function burst.new()
    local self = {}

    -- Private Variables.
    local bp        = false
    local private   = {events={}}
    local elements  = T{'Fire','Blizzard','Stone','Aero','Water','Thunder'}
    local tiers     = T{'I','II','III','IV','V','VI'}
    local messages  = {
        
        [288] = "Light",
        [289] = "Darkness",
        [290] = "Gravitation",
        [291] = "Fragmentation",
        [292] = "Distortion",
        [293] = "Fusion",
        [294] = "Compression",
        [295] = "Liquefaction",
        [296] = "Induration",
        [297] = "Reverberation",
        [298] = "Transfixion",
        [299] = "Scission",
        [300] = "Detonation",
        [301] = "Impaction",
        [302] = "Radiance",
        [302] = "Umbra",

    }
    local chains   = {

        [288] = T{'Light','Fire','Thunder','Wind'},
        [289] = T{'Dark','Earth','Water','Ice'},
        [290] = T{'Dark','Earth'},
        [291] = T{'Thunder','Wind'},
        [292] = T{'Ice','Water'},
        [293] = T{'Light','Fire'},
        [294] = T{'Dark'},
        [295] = T{'Fire'},
        [296] = T{'Ice'},
        [297] = T{'Water'},
        [298] = T{'Light'},
        [299] = T{'Earth'},
        [300] = T{'Wind'},
        [301] = T{'Thunder'},
        [769] = T{'Light','Fire','Thunder','Wind'},
        [770] = T{'Dark','Earth','Water','Ice'},

    }

    -- Private Functions.
    private.registerSkillchain = function(data)
        --local enabled = bp.core.getSetting('BURST')

        if bp and data and enabled and bp.enabled then
            local packed = bp.packets.parse('incoming', data)
            local target = bp.helpers['target'].getTarget()

            if packed and packed['Category'] and target then
                local category  = packed['Category']
                local element   = bp.core.getSetting('ELEMENT')
                local tier      = bp.core.getSetting('NUKE TIER')
                local aoe       = bp.core.getSetting('ALLOW AOE')
                
                if category == 3 then
                    
                    if packed['Target 1 Action 1 Added Effect Message'] and messages[packed['Target 1 Action 1 Added Effect Message']] then
                        self.burst(self.buildSpells(self.getElements(packed['Target 1 Action 1 Added Effect Message'])))
                    end

                end

            end

        end

    end

    -- Public Functions.
    self.setSystem = function(buddypal)
        if buddypal then
            bp = buddypal
        end

    end

    self.getElements = function(id)

        if chains[id] then
            return chains[id]
        end
        return T{}

    end

    self.buildSpells = function(allowed)
        local spells    = T{}
        local element   = bp.core.getSetting('ELEMENT')
        local aoe       = bp.core.getSetting('ALLOW AOE')
        local allowed   = allowed or false

        if allowed then

            for _,v in ipairs(allowed) do

                if element == 'Random' then

                    if v == 'Fire' then
                        table.extend(spells, bp.core['MAGIC BURST'].Liquefaction[1])

                        if aoe then
                            table.extend(spells, bp.core['MAGIC BURST'].Liquefaction[2])
                        end

                    elseif v == 'Water' then
                        table.extend(spells, bp.core['MAGIC BURST'].Reverberation[1])

                        if aoe then
                            table.extend(spells, bp.core['MAGIC BURST'].Reverberation[2])
                        end

                    elseif v == 'Thunder' then
                        table.extend(spells, bp.core['MAGIC BURST'].Impaction[1])
                        
                        if aoe then
                            table.extend(spells, bp.core['MAGIC BURST'].Impaction[2])
                        end

                    elseif v == 'Earth' then
                        table.extend(spells, bp.core['MAGIC BURST'].Scission[1])

                        if aoe then
                            table.extend(spells, bp.core['MAGIC BURST'].Scission[2])
                        end

                    elseif v == 'Wind' then
                        table.extend(spells, bp.core['MAGIC BURST'].Detonation[1])

                        if aoe then
                            table.extend(spells, bp.core['MAGIC BURST'].Detonation[2])
                        end

                    elseif v == 'Ice' then
                        table.extend(spells, bp.core['MAGIC BURST'].Induration[1])

                        if aoe then
                            table.extend(spells, bp.core['MAGIC BURST'].Induration[2])
                        end

                    elseif v == 'Light' then
                        table.extend(spells, bp.core['MAGIC BURST'].Transfixion[1])

                        if aoe then
                            table.extend(spells, bp.core['MAGIC BURST'].Transfixion[2])
                        end

                    elseif v == 'Dark' then
                        table.extend(spells, bp.core['MAGIC BURST'].Compression[1])

                        if aoe then
                            table.extend(spells, bp.core['MAGIC BURST'].Compression[2])
                        end

                    end

                elseif element ~= 'Random' then

                    if v == 'Fire' and element == 'Fire' then
                        table.extend(spells, bp.core['MAGIC BURST'].Liquefaction[1])

                        if aoe then
                            table.extend(spells, bp.core['MAGIC BURST'].Liquefaction[2])
                        end

                    elseif v == 'Water' and element == 'Water' then
                        table.extend(spells, bp.core['MAGIC BURST'].Reverberation[1])

                        if aoe then
                            table.extend(spells, bp.core['MAGIC BURST'].Reverberation[2])
                        end

                    elseif v == 'Thunder' and element == 'Thunder' then
                        table.extend(spells, bp.core['MAGIC BURST'].Impaction[1])
                        
                        if aoe then
                            table.extend(spells, bp.core['MAGIC BURST'].Impaction[2])
                        end

                    elseif v == 'Earth' and element == 'Earth' then
                        table.extend(spells, bp.core['MAGIC BURST'].Scission[1])

                        if aoe then
                            table.extend(spells, bp.core['MAGIC BURST'].Scission[2])
                        end

                    elseif v == 'Wind' and element == 'Wind' then
                        table.extend(spells, bp.core['MAGIC BURST'].Detonation[1])

                        if aoe then
                            table.extend(spells, bp.core['MAGIC BURST'].Detonation[2])
                        end

                    elseif v == 'Ice' and element == 'Ice' then
                        table.extend(spells, bp.core['MAGIC BURST'].Induration[1])

                        if aoe then
                            table.extend(spells, bp.core['MAGIC BURST'].Induration[2])
                        end

                    elseif v == 'Light' and element == 'Light' then
                        table.extend(spells, bp.core['MAGIC BURST'].Transfixion[1])

                        if aoe then
                            table.extend(spells, bp.core['MAGIC BURST'].Transfixion[2])
                        end

                    elseif v == 'Dark' and element == 'Dark' then
                        table.extend(spells, bp.core['MAGIC BURST'].Compression[1])

                        if aoe then
                            table.extend(spells, bp.core['MAGIC BURST'].Compression[2])
                        end

                    end

                end

            end

        end
        return spells

    end

    self.burst = function(spells)
        local spells    = spells or false
        local tier      = bp.core.getSetting('NUKE TIER')
        local only      = bp.core.getSetting('NUKE ONLY')
        local target    = bp.helpers['target'].getTarget()

        if bp and spells and target then
            local bursting = T{}
            
            for _,v in ipairs(spells) do

                if only and self.isNuke(v) then
                    
                    if tier == 'Random' then
                        table.insert(bursting, v)

                    elseif (tier ~= 'I' and (v):match(tier) and bp.helpers['actions'].isReady('MA', v)) or (tier == 'I' and self.isNuke(v) and not (v):match(tier) and not (v):match('V') and bp.helpers['actions'].isReady('MA', v)) then
                        table.insert(bursting, v)

                    end

                else

                    if tier == 'Random' then
                        table.insert(bursting, v)

                    elseif (tier ~= 'I' and (v):match(tier) and bp.helpers['actions'].isReady('MA', v)) or (tier == 'I' and self.isNuke(v) and not (v):match(tier) and not (v):match('V') and bp.helpers['actions'].isReady('MA', v)) then
                        table.insert(bursting, v)

                    end

                end

            end

            if bursting:length() > 0 then

                if bp.core.getSetting('MULTINUKE') == 2 and T{'I','II','III'}:contains(tier) then
                    bp.helpers['queue'].addToFront(bp.MA[bursting[math.random(1, bursting:length())]], target)

                elseif bp.core.getSetting('MULTINUKE') == 3 and T{'I','II','III'}:contains(tier) then
                    bp.helpers['queue'].addToFront(bp.MA[bursting[math.random(1, bursting:length())]], target)
                    bp.helpers['queue'].addToFront(bp.MA[bursting[math.random(1, bursting:length())]], target)

                else
                    bp.helpers['queue'].addToFront(bp.MA[bursting[math.random(1, bursting:length())]], target)

                end

            end

        end

    end

    self.isNuke = function(name)
        local list = T{

            'Fire','Fire II','Fire III','Fire IV','Fire V','Fire VI','Fira','Fira II','Fira III','Firaga','Firaga II','Firaga III','Firaga IV','Firaja',
            'Water','Water II','Water III','Water IV','Water V','Water VI','Watera','Watera II','Watera III','Waterga','Waterga II','Waterga III','Waterga IV','Waterja',
            'Thunder','Thunder II','Thunder III','Thunder IV','Thunder V','Thunder VI','Thundara','Thundara II','Thundara III','Thundaga','Thundaga II','Thundaga III','Thundaga IV','Thundaja',
            'Stone','Stone II','Stone III','Stone IV','Stone V','Stone VI','Stonera','Stonera II','Stonera III','Stonega','Stonega II','Stonega III','Stonega IV','Stoneja',
            'Aero','Aero II','Aero III','Aero IV','Aero V','Aero VI','Aera','Aera II','Aera III','Aeroga','Aeroga II','Aeroga III','Aeroga IV','Aeroja',
            'Blizzard','Blizzard II','Blizzard III','Blizzard IV','Blizzard V','Blizzard VI','Blizzara','Blizzara II','Blizzara III','Blizzaga','Blizzaga II','Blizzaga III','Blizzaga IV','Blizzaja',

        }

        if name then

            if list:contains(name) then
                return true
            end

        end
        return false

    end

    -- Private Events.
    private.events.actions = windower.register_event('incoming chunk', function(id, original, modified, injected, blocked)
        
        if bp and id == 0x028 then
            local pack      = bp.packets.parse('incoming', original)
            local player    = bp.player
            local actor     = windower.ffxi.get_mob_by_id(pack['Actor'])
            local target    = windower.ffxi.get_mob_by_id(pack['Target 1 ID'])
            local count     = pack['Target Count']
            local category  = pack['Category']
            local param     = pack['Param']
            
            if player and actor and target then
                private.registerSkillchain(original)
            end

        end

    end)

    return self

end
return burst.new()
