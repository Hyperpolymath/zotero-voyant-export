package config

import "encoding/json"

rescript: {
	name:    "zotero-voyant-export"
	version: "0.0.1"

	sources: {
		dir:          "src"
		subdirs:      true
	}

	"bs-dependencies": [
		"@rescript/core",
	]

	"package-specs": {
		module: "esmodule"
		"in-source": true
		suffix: ".mjs"
	}
}

// Output rescript.json file
rescript_json: json.Marshal(rescript)
