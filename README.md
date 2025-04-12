# Fish Shell Function Collection

A curated collection of utility functions for the Fish shell that enhance productivity, improve user experience, and provide convenient workflows for daily command-line use.

## 🌟 Features

### File Management
- **`cattree`**: Recursively display contents of all text files in a directory
- **`compress`/`extract`**: Comprehensive compression/extraction tools supporting multiple formats
- **`copy`/`cut`/`paste`**: Simple clipboard-like file operations for shell use
- **`copycat`**: Display file contents while simultaneously copying to clipboard
- **`trash`**: Safely move files to trash with listing and emptying capabilities

### Shell Experience
- **`clear`**: Enhanced clear command that also clears scrollback buffer
- **`private`**: Quickly enter a fish private mode session
- **`help`**: Display comprehensive keyboard shortcuts for shell navigation

### Terminal Management
- **`getout`**: Copy terminal output to clipboard (supports different terminal types)
- **`bottom_bar`**: Display a stylish information bar at the bottom of the terminal

### System Utilities
- **`apro`**: Search through tldr and man pages with fuzzy finding
- **`ssh`**: Enhanced SSH command with connection management and fuzzy finder

### Shell Enhancements
- **`fzf_tab_complete`**: Robust tab completion with fuzzy finding
- **Command not found handler**: Provides suggestions for mistyped commands

## 💻 Installation

1. Clone this repository to your Fish functions directory:

```bash
git clone https://github.com/yourusername/fish-functions ~/.config/fish/functions
```

2. Reload your Fish configuration:

```bash
source ~/.config/fish/config.fish
```

## 🚀 Usage Examples

### File Operations

```fish
# Display all text files recursively
cattree ~/projects/myproject

# Compress a directory with the best compression
compress ~/projects/myproject tar.zst

# Extract an archive
extract archive.tar.gz

# Copy/cut/paste files
copy important.txt
paste ~/backup/
```

### Shell Navigation

```fish
# Search through available commands with descriptions
apro

# Show comprehensive keyboard shortcuts
help

# SSH with fuzzy finding
ssh
```

## 🔧 Configuration

Many functions can be customized through Fish variables. Set these in your `config.fish` file:

```fish
# Theme configuration
set -g theme_display_git yes
set -g theme_display_virtualenv yes
set -g theme_nerd_fonts yes
set -g theme_powerline_fonts yes

# Command history filter configuration
set -g sponge_delay 5
set -g sponge_purge_only_on_exit false
```

## 📄 Dependencies

- **fzf**: Required for fuzzy finding functionality
- **fd**: Used by some search functions
- **gio**: Used by the trash function
- **Nerd Fonts**: Recommended for optimal visual experience
