# Convert Numeric Months

One-time utility to fix a data format issue in Shoebox archives.

## Purpose

This script was created to fix a specific coding error that resulted in numeric months (e.g., "01", "1", "12") being stored in `accessions.json` instead of the required three-character month abbreviations (e.g., "Jan", "Dec").

**This is a one-time fix utility** - if your archive already has properly formatted months, you don't need this script.

## What It Does

Processes an `accessions.json` file and converts numeric month values to three-character abbreviations in:
- `item.date.month` (when media was created)
- `item.source[].received.month` (when item was acquired)

### Conversion Examples

```
"01" → "Jan"
"1"  → "Jan"
"12" → "Dec"
"6"  → "Jun"
```

## Requirements

- Node.js (any modern version)
- An `accessions.json` file with numeric months to convert

## Usage

```bash
node convert-numeric-months <path-to-accessions.json>
```

### Example

```bash
cd /home/mbudd/Documents/shoebox-utilities/convert-numeric-months
node convert-numeric-months ~/my-archive/accessions.json
```

Or from anywhere:

```bash
node /path/to/convert-numeric-months ~/my-archive/accessions.json
```

## Safety Features

- **Automatic backup**: Creates a timestamped backup before making changes
  - Format: `accessions_backup_YYYY-MM-DD-HHMMSS` (no .json extension per Shoebox standards)
- **Detailed logging**: Shows exactly which fields are being converted
- **Safe processing**: Only converts recognized numeric values (1-12)
- **Idempotent**: Running multiple times is safe - already-converted months are skipped

## Example Output

```
=== Converting Numeric Months to Three-Character Abbreviations ===
File: /home/user/archive/accessions.json

Reading file...
Creating backup...
Backup created: /home/user/archive/accessions_backup_2026-03-21-140523

Converting months...

Processing items...
  item[0] (BUDW001).date: "01" → "Jan"
  item[5] (BUDW006).source[0].received: "12" → "Dec"
  item[12] (BUDW013).date: "6" → "Jun"

Writing updated file...

✓ Successfully converted 3 numeric month(s) to three-character format.
✓ File updated: /home/user/archive/accessions.json
```

## When to Use This

**Use this script if:**
- You see numeric months (01, 1, 12) in your accessions.json
- Shoebox is complaining about invalid month format
- You've upgraded from an old version that had the numeric month bug

**You don't need this if:**
- Your months are already "Jan", "Feb", "Mar", etc.
- You've never encountered month-related errors
- You're creating a new archive (the current version stores months correctly)

## Technical Details

### Month Mapping

Supports both zero-padded and unpadded numeric months:

```javascript
'1', '01' → 'Jan'
'2', '02' → 'Feb'
'3', '03' → 'Mar'
'4', '04' → 'Apr'
'5', '05' → 'May'
'6', '06' → 'Jun'
'7', '07' → 'Jul'
'8', '08' → 'Aug'
'9', '09' → 'Sep'
'10'      → 'Oct'
'11'      → 'Nov'
'12'      → 'Dec'
```

### What Gets Processed

The script searches through:
1. Each item's `date.month` field
2. Each item's `source` array entries' `received.month` field

Other date fields (year, day) are left unchanged.

### Backup File Handling

Backup files follow Shoebox naming conventions:
- No `.json` extension
- Timestamped: `accessions_backup_2026-03-21-140523`
- Created in same directory as original file

## Cross-Platform

Works on Linux, macOS, and Windows - anywhere Node.js runs.

## Troubleshooting

**"File not found" error:**
- Check that the path to accessions.json is correct
- Use absolute paths if relative paths don't work

**"No numeric months found" message:**
- Your file is already in correct format!
- No changes needed

**JSON parse error:**
- Your accessions.json file may be corrupted
- Check syntax with a JSON validator
- Restore from a backup if needed

**Permission denied:**
- Ensure you have write access to the directory
- May need to run with appropriate permissions

## After Running

1. Verify the backup was created
2. Open your archive in Shoebox to verify it loads correctly
3. Check a few items to confirm months display properly
4. Keep the backup until you're sure everything works
5. Delete the backup once satisfied (or keep for archival purposes)

## Support

This is a one-time utility script - if you encounter issues:
- Check that you're using a valid accessions.json file
- Verify backups were created
- Report issues at: https://github.com/Marvbudd/shoebox-utilities/issues

## History

Created to fix a bug in an early version of Shoebox that stored months as numeric strings instead of three-character abbreviations. The data structure specification always required "Jan", "Feb", etc., but the implementation mistakenly allowed numeric values.
