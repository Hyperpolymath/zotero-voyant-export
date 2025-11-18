# Justfile for Zotero Voyant Export
# Based on zoterho-template architecture

# Default recipe - list available commands
default:
	@just --list

# Clean build artifacts and generated files
clean:
	rm -rf lib/bs .bsb.lock .merlin
	rm -f manifest.json deno.json rescript.json
	rm -f src/**/*.mjs src/**/*.cmi src/**/*.cmj src/**/*.cmt src/**/*.cmti
	rm -rf web-ext-artifacts dist

# Export CUE configurations to JSON files
config:
	@echo "Exporting configurations from CUE..."
	cue export ./config/project.cue -e manifest --out json > manifest.json
	cue export ./config/deno.cue -e deno --out json > deno.json
	cue export ./config/rescript.cue -e rescript --out json > rescript.json
	@echo "✓ Configuration files generated"

# Validate CUE configuration without exporting
validate:
	@echo "Validating CUE configuration..."
	cue vet ./config/*.cue
	@echo "✓ CUE configuration valid"

# Initialize setup after configuration
setup: config
	@echo "Setting up Deno permissions..."
	deno cache --allow-scripts=npm:rescript,npm:web-ext deno.json
	@echo "✓ Setup complete"

# Build ReScript code to JavaScript
build:
	@echo "Building ReScript..."
	deno task rescript:build
	@echo "✓ Build complete"

# Complete rebuild from scratch
rebuild: clean config build

# Watch mode for development
watch:
	@echo "Starting watch mode..."
	deno task rescript:dev

# Type check without building
check:
	@echo "Type checking..."
	deno run --allow-read --allow-write --allow-env --allow-run npm:rescript build -with-deps
	@echo "✓ Type check complete"

# Development mode - rebuild and watch
dev: rebuild watch

# Lint ReScript code
lint:
	@echo "Linting ReScript..."
	deno run --allow-read --allow-write --allow-env --allow-run npm:rescript format -check src
	@echo "✓ Lint complete"

# Format ReScript code
fmt:
	@echo "Formatting ReScript..."
	deno run --allow-read --allow-write --allow-env --allow-run npm:rescript format -all src
	@echo "✓ Format complete"

# Lint extension package
lint-ext:
	@echo "Linting extension..."
	deno task ext:lint
	@echo "✓ Extension lint complete"

# Run CI verification
ci-verify: validate build lint lint-ext
	@echo "✓ CI verification complete"

# Package extension for distribution
package: rebuild
	@echo "Packaging extension..."
	deno task ext:build
	@echo "✓ Package complete - check web-ext-artifacts/"

# Run extension in Firefox
run: build
	@echo "Running extension in Firefox..."
	deno task ext:run

# Full release build
release: clean config build package
	@echo "✓ Release build complete"

# Display project information
info:
	@echo "=== Zotero Voyant Export ==="
	@echo "Version: $(cue export ./config/project.cue -e project.version --out text)"
	@echo "Author: $(cue export ./config/project.cue -e project.author --out text)"
	@echo "Repository: $(cue export ./config/project.cue -e project.homepage --out text)"

# Update version number
bump-version VERSION:
	@echo "Updating version to {{VERSION}}..."
	sed -i 's/version: *"[^"]*"/version: "{{VERSION}}"/' config/project.cue
	@just config
	@echo "✓ Version updated to {{VERSION}}"

# Install git hooks
install-hooks:
	@echo "Installing git hooks..."
	@echo "Note: Install lefthook separately: https://github.com/evilmartians/lefthook"
	@echo "Then run: lefthook install"
