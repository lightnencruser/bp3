local mount = {}
function mount.new()
    local self = {}

    self.capture = function(bp, commands)
        local bp        = bp or false
        local commands  = commands or false
        
        if bp and commands then
            local name = {}

            if commands[2] then
                
                for i=2, #commands do
                    table.insert(name, commands[i])
                end
                bp.helpers['mount'].change(bp, table.concat(name, ' '))

            else
                bp.helpers['mount'].mount()

            end

        end

    end

    return self

end
return mount.new()
