# MkCol - Create Shoebox Collections

Quickly create Shoebox collection files from media files in your current directory. Perfect for organizing themed sets of photos, videos, or audio recordings.

## Overview

MkCol scans your current directory for media files and creates a Shoebox collection JSON file by:

1. **Finding media files** in the current directory (.jpg, .mp4, .mp3, etc.)
2. **Looking up accession numbers** from your accessions.json file
3. **Creating a collection file** in the collections directory
4. **Auto-organizing** items alphabetically by filename

## Platform Support

- ✅ **Cross-platform** - Works on Linux, macOS, and Windows (requires Node.js)

## Requirements

- Node.js (any modern version)
- A Shoebox archive with accessions.json file
- Media files in the current directory

## Installation

1. Clone or download this repository
2. Navigate to the mkcol directory:
   ```bash
   cd mkcol
   ```
3. Make the script executable (Linux/macOS):
   ```bash
   chmod +x mkcol
   ```

## Usage

### Basic Syntax

```bash
mkcol --accessions-file <path-to-accessions.json> <key> <text> <title>
```

### Required Option

- `--accessions-file PATH` - Path to your accessions.json file

### Optional Options

- `--dry-run` - Preview collection without creating file
- `--help` - Show help message

### Arguments

1. **key** - Unique identifier for the collection (letters, numbers, hyphens, underscores only)
2. **text** - Short description shown in Shoebox dropdown menus
3. **title** - Full human-readable description of the collection

### Examples

**Create a summer vacation collection:**
```bash
cd ~/Photos/2024-Summer
mkcol --accessions-file ~/archive/accessions.json \
  summer2024 "Summer 2024" "Summer Vacation Photos 2024"
```

**Preview before creating (dry-run):**
```bash
cd ~/Downloads/family-reunion
mkcol --accessions-file ~/shoebox/accessions.json --dry-run \
  reunion2024 "Reunion 2024" "Family Reunion August 2024"
```

**Create a themed collection:**
```bash
cd ~/Pictures/Birthdays
mkcol --accessions-file ~/archive/accessions.json \
  grandma90 "Grandma's 90th" "Grandma's 90th Birthday Celebration"
```

**Quick collection from current directory:**
```bash
cd wedding-photos
node /path/to/mkcol/mkcol --accessions-file ~/archive/accessions.json \
  wedding "Wedding Day" "Sarah and John's Wedding - June 2024"
```

## How It Works

### Step-by-Step Process

1. **Scan Current Directory**:
   - Finds all media files with supported extensions
   - Sorts files alphabetically for consistent ordering

2. **Look Up Accessions**:
   - Loads accessions.json file
   - Matches each filename to its accession number
   - Warns if files aren't found in archive

3. **Build Collection**:
   - Creates collection object with key, text, title
   - Includes only files found in accessions.json
   - Maintains alphabetical order

4. **Write Collection File**:
   - Saves to collections directory (next to accessions.json)
   - Creates collections directory if needed
   - Prevents overwriting existing collections

### Supported File Types

**Images:**
- .jpg, .jpeg (any case: .JPG, .JPEG)

**Videos:**
- .mp4 (any case: .MP4)

**Audio:**
- .mp3 (any case: .MP3)

### Collection File Structure

Creates a JSON file like this:

```json
{
  "key": "summer2024",
  "text": "Summer 2024",
  "title": "Summer Vacation Photos 2024",
  "itemKeys": [
    {
      "accession": "BUDW001",
      "link": "beach-sunset.jpg"
    },
    {
      "accession": "BUDW002",
      "link": "family-photo.jpg"
    }
  ]
}
```

## Features

### Safety Features

- **Dry-run mode**: Preview what would be created without writing files
- **Collision detection**: Won't overwrite existing collection files
- **Validation**: Checks key format, file existence, accession lookups
- **Clear warnings**: Shows files not found in accessions.json

### User Experience

- **Color-coded output**:
  - Green for success
  - Yellow for warnings and dry-run
  - Red for errors
  - Cyan for informational
- **Detailed listing**: Shows each file mapped to accession number
- **Progress feedback**: Reports counts and status at each step
- **Summary statistics**: Final count and file location

### Smart Features

- **Auto-directory creation**: Creates collections directory if needed
- **Filename matching**: Matches by link field in accessions.json
- **Sorted results**: Alphabetical ordering for consistency
- **Skip missing**: Continues even if some files aren't in archive

## Common Use Cases

### Themed Photo Collections

Create collections for specific events or themes:

