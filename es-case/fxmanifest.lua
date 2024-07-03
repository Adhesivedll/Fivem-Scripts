fx_version "adamant"

description "www.fivemscript.store"


game "gta5"

client_script { 
"main/client.lua"
}

server_script {
'@mysql-async/lib/MySQL.lua',
"main/server.lua",
} 

shared_script { 
    'main/shared.lua'
}

ui_page "index.html"

files {
    'index.html',
    'web/vue.js',
    'assets/**/*.*'
}


lua54 'yes'
