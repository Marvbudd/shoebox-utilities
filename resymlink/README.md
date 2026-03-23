# Resymlink - Directory Rename & Symlink Updater

Rename a source directory and automatically update all symlinks in your Shoebox archive that point to files in that directory. Essential for maintaining archive integrity when reorganizing source media.

## Overview

When you use symbolic links in your Shoebox archive (via [mklinks](../mklinks/mklinks.README.md)), the symlinks contain paths to your original media files. If you rename or move those source directories, the symlinks break. This utility solves that problem by:

1. **Renaming the directory** to the new location
2. **Finding all symlinks** in your archive that point to the old directory
3. **Updating each symlink** to point to the new directory location
4. **Preserving archive integrity** - your Shoebox archive continues to work seamlessly

## Platform Support

- ✅ **Linux** - Bash script
- ✅ **macOS** - Bash script
- 🚧 **Windows** - Coming soon (use WSL or Git Bash in the meantime)

## Installation

1. Clone or download this repository
2. Navigate to the platform-specific directory:
   ```bash
   cd resymlink/linux  # or macos
   ```
3. Make the script executable:
   ```bash
   chmod +x resymlink
   ```

## Usage

### Basic Syntax

```bash
./resymlink --archive-dir <archive-path> <old-directory> <new-directory>
```

### Required Options

- `--archive-dir DIR` - Path to your Shoebox archive (directory containing photo/, video/, audio/ subdirectories)

### Optional Options

- `--dry-run` - Preview changes without renaming or updating symlinks
- `--help` - Show help message

### Examples

**Rename a photo source directory:**
```bash
resymlink --archive-dir ~/my-shoebox-archive \
  ~/Photos/Trip2017 \
  ~/Photos/Europe-Vacation-2017
```

**Preview changes first (dry-run):**
```bash
resymlink --archive-dir ~/my-shoebox-archive --dry-run \
  /media/usb/OldPhotos \
  /media/usb/FamilyPhotos
```

**Fix after external drive rename:**
```bash
resymlink --archive-dir ~/Documents/shoebox \
  /media/backup-old/photos \
  /media/backup-new/photos
```

**Reorganize mounted volume:**
```bash
# macOS example
resymlink --archive-dir ~/shoebox-archive \
  /Volumes/Photos/Collection1 \
  /Volumes/Photos/Family/Collection1
```

## How It Works

### Step-by-Step Process

1. **Validation**:
   - Checks old directory exists
   - Verifies new directory doesn't already exist
   - Confirms archive directory has photo/video/audio subdirectories

2. **Interactive Confirmation** (unless --dry-run):
   - Shows old and new directory paths
   - Asks for confirmation before proceeding

3. **Directory Rename**:
   - Uses `mv` to rename the directory
   - Or in dry-run: shows what would be renamed

4. **Symlink Scanning**:
   - Searches photo/, video/, and audio/ directories
   - Finds all symlinks pointing to old directory

5. **Symlink Updates**:
   - For each matching symlink:
     - Extracts the relative path within old directory
     - Constructs new target path
     - Verifies new target exists
     - Updates symlink with `ln -sf`

6. **Summary Report**:
   - Shows count of updated symlinks by type
   - Displays total symlinks updated

### What Gets Updated

Only symlinks with **absolute paths** pointing to the old directory are updated. For example:

**Before:**
```
photo/BUDW001.jpg -> /home/user/Photos/Trip2017/IMG_001.jpg
```

**After renaming /home/user/Photos/Trip2017 to /home/user/Photos/Vacation2017:**
```
photo/BUDW001.jpg -> /home/user/Photos/Vacation2017/IMG_001.jpg
```

## Features

### Safety Features

- **Dry-run mode**: Preview all changes before applying them
- **Interactive confirmation**: Must explicitly confirm rename operation
- **Target validation**: Verifies new file location exists before updating symlink
- **Error handling**: Skips invalid symlinks with clear warnings
- **No data loss**: Only updates symlinks, never deletes media files

### User Experience

- **Color-coded output**:
  - Green for successful updates
  - Yellow for warnings and dry-run
  - Red for errors
  - Cyan for informational
- **Detailed progress**: Shows each symlink as it's updated
- **Clear statistics**: Summary by media type (photo/video/audio)
- **Visual separation**: Box-drawing characters for sections

### Smart Validation

- **Path resolution**: Converts relative to absolute paths automatically
- **Trailing slash handling**: Normalizes directory paths
- **Parent directory check**: Ensures destination parent exists
- **Archive structure validation**: Warns if photo/video/audio missing
- **Collision detection**: Prevents overwriting existing directories

## Common Use Cases

### After Renaming External Drive

Your external drive got renamed:
```bash
resymlink --archive-dir ~/shoebox \
  /media/Backup \
  /media/MyBackup
```

### Reorganizing Source Files

Moving photos to better-organized folders:
```bash
resymlink --archive-dir ~/archive \
  ~/Pictures/Misc \
  ~/Pictures/Family/2020-Events
```

### After Restoring from Backup

Backup restored to different location:
```bash
resymlink --archive-dir ~/shoebox-archive \
  /old-backup/photos \
  /new-backup/photos
```

### Fixing Broken Symlinks

Someone renamed a directory outside your archive:
```bash
# Preview what's broken
resymlink --archive-dir ~/archive --dry-run \
  /old/path \
  /current/path

# Fix it
resymlink --archive-dir ~/archive \
  /old/path \
  /current/path
```

## Workflow

Recommended workflow for safety:

1. **Run dry-run first:**
   ```bash
   resymlink --archive-dir ~/archive --dry-run \
     /old/path /new/path
   ```

2. **Review the output**:
   - Check which symlinks would be updated
   - Verify counts make sense
   - Look for any warnings

3. **Run for real:**
   ```bash
   resymlink --archive-dir ~/archive \
     /old/path /new/path
   ```

4. **Verify in Shoebox**:
   - Open your archive in Shoebox
   - Browse the affected items
   - Confirm images/videos display correctly

5. **Test a few files**:
   ```bash
   ls -l ~/archive/photo/BUDW001.jpg
   # Should show symlink pointing to new location
   ```

## Output Example

```
╔════════════════════════════════════════════════════════════════╗
║              Resymlink - Directory Rename & Update            ║
╚════════════════════════════════════════════════════════════════╝

Configuration:
  Old directory: /home/user/Photos/Trip2017
  New directory: /home/user/Photos/Europe-Vacation-2017
  Archive dir:   /home/user/shoebox-archive

Proceed with renaming directory and updating symlinks? (y/N) y

Renaming directory...
✓ Directory renamed successfully

Scanning photo/ directory...
  ✓ Updated: BUDW001.jpg
    Old: /home/user/Photos/Trip2017/IMG_001.jpg
    New: /home/user/Photos/Europe-Vacation-2017/IMG_001.jpg
  ✓ Updated: BUDW002.jpg
    Old: /home/user/Photos/Trip2017/IMG_002.jpg
    New: /home/user/Photos/Europe-Vacation-2017/IMG_002.jpg

Scanning video/ directory...
  ✓ Updated: BUDW010.mp4
    Old: /home/user/Photos/Trip2017/VID_001.mp4
    New: /home/user/Photos/Europe-Vacation-2017/VID_001.mp4

Scanning audio/ directory...
  No symlinks found pointing to old directory

════════════════════════════════════════════════════════════════
Summary:
────────────────────────────────────────
  Photo symlinks: 2
  Video symlinks: 1
  Audio symlinks: 0
  Total symlinks: 3
════════════════════════════════════════════════════════════════

✓ Directory renamed and symlinks updated successfully!
```

## Tips & Tricks

### Always Dry-Run First

Make it a habit:
```bash
# Step 1: Preview
resymlink --archive-dir ~/archive --dry-run old new

# Step 2: Apply changes
resymlink --archive-dir ~/archive old new
```

### Use Absolute Paths

More reliable:
```bash
# Good - absolute paths
resymlink --archive-dir ~/archive \
  /home/user/Photos/Old \
  /home/user/Photos/New

# Also works - but absolute is clearer
resymlink --archive-dir ~/archive \
  ../Photos/Old \
  ../Photos/New
```

### Check Symlink Status Before

See what's currently linked:
```bash
ls -l ~/archive/photo/ | grep Trip2017
# Shows which files link to that directory
```

### Update Multiple Archives

If you have multiple archives:
```bash
for archive in ~/archive1 ~/archive2 ~/archive3; do
  echo "Updating $archive"
  resymlink --archive-dir "$archive" /old/path /new/path
done
```

## Troubleshooting

**"Archive directory not found"**
- Check --archive-dir path is correct
- Verify directory exists and is accessible

**"No photo/, video/, or audio/ subdirectories found"**
- Wrong archive directory specified
- Not a Shoebox archive structure
- Script will ask if you want to continue anyway

**"New directory already exists"**
- Target directory name taken
- Choose different name
- Or move/rename existing directory first

**"Old directory does not exist"**
- Check path spelling
- Directory may have been moved already
- Use `find` to locate it

**"New target doesn't exist" warnings**
- Original file was deleted
- File was moved outside the directory
- These symlinks are skipped (broken before rename)

**"No symlinks were updated"**
- Symlinks might use relative paths (not supported)
- No files in archive point to that directory
- Check with `ls -l` in archive directories

**Directory renamed but symlinks weren't updated**
- This is rare - indicates scripting error
- Manually revert: `mv new_path old_path`
- Report issue with details

## Integration with Shoebox

Perfect for maintaining archives created with [mklinks](../mklinks/mklinks.README.md):

1. **Initial setup**: Use mklinks to create symlink-based archive
2. **Ongoing maintenance**: Use resymlink when source directories change
3. **Archive portability**: Symlinks allow flexible source organization

### Workflow Example

```bash
# 1. Create symlink archive
cd ~/Photos/2020
/path/to/mklinks/linux/mklinks mklinks.conf

# 2. Later, reorganize source photos
mv ~/Photos/2020/Trip ~/Photos/2020/Europe-Vacation

# 3. Update archive symlinks
resymlink --archive-dir ~/shoebox-archive \
  ~/Photos/2020/Trip \
  ~/Photos/2020/Europe-Vacation

# 4. Archive continues working in Shoebox!
```

## Limitations

### Relative Path Symlinks

The script only updates **absolute path** symlinks:
- ✅ Supported: `/home/user/Photos/image.jpg`
- ❌ Not supported: `../../Photos/image.jpg`

If you use relative symlinks, this tool won't help.

### Multiple Renames

Cannot rename multiple directories at once:
```bash
# Not supported
resymlink --archive-dir ~/archive dir1 new1 dir2 new2

# Instead, run separately
resymlink --archive-dir ~/archive dir1 new1
resymlink --archive-dir ~/archive dir2 new2
```

### Cross-Filesystem Moves

Moving to different filesystem requires copy + update:
```bash
# Moving to different drive
cp -a /old-drive/photos /new-drive/photos
resymlink --archive-dir ~/archive \
  /old-drive/photos \
  /new-drive/photos
# Then manually remove old directory if desired
```

## Technical Details

### Symlink Detection

Uses `find` with `-type l` to locate symlinks:
```bash
find "$archive_dir/photo" -type l -print0
```

### Path Extraction

Extracts relative path within old directory:
```bash
target=$(readlink "$symlink")
relative_path="${target#$old_dir/}"
new_target="$new_dir/$relative_path"
```

### Symlink Update

Uses `ln -sf` to update symlink atomically:
```bash
ln -sf "$new_target" "$symlink"
```

## Performance

Expected performance:
- Small archives (<100 symlinks): Instant
- Medium archives (100-1000 symlinks): Few seconds
- Large archives (1000+ symlinks): 10-30 seconds
- External drives: May be slower depending on USB speed

## Contributing

Contributions welcome! Areas for improvement:

- Windows PowerShell version
- Support for relative path symlinks
- Batch mode (multiple directories)
- Undo functionality
- Progress bar for large archives
- Backup/restore archive state

## Safety Considerations

This script **renames directories** and **modifies symlinks**. Always:

1. ✓ Use --dry-run first
2. ✓ Verify archive backups exist
3. ✓ Test on small directory first
4. ✓ Review output carefully
5. ✓ Verify in Shoebox after running

If something goes wrong, you can usually revert:
```bash
# Revert directory rename
mv /new/path /old/path

# Then fix symlinks
resymlink --archive-dir ~/archive /new/path /old/path
```

## License

MIT License - See [LICENSE](../LICENSE) file for details.

## Support

For issues or questions:
- [Open an issue](https://github.com/Marvbudd/shoebox-utilities/issues)
- Check existing issues for solutions
- Contribute improvements via pull request

## Related Utilities

- [mklinks](../mklinks/mklinks.README.md) - Create symlink-based archives
- [unsymlink](../unsymlink/README.md) - Convert symlinks to copies (if available)
