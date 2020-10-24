local bpcore = {}
function bpcore.new()
    local self = {}

    self.playSound = function(name)
        local name = name or false

        --if name and bpcore:fileExists(("bp/resources/sounds/%s.wav"):format(name)) then
            --windower.play_sound(("%sbp/resources/sounds/%s.wav"):format(windower.addon_path, name))
        --end

    end

    self.numberToHex = function(number)
        return string.format("%x", number * 256)
    end

    slef.stringToHex = function(string)
        local hex = ''

        while #string > 0 do
            local hb = bpcore:numberToHex(string.byte(string, 1, 1))

            if #hb < 2 then hb = '0' .. hb end
                hex = hex .. hb
                string = string.sub(string, 2)

            end
            return hex

        end

    end

    self.round = function(num, numDecimalPlaces)
        return tonumber(string.format("%." .. (numDecimalPlaces or 0) .. "f", num))
    end

    self.buffActive(id)

        for _,v in ipairs(windower.ffxi.get_player().buffs) do

            if v == id then
                return true
            end

        end
        return false

    end

--------------------------------------------------------------------------------
-- Use various useable goods in inventory while idle.
--------------------------------------------------------------------------------
function bpcore:useBaggedGoods()
    local enabled = commands["items"].settings().toggle
    local user    = commands["items"].settings().user
    local beads   = commands["items"].settings().beads
    local silt    = commands["items"].settings().silt
    local skills  = commands["items"].settings().skills
    local rocks   = commands["items"].settings().rocks
    local list    = commands["items"].settings().list
    local bead_count = tonumber(helpers["currencies"].getCurrency("Beads"))

    if enabled and not windower.ffxi.get_info().mog_house then
        local busy = false

        if user and bpcore:hasSpace(0) then
            local items = list["My Items"]

            for _,v in ipairs(items) do
                if bpcore:findItemByName(v, 0) then
                    helpers["actions"].useItem(v)
                    busy = true
                end
            end

        end

        if skills and bpcore:hasSpace(0) and not busy then
            local items = list["Skill Items"]
            local job = windower.ffxi.get_player().main_job
            local sub = windower.ffxi.get_player().sub_job

            if (items[job] or items[sub]) then

                if items[job] then

                    for _,v in ipairs(items[job]) do
                        if bpcore:findItemByName(v, 0) then
                            helpers["actions"].useItem(v)
                            busy = true
                        end
                    end

                end

                if items[sub] and not busy then

                    for _,v in ipairs(items[sub]) do
                        if bpcore:findItemByName(v, 0) then
                            helpers["actions"].useItem(v)
                            busy = true
                        end
                    end

                end

            end

        end

        if rocks and bpcore:hasSpace(0) and not busy then
            local items = list["Rock Items"]

            for _,v in ipairs(items) do
                if bpcore:findItemByName(v, 0) then
                    helpers["actions"].useItem(v)
                    busy = true
                end
            end

        end

        if beads and bead_count < 50000 and bpcore:hasSpace(0) and not busy then
            local items = {"Bead Pouch"}

            for _,v in ipairs(items) do
                if bpcore:findItemByName(v, 0) then
                    helpers["actions"].useItem(v)
                    busy = true
                end
            end

        end

        if silt and bpcore:hasSpace(0) and not busy then
            local items = {"Silt Pouch"}

            for _,v in ipairs(items) do
                if bpcore:findItemByName(v, 0) then
                    helpers["actions"].useItem(v)
                    busy = true
                end
            end

        end
        busy = false

    end

end

--------------------------------------------------------------------------------
-- Find a mob nearby by name.
--------------------------------------------------------------------------------
function bpcore:findMobInProximity(name, range)
    if name ~= "" and type(name) == 'string' then

        for i,v in pairs(windower.ffxi.get_mob_array()) do
            if string.find(v['name'], name) then
                local mob = windower.ffxi.get_mob_by_id(v.id)

                if mob and mob.hpp > 0 then

                    if helpers["actions"].rangeCheck(mob.x, mob.y, range) then
                        return mob
                    end

                end

            end

        end

	end
	return false

end

--------------------------------------------------------------------------------
-- Find a mob nearby by name.
--------------------------------------------------------------------------------
function bpcore:getFinishingMoves()
    local buffs = system["Buffs"].Player

    for _,v in ipairs(buffs) do

        if v == 381 then
            return 1
        elseif v == 382 then
            return 2
        elseif v == 382 then
            return 3
        elseif v == 382 then
            return 4
        elseif v == 382 then
            return 5
        elseif v == 588 then
            return 6
        end

    end
    return 0

end

return bpcore
