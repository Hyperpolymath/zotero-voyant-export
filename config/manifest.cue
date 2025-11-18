package config

import "encoding/json"

// Import project configuration
#Project: project

// Output manifest.json file
manifest_json: json.Marshal(manifest)
