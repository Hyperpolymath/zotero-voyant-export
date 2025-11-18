package config

project: {
	name:        "Zotero Voyant Export"
	id:          "zotero-voyant-export@corajr.com"
	version:     "2.0.0"
	description: "Export your Zotero collections to Voyant"
	author:      "Cora Johnson-Roberson"
	homepage:    "https://github.com/corajr/zotero-voyant-export"
}

manifest: {
	manifest_version: 2
	name:             project.name
	version:          project.version
	description:      project.description
	author:           project.author
	homepage_url:     project.homepage

	applications: gecko: {
		id:                  project.id
		strict_min_version: "115.0"
	}

	icons: "64": "ui/icon.png"

	background: scripts: ["src/background.mjs"]

	permissions: [
		"storage",
	]
}
