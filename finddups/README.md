# FindDups - Intelligent Duplicate File Finder

Find and manage duplicate files by comparing filenames, sizes, and content hashes. Perfect for cleaning up media collections before importing to Shoebox.

## Overview

FindDups helps you:
- **Identify duplicates**: Find all copies of files in your current directory
- **Verify identity**: Compare file size and SHA-256 hash to confirm duplicates
- **Safe deletion**: Interactively delete duplicates only when identical copies exist elsewhere
- **Preview first**: Dry-run mode to see what would be deleted
- **Targeted search**: Specify search paths to find duplicates in specific locations

## Platform Support

- ✅ **Linux** - Bash script
- ✅ **macOS** - Bash script (uses macOS-specific commands)
- 🚧 **Windows** - Coming soon (use WSL or Git Bash in the meantime)

## Installation

1. Clone or download this repository
2. Navigate to the platform-specific directory:
   ```bash
   cd finddups/linux  # or macos
   ```
3. Make the script executable:
   ```bash
   chmod +x finddups
   ```

## Usage

### Basic Syntax

```bash
./finddups [OPTIONS]
```

### Options

- `--dry-run` - Preview duplicates without prompting to delete
- `--search-path DIR` - Search in DIR instead of home directory (default: ~/)
- `--quiet` - Suppress detailed output, only show duplicates
- `--help` - Show help message

### Examples

**Find duplicates in home directory:**
```bash
cd /path/to/files/to/check
/path/to/finddups/linux/finddups
```

**Preview duplicates without deleting:**
```bash
./finddups --dry-run
```

**Search in specific backup location:**
```bash
./finddups --search-path /media/backup
```

**Quick scan (quiet mode):**
```bash
./finddups --quiet --dry-run
```

**Check if files exist in external drive:**
```bash
cd ~/Downloads/new-photos
/path/to/finddups/linux/finddups --search-path /media/external-drive
```

## How It Works

For each file in your current directory:

1. **Search**: Finds all files with the same name in search path
2. **Compare Size**: Checks if file sizes match
3. **Hash Verification**: Computes SHA-256 hash to verify identical content
4. **Report**: Shows detailed comparison results
5. **Prompt**: Asks if you want to delete the local copy (if identical copies exist)

### Duplicate Detection Logic

Files are considered duplicates only when:
- ✓ Same filename
- ✓ Same file size
- ✓ Same SHA-256 hash (identical content)

If filenames match but content differs, they are reported as **different files** (not duplicates).

## Features

### Safety Features

- **Dry-run mode**: Preview all duplicates before deleting
- **Hash verification**: Content must be identical, not just same size
- **Interactive prompts**: Confirm each deletion individually
- **Clear warnings**: Distinguishes between identical and different files
- **Statistics summary**: See totals before and after

### User Experience

- **Color-coded output**: 
  - Green for identical duplicates
  - Yellow for warnings
  - Red for different content
  - Blue for informational
- **Detailed comparison**: See size, hash, and location for every match
- **Progress indication**: Clear visual separation between files
- **Summary statistics**: Total files, unique files, duplicates found, files deleted

### Smart Detection

- **Multiple locations**: Shows all locations where file exists
- **Mixed duplicates**: Handles cases where some copies are identical, others aren't
- **Size pre-check**: Skips hash computation if sizes differ (faster)
- **Truncated hashes**: Displays first 16 chars for readability

## Common Use Cases

### Before Importing to Shoebox

Clean up duplicate photos before creating archive:
```bash
cd ~/Pictures/2020-family-photos
/path/to/finddups/linux/finddups --search-path ~/Pictures/archive
# Safely delete duplicates already in archive
```

### Cleaning Downloads Folder

Find photos already backed up:
```bash
cd ~/Downloads
/path/to/finddups/linux/finddups --search-path /media/backup
```

### After Copying Files

Verify copies and remove originals:
```bash
cd ~/temporary-import
/path/to/finddups/linux/finddups --search-path ~/final-archive --dry-run
# Review, then run without --dry-run to delete
```

### External Drive Verification

Check if files exist on backup drive:
```bash
cd ~/important-files
/path/to/finddups/linux/finddups --search-path /media/usb-backup --dry-run
```

## Workflow

Recommended workflow for safety:

1. **Navigate to directory with files to check:**
   ```bash
   cd /path/to/files
   ```

2. **Preview with dry-run:**
   ```bash
   /path/to/finddups/linux/finddups --search-path ~/backup --dry-run
   ```

