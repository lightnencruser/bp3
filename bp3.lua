_addon.name     = 'bp3'
_addon.author   = 'Elidyr'
_addon.version  = '2.20210908'
_addon.command  = 'bp'
local bp = require('bp/bootstrap')

-- Register Aliases.
local aliases = {

    {'bpon',        "ord pp bp enable"},
    {'bpoff',       "ord pp bp disable"},

}
bp.helpers['alias'].register(aliases)

-- Register Keybinds.
local keybinds = {

    '@b bp toggle',
    '@f bp follow',
    '@a bp assist',
    '@s bp request_stop',
    '@i bp party invite',
    '@t bp target t',
    '@p bp target pt',
    '@, bp target lt',
    '@. bp target et',

}
bp.helpers['keybinds'].register(keybinds)

-- Autoload Add-ons.
local addons = {

    --'superwarp', -- ADDON NAME HERE

}
bp.helpers['autoload'].load(addons)