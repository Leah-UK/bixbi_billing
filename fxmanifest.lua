--[[----------------------------------
Creation Date:	27/08/2021
]]------------------------------------
fx_version 'cerulean'
game 'gta5'
author 'Leah#0001'
version '1.99'
versioncheck 'https://raw.githubusercontent.com/Leah-UK/bixbi_billing/main/fxmanifest.lua'
lua54 'yes'

shared_scripts {
	'@es_extended/imports.lua',
	'@ox_lib/init.lua',
	'config.lua'
}

client_scripts {
	'client/cl_functions.lua',
	'client/cl_main.lua',
	'client/cl_menu.lua',
	'client/cl_target.lua'
}

server_scripts {
	'@oxmysql/lib/MySQL.lua',
	'server/sv_main.lua',
	'server/sv_functions.lua',
	'server/sv_callbacks.lua',
	'server/sv_version.lua'
	-- 'server.lua'
}