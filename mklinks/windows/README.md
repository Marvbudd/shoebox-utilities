# mklinks - Windows Version

Create symbolic links for media files using Windows `mklink` functionality via PowerShell.

## Overview

The Windows version of mklinks uses PowerShell's `New-Item -ItemType SymbolicLink` (which internally uses Windows `mklink` command) to create symbolic links for media files from a source directory tree to a destination directory organized by media type.

## Requirements

- **Windows 10 or higher** (for reliable symlink support)
- **PowerShell 5.1 or higher** (included with Windows 10+)
- **Administrator privileges** OR **Developer Mode enabled** (for creating symlinks)

### Checking PowerShell Version

```powershell
$PSVersionTable.PSVersion
```

Should show version 5.1 or higher (Windows 10+ includes PowerShell 5.1 by default).

## Installation

1. Download or clone the shoebox-utilities repository
2. Navigate to `mklinks/windows/`
3. No additional installation needed - PowerShell is built into Windows

## Usage

### Basic Usage

```powershell
# Navigate to your source directory (where your media files are)
cd C:\Users\YourName\Pictures

# Create a configuration file (see below)
notepad mklinks.conf

# Run the script
.\mklinks.ps1 mklinks.conf
```

### Running as Administrator

If you get permission errors, run PowerShell as Administrator:

1. Right-click **PowerShell** in Start menu
2. Select **Run as Administrator**
3. Navigate to your source directory and run the script

Alternatively, you can enable Developer Mode in Windows 10/11 to create symlinks without admin privileges:
- Settings > Update & Security > For Developers > Developer Mode: **On**

## Configuration File

Create a plain text file (e.g., `mklinks.conf`) with:
- **Line 1**: Destination directory path (where symlinks will be created)
- **Lines 2+**: Directory names to exclude (one per line, relative to source)
- Empty lines and lines starting with `#` are ignored

### Example Configuration

```
C:\Users\John\Pictures\shoebox
shoebox
Archive
Backup
Private
Temp
```

This configuration:
- Creates symlinks in `C:\Users\John\Pictures\shoebox`
- Excludes directories named: shoebox, Archive, Backup, Private, Temp

## Examples

### Example 1: Basic Setup

```powershell
# Navigate to your photo collection
cd C:\Users\John\Pictures

# Create config file
@"
C:\Users\John\Pictures\shoebox
shoebox
Archive
"@ | Out-File -FilePath mklinks.conf -Encoding ASCII

# Run mklinks
.\path\to\mklinks.ps1 mklinks.conf
```

### Example 2: Multiple Source Locations

If you have photos in multiple locations, run mklinks for each:

```powershell
# Process Documents\Photos
cd C:\Users\John\Documents\Photos
.\path\to\mklinks.ps1 ..\photos-config.conf

# Process external drive
cd E:\PhotoBackup
.\path\to\mklinks.ps1 E:\backup-config.conf
```

### Example 3: Network Paths

Works with UNC network paths:

```powershell
cd \\server\share\Photos
.\path\to\mklinks.ps1 \\server\share\shoebox-config.conf
```

## Output

The script provides colored, formatted output:

```
Configuration loaded:
  Source directory: C:\Users\John\Pictures
  Destination directory: C:\Users\John\Pictures\shoebox
  Excluded directories: 2
    - shoebox
    - Archive

Clearing existing symlinks...
✓ Destination directories cleared.

Creating symlinks for media files...

Processing: Vacation2023
  → Created: IMG_0001.jpg
  → Created: IMG_0002.jpg
  → Created: VID_0001.mp4

Processing: Family
  → Created: reunion-2023.jpg
  ⚠ File already exists: duplicate.jpg → C:\Users\John\Pictures\Other\duplicate.jpg

═══════════════════════════════════════════════════════════════
Summary:
───────────────────────────────────────────────────────────────
  Photos:  45 symlinks created
  Videos:  12 symlinks created
  Audio:   3 symlinks created
  Total:   60 symlinks
═══════════════════════════════════════════════════════════════

✓ Done! Symlinks created from C:\Users\John\Pictures to C:\Users\John\Pictures\shoebox
```

## Directory Structure

After running, your destination directory will have:

```
shoebox/
├── audio/      # Symlinks to .mp3 files
├── photo/      # Symlinks to .jpg, .jpeg files
└── video/      # Symlinks to .mov, .mp4 files
```

## Supported File Formats

- **Photos**: `.jpg`, `.jpeg` (case-insensitive)
- **Videos**: `.mov`, `.mp4` (case-insensitive)
- **Audio**: `.mp3` (case-insensitive)

## Features

- ✓ Uses Windows native `mklink` functionality
- ✓ Processes current directory as source
- ✓ Organizes symlinks by media type (photo/video/audio)
- ✓ Processes directories up to 2 levels deep
- ✓ Configurable directory exclusions
- ✓ Detects and reports duplicate filenames
- ✓ Clears existing symlinks before creating new ones
- ✓ Colored output for better readability
- ✓ Statistics summary
- ✓ Handles Windows paths (backslashes, drive letters)
- ✓ Supports UNC network paths

## Troubleshooting

### "You do not have sufficient privilege to perform this operation"

**Problem**: Creating symlinks requires administrator privileges on some Windows versions.

**Solutions**:
1. **Run as Administrator**:
   - Right-click PowerShell
   - Select "Run as Administrator"
   - Navigate to directory and run script

2. **Enable Developer Mode** (Windows 10/11):
   - Settings > Update & Security > For Developers
   - Turn on "Developer Mode"
   - Restart if prompted
   - No admin privileges needed after this

3. **Use Hard Links Instead** (alternative):
   - Modify script to use `-ItemType HardLink` instead of `-ItemType SymbolicLink`
   - Note: Hard links have different behavior than symlinks

### "Execution Policy" Error

**Problem**: PowerShell won't run scripts due to execution policy.

**Solution**:
```powershell
# Check current policy
Get-ExecutionPolicy

# Allow scripts for current user (recommended)
Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Scope CurrentUser

# Or bypass for single execution
PowerShell -ExecutionPolicy Bypass -File mklinks.ps1 mklinks.conf
```

### "Config file not found"

**Problem**: PowerShell can't find the config file.

**Solution**:
```powershell
# Use full path
.\mklinks.ps1 C:\full\path\to\mklinks.conf

# Or make sure you're in the right directory
cd C:\Users\John\Pictures
.\path\to\mklinks.ps1 .\mklinks.conf
```

### Symlinks Not Working on Network Drives

**Problem**: Network drives or network paths don't support symlinks properly.

**Workaround**:
- Use local drives for destination
- Or copy files instead of symlinking for network locations
- Check with network administrator about symlink support

### Colors Not Showing

**Problem**: ANSI color codes not displayed in older PowerShell or console.

**Solution**:
- Use Windows Terminal (recommended) - available free in Microsoft Store
- Or use PowerShell 7+ which has better color support
- Colors will automatically fall back if not supported

## Windows-Specific Notes

### Path Differences

Windows uses backslashes (`\`) in paths, but PowerShell and the script handle both:
- `C:\Users\John\Pictures` (Windows style)
- `C:/Users/John/Pictures` (Unix style - also works)

### Drive Letters

Include drive letter in destination path:
```
C:\Users\John\shoebox\archive
```

### UNC Paths

Network paths work too:
```
\\server\share\archive
```

### Case Sensitivity

Windows file systems are case-insensitive:
- `IMG_0001.jpg` and `img_0001.jpg` are the same file
- Script handles this automatically

### File Extensions

The script matches extensions case-insensitively:
- `.jpg`, `.JPG`, `.Jpg` all work
- `.mp3`, `.MP3`, `.Mp3` all work

## Comparison with Linux/macOS Versions

| Feature | Linux/macOS | Windows (PowerShell) |
|---------|-------------|---------------------|
| Core functionality | ✓ Same | ✓ Same |
| Config file format | ✓ Same | ✓ Same |
| Symlink creation | `ln -s` | `mklink` via `New-Item` |
| Colored output | ✓ Yes | ✓ Yes |
| Admin required | No | Sometimes (see Developer Mode) |
| Network paths | ✓ Yes | ✓ Yes |
| Path separators | `/` | `\` or `/` (both work) |

## Performance

- **Fast**: Processes thousands of files in seconds
- **No data duplication**: Symlinks don't copy files
- **Instant updates**: Changes to source files reflected immediately

## Integration with Shoebox

After creating symlinks:

1. Your media files stay in their original locations
2. Shoebox sees them organized in photo/, video/, audio/ directories
3. Use Shoebox's **Add Media Metadata** to import:
   - Point it to the destination directory (with symlinks)
   - Shoebox will find all media in the organized structure
   - Metadata is added to accessions.json

## Advanced Usage

### Automation with Task Scheduler

Create a scheduled task to run mklinks automatically:

```powershell
# Create a task that runs daily
$action = New-ScheduledTaskAction -Execute 'PowerShell.exe' `
  -Argument '-File C:\path\to\mklinks.ps1 C:\path\to\mklinks.conf' `
  -WorkingDirectory 'C:\Users\John\Pictures'

$trigger = New-ScheduledTaskTrigger -Daily -At 2am

Register-ScheduledTask -Action $action -Trigger $trigger `
  -TaskName "Shoebox mklinks" -Description "Create media symlinks daily"
```

### Batch Processing Multiple Configs

Process multiple configurations at once:

```powershell
# Create a script to run multiple configs
Get-ChildItem -Path C:\configs -Filter *.conf | ForEach-Object {
    Write-Host "Processing: $($_.Name)"
    .\mklinks.ps1 $_.FullName
}
```

### Logging Output

Save output to a log file:

```powershell
.\mklinks.ps1 mklinks.conf | Tee-Object -FilePath mklinks.log
```

## Security Considerations

### Symlink Vulnerabilities

Symbolic links can be security risks if misused:
- Don't create symlinks to system directories
- Be careful with symlinks to network locations
- Review excluded directories carefully

### Developer Mode

Enabling Developer Mode has security implications:
- Allows non-admin symlink creation
- May enable other developer features
- Consider if appropriate for your security needs

## Exit Codes

- `0` - Success
- `1` - Error (missing config, path not found, permission denied, etc.)

## See Also

- [Linux version](../linux/mklinks) - Bash implementation
- [macOS version](../macos/mklinks) - Bash implementation  
- [Main README](../mklinks.README.md) - General documentation
- [Shoebox Documentation](https://github.com/Marvbudd/shoebox)

## Contributing

Found a bug or have improvement suggestions for the Windows version? Please open an issue in the Shoebox Utilities repository.

## Testing

This Windows version has been designed and structured to match the Linux/macOS functionality, but **requires testing on Windows 10/11** to verify:
- Symlink creation with various permission levels
- Path handling (drive letters, UNC paths)
- Color output in different terminals
- Error handling and edge cases

If you test this script, please report your results!
