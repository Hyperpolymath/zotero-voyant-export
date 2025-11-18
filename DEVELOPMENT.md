# Development Guide

This document provides detailed information for developers working on the Zotero Voyant Export extension.

## Architecture

This project is based on the [zoterho-template](https://gitlab.com/extensions-library/zotero/zoterho-template) architecture, which provides a production-ready framework for building modern Zotero 7 extensions with type safety, modern tooling, and professional automation.

### Key Architectural Decisions

1. **ReScript for Type Safety**: All source code is written in ReScript (.res files), which provides:
   - Compile-time type checking
   - No runtime type errors
   - Excellent editor support
   - Compiles to clean, readable JavaScript

2. **Deno as Runtime**: Deno manages all build dependencies:
   - No package.json or node_modules
   - Secure by default
   - Built-in TypeScript support
   - npm: imports for accessing npm packages

3. **CUE for Configuration**: All configuration is defined in CUE:
   - Type-safe configuration with validation
   - Single source of truth
   - Generates manifest.json, deno.json, rescript.json
   - Prevents configuration drift

4. **Just for Task Automation**: Justfile replaces Makefiles and npm scripts:
   - Simple, readable syntax
   - Cross-platform
   - Built-in help system
   - No dependencies

## File Organization

### Source Files (Checked into Git)

```
config/
├── project.cue      # Project metadata and WebExtension manifest
├── deno.cue         # Deno configuration and task definitions
├── rescript.cue     # ReScript compiler configuration
└── manifest.cue     # Helper for manifest export

src/
├── background.res   # Extension entry point
├── Zotero.res       # Zotero API bindings
├── Exporter.res     # Export logic
├── Format.res       # XML generation (MODS, Dublin Core)
└── UI.res           # User interface (menus, dialogs)

ui/
└── icon.png         # Extension icon

justfile             # Build automation
README.md            # User-facing documentation
DEVELOPMENT.md       # This file
LICENSE              # GPL-3.0 license
```

### Generated Files (Not in Git)

```
manifest.json        # Generated from config/project.cue
deno.json           # Generated from config/deno.cue
rescript.json       # Generated from config/rescript.cue

src/*.mjs           # Compiled JavaScript from ReScript
src/*.cmi           # ReScript interface files
src/*.cmj           # ReScript compiled modules
src/*.cmt           # ReScript type information

lib/bs/             # ReScript build directory
web-ext-artifacts/  # Built XPI packages
```

## Build Process

### 1. Configuration Generation

```bash
just config
```

This runs:
- `cue export ./config/project.cue -e manifest` → `manifest.json`
- `cue export ./config/deno.cue -e deno` → `deno.json`
- `cue export ./config/rescript.cue -e rescript` → `rescript.json`

### 2. ReScript Compilation

```bash
just build
```

This runs:
- `deno task rescript:build` → Compiles `src/*.res` to `src/*.mjs`

### 3. Extension Packaging

```bash
just package
```

This runs:
- Clean build
- Configuration generation
- ReScript compilation
- `deno task ext:build` → Creates XPI in `web-ext-artifacts/`

## ReScript Code Structure

### Zotero.res - API Bindings

Provides type-safe bindings to Zotero's JavaScript API:

```rescript
// Type definitions
type rec collection = {
  name: string,
  getChildItems: unit => array<item>,
}

and item = {
  id: int,
  libraryKey: string,
  getDisplayTitle: unit => string,
  // ...
}

// External bindings
@val @scope("window")
external initializationPromise: promise<unit> = "Zotero.initializationPromise"
```

### Format.res - XML Generation

Generates MODS and Dublin Core metadata:

```rescript
let generateMODS = (item: Zotero.item): string => {
  // Create XML document
  // Add title and creators
  // Serialize to string
}
```

### Exporter.res - Export Logic

Handles the export process:

```rescript
let doExport = async (): unit => {
  // Get selected collection
  // Create temp directory
  // Process each item
  // Generate metadata files
  // Zip everything
}
```

### UI.res - User Interface

Manages menu items and file picker:

```rescript
let insertExportMenuItem = (onclick: unit => unit): unit => {
  // Create menu item
  // Add to collection menu
}
```

### background.res - Entry Point

Initializes the extension:

```rescript
let main = async () => {
  await Zotero.initializationPromise
  UI.insertExportMenuItem(() => {
    Exporter.doExport()->ignore
  })
}
```

## Testing

### Manual Testing

```bash
# Run in Firefox with auto-reload
just run
```

This opens Firefox with the extension loaded and watches for changes.

### Testing Export Functionality

1. Create a test collection in Zotero
2. Add items with attachments
3. Right-click collection → "Export Collection to Voyant..."
4. Choose save location
5. Verify ZIP file contains:
   - `bagit.txt`
   - `data/[item-id]/CWRC.bin` (attachment)
   - `data/[item-id]/MODS.bin` (metadata)
   - `data/[item-id]/DC.xml` (Dublin Core)

## Troubleshooting

### ReScript Compilation Errors

```bash
# Check for syntax errors
just check

# View detailed error messages
deno task rescript:build
```

### CUE Validation Errors

```bash
# Validate CUE files
just validate

# Check individual file
cue vet config/project.cue
```

### Extension Loading Issues

Check browser console for errors:
1. Open Zotero
2. Tools → Developer → Error Console
3. Look for "[Voyant Export]" messages

## Adding New Features

### 1. Add Zotero API Bindings

If you need new Zotero API functions:

```rescript
// In Zotero.res
@val @scope(("window", "Zotero"))
external someNewFunction: string => int = "someNewFunction"
```

### 2. Modify Export Logic

To change what's exported:

```rescript
// In Exporter.res
let processItem = async (item: Zotero.item, dataDir: {..}): unit => {
  // Add your custom processing here
}
```

### 3. Update Configuration

To change extension metadata:

```cue
// In config/project.cue
project: {
  version: "2.1.0"
  description: "New description"
}
```

Then run `just config` to regenerate files.

## Release Process

1. Update version in `config/project.cue`
2. Regenerate configs: `just config`
3. Run full build: `just release`
4. Test the XPI in clean Zotero install
5. Create GitHub release with XPI
6. Update changelog

## Credits and Attribution

This project's build system and architecture is based on:

**[zoterho-template](https://gitlab.com/extensions-library/zotero/zoterho-template)**
A production-ready template for building modern Zotero 7 extensions with type safety, modern tooling, and professional automation.

Key concepts adopted from zoterho-template:
- Deno-based toolchain
- CUE for configuration management
- Just for task automation
- ReScript for type-safe code
- In-source build for compiled files
- Generated configuration files

Original Zotero Voyant Export extension:
- Concept and initial implementation: Cora Johnson-Roberson
- Licensed under GPL-3.0

## Resources

- [ReScript Documentation](https://rescript-lang.org/docs/manual/latest/introduction)
- [Deno Manual](https://deno.land/manual)
- [CUE Documentation](https://cuelang.org/docs/)
- [Just Documentation](https://github.com/casey/just)
- [Zotero Plugin Development](https://www.zotero.org/support/dev/zotero_7_for_developers)
- [zoterho-template](https://gitlab.com/extensions-library/zotero/zoterho-template)
