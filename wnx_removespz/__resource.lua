resource_manifest_version "77731fab-63ca-442c-a67b-abc70f28dfa5"

ui_page 'h.html'

lua54 'yes'

client_scripts {
    'client.lua'
} 

shared_scripts {
	"@ox_lib/init.lua",
	'config.lua'
}


files {
    'h.html'
}

export "startUI"