fx_version 'adamant'

game 'gta5'

author 'Sheriff Matt'

description 'Toll Booth'

version '2.0.0'

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