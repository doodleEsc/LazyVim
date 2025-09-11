# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

LazyVim is a Neovim configuration framework built on top of [lazy.nvim](https://github.com/folke/lazy.nvim). This repository contains the core LazyVim distribution with plugins, utilities, and extras. Users typically use the [LazyVim starter template](https://github.com/LazyVim/starter) rather than this repository directly.

## Development Commands

### Testing
```bash
./scripts/test                    # Run all tests using nvim with minitest
nvim -l tests/minit.lua --minitest  # Run tests directly
```

### Code Quality
```bash
stylua lua/                       # Format Lua code (configured in stylua.toml)
selene lua/                       # Lint Lua code (configured in selene.toml)
```

### Single Test
```bash
nvim -l tests/minit.lua tests/specific_test.lua --minitest
```

## Architecture

### Core Components

- **`lua/lazyvim/init.lua`**: Main entry point with setup() function
- **`lua/lazyvim/config/`**: Core configuration modules
  - `init.lua`: Main configuration and setup logic
  - `autocmds.lua`: Auto-commands
  - `keymaps.lua`: Key mappings
  - `options.lua`: Neovim options
- **`lua/lazyvim/plugins/`**: Core plugin specifications
  - `coding.lua`: Coding-related plugins
  - `colorscheme.lua`: Theme configuration
  - `editor.lua`: Editor enhancement plugins
  - `extras/`: Optional plugin collections organized by category
- **`lua/lazyvim/util/`**: Utility modules providing common functionality

### Plugin System

LazyVim uses a modular plugin system:
- Core plugins are in `lua/lazyvim/plugins/`
- Optional plugins ("extras") are in `lua/lazyvim/plugins/extras/`
- Extras are organized by category (ai/, coding/, editor/, lang/, etc.)
- Each extra is self-contained and can be enabled independently

### Configuration Loading Order

1. Options loaded first (`lazyvim.config.options`)
2. LazyVim core setup
3. Auto-commands and keymaps loaded after VeryLazy event
4. User configurations override LazyVim defaults

### Utility System

The `LazyVim` global table provides access to utilities:
- `LazyVim.format`: Code formatting utilities
- `LazyVim.lsp`: LSP-related utilities
- `LazyVim.pick`: File picker utilities
- `LazyVim.root`: Project root detection
- `LazyVim.terminal`: Terminal utilities

## Development Guidelines

### Plugin Contributions
- Avoid Vim plugins when possible; prefer Lua-native solutions
- All configurations must be overridable by users
- Use proper lazy-loading for performance
- Tag optional dependencies as `optional = true`
- Include comprehensive setup for language extras

### Code Style
- Lua formatting: 2 spaces, 120 column width (stylua.toml)
- Follow existing patterns in similar plugins
- Use LazyVim utilities where available
- Maintain backwards compatibility

### Testing
- Tests are in `tests/` directory using a custom minitest framework
- `tests/minit.lua` sets up the test environment
- Use `./scripts/test` to run the full test suite

### Language Extras Requirements
- Must include Tree-sitter parser setup
- Include widely-used LSP server configuration
- Add formatters/linters only if community standard
- Include `recommended` section for proper setup
- Test with actual projects in that language