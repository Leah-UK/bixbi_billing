--[[----------------------------------
Creation Date:	27/08/2021
]]------------------------------------
fx_version 'cerulean'
game 'gta5'
author 'Leah#0001'
version '2.01'
versioncheck 'https://raw.githubusercontent.com/Bixbi-FiveM/bixbi_billing/main/fxmanifest.lua'
lua54 'yes'

shared_scripts {
	'@ox_lib/init.lua',
	'sh_config.lua'
}

client_scripts {
	'client/cl_framework.lua',
	'client/cl_functions.lua',
	'client/cl_menu.lua',
	'client/cl_target.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/sv_framework.lua',
	'server/sv_functions.lua',
	'server/sv_callbacks.lua',
	'server/sv_version.lua'
}
