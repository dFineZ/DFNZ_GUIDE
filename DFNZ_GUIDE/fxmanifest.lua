fx_version 'cerulean'
game 'gta5'
lua54 'yes'

author 'DFNZ'
description 'Guidetour by DFNZ'
version '1.0.0'

shared_script {
    '@es_extended/imports.lua',
    '@ox_lib/init.lua'
}

client_scripts {
    "shared/config.lua",
    "client/*.lua"
}

server_scripts {
    "@mysql-async/lib/MySQL.lua",
    "shared/config.lua",
    "server/*.lua"
}
