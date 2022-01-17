--[[----------------------------------
Creation Date:	27/08/2021
Discord: View Link on 'versioncheck' URL
]]------------------------------------
fx_version 'cerulean'
game 'gta5'
author 'Leah#0001'
version '1.0'
-- versioncheck 'https://raw.githubusercontent.com/Leah-UK/FiveM-Script-Versioning/main/bixbi_billing.lua'
lua54 'yes'

shared_scripts {
	'@es_extended/imports.lua',
	'config.lua'
}

client_scripts {
	'client.lua'
}

server_scripts {
	-- '@async/async.lua',
	-- '@mysql-async/lib/MySQL.lua',
	'server.lua'
}

dependencies {
	'bixbi_core'
}

escrow_ignore {
	'config.lua',
	'client.lua'
}