local romans = {}
function romans.new()
    local self = {}

    -- Private Variables.
    local conversion = {
        
        { number = 1000,    symbol = "M" },
        { number = 900,     symbol = "CM" },
        { number = 500,     symbol = "D" },
        { number = 400,     symbol = "CD" },
        { number = 100,     symbol = "C" },
        { number = 90,      symbol = "XC" },
        { number = 50,      symbol = "L" },
        { number = 40,      symbol = "XL" },
        { number = 10,      symbol = "X" },
        { number = 9,       symbol = "IX" },
        { number = 5,       symbol = "V" },
        { number = 4,       symbol = "IV" },
        { number = 1,       symbol = "I" }

    }
      
    self.toRoman = function(number)
        local number    = number or false
        local r         = ""

        if number then
            
            for _,table in pairs (conversion) do
                
                while(number >= table.number) do
                    r       = (r .. table.symbol)
                    number  = (number - table.number)
    
                end
    
            end  
            return r

        end

    end

    return self

end
return romans.new()