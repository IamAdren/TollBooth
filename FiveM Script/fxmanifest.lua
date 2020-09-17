fx_version 'adamant'
game 'gta5'
author 'IamAdren'
description 'Toll Booth'
version '2.0.0'
this_is_a_map 'yes'

server_scripts {
	'@mysql-async/lib/MySQL.lua',
	'config.lua',
	'server/main.lua'
}

client_scripts {
	'config.lua',
	'client/main.lua'
}

dependency 'es_extended'

ui_page('html/index.html')

files {
    'html/index.html'
}
