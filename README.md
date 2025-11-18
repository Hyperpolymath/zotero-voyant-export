# Zotero Voyant Export

Export your Zotero collections to Voyant for text analysis.

[Voyant](http://voyant-tools.org/) is "a web-based text analysis and reading
environment" that lets you visualize the content of a text
corpus. [Zotero](https://www.zotero.org/) is a "a free, easy-to-use tool to help
you collect, organize, cite, and share your research sources." This extension
helps those with preexisting Zotero collections get a new view on their
data via Voyant.

## Version 2.0 - Zotero 7 Compatible

This version has been completely rewritten for Zotero 7 compatibility using modern
tooling:

- **ReScript** for type-safe code
- **Modern JavaScript (ESM)** with .mjs modules
- **WebExtension Manifest v2** for Zotero 7
- Based on the [zoterho-template](https://gitlab.com/extensions-library/zotero/zoterho-template) architecture

## Requirements

* Zotero 7.0 or higher
* A collection containing full texts (as PDFs, HTML snapshots, etc.)

## Installation

Download the latest XPI from the releases page. Then open Zotero and select
Tools menu -> Add-ons. Click the gear icon in the upper right and select
"Install Add-On From File..."; open the XPI file you just saved.

## Usage

Right-click on the collection you wish to analyze. Select "Export Collection to
Voyant..." and choose a save location for the corpus as a zip file.

Upload the resulting zip to [voyant-tools.org](http://voyant-tools.org) (or
to [your local Voyant server][local-voyant] -- for collections larger than a
handful of documents, you'll probably want to host locally). You should then be
able to see your corpus in the default Voyant view.

## Development

### Prerequisites

- Node.js 18+
- npm

### Setup

```bash
npm install
```

### Build

Build the extension:

```bash
npm run build
```

Watch mode for development:

```bash
npm run dev
```

Create XPI package:

```bash
npm run package
```

### Project Structure

```
├── config/           # CUE configuration files (for future use)
├── src/              # ReScript source files
│   ├── background.res   # Main entry point
│   ├── Zotero.res       # Zotero API bindings
│   ├── Exporter.res     # Export logic
│   ├── Format.res       # MODS/DC XML generation
│   └── UI.res           # Menu items and file picker
├── ui/               # UI assets (icons, etc.)
├── manifest.json     # WebExtension manifest
├── rescript.json     # ReScript configuration
└── package.json      # npm configuration
```

### Tech Stack

- **ReScript**: Type-safe language that compiles to JavaScript
- **@rescript/core**: Standard library for ReScript
- **web-ext**: Mozilla's tool for building and testing extensions

### How it Works

1. ReScript (.res) files in `src/` are compiled to JavaScript (.mjs) files
2. The manifest.json defines the extension for Zotero 7
3. background.mjs is loaded when Zotero starts
4. A context menu item is added to collections
5. When clicked, items are exported with metadata to a zip file

[local-voyant]: http://docs.voyant-tools.org/resources/run-your-own/voyant-server/

## LICENSE

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <https://www.gnu.org/licenses/>.