```bash
# Birthday party
cd ~/Pictures/birthdays/mom-60th
mkcol --accessions-file ~/archive/accessions.json \
  mom60 "Mom's 60th" "Mom's 60th Birthday Party"

# Holiday photos
cd ~/Photos/Christmas2024
mkcol --accessions-file ~/archive/accessions.json \
  xmas2024 "Christmas 2024" "Christmas Family Gathering 2024"
```

### Geographic Collections

Group photos by location:

```bash
# Trip to Paris
cd ~/Travel/Paris2024
mkcol --accessions-file ~/archive/accessions.json \
  paris2024 "Paris Trip" "Paris Vacation May 2024"

# Home town photos
cd ~/Photos/Hometown
mkcol --accessions-file ~/archive/accessions.json \
  hometown "Hometown" "Photos from Our Hometown"
```

### Person-Based Collections

Collections focused on specific people:

```bash
# Grandchildren photos
cd ~/Grandkids/2024
mkcol --accessions-file ~/archive/accessions.json \
  grandkids2024 "Grandkids 2024" "Grandchildren Photos 2024"
```

### After Importing New Media

After using Add Media Metadata:

```bash
# 1. Add media to archive via Shoebox
# 2. Navigate to source directory
cd ~/Downloads/new-photos
# 3. Create collection
mkcol --accessions-file ~/archive/accessions.json \
  import2024 "March Import" "Photos Imported March 2024"
```

## Workflow

Recommended workflow:

1. **Navigate to directory with media files:**
   ```bash
   cd ~/path/to/photos
   ```

2. **Preview first (dry-run):**
   ```bash
   mkcol --accessions-file ~/archive/accessions.json --dry-run \
     mykey "My Text" "My Title"
   ```

3. **Review output**:
   - Check file count
   - Verify accession lookups
   - Note any warnings about missing files

4. **Create collection:**
   ```bash
   mkcol --accessions-file ~/archive/accessions.json \
     mykey "My Text" "My Title"
   ```

5. **Open in Shoebox**:
   - Launch Shoebox
   - Check Collections menu
   - Your new collection appears in the dropdown

## Output Example

```
╔════════════════════════════════════════════════════════════════╗
║              Create Shoebox Collection                         ║
╚════════════════════════════════════════════════════════════════╝

Configuration:
  Key:               summer2024
  Text:              Summer 2024
  Title:             Summer Vacation Photos 2024
  Accessions file:   /home/user/archive/accessions.json
  Current directory: /home/user/Photos/Summer

Loading accessions.json...
✓ Loaded 150 accession entries

Scanning for media files...
✓ Found 12 media file(s)

Building collection...
✓ Including 12 item(s) in collection:

    1. beach-sunset.jpg → BUDW045
    2. family-hiking.jpg → BUDW046
    3. lake-view.jpg → BUDW047
    ...

════════════════════════════════════════════════════════════════
✓ Collection created successfully!
  File:  summer2024.json
  Items: 12
  Path:  /home/user/archive/collections/summer2024.json
════════════════════════════════════════════════════════════════
```

## Tips & Tricks

### Always Dry-Run First

Preview before creating:
```bash
# Step 1: Preview
mkcol --accessions-file ~/archive/accessions.json --dry-run \
  key "Text" "Title"

# Step 2: If looks good, create
mkcol --accessions-file ~/archive/accessions.json \
  key "Text" "Title"
```

### Use Descriptive Keys

Good key names:
```bash
# Good - descriptive and date-based
summer2024, reunion2023, paris-trip, wedding-2024

# Avoid - too generic or unclear
collection1, photos, temp, test
```

### Organize by Directory

Keep related files in same directory for easy collection creation:
```bash
~/Pictures/
  ├── 2024-Summer/        # mkcol summer2024 ...
  ├── Family-Reunion/     # mkcol reunion ...
  └── Vacation-Paris/     # mkcol paris ...
```

### Batch Collections

Create multiple collections from subdirectories:
```bash
for dir in ~/Pictures/*/; do
  cd "$dir"
  basename=$(basename "$dir")
  mkcol --accessions-file ~/archive/accessions.json \
    "$basename" "$basename" "Photos from $basename"
done
```

### Check Files First

See what would be included:
```bash
# List media files in current directory
ls *.jpg *.mp4 *.mp3 2>/dev/null | sort
```

## Troubleshooting

**"accessions.json not found"**
- Check --accessions-file path is correct
- Use absolute path: ~/archive/accessions.json
- Verify file exists: `ls -l path/to/accessions.json`

