local install = {}
local files = require('files')

function install.new()
    local self = {}

    self.install = function(bp, name)

    end

    self.exists = function(bp, name)

    end

    return self

end
return install.new()