fx_version 'cerulean'
game 'gta5'

name "maestro_itemvehicles"
description "Item Vehicles"
author "MaestroAbi"
version "1.0.0"

dependencies {
    'ox_lib',
    'ox_target',
    'qbx_core',
    'ox_inventory'
}

shared_scripts {
    '@ox_lib/init.lua',
    '@qbx_core/modules/lib.lua',
    'shared/config.lua'
}

server_scripts {
    'server/main.lua'
}

client_scripts {
    'client/main.lua'
}

lua54 'yes'
