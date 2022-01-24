--[[----------------------------------
Creation Date:	27/08/2021
]]------------------------------------
fx_version 'cerulean'
game 'gta5'
author 'Leah#0001'
version '1.0.3'
versioncheck 'https://raw.githubusercontent.com/Leah-UK/bixbi_billing/main/fxmanifest.lua'
lua54 'yes'

shared_scripts {
	'@es_extended/imports.lua',
	'config.lua'
}

client_scripts {
	'client.lua'
}

server_scripts {
	'server.lua'
}

dependencies {
	'bixbi_core'
}

escrow_ignore {
	'config.lua',
	'client.lua'
}