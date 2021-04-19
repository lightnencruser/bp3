local menus = {}
function menus.new()
    local self = {}

    -- Private Variables.
    local allowed = {

        assaults    = S{'Yahsra','Isdebaaq','Famad','Lageegee','Bhoy Yhupplo'},
        sparks      = S{'Isakoth'},

    }

    -- Public Variables.
    self.enabled = false

    -- Public Functions.
    self.capture = function(bp, original)
        local bp        = bp or false
        local original  = original or false

        if self.enabled and bp and original then
            local packed    = bp.packets.parse('incoming', original)
            local npc       = windower.ffxi.get_mob_by_id(original:sub(5,8):unpack('I')) or false
            local menu      = { original:sub(9,40):unpack('C32') }

            -- Unlock Coalitions.
            if npc and npc.name == "Task Delegator" then                
                local updated = {}
    
                for i,v in ipairs(menu) do
                    
                    if (i < 2 or i > 4) then
                        updated[i] = ('C'):pack(menu[i])
                    else
                        updated[i] = ('C'):pack(222)
                    end
                    
                end
                windower.packets.inject_incoming(0x034, original:sub(1,8)..table.concat(updated, '')..original:sub(41))
                return true

            -- Unlock Sparks.
            elseif npc and allowed.sparks:contains(npc.name) then
                local updated = {}
    
                for i,v in ipairs(menu) do
                    
                    if (i < 9 or i > 20) then
                        updated[i] = ('C'):pack(menu[i])
                    else
                        updated[i] = ('C'):pack(255)
                    end
                    
                end
                windower.packets.inject_incoming(0x034, original:sub(1,8)..table.concat(updated, '')..original:sub(41))
                return true

            -- Unlock Delve Items.
            elseif npc and npc.name == "Forri-Porri" then
                local updated = {}

                for i,v in ipairs(menu) do
                    
                    if (i < 6 or i > 9) then
                        updated[i] = ('C'):pack(menu[i])
                    else
                        updated[i] = ('C'):pack(255)
                    end
                    
                end
                windower.packets.inject_incoming(0x034, original:sub(1,8)..table.concat(updated, '')..original:sub(41))
                return true

            -- Unlock High-Tier Battlefields.
            elseif npc and (npc.name == "Raving Opossum" or npc.name == "Trisvain" or npc.name == "Mimble-Pimble") then
                local updated = {}

                for i,v in ipairs(menu) do
                    
                    if (i < 4 or i > 9) then
                        updated[i] = ('C'):pack(menu[i])
                    else
                        updated[i] = ('C'):pack(255)
                    end
                    
                end
                windower.packets.inject_incoming(0x034, original:sub(1,8)..table.concat(updated, '')..original:sub(41))
                return true

            -- Unlock Nation Items.
            elseif npc and (npc.name:match('I.M.') or npc.name:match('T.K.')) then
                local updated = {}
                
                for i,v in ipairs(menu) do
                    
                    if (i < 3 or i > 11) then
                        updated[i] = ('C'):pack(menu[i])
                    
                    elseif i == 3 then
                        updated[i] = ('C'):pack(255)
                    
                    elseif i == 4 then
                        updated[i] = ('C'):pack(255)
                    
                    elseif i == 5 then
                        updated[i] = ('C'):pack(255)
                    
                    elseif i == 6 then
                        updated[i] = ('C'):pack(255)
                    
                    elseif i == 7 then
                        updated[i] = ('C'):pack(255)
                        
                    elseif i == 8 then
                        updated[i] = ('C'):pack(255)
                        
                    elseif i == 9 then
                        updated[i] = ('C'):pack(182)
                        
                    elseif i == 10 then
                        updated[i] = ('C'):pack(255)
                        
                    elseif i == 11 then
                        updated[i] = ('C'):pack(255)
                        
                    end
                    
                end
                windower.packets.inject_incoming(0x034, original:sub(1,8)..table.concat(updated, '')..original:sub(41))
                return true

            end

        end
        return original

    end

    self.toggle = function(bp)
        local bp = bp or false

        if bp then

            if self.enabled then
                self.enabled = false

            else
                self.enabled = true

            end
            bp.helpers['popchat'].pop(string.format('MENU HACKS: %s!', tostring(self.enabled)))

        end

    end

    return self

end
return menus.new()