local bootstrap = {}
local player    = windower.ffxi.get_player() or false

bootstrap.load = function()
    local self = {}

    -- Private Settings.
    local helpers_update    = dofile(string.format('%sbp/settings/template/default_settings.lua', windower.addon_path)).helpers
    local directory         = string.format('bp/settings/%s', player.name)

    self.debug      = false
    self.core       = false
    self.settings   = {}
    self.helpers    = {}
    self.commands   = {}
    self.events     = {}
    self.JA         = {}
    self.MA         = {}
    self.WS         = {}
    self.IT         = {}
    self.res        = require('resources')
    self.files      = require('files')
    self.packets    = require('packets')
    self.texts      = require('texts')
    self.sets       = require('sets')
    self.images     = require('images')
    self.queues     = require('queues')
    self.extdata    = require('extdata')
    self.json       = require('/bp/resources/JSON')
                    require('actions')
                    require('strings')
                    require('lists')
                    require('tables')
                    require('chat')
                    require('logger')
                    require('pack')

    self.pinger     = os.clock()+15
    self.pos        = {x=windower.ffxi.get_mob_by_target('me').x, y=windower.ffxi.get_mob_by_target('me').y, x=windower.ffxi.get_mob_by_target('me').z}
    self.shutdown   = {[131]=131}
    self.blocked    = {
 
    [026]=026,[048]=048,[050]=050,[053]=053,[070]=070,
    [071]=071,[080]=080,[087]=087,[094]=094,[230]=230,
    [231]=231,[232]=232,[233]=233,[234]=234,[235]=235,
    [236]=236,[237]=237,[238]=238,[239]=239,[240]=240,
    [241]=241,[242]=242,[243]=243,[244]=244,[245]=245,
    [246]=246,[247]=247,[248]=248,[249]=249,[250]=250,
    [252]=252,[256]=256,[257]=257,[280]=280,[281]=281,
    [284]=284,[251]=251,

    }

    self.skillup    = {
        
        ['Divine']     = {list={'Banish','Flash','Banish II','Enlight','Repose'}, target='t'},
        ['Enhancing']  = {list={'Barfire','Barfira','Barblizzard','Barblizzara','Baraero','Baraera','Barstone','Barstonra','Barthunder','Barthundra','Barwater','Barwatera'}, target='me'},
        ['Enfeebling'] = {list={'Bind','Blind','Dia','Poison','Gravity','Slow','Silence'}, target='t'},
        ['Elemental']  = {list={'Stone'}, target='t'},
        ['Dark']       = {list={'Aspir','Aspir II','Bio','Bio II','Drain','Drain II'}, target='t'},
        ['Singing']    = {list={"Mage's Ballad","Mage's Ballad II","Mage's Ballad III"}, target='me'},
        ['Summoning']  = {list={'Carbuncle'}, target='me'},
        ['Blue']       = {list={'Cocoon','Pollen'}, target='me'},
        ['Geomancy']   = {list={'Indi-Refresh'}, target='me'},
        
        
    }

    self.round = function(num)
        
        if num >= 0 then 
            return math.floor(num+.5)

        else
            return math.ceil(num-.5)

        end

    end

    self.convertTarget = function(target)
        local target = target or false

        if type(target) == 'table' then
            return target or false

        elseif type(target) == 'number' or tonumber(target) ~= nil then
            return windower.ffxi.get_mob_by_id(target) or windower.ffxi.get_mob_by_index(target) or false

        elseif type(target) == 'string' and tonumber(target) == nil then
            return windower.ffxi.get_mob_by_name(target) or false

        end
        return false

    end

    self.writeSettings = function(dir, settings)
        local dir, settings = dir or false, settings or {}

        if dir and settings and type(settings) == 'table' then
            self.files.new(string.format('%s.lua', dir)):write(string.format('return %s', T(settings):tovstring()))
        end

    end

    self.buildCore = function(update)
        local player = windower.ffxi.get_player() or false

        if player then
            local dir = string.format('bp/core/%s/%score.lua', player.main_job:lower(), player.main_job:lower())
            local f   = self.files.new(dir)

            if f:exists() then

                if update and self.helpers ~= nil then
                    self.helpers['popchat'].pop(string.format('Core loaded for %s!', player.main_job_full))
                end
                self.core = dofile(string.format('%s%s', windower.addon_path, dir))

            end

        end

    end
    self.buildCore(false)

    local buildSettings = function()

        if player then
            local dir = string.format('bp/settings/%s.lua', player.name)
            local f   = self.files.new(dir)

            if f:exists() then
                return dofile(string.format('%s%s', windower.addon_path, dir))

            else
                local f = self.files.new('bp/settings/template/default_settings.lua')

                if f:exists() then
                    local settings = dofile(string.format('%sbp/settings/template/default_settings.lua', windower.addon_path))

                    if settings then
                        self.writeSettings(string.format('bp/settings/%s', player.name), settings)
                        return settings

                    end

                end

            end

        end

    end
    self.settings = buildSettings()

    local flag_update = false
    local updateHelpers = function()

        for _,v in ipairs(helpers_update) do
            local found = false
            
            for _,vv in ipairs(self.settings.helpers) do

                if v.name == vv.name then
                    found = true
                end

            end

            if not found then
                flag_update = true
                table.insert(self.settings.helpers, v)

            end

        end
        self.writeSettings(directory, self.settings)

    end
    updateHelpers()

    local buildHelpers = function()
        local dir = {helpers=('bp/helpers/'), commands=('bp/commands/')}

        if self.settings and self.settings.helpers then

            for _,v in ipairs(self.settings.helpers) do

                if v and v.name and v.status then
                    local f = {helper=self.files.new(string.format('%s%s.lua', dir.helpers, v.name)), command=self.files.new(string.format('%s%s.lua', dir.commands, v.name))}

                    if f.helper:exists() then
                        self.helpers[v.name] = dofile(string.format('%s%s%s.lua', windower.addon_path, dir.helpers, v.name))
                    end

                    if f.command:exists() then
                        self.commands[v.name] = dofile(string.format('%s%s%s.lua', windower.addon_path, dir.commands, v.name))
                    end

                end

            end

        end

    end
    buildHelpers()

    if flag_update then
        self.helpers['popchat'].pop('NEW HELPERS HAVE BEEN INSTALLED!')
    end

    local buildResources = function()

        for _,v in pairs(self.res.job_abilities) do
            if v.en then
                self.JA[v.en] = v
            end
        end

        for _,v in pairs(self.res.spells) do
            if v.en then
                self.MA[v.en] = v
            end
        end

        for _,v in pairs(self.res.weapon_skills) do
            if v.en then
                self.WS[v.en] = v
            end
        end

        for _,v in pairs(self.res.items) do
            if v.en then
                self.IT[v.en] = v
            end
        end

    end
    buildResources()

    return self

end
return bootstrap.load()
