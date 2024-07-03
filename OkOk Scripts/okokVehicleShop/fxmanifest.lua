fx_version 'cerulean'

game 'gta5'

author 'okok#3488'
description 'okokVehicleShop'

ui_page 'web/ui.html'

files {
	'web/*.*',
	'web/img/*.png'
}

shared_script 'config.lua'

client_scripts {
	'client.lua',
	'cl_utils.lua'
}

server_scripts {
	'webhook.lua',
	'server.lua'
}

lua54 'yes'

escrow_ignore {
	'config.lua',
	'webhook.lua',
	'cl_utils.lua'
}