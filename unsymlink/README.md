# unsymlink - Remove Symlinks and Accession Entries

Remove symlinks from your Shoebox archive that point to files in a specified source directory, and clean up the corresponding accession entries.

## Purpose

When you want to remove files from your Shoebox archive that were originally imported from a specific source directory, `unsymlink`:

1. **Finds matching symlinks** - Scans photo/, video/, and audio/ directories for symlinks pointing to files in the specified source
2. **Removes symlinks** - Deletes the symlinks from your archive
3. **Updates accessions** - Removes corresponding entries from accessions.json (matched by link field)
4. **Preserves originals** - Leaves original files in the source directory completely untouched

## Installation

### Prerequisites

- Node.js 18 or higher
- A Shoebox archive with symlinked media files

### Setup

```bash
# Clone or download this repository
cd shoebox-utilities/unsymlink

# Make the script executable (Linux/macOS)
chmod +x unsymlink

# Add to your PATH (optional, for convenience)
sudo ln -s "$(pwd)/unsymlink" /usr/local/bin/unsymlink
```

## Usage

### Basic Syntax

```bash
unsymlink --accessions-file <path-to-accessions.json> [options] <source-directory>
```

### Required Arguments

- `--accessions-file <path>` - Path to your archive's accessions.json file
- `<source-directory>` - Directory containing the files you want to unlink

### Options

- `--dry-run` - Preview what would be removed without making changes
- `--help` - Show help message

## Examples

### Preview Changes (Recommended First Step)

```bash
# See what would be removed without making changes
unsymlink --accessions-file ~/archive/accessions.json \
  --dry-run /home/user/Documents/old-imports/2020-photos
```

Output:
```
╔════════════════════════════════════════════════════════════════════╗
║ Unsymlink - Remove symlinks and accession entries                 ║
╚════════════════════════════════════════════════════════════════════╝

ℹ  DRY RUN MODE - No changes will be made

Source directory: /home/user/Documents/old-imports/2020-photos
Accessions file:  /home/user/archive/accessions.json
Resource dir:     /home/user/archive

──────────────────────────────────────────────────────────────────────
Finding symlinks...
──────────────────────────────────────────────────────────────────────

Scanning photo/ directory...
  → ABCD001.jpg → /home/user/Documents/old-imports/2020-photos/IMG_001.jpg
  → ABCD002.jpg → /home/user/Documents/old-imports/2020-photos/IMG_002.jpg

Scanning video/ directory...
  → ABCD003.mp4 → /home/user/Documents/old-imports/2020-photos/VID_001.mp4

Preview: Updating accessions.json...
  × ABCD001.jpg (accession: 2020-01-15-A)
  × ABCD002.jpg (accession: 2020-01-15-B)
  × ABCD003.mp4 (accession: 2020-01-16-A)

╔════════════════════════════════════════════════════════════════════╗
║ Preview Summary                                                    ║
╟────────────────────────────────────────────────────────────────────╢
║ Symlinks found:                                                  3 ║
║    • photo:                                                      2 ║
║    • video:                                                      1 ║
║ Accession entries to remove:                                     3 ║
╚════════════════════════════════════════════════════════════════════╝

ℹ  DRY RUN - No changes were made
  Run without --dry-run to apply these changes
```

### Remove Symlinks and Update Accessions

```bash
# Actually remove the symlinks and update accessions.json
unsymlink --accessions-file ~/archive/accessions.json \
  /home/user/Documents/old-imports/2020-photos
```

The script will:
1. Find and remove matching symlinks
2. Show what was found
3. Ask for confirmation before updating accessions.json
4. Create a timestamped backup of accessions.json
5. Remove entries from accessions.json
6. Display a summary of changes

### Using Relative Paths

```bash
# Relative paths work too
cd ~/Documents/old-imports
unsymlink --accessions-file ~/archive/accessions.json \
  ./2020-photos
```

### Multiple Source Directories

To unlink files from multiple source directories, run the command separately for each:

```bash
# First directory
unsymlink --accessions-file ~/archive/accessions.json \
  /source/path/directory1

# Second directory
unsymlink --accessions-file ~/archive/accessions.json \
  /source/path/directory2
```

## How It Works

### 1. Symlink Discovery

The script scans three media directories in your archive:
- `photo/` - for .jpg, .jpeg, .png, etc.
- `video/` - for .mp4, .mov, .avi, etc.
- `audio/` - for .mp3, .wav, .m4a, etc.

For each file, it checks:
1. Is it a symlink?
2. Does the symlink target point to a file in the specified source directory?

### 2. Symlink Removal

When a matching symlink is found:
- In `--dry-run` mode: listed but not removed
- In normal mode: immediately deleted from the archive

### 3. Accession Updates

The script:
1. Loads your accessions.json file
2. Finds entries where the `link` field matches removed symlinks
3. Creates a timestamped backup of accessions.json
4. Removes matching entries
5. Saves the updated accessions.json

### 4. Safety Features

- **Backup Creation**: Automatic timestamped backup before modifying accessions.json
- **Interactive Confirmation**: Prompts before updating accessions (unless --dry-run)
- **Original Files Protected**: Source directory files are never touched
- **Dry-Run Mode**: Preview all changes before applying

## Common Use Cases

### Removing Test Imports

After testing your import workflow with sample files:

```bash
unsymlink --accessions-file ~/archive/accessions.json \
  --dry-run ~/test-imports/samples

# If preview looks good:
unsymlink --accessions-file ~/archive/accessions.json \
  ~/test-imports/samples
```

### Cleaning Up Duplicate Imports

If you accidentally imported the same source directory twice:

```bash
# Check what would be removed
unsymlink --accessions-file ~/archive/accessions.json \
  --dry-run /media/external-drive/duplicate-photos

# Remove if confirmed
unsymlink --accessions-file ~/archive/accessions.json \
  /media/external-drive/duplicate-photos
```

### Removing Files from Moved Sources

If a source directory has been moved or renamed:

```bash
# Remove symlinks pointing to the old location
unsymlink --accessions-file ~/archive/accessions.json \
  /old/path/to/photos

# Then re-import from the new location using resymlink
resymlink --archive-dir ~/archive /old/path/to/photos /new/path/to/photos
```

## Understanding the Output

### Color-Coded Messages

- **Cyan (→)** - Symlinks found
- **Green (✓)** - Successful operations
- **Yellow (×)** - Accession entries to be removed
- **Red** - Errors
- **Gray** - Informational messages

### Statistics Breakdown

The summary shows:
- **Symlinks found/removed** - Total count and breakdown by media type
- **Accession entries removed** - Number of entries removed from accessions.json

### Backup Files

Backups are named: `accessions.json.backup.YYYY-MM-DDTHH-MM-SS-mmmZ`

Example: `accessions.json.backup.2024-03-21T15-30-45-123Z`

## Troubleshooting

### "Source directory does not exist"

**Problem**: The specified source directory path is incorrect or the directory has been moved/deleted.

**Solution**:
```bash
# Verify the directory exists
ls -la /path/to/source/directory

# Use tab completion to ensure correct path
unsymlink --accessions-file ~/archive/accessions.json \
  /path/to/<TAB>
```

### "accessions.json not found"

**Problem**: The path to accessions.json is incorrect.

**Solution**:
```bash
# Find your accessions.json file
find ~ -name "accessions.json" -type f

# Use the correct path
unsymlink --accessions-file /correct/path/to/accessions.json \
  /source/directory
```

### No Symlinks Found

**Problem**: The script reports no symlinks found, but you expected some.

**Possible Causes**:
1. Source directory path doesn't exactly match symlink targets
2. Files have already been removed
3. Files weren't imported as symlinks (they were copied instead)

**Diagnosis**:
```bash
# Check a specific symlink target
ls -la ~/archive/photo/ABCD001.jpg
readlink ~/archive/photo/ABCD001.jpg

# Compare with source directory path
echo /path/to/source/directory
```

### Symlinks Removed But Accessions Not Updated

**Problem**: You cancelled the confirmation prompt after symlinks were removed.

**Solution**:
The script has already removed the symlinks. You can:

1. Run the script again - it won't find symlinks, but you can manually edit accessions.json
2. Restore from backup if you have one
3. Manually remove the entries from accessions.json

To prevent this, always use `--dry-run` first!

### Permission Denied Errors

**Problem**: Can't read accessions.json or remove symlinks.

**Solution**:
```bash
# Check permissions
ls -la ~/archive/accessions.json
ls -la ~/archive/photo/

# Fix if needed (adjust ownership as appropriate)
chmod 644 ~/archive/accessions.json
chmod 755 ~/archive/photo/
```

## Safety and Best Practices

### Always Use Dry-Run First

```bash
# ALWAYS preview first
unsymlink --accessions-file ~/archive/accessions.json \
  --dry-run /source/directory

# Then run for real
unsymlink --accessions-file ~/archive/accessions.json \
  /source/directory
```

### Backup Your Archive

Before running unsymlink on large batches:

```bash
# Back up your entire archive
tar czf archive-backup-$(date +%Y%m%d).tar.gz ~/archive/

# Or at minimum, back up accessions.json
cp ~/archive/accessions.json ~/archive/accessions.json.manual-backup
```

### Verify Removals

After running unsymlink:

```bash
# Check symlink is gone
ls ~/archive/photo/ABCD001.jpg  # Should show "No such file"

# Verify accession removed
grep "ABCD001" ~/archive/accessions.json  # Should return nothing
```

### Restore from Backup if Needed

If something goes wrong:

```bash
# List available backups
ls -lt ~/archive/accessions.json.backup.*

# Restore the most recent backup
cp ~/archive/accessions.json.backup.YYYY-MM-DDTHH-MM-SS-mmmZ \
   ~/archive/accessions.json
```

## Integration with Other Shoebox Utilities

### With resymlink

If you're moving source directories, use both tools:

```bash
# Method 1: Use resymlink (simpler, updates symlinks in place)
resymlink --archive-dir ~/archive \
  /old/source/path /new/source/path

# Method 2: Remove and re-import (more thorough)
# 1. Remove old symlinks
unsymlink --accessions-file ~/archive/accessions.json \
  /old/source/path

# 2. Re-import from new location
# (use your import script with --accessions-file option)
```

### With finddups

Clean up duplicates before removing:

```bash
# 1. Find and remove any duplicates in the source directory
finddups --search-path /source/directory

# 2. Then unlink from archive
unsymlink --accessions-file ~/archive/accessions.json \
  /source/directory
```

## Technical Details

### Node.js Version

Requires Node.js 18 or higher for:
- ES modules (`import`/`export`)
- Modern filesystem APIs

### Symlink Detection

Uses `fs.lstatSync()` to detect symlinks without following them, and `fs.readlinkSync()` to read symlink targets.

### Path Comparison

Handles both absolute and relative symlink paths by resolving relative paths before comparison:

```javascript
const absoluteTarget = path.isAbsolute(target) 
  ? target 
  : path.resolve(path.dirname(filePath), target);
```

### Accessions Matching

Matches removed symlinks to accession entries by the `link` field:

```json
{
  "accession": "2023-04-15-A",
  "link": "ABCD001.jpg",
  "..."
}
```

### Backup Naming

Timestamps use ISO 8601 format with special characters replaced for filesystem compatibility:

```
accessions.json.backup.2024-03-21T15-30-45-123Z
```

## Platform Support

- **Linux**: ✓ Fully supported
- **macOS**: ✓ Fully supported
- **Windows**: ⚠ Requires Windows Subsystem for Linux (WSL) or Git Bash

### Cross-Platform Notes

- Written in Node.js, works on all platforms with Node installed
- Symlink support required (native on Linux/macOS, available via WSL on Windows)
- Path separators handled automatically by Node.js `path` module

## Exit Codes

- `0` - Success (or no changes needed)
- `1` - Error (invalid arguments, file not found, permission denied, etc.)

## See Also

- [resymlink](../resymlink/README.md) - Rename source directories and update symlinks
- [finddups](../finddups/README.md) - Find and remove duplicate files
- [mkcol](../mkcol/README.md) - Create collection files from media
- [Shoebox Documentation](https://github.com/Marvbudd/shoebox) - Main Shoebox application

## License

Same as Shoebox Utilities repository.

## Contributing

Found a bug or have a suggestion? Please open an issue in the Shoebox Utilities repository.
