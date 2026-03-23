# Shoebox Utilities

Community utilities and helper scripts for working with [Shoebox](https://github.com/Marvbudd/shoebox) multimedia archives.

## Overview

This repository contains platform-specific utilities, scripts, and tools to help manage, organize, and work with Shoebox archives. These are community-contributed utilities that complement the main Shoebox application.

## Available Utilities

### 📁 mklinks - Media File Symlink Creator

Create symbolic links for media files from a source directory tree to a destination directory organized by media type.

- **Platforms**: Linux, macOS, Windows
- **Purpose**: Flatten deep directory structures into organized photo/video/audio folders
- **Use Case**: Prepare media for import into Shoebox archives

[View Documentation →](mklinks/mklinks.README.md)

**Quick Start:**
```bash
# Linux/macOS
mklinks mklinks.conf

# Windows (Command Prompt or PowerShell)
mklinks.bat mklinks.conf
```

### 🔤 changeprefix - Media File Prefix Renamer

Batch rename media files by changing or adding filename prefixes for organizing photos from multiple cameras or standardizing file naming conventions.

- **Platforms**: Linux, macOS, Windows (planned)
- **Purpose**: Replace or add filename prefixes to media files
- **Use Case**: Standardize naming conventions before importing to Shoebox

[View Documentation →](changeprefix/README.md)

**Quick Start (Linux/macOS)**:
```bash
cd /path/to/your/media
/path/to/changeprefix/linux/changeprefix OLD_PREFIX NEW_PREFIX --dry-run
```

### 🔍 finddups - Intelligent Duplicate File Finder

Find and manage duplicate files by comparing filenames, sizes, and content hashes. Perfect for cleaning up media collections before importing to Shoebox.

- **Platforms**: Linux, macOS, Windows (planned)
- **Purpose**: Find and optionally delete duplicate files
- **Use Case**: Clean up duplicates before importing or after organizing media

[View Documentation →](finddups/README.md)

**Quick Start (Linux/macOS)**:
```bash
cd /path/to/files/to/check
/path/to/finddups/linux/finddups --search-path ~/backup --dry-run
```

### 🔗 resymlink - Directory Rename & Symlink Updater

Rename a source directory and automatically update all symlinks in your Shoebox archive that point to files in that directory. Essential for maintaining archive integrity when reorganizing source media.

- **Platforms**: Linux, macOS, Windows (planned)
- **Purpose**: Rename directories and update symlinks in Shoebox archives
- **Use Case**: Fix broken symlinks when source directories are moved or renamed

[View Documentation →](resymlink/README.md)

**Quick Start (Linux/macOS)**:
```bash
/path/to/resymlink/linux/resymlink --archive-dir ~/shoebox-archive \
  /old/source/path /new/source/path
```

### 📋 mkcol - Collection Creator

Create Shoebox collection files from media files in your current directory. Quickly organize themed sets of photos, videos, or audio recordings.

- **Platform**: Cross-platform (Node.js)
- **Purpose**: Generate collection JSON files from current directory contents
- **Use Case**: Create themed collections after importing media or for organizing by event/topic

[View Documentation →](mkcol/README.md)

**Quick Start:**
```bash
cd ~/Photos/event-photos
node /path/to/mkcol/mkcol --accessions-file ~/archive/accessions.json \
  mykey "Collection Name" "Full Collection Title"
```

### 🗑️ unsymlink - Symlink Remover

Remove symlinks from your archive and clean up accession entries for files from a specific source directory. Perfect for removing test imports or unwanted batches.

- **Platform**: Cross-platform (Node.js)
- **Purpose**: Remove symlinks and their accession entries
- **Use Case**: Clean up test imports, remove duplicate imports, or delete files from specific sources

[View Documentation →](unsymlink/README.md)

**Quick Start:**
```bash
# Preview what would be removed
node /path/to/unsymlink/unsymlink --accessions-file ~/archive/accessions.json \
  --dry-run /source/directory/to/remove

# Actually remove
node /path/to/unsymlink/unsymlink --accessions-file ~/archive/accessions.json \
  /source/directory/to/remove
```

## One-Time Fix Utilities

### 🔧 convert-numeric-months - Month Format Converter

Fix a specific data format issue in older Shoebox archives. Converts numeric months (01, 1, 12) to required three-character abbreviations (Jan, Dec) in accessions.json files.

- **Platform**: Cross-platform (Node.js)
- **Purpose**: One-time fix for archives with numeric month bug
- **Use Case**: Fix data from older Shoebox versions that stored months incorrectly

[View Documentation →](convert-numeric-months/README.md)

**Usage**:
```bash
node convert-numeric-months/convert-numeric-months ~/archive/accessions.json
```

::: tip When to Use
Only needed if you have numeric months in your accessions.json. If months are already "Jan", "Feb", "Mar", etc., you don't need this utility.
:::

## Installation

### Quick Install (Recommended)

The easiest way to use these utilities is to install them to your system PATH using the provided install scripts.

#### Linux / macOS

```bash
# Clone the repository
git clone https://github.com/Marvbudd/shoebox-utilities.git
cd shoebox-utilities

# Run the installer
./install.sh
```

The installer will:
- Create symlinks in `~/.local/bin` for all utilities compatible with your OS
- Handle both bash scripts and Node.js utilities
- Check if `~/.local/bin` is in your PATH and provide instructions if needed

**Uninstall:**
```bash
./install.sh --uninstall
```

#### Windows

```batch
REM Clone the repository
git clone https://github.com/Marvbudd/shoebox-utilities.git
cd shoebox-utilities

REM Run the installer (right-click and "Run as Administrator" if Developer Mode is not enabled)
install.bat
```

The installer will:
- Create symlinks or copies in `%USERPROFILE%\bin` for all Windows-compatible utilities
- Automatically add the directory to your PATH
- Fall back to file copies if symlinks aren't available (non-admin mode)

**Uninstall:**
```batch
install.bat uninstall
```

**Note:** For best results on Windows, enable Developer Mode (Settings → System → For Developers → Developer Mode) or run as Administrator to allow symlink creation.

### Manual Installation (Advanced)

If you prefer not to use the install scripts, you can access utilities directly:

Each utility has platform-specific versions in its subdirectories:
- `linux/` - Linux scripts (bash)
- `macos/` - macOS scripts (bash/zsh)
- `windows/` - Windows scripts (PowerShell/batch)

**Example:**
```bash
# Run mklinks directly without installing
cd shoebox-utilities
./mklinks/linux/mklinks ~/myconfig.conf
```

### Verify Installation

After installing, verify the utilities are accessible:

```bash
# Linux / macOS
mklinks --help
mkcol --help

# Windows (Command Prompt or PowerShell)
mklinks.bat --help
mkcol.bat --help
```

## Usage Pattern

Most utilities follow this pattern:

1. Navigate to the utility directory
2. Copy the example config file: `cp platform/utility.conf.example utility.conf`
3. Edit the config file with your settings
4. Run the utility: `./platform/utility utility.conf`

### Utility Structure Guidelines

```
utility-name/
├── README.md                   # Utility-specific documentation
├── linux/
│   ├── utility-name           # Executable script
│   └── utility.conf.example   # Example config
├── macos/
│   ├── utility-name
│   └── utility.conf.example
└── windows/
    ├── utility-name.ps1
    └── utility.conf.example
```

## Support

For issues with:
- **Shoebox application**: [Open issue on main repo](https://github.com/Marvbudd/shoebox/issues)
- **These utilities**: [Open issue here](https://github.com/Marvbudd/shoebox-utilities/issues)

## License

MIT License - See [LICENSE](LICENSE) file for details.

Each utility may have its own license - check the utility's directory for details.

## Related Projects

- [Shoebox](https://github.com/Marvbudd/shoebox) - Main multimedia archival application
