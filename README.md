# Shoebox Utilities

Community utilities and helper scripts for working with [Shoebox](https://github.com/Marvbudd/shoebox) multimedia archives.

## Overview

This repository contains platform-specific utilities, scripts, and tools to help manage, organize, and work with Shoebox archives. These are community-contributed utilities that complement the main Shoebox application.

## Available Utilities

### 📁 mklinks - Media File Symlink Creator

Create symbolic links for media files from a source directory tree to a destination directory organized by media type.

- **Platforms**: Linux, macOS, Windows (planned)
- **Purpose**: Flatten deep directory structures into organized photo/video/audio folders
- **Use Case**: Prepare media for import into Shoebox archives

[View Documentation →](mklinks/mklinks.README.md)

**Quick Start (Linux/macOS)**:
```bash
cd /path/to/your/media
./mklinks mklinks.conf
```

## Installation

Clone this repository to access the utilities:

```bash
git clone https://github.com/Marvbudd/shoebox-utilities.git
cd shoebox-utilities
```

Each utility has platform-specific versions in its subdirectories:
- `linux/` - Linux scripts (bash)
- `macos/` - macOS scripts (bash/zsh)
- `windows/` - Windows scripts (PowerShell)

## Usage Pattern

Most utilities follow this pattern:

1. Navigate to the utility directory
2. Copy the example config file: `cp platform/utility.conf.example utility.conf`
3. Edit the config file with your settings
4. Run the utility: `./platform/utility utility.conf`

## Contributing

We welcome contributions! To add a new utility or improve existing ones:

1. Fork this repository
2. Create a feature branch
3. Add your utility with:
   - Platform-specific implementations
   - Example configuration files
   - Clear documentation
   - OS compatibility notes
4. Submit a pull request

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

## Planned Utilities

- **backup-archive** - Automated archive backup with versioning
- **media-prep** - Batch resize/convert media for optimal archive storage
- **archive-merge** - Merge multiple archives intelligently
- **duplicate-finder** - Find and manage duplicate media across archives

Have an idea? Open an issue or submit a pull request!

## Support

For issues with:
- **Shoebox application**: [Open issue on main repo](https://github.com/Marvbudd/shoebox/issues)
- **These utilities**: [Open issue here](https://github.com/Marvbudd/shoebox-utilities/issues)

## License

MIT License - See [LICENSE](LICENSE) file for details.

Each utility may have its own license - check the utility's directory for details.

## Related Projects

- [Shoebox](https://github.com/Marvbudd/shoebox) - Main multimedia archival application
