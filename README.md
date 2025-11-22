# Zotero Voyant Export

[![License: GPL v3](https://img.shields.io/badge/License-GPLv3-blue.svg)](LICENSE)
[![Status: Development](https://img.shields.io/badge/Status-Development-yellow.svg)](#development-status)

Export your Zotero collections to Voyant Tools for text analysis and visualization.

## Overview

**Zotero Voyant Export** bridges [Zotero](https://www.zotero.org/), a reference management tool, and [Voyant Tools](http://voyant-tools.org/), a web-based text analysis environment. This plugin enables researchers to analyze their Zotero collections using Voyant's powerful text mining and visualization capabilities.

### Key Features

- 📚 **One-Click Export**: Right-click any Zotero collection to export
- 📦 **BagIt Format**: Creates standards-compliant BagIt archives
- 📄 **Rich Metadata**: Includes MODS and Dublin Core metadata
- 🔍 **Smart Attachments**: Automatically selects best attachment (PDF, HTML, etc.)
- 🎯 **Voyant-Ready**: ZIP files upload directly to Voyant Tools

## Requirements

### Zotero
- **[Zotero Standalone 5.0+][zot]** or newer
- ⚠️ **Important**: Zotero 5.0 beta will irreversibly upgrade your database
- **Backup recommended** before installation

### Collection Requirements
- Collection must contain items with attachments
- Supported attachment types:
  - PDF files (preferred)
  - HTML snapshots
  - Other text-based formats

### Optional
- **[Voyant Server][local-voyant]** (recommended for large collections)
- For collections with 50+ documents, local hosting provides better performance

## Installation

### From Release (Recommended)

1. Download the latest [release][release] XPI file
   - Right-click → "Save Link As..." (if in Firefox)
2. Open Zotero Standalone
3. Navigate to **Tools → Add-ons**
4. Click the gear icon (⚙️) in the upper right
5. Select **"Install Add-On From File..."**
6. Choose the downloaded XPI file
7. Restart Zotero

### From Source (Development)

See [CONTRIBUTING.md](CONTRIBUTING.md) for build instructions.

## Usage

### Basic Export

1. **Select Collection**: In Zotero, right-click the collection you want to analyze
2. **Export**: Choose **"Export Collection to Voyant..."** from the context menu
3. **Save Location**: Choose where to save the ZIP file
4. **Wait**: Export progress is logged to Zotero's debug output

### Upload to Voyant

#### Cloud Version
1. Visit [voyant-tools.org](http://voyant-tools.org)
2. Click **"Upload"** or drag-and-drop the ZIP file
3. Wait for processing
4. Explore your corpus with Voyant's tools

#### Local Server (Recommended for Large Collections)
1. [Install Voyant Server][local-voyant] on your machine
2. Start the server (typically `http://localhost:8888`)
3. Upload your ZIP file
4. Better performance, no file size limits, data stays local

### What Gets Exported

Each exported ZIP contains:
- **BagIt Structure**: Standards-compliant package format
- **Metadata**: MODS and Dublin Core XML for each item
- **Attachments**: PDF, HTML, or other text files
- **Collection Info**: Organized by Zotero item ID

See [BAGIT.md](BAGIT.md) for detailed format documentation.

## Troubleshooting

### Export Menu Item Not Appearing

**Problem**: Right-click menu doesn't show "Export Collection to Voyant..."

**Solutions**:
1. Verify extension is installed: **Tools → Add-ons → Extensions**
2. Check that you're right-clicking on a **collection** (not a library or item)
3. Restart Zotero
4. Check Zotero debug output for errors:
   - **Help → Debug Output Logging → Start Logging**
   - Restart Zotero
   - **Help → Debug Output Logging → View Output**
   - Look for "zotero-voyant-export" messages

### Export Produces Empty/Incomplete ZIP

**Problem**: ZIP file is created but missing items or very small

**Possible Causes & Solutions**:

1. **Items without attachments**
   - Only items with PDF, HTML, or other attachments are exported
   - Check that your collection items have attached files
   - In Zotero, look for the attachment icon (📎) next to items

2. **Permission errors**
   - Check Zotero debug output for "Failed to copy attachment" messages
   - Verify Zotero can access your attachment files
   - Check file permissions on your Zotero storage directory

3. **Temporary directory issues**
   - Ensure you have sufficient disk space
   - Check system temp directory permissions

### Export Fails or Hangs

**Problem**: Export starts but never completes or errors out

**Solutions**:

1. **Large collections**
   - Try exporting a smaller subset first
   - Check available disk space (need ~2x collection size)
   - Monitor Zotero debug output for progress

2. **Corrupted items**
   - Export may skip items with errors
   - Check debug output for "Item X: Export failed" messages
   - Try removing problematic items from collection temporarily

3. **Zotero frozen**
   - Export is synchronous and may freeze UI briefly for large collections
   - Wait a few minutes for large collections
   - Check Task Manager / Activity Monitor to verify Zotero is still running

### Voyant Upload Issues

**Problem**: ZIP uploads but Voyant shows errors or empty corpus

**Possible Causes**:

1. **File size limits (cloud Voyant only)**
   - Cloud Voyant has upload size limits
   - Solution: Use [local Voyant server][local-voyant]

2. **Network timeout**
   - Large uploads may timeout
   - Try a smaller collection or local Voyant

3. **Invalid attachments**
   - Voyant needs readable text files
   - Scanned PDFs without OCR won't work
   - Binary files won't produce meaningful analysis

### Debug Output

To get detailed debug information:

1. **Enable Logging**:
   - **Help → Debug Output Logging → Start Logging**
   - Select "All" or at minimum "zotero-voyant-export"

2. **Reproduce Issue**: Perform the export

3. **View Output**:
   - **Help → Debug Output Logging → View Output**
   - Copy output to file for issue reporting

4. **Look for**:
   - "zotero-voyant-export loaded" (confirms installation)
   - "Starting export: collection..." (confirms export started)
   - "Item X: No attachment found" (items skipped)
   - "Export completed successfully" (confirms success)
   - Any ERROR messages

### Getting Help

If troubleshooting doesn't solve your issue:

1. **Check existing issues**: [GitHub Issues](https://github.com/corajr/zotero-voyant-export/issues)
2. **Create new issue** using the bug report template
3. **Include**:
   - Zotero version
   - Plugin version
   - Operating system
   - Debug output (from above)
   - Collection details (size, item types)

## Development Status

This project is under active modernization:

- ✅ **Modernized to ES6+**: All modules use modern JavaScript
- ✅ **Enhanced error handling**: Comprehensive error checking and reporting
- ✅ **Expanded metadata**: Rich MODS and Dublin Core generation
- ✅ **Comprehensive tests**: Extensive test coverage
- ✅ **Full documentation**: Developer guides, BagIt specs, contribution guidelines
- ⚠️ **In Development**: Not yet production-ready, testing recommended

### Contributing

Contributions welcome! See [CONTRIBUTING.md](CONTRIBUTING.md) for:
- Development setup
- Coding standards
- Testing guidelines
- Pull request process

### Documentation

- **[CLAUDE.md](CLAUDE.md)**: AI assistant guide to codebase
- **[DEVELOPMENT.md](DEVELOPMENT.md)**: Comprehensive developer documentation
- **[BAGIT.md](BAGIT.md)**: BagIt format specification compliance
- **[CONTRIBUTING.md](CONTRIBUTING.md)**: Contribution guidelines

## Build

### Quick Build

```bash
make xpi  # Creates unsigned XPI
```

### Build with Tests

```bash
# Run tests
make test

# Or specify Firefox Nightly path
jpm test -b "/Applications/Nightly.app/"
```

### Signed Release

Requires Mozilla API credentials:

```bash
export JWT_ISSUER="your-issuer"
export JWT_SECRET="your-secret"
export UHURA_PEM_FILE="/path/to/key.pem"

make sign     # Sign XPI
make release  # Full release with update.rdf
```

See [DEVELOPMENT.md](DEVELOPMENT.md) for detailed build instructions.

[local-voyant]: http://docs.voyant-tools.org/resources/run-your-own/voyant-server/
[zot]: https://forums.zotero.org/discussion/59829/zotero-5.0-beta/
[release]: https://github.com/corajr/zotero-voyant-export/releases

## Technical Details

### Architecture

- **Entry Point**: `index.js` - Add-on initialization with retry logic
- **Core Modules**:
  - `lib/zotero.js` - Zotero API access
  - `lib/exporter.js` - Export orchestration
  - `lib/format.js` - MODS and Dublin Core generation
  - `lib/ui.js` - Menu integration
  - `lib/utils.js` - Logging and utilities

### Export Process

1. User right-clicks collection
2. File picker dialog shown
3. Temporary BagIt directory created
4. For each item with attachment:
   - Generate MODS metadata
   - Generate Dublin Core metadata
   - Copy attachment file
5. Create ZIP archive
6. Clean up temporary files

### Metadata Standards

- **MODS** (Metadata Object Description Schema): Rich bibliographic metadata
- **Dublin Core**: Simple, interoperable metadata
- **BagIt**: Package format for digital preservation

See [BAGIT.md](BAGIT.md) for detailed format specification.

## License

This project is licensed under the **GNU General Public License v3.0** (GPL-3.0).

See the [LICENSE](LICENSE) file for full license text.

### What This Means

- ✅ You can use this software freely
- ✅ You can modify the software
- ✅ You can distribute the software
- ✅ You can use it commercially
- ⚠️ Changes must be released under GPL-3.0
- ⚠️ Source code must be made available
- ⚠️ Include the license and copyright notice

## Acknowledgments

- **Zotero** team for the excellent research tool
- **Voyant Tools** developers for text analysis capabilities
- **MODS** and **Dublin Core** standards communities
- All contributors to this project

## Links

- **Repository**: https://github.com/corajr/zotero-voyant-export
- **Issues**: https://github.com/corajr/zotero-voyant-export/issues
- **Zotero**: https://www.zotero.org/
- **Voyant Tools**: http://voyant-tools.org/