3. **Review the output** - verify duplicates are truly identical

4. **Run interactively:**
   ```bash
   /path/to/finddups/linux/finddups --search-path ~/backup
   ```

5. **Selectively delete** - press 'D' for duplicates you want to remove, Return to skip

6. **Review summary** - check statistics at the end

## Output Example

```
════════════════════════════════════════
⚑ File: family-reunion-2020.jpg
  Current location: /home/user/downloads/family-reunion-2020.jpg
  Size: 2458432 bytes
  Hash: a3f5c8d9e1b2a...

Found in other locations:
  ────────────────────────────────────────
  Location: /home/user/Pictures/archive/photo/family-reunion-2020.jpg
    Size: 2458432 bytes
    Hash: a3f5c8d9e1b2a...
    Status: ✓ IDENTICAL (same size and content)

────────────────────────────────────────
✓ Found 1 copy/copies - at least one IDENTICAL

Delete current file 'family-reunion-2020.jpg'? [D=delete, Return=skip]: 
```

## Tips & Tricks

### Always Dry-Run First

Make it a habit to preview:
```bash
# Step 1: Preview
./finddups --dry-run

# Step 2: If safe, run for real
./finddups
```

### Limit Search Scope

Faster searches with specific paths:
```bash
# Instead of searching entire home directory
./finddups --search-path ~/Pictures/archive
```

### Quiet Mode for Quick Overview

Get just the duplicate count:
```bash
./finddups --quiet --dry-run --search-path ~/backup
```

### Combine with Other Tools

Use with changeprefix for workflow:
```bash
# 1. Standardize filenames
/path/to/changeprefix/linux/changeprefix DSC_ CANON_

# 2. Find duplicates with new names
/path/to/finddups/linux/finddups --search-path ~/archive
```

## Troubleshooting

**"Permission denied" errors during search**
- Normal when searching home directory (e.g., .cache, system folders)
- These are suppressed (2>/dev/null) and don't affect results

**"Search path does not exist"**
- Check that --search-path points to valid directory
- Use absolute paths: `/media/backup` not `~/backup` in some cases

**Script doesn't find duplicates you know exist**
- Verify the files have identical names (case-sensitive)
- Check that search path includes the location
- Files must be regular files (not symlinks)

**Slow on large search paths**
- Limit search with --search-path
- Use --quiet to reduce output processing
- Hash calculation on large files takes time (this is normal)

**Different results on macOS vs Linux**
- Both versions use platform-specific stat/hash commands
- Results should be identical, just command syntax differs

## Integration with Shoebox

Perfect complement to Shoebox workflows:

1. **Pre-import cleanup**: Remove duplicates before creating symlinks
2. **Archive verification**: Check if files already exist in archive
3. **Post-scan cleanup**: Find duplicates created during media organization
4. **Backup validation**: Verify files exist on backup drives before deleting

Use with [changeprefix](../changeprefix/README.md) for complete file organization.

## Technical Details

### Hash Algorithm

Uses SHA-256 for content comparison:
- **Linux**: `sha256sum`
- **macOS**: `shasum -a 256`

### File Metadata

Retrieves file size using:
- **Linux**: `stat -c%s`
- **macOS**: `stat -f%z`

### Search Method

Uses `find` command with:
- Name-based matching
- Recursive directory traversal
- Error suppression for permission issues

## Performance

Expected performance:
- Small directories (<100 files): Instant
- Medium directories (100-1000 files): Seconds to minutes
- Large search paths (entire home): Several minutes
- Hash computation: ~50-100 MB/s depending on disk

Optimization tips:
- Use --search-path to limit scope
- Use --quiet for less output processing
- Run on SSD for faster hashing

## Contributing

Contributions welcome! Areas for improvement:

- Windows PowerShell version
- Multi-threaded hash computation
- Progress bar for large directories
- MD5/SHA1 hash options
- JSON output format
- Automatic duplicate removal mode
- Hardlink detection

## Safety Considerations

This script can **permanently delete files**. Always:

1. ✓ Use --dry-run first
2. ✓ Verify backup copies exist
3. ✓ Review hash matches carefully
4. ✓ Keep backups before bulk deletions
5. ✓ Test on small directories first

The script will only delete files in the current directory - it never deletes files in the search path.

## License

MIT License - See [LICENSE](../LICENSE) file for details.

## Support

For issues or questions:
- [Open an issue](https://github.com/Marvbudd/shoebox-utilities/issues)
- Check existing issues for solutions
- Contribute improvements via pull request
