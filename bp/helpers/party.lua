local party = {}
function party.new()
    local self = {}

    -- Public Variables.
    self.jobs = {}

    -- Private Variables.
    local timer = {last=0, delay=2}

    -- Public Functions.
    self.updateJobs = function(bp, data)
        local bp    = bp or false
        local data  = data or false

        do -- Build Status removal tables.
            bp.helpers['status'].build(bp, data)
        end

        if bp and data then
            local packed = bp.packets.parse('incoming', data)

            if packed and packed['ID'] then

                if (os.clock()-timer.last) >= timer.delay then
                    self.jobs = {}
                    coroutine.sleep(1)
                end

                if bp.helpers['party'].findByName(bp, packed['Name'], true) and packed['Index'] ~= 0 then
                    self.jobs[packed['ID']] = {name=packed['Name'], id=packed['ID'], job=packed['Main job'], sub=packed['Sub job']}
                    timer.last = os.clock()

                end

            end

        end

    end

    self.getMembers = function(bp, alliance)
        local party     = windower.ffxi.get_party() or false
        local alliance  = alliance or false
        local members   = {}

        if party then

            if alliance then

                for i,v in pairs(party) do

                    if (i:sub(1,1) == "p" or i:sub(1,1) == "a") and tonumber(i:sub(2)) ~= nil then
                        table.insert(members, v)
                    end

                end

            elseif not alliance then

                for i,v in pairs(party) do

                    if i:sub(1,1) == "p" and tonumber(i:sub(2)) ~= nil then
                        table.insert(members, v)
                    end

                end

            end

        end
        return members

    end

    self.getMember = function(bp, player, alliance)
        local player    = player or false
        local alliance  = alliance or false
        local party     = windower.ffxi.get_party() or false

        if player then

            if type(player) == "table" then
                player = player

            elseif type(player) == "string" and self.findByName(bp, player, alliance) then
                player = windower.ffxi.get_mob_by_name(self.findByName(bp, player, alliance))

            elseif type(player) == "number" then
                player = windower.ffxi.get_mob_by_id(player)

            else
                return false

            end

        end

        if player and party then

            if alliance then

                for i,v in pairs(party) do

                    if (i:sub(1,1) == "p" or i:sub(1,1) == "a") and tonumber(i:sub(2)) ~= nil and (player.name):lower() == (v.name):lower() then
                        return player
                    end

                end

            elseif not alliance then

                for i,v in pairs(party) do

                    if i:sub(1,1) == "p" and tonumber(i:sub(2)) ~= nil and (player.name):lower() == (v.name):lower() then
                        return player
                    end

                end

            end

        end
        return false

    end

    self.isInParty = function(bp, player, alliance)
        local player    = player or false
        local alliance  = alliance or false
        local party     = windower.ffxi.get_party() or false

        if player then

            if type(player) == "table" then
                player = player

            elseif type(player) == "string" then
                player = windower.ffxi.get_mob_by_name(self.findByName(bp, player, alliance))

            elseif type(player) == "number" then
                player = windower.ffxi.get_mob_by_id(player)

            else
                return false

            end

        end

        if player and party then

            if alliance then

                for i,v in pairs(party) do

                    if (i:sub(1,1) == "p" or i:sub(1,1) == "a") and tonumber(i:sub(2)) ~= nil and (player.name):lower() == (v.name):lower() then
                        return true
                    end

                end

            elseif not alliance then

                for i,v in pairs(party) do

                    if i:sub(1,1) == "p" and tonumber(i:sub(2)) ~= nil and (player.name):lower() == (v.name):lower() then
                        return true
                    end

                end

            end

        end
        return false

    end

    self.membersAreInRange = function(bp, d, alliance)
        local party     = windower.ffxi.get_party()
        local player    = windower.ffxi.get_player()
        local count     = party.party1_count
        local alliance  = alliance or false
        local d         = d or false
        local pass      = 0

        if alliance then
            count = (count + party.party2_count + party.party3_count)

            for i,v in pairs(party) do

                if (i:sub(1,1) == "p" or i:sub(1,1) == "a") and tonumber(i:sub(2)) ~= nil and (player.name):lower() == (v.name):lower() then

                    if v.mob and not v.mob.is_npc and (v.mob.distance):sqrt() <= d then

                        if (v.mob.name):lower() == (player.name):lower() and (v.mob.distance):sqrt() == 0 then
                            pass = (pass + 1)

                        elseif (v.mob.name):lower() ~= (player.name):lower() and (v.mob.distance):sqrt() ~= 0 then
                            pass = (pass + 1)

                        end

                    elseif not d and v.mob then
                        pass = (pass + 1)

                    end

                end

            end

        elseif not alliance then

            for i,v in pairs(party) do

                if i:sub(1,1) == "p" and tonumber(i:sub(2)) ~= nil then

                    if v.mob and not v.mob.is_npc and (v.mob.distance):sqrt() <= d then

                        if (v.mob.name):lower() == (player.name):lower() and (v.mob.distance):sqrt() == 0 then
                            pass = (pass + 1)

                        elseif (v.mob.name):lower() ~= (player.name):lower() and (v.mob.distance):sqrt() ~= 0 then
                            pass = (pass + 1)

                        end

                    elseif not d and v.mob then
                        pass = (pass + 1)

                    end

                end

            end

        end
        if pass == count then
            return true

        end
        return false

    end

    self.findByName = function(bp, name, alliance)
        local name      = name or false
        local alliance  = alliance or false
        local party     = windower.ffxi.get_party() or false

        if name and party and type(name) == "string" and name ~= "" and #name > 2 then
            
            if alliance then

                for i,v in pairs(party) do

                    if (i:sub(1,1) == "p" or i:sub(1,1) == "a") and tonumber(i:sub(2)) ~= nil and (name:sub(1,#name)):lower() == (v.name:sub(1,#name)):lower() then
                        return v.name
                    end

                end

            elseif not alliance then

                for i,v in pairs(party) do

                    if i:sub(1,1) == "p" and tonumber(i:sub(2)) ~= nil and (name:sub(1,#name)):lower() == (v.name:sub(1,#name)):lower() then
                        return v.name
                    end

                end

            end

        end
        return false

    end

    self.getPartyCount = function(bp, alliance)
        local alliance  = alliance or false
        local party     = windower.ffxi.get_party() or false
        local count     = 0

        if party then

            if alliance then

                for i,v in pairs(party) do

                    if (i:sub(1,1) == "p" or i:sub(1,1) == "a") then
                        count = (count + 1)
                    end

                end

            elseif not alliance then

                for i,v in pairs(party) do

                    if i:sub(1,1) == "p" and tonumber(i:sub(2)) ~= nil then
                        count = (count + 1)
                    end

                end

            end

        end
        return count

    end

    return self

end
return party.new()
