_addon.name     = 'bp3'
_addon.author   = 'Elidyr'
_addon.version  = '1.202100826'
_addon.command  = 'bp'
local bp = require('bp/bootstrap')

-- Register Aliases.
local aliases = {

    {'bpon',        "ord pp bp enable"},
    {'bpoff',       "ord pp bp disable"},
    {'poke',        "ibruh bigpoke"},
    {'rap',         "ord rr raptor"},
    {'lilith',      "ord rr pg maiden"},
    {'rads',        "ord rr temps buy radialens"},
    {'portb',       "ord rr hp Port Bastok 2"},
    {'selbina',     "ord rr hp Selbina"},
    {'mha',         "ord rr hp Mhaura"},
    {'mountup',     "ord r bp mount"},
    {'prisms',      "ord rr input /item 'Prism Powder' <me>"},
    {'oils',        "ord rr input /item 'Silent Oil' <me>"},
    {'vshard',      "ord rr input /item 'V. Con. Shard' <me>"},
    {'ontic',       "ord rr input /item 'Ontic Extermity' <me>"},
    {'demring',     "ord rr bp demring"},

}
bp.helpers['alias'].register(aliases)

-- Register Keybinds.
local keybinds = {

    '@b bp toggle',
    '@f bp follow',
    '@a bp assist',
    '@m ord r bp mount',
    '@s bp request_stop',
    '@i bp party invite',
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
    '@w ord rr bp wring',
    '@d ord rr bp demring',
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