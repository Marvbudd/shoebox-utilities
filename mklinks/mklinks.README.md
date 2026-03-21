# mklinks - Media File Symlink Creator

## Overview

The `mklinks` script creates symbolic links for media files (photos, videos, audio) from a source directory tree to a destination directory organized by media type. It's useful for creating a flat view of media files scattered across a deep directory structure.

## Features

- Processes current directory as source
- Organizes symlinks by media type (photo/video/audio)
- Supports file formats: JPG, JPEG, MOV, MP4, MP3 (case-insensitive)
- Processes directories up to 2 levels deep
- Configurable directory exclusions
- Detects and reports duplicate filenames
- Clears existing symlinks before creating new ones

## Usage

```bash
./mklinks <config-file>
```

## Configuration File Format

Create a plain text configuration file with:
- **Line 1**: Destination directory path (where symlinks will be created)
- **Lines 2+**: Directory names to exclude (one per line, relative to source)
- Empty lines and lines starting with `#` are ignored

### Example Configuration (mklinks.conf)

```
/home/user/Photos/shoebox
shoebox
Archive
Private
Temp
```

## Example Usage

1. Navigate to your source directory:
   ```bash
   cd /home/user/Pictures
   ```

2. Create a configuration file (e.g., `mklinks.conf`):
   ```bash
   cat > mklinks.conf << EOF
   /home/user/Pictures/shoebox
   shoebox
   Archive
   EOF
   ```

3. Run the script:
   ```bash
   ./mklinks mklinks.conf
   ```

## Output

The script will:
1. Display loaded configuration
2. Clear existing symlinks in destination
3. Process directories and create symlinks
4. Report any duplicate filenames (conflicts)
5. Display completion message

Example output:
```
Configuration loaded:
  Source directory: /home/user/Pictures
  Destination directory: /home/user/Pictures/shoebox
  Excluded directories: 2
    - shoebox
    - Archive

Clearing existing symlinks...
Destination directories cleared.

Creating symlinks for media files...
Now creating symlink: /home/user/Pictures/Vacation/IMG_0001.jpg -> /home/user/Pictures/shoebox/photo/IMG_0001.jpg
...

Done! Symlinks created from /home/user/Pictures to /home/user/Pictures/shoebox
```

## Directory Structure

The destination directory will have this structure:
```
destination/
├── audio/      # Symlinks to .mp3 files
├── photo/      # Symlinks to .jpg, .jpeg files
└── video/      # Symlinks to .mov, .mp4 files
```

## Exit Codes

- `0` - Success
- `1` - Error (missing config file, invalid format, destination doesn't exist)

## Notes

- The script processes the current working directory as the source
- Subdirectories are processed up to 2 levels deep
- Excluded directories are matched by basename or relative path
- The destination directory must exist before running the script
- Existing symlinks are removed and recreated on each run
- Duplicate filenames from different directories will cause conflicts (first one wins)
