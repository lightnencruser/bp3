_addon.name     = 'bp3'
_addon.author   = 'Elidyr'
_addon.version  = '3.20211225'
_addon.command  = 'bp'
local bp = require('bp/bootstrap')
--[[ From all your friends on Lakshmi, RIP Kanobrown, and you will be forever missed in the FFXI Community. ]]--

-- Register Aliases.
local aliases = {

    {'bpon',        "ord pp bp enable"},
    {'bpoff',       "ord pp bp disable"},
    {'poke',        "ibruh bigpoke"},
    {'rap',         "ord rr raptor"},
    {'lilith',      "ord pp pg maiden"},
    {'cait',        "ord pp pg cait"},
    {'alex',        "ord pp pg divine"},
    {'rads',        "ord rr temps buy radialens"},
    {'portb',       "ord pp hp Port Bastok 2"},
    {'selbina',     "ord pp hp Selbina"},
    {'mha',         "ord pp hp Mhaura"},
    {'prisms',      "ord rr input /item 'Prism Powder' <me>"},
    {'oils',        "ord rr input /item 'Silent Oil' <me>"},
    {'vshard',      "ord rr input /item 'V. Con. Shard' <me>"},
    {'ontic',       "ord rr input /item 'Ontic Extermity' <me>"},
    {'woe',         "ord rr ent buy"},

    -- RINGS.
    {'wring',       "bp wring"},
    {'demring',     "bp demring"},
    {'wrings',      "ord @ bp wring"},
    {'demrings',    "ord @ bp demring"},

    -- ITEMS.
    {'mars',        "bp trade mars:1"},
    {'venus',       "bp trade venus:1"},

}
bp.helpers['alias'].register(aliases)

-- Register Keybinds.
local keybinds = {

    '@b bp toggle',
    '@f bp follow',
    '@a bp assist',
    '@m ord r bp mount',
    '@s bp request_stop',
    '@t bp target t',
    '@p bp target pt',
    '@, bp target lt',
    '@. bp target et',
    '@up ord p bp controls up',
    '@down ord p bp controls down',
    '@left ord p bp controls left',
    '@right ord p bp controls right',
    '@escape ord p bp controls escape',
    '@enter ord p bp controls enter',
    '@[ ord @ bp on',
    '@] ord @ bp off',
    '@/ bp mode',

}
bp.helpers['keybinds'].register(keybinds)

-- Autoload Add-ons.
local addons = {

    'orders',
    'enter',
    'skillchains',
    'allmaps',
    'phantomgem',
    'superwarp',
    'interactbruh',

}
bp.helpers['autoload'].load(addons)