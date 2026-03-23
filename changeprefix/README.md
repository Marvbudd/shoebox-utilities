# ChangePrefix - Media File Prefix Renamer

Batch rename media files by changing or adding filename prefixes. Perfect for organizing photos from multiple cameras or standardizing file naming conventions.

## Overview

ChangePrefix allows you to:
- Replace one filename prefix with another (e.g., `DSC_1234.jpg` → `BUDW1234.jpg`)
- Add a prefix to files that don't have one (e.g., `1234.jpg` → `BUDW1234.jpg`)
- Preview changes with dry-run mode before committing
- Process multiple file types: `.jpg`, `.mp4`, `.mp3`, `.mov` (case-insensitive)

## Platform Support

- ✅ **Linux** - Bash script
- ✅ **macOS** - Bash script  
- 🚧 **Windows** - Coming soon (use WSL or Git Bash in the meantime)

## Installation

1. Clone or download this repository
2. Navigate to the platform-specific directory:
   ```bash
   cd changeprefix/linux  # or macos
   ```
3. Make the script executable:
   ```bash
   chmod +x changeprefix
   ```

## Usage

### Basic Syntax

```bash
./changeprefix OLD_PREFIX NEW_PREFIX [--dry-run]
```

### Examples

**Replace existing prefix:**
```bash
./changeprefix DSC_ BUDW
# DSC_1234.jpg → BUDW1234.jpg
# DSC_5678.JPG → BUDW5678.JPG
```

**Add prefix to all files:**
```bash
./changeprefix "" BUDW
# 1234.jpg → BUDW1234.jpg
# video.mp4 → BUDWvideo.mp4
```

**Preview changes (dry-run):**
```bash
./changeprefix DSC_ PHOTO --dry-run
# Shows what would be renamed without making changes
```

**Replace and preview:**
```bash
./changeprefix IMG_ FAMILY_ --dry-run
# IMG_001.jpg → Would rename to FAMILY_001.jpg
# IMG_002.JPG → Would rename to FAMILY_002.JPG
```

## Features

### Safety Features

- **Dry-run mode**: Preview all changes before committing
- **Collision detection**: Skips files if target name already exists
- **No config needed**: Simple command-line arguments only
- **Case-insensitive**: Handles .JPG, .jpg, .Mp4, etc.

### User Experience

- **Color-coded output**: Green for success, yellow for warnings, red for errors
- **Progress feedback**: See each file as it's renamed
- **Summary statistics**: Count of renamed files at completion
- **Clear error messages**: Helpful guidance when things go wrong

### Supported File Types

- Photos: `.jpg`, `.jpeg` (any case)
- Videos: `.mp4`, `.mov` (any case)
- Audio: `.mp3` (any case)

## Common Use Cases

### Camera File Organization

Different cameras use different prefixes:
```bash
# Canon: DSC_ → CANON_
./changeprefix DSC_ CANON_

# Nikon: DSC_ → NIKON_
./changeprefix DSC_ NIKON_

# iPhone: IMG_ → IPHONE_
./changeprefix IMG_ IPHONE_
```

### Family Archive Organization

Standardize files by source:
```bash
# Mom's photos
cd /archive/photo/moms-collection
./changeprefix "" MOM_

# Dad's videos  
cd /archive/video/dads-videos
./changeprefix "" DAD_
```

### Before Import to Shoebox

Ensure unique filenames before creating symbolic links:
```bash
# Preview first
./changeprefix "" FAMILY2020_ --dry-run

# Apply changes
./changeprefix "" FAMILY2020_
```

## Workflow

Recommended workflow for safety:

1. **Navigate to target directory:**
   ```bash
   cd /path/to/your/media/files
   ```

2. **Preview changes:**
   ```bash
   /path/to/changeprefix/linux/changeprefix DSC_ BUDW --dry-run
   ```

3. **Review the output** - make sure it's what you want

4. **Apply changes:**
   ```bash
   /path/to/changeprefix/linux/changeprefix DSC_ BUDW
   ```

5. **Verify results:**
   ```bash
   ls -la
   ```

## Tips & Tricks

### Empty String for Old Prefix

Use `""` to add a prefix to all files:
```bash
./changeprefix "" NEWPREFIX_
```

### Batch Processing Multiple Directories

Create a simple loop:
```bash
for dir in collection1 collection2 collection3; do
    cd "$dir"
    /path/to/changeprefix/linux/changeprefix OLD_ NEW_
    cd ..
done
```

### Always Dry-Run First

Make it a habit:
```bash
# Step 1: Always dry-run
./changeprefix OLD NEW --dry-run

# Step 2: If output looks good, run for real
./changeprefix OLD NEW
```

## Troubleshooting

**"No files found"**
- Check that you're in the correct directory
- Verify files have the expected extensions (.jpg, .mp4, etc.)
- Check file permissions with `ls -la`

**"Target exists" warnings**
- Files with the new name already exist
- Review conflicting files manually
- Consider using a different prefix

**Permission denied**
- Make script executable: `chmod +x changeprefix`
- Check write permissions in target directory

**Script doesn't run on macOS**
- Make sure you're using bash or zsh
- Try: `bash changeprefix OLD NEW`

## Integration with Shoebox

This utility complements Shoebox workflows:

1. **Pre-import standardization**: Ensure unique filenames before creating symlinks
2. **Collection organization**: Add source identifiers to files from different origins
3. **Archive preparation**: Standardize naming conventions across multiple sources

See also: [mklinks utility](../mklinks/mklinks.README.md) for creating symbolic links.

## Contributing

Contributions welcome! Areas for improvement:

- Windows PowerShell version
- Recursive directory processing
- Regular expression pattern matching
- Configuration file support
- Undo functionality

## License

MIT License - See [LICENSE](../LICENSE) file for details.

## Support

For issues or questions:
- [Open an issue](https://github.com/Marvbudd/shoebox-utilities/issues)
- Check existing issues for solutions
- Contribute improvements via pull request