**"No supported media files found"**
- Check you're in correct directory
- Verify files have supported extensions (.jpg, .mp4, .mp3)
- Extensions are case-sensitive on Linux

**"Link not found in accessions.json"**
- File hasn't been added to archive via Add Media Metadata
- Filename doesn't match link field in accessions.json
- File is skipped but collection continues

**"Collection file already exists"**
- Key name is already used
- Choose different key name
- Or delete existing: `rm ~/archive/collections/key.json`

**"Key must contain only letters, numbers, hyphens, and underscores"**
- Invalid characters in key
- Remove spaces: "my key" → "my-key" or "my_key"
- Avoid special characters: no @, #, !, etc.

**"Expected 3 arguments"**
- Must provide all three: key, text, title
- Use quotes for multi-word arguments
- Check spacing and quote placement

## Integration with Shoebox

Perfect for organizing your Shoebox archive:

1. **Import media**: Use Shoebox's Add Media Metadata
2. **Navigate to source**: cd to directory with those files
3. **Create collection**: Run mkcol with those files
4. **View in Shoebox**: Collection appears in Collections menu

### Workflow Example

```bash
# 1. Import new photos via Shoebox
# File > Add Media Metadata > select directory

# 2. Create collection from same directory
cd ~/Photos/Trip2024
mkcol --accessions-file ~/shoebox-archive/accessions.json \
  trip2024 "2024 Trip" "Family Trip to Mountains 2024"

# 3. Open Shoebox and view collection
# Collections > 2024 Trip
```

## Advanced Usage

### Collections Directory

Collections are saved in:
```
<archive-directory>/collections/<key>.json
```

For example:
```
~/archive/
  ├── accessions.json
  ├── collections/
  │   ├── summer2024.json
  │   ├── reunion2023.json
  │   └── wedding.json
  ├── photo/
  ├── video/
  └── audio/
```

### Manual Editing

Collection files are JSON - can be manually edited:

```json
{
  "key": "mykey",
  "text": "My Collection",
  "title": "Full Collection Title",
  "itemKeys": [
    { "accession": "BUDW001", "link": "photo1.jpg" },
    { "accession": "BUDW002", "link": "photo2.jpg" }
  ]
}
```

### Combining Multiple Directories

Manual approach:
```bash
# Create temp directory
mkdir /tmp/combined
cd ~/Photos/Set1 && cp *.jpg /tmp/combined/
cd ~/Photos/Set2 && cp *.jpg /tmp/combined/
cd /tmp/combined
mkcol --accessions-file ~/archive/accessions.json \
  combined "Combined" "Photos from Multiple Sets"
```

## Limitations

### Current Directory Only

Only scans current directory (not recursive):
```bash
# Files in current directory - ✓ included
# Files in subdirectories - ✗ not included
```

To include subdirectories:
```bash
# Copy files up first
find . -type f -name "*.jpg" -exec cp {} . \;
# Then run mkcol
```

### Filename Matching

Matches by link field in accessions.json:
- File must already be in archive
- Filename must exactly match link field
- Case-sensitive on Linux

### Single Collection Per Run

Creates one collection at a time:
```bash
# Not supported
mkcol ... key1 ... key2 ...

# Instead, run multiple times
mkcol ... key1 "Text 1" "Title 1"
mkcol ... key2 "Text 2" "Title 2"
```

## Technical Details

### Accession Lookup

Builds a map from accessions.json:
```javascript
link → accession
"photo.jpg" → "BUDW001"
```

### File Extension Matching

Case-insensitive extension check:
```javascript
['.jpg', '.jpeg', '.JPG', '.JPEG', '.mp4', '.MP4', '.mp3', '.MP3']
```

### Collection Storage

JSON format with 2-space indentation:
```javascript
JSON.stringify(collection, null, 2)
```

## Performance

Expected performance:
- Small directories (<50 files): Instant
- Medium directories (50-500 files): 1-2 seconds
- Large directories (500-2000 files): 2-10 seconds
- Very large accessions.json: May take longer to load

## Contributing

Contributions welcome! Areas for improvement:

- Recursive directory scanning
- Fuzzy filename matching
- Collection merging
- Batch mode (multiple collections)
- GUI interface
- Export to other formats

## License

MIT License - See [LICENSE](../LICENSE) file for details.

## Support

For issues or questions:
- [Open an issue](https://github.com/Marvbudd/shoebox-utilities/issues)
- Check existing issues for solutions
- Contribute improvements via pull request
