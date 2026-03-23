<#
.SYNOPSIS
    Create symbolic links for media files in destination directory

.DESCRIPTION
    This script creates symbolic links for media files (photos, videos, audio)
    from a source directory tree to a destination directory organized by type.
    It processes directories up to two levels deep and can exclude specific
    directories from processing.
    
    Uses Windows mklink functionality via PowerShell's New-Item -ItemType SymbolicLink.

.PARAMETER ConfigFile
    Path to configuration file
    Format:
      Line 1: Destination directory path
      Lines 2+: Directory names to exclude (one per line)

.EXAMPLE
    .\mklinks.ps1 mklinks.conf

.EXAMPLE CONFIG FILE (mklinks.conf)
    C:\Users\User\Pictures\shoebox
    shoebox
    Archive
    Private
    Temp

.NOTES
    - Source directory: Current working directory
    - Clears existing links in destination audio/photo/video directories
    - Creates links for: .jpg, .jpeg, .mov, .mp4, .mp3 (case-insensitive)
    - Processes directories up to 2 levels deep
    - Skips excluded directories and their subdirectories
    - Warns about duplicate filenames (symlink conflicts)
    - Requires PowerShell 5.1 or higher (included with Windows 10+)
    - May require administrator privileges for creating symlinks (unless Developer Mode enabled)

.LINK
    https://github.com/Marvbudd/shoebox-utilities
#>

param(
    [Parameter(Mandatory=$true, Position=0)]
    [string]$ConfigFile
)

# Set strict mode for better error handling
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# ANSI color codes for output (using escape character that works in PowerShell 5.1+)
# Detect if terminal supports ANSI colors (Windows Terminal, VS Code, PowerShell 7+)
$SupportsColors = $false
try {
    # Check if running in Windows Terminal or other modern terminal
    if ($env:WT_SESSION -or $env:TERM_PROGRAM -eq 'vscode' -or $PSVersionTable.PSVersion.Major -ge 7) {
        $SupportsColors = $true
    }
} catch {
    $SupportsColors = $false
}

if ($SupportsColors) {
    $ESC = [char]27
    $colors = @{
        Reset = "$ESC[0m"
        Bright = "$ESC[1m"
        Red = "$ESC[31m"
        Green = "$ESC[32m"
        Yellow = "$ESC[33m"
        Cyan = "$ESC[36m"
        Gray = "$ESC[90m"
    }
} else {
    # No color support - use empty strings
    $colors = @{
        Reset = ""
        Bright = ""
        Red = ""
        Green = ""
        Yellow = ""
        Cyan = ""
        Gray = ""
    }
}

# Check if config file exists
if (-not (Test-Path -Path $ConfigFile -PathType Leaf)) {
    Write-Host "$($colors.Red)Error: Config file '$ConfigFile' not found$($colors.Reset)" -ForegroundColor Red
    exit 1
}

# Read configuration file
$configLines = Get-Content -Path $ConfigFile | Where-Object {
    # Skip empty lines and comments
    $_ -match '\S' -and $_ -notmatch '^\s*#'
}

if ($configLines.Count -eq 0) {
    Write-Host "$($colors.Red)Error: Config file is empty or contains only comments$($colors.Reset)" -ForegroundColor Red
    exit 1
}

# First line is destination directory, rest are excludes
$DESTDIR = $configLines[0].Trim()
$EXCLUDES = @()
if ($configLines.Count -gt 1) {
    $EXCLUDES = $configLines[1..($configLines.Count - 1)] | ForEach-Object { $_.Trim() }
}

# Validate destination directory
if ([string]::IsNullOrWhiteSpace($DESTDIR)) {
    Write-Host "$($colors.Red)Error: Destination directory not specified in config file$($colors.Reset)" -ForegroundColor Red
    exit 1
}

if (-not (Test-Path -Path $DESTDIR -PathType Container)) {
    Write-Host "$($colors.Red)Error: Destination directory does not exist: $DESTDIR$($colors.Reset)" -ForegroundColor Red
    exit 1
}

# Source directory is current directory
$SRCDIR = Get-Location | Select-Object -ExpandProperty Path

# Display configuration
Write-Host ""
Write-Host "$($colors.Bright)Configuration loaded:$($colors.Reset)"
Write-Host "  Source directory: $($colors.Cyan)$SRCDIR$($colors.Reset)"
Write-Host "  Destination directory: $($colors.Cyan)$DESTDIR$($colors.Reset)"
Write-Host "  Excluded directories: $($colors.Cyan)$($EXCLUDES.Count)$($colors.Reset)"
foreach ($ex in $EXCLUDES) {
    Write-Host "    $($colors.Gray)- $ex$($colors.Reset)"
}
Write-Host ""

# Check if we can create symlinks (test early to warn user)
try {
    $testLinkPath = Join-Path -Path $DESTDIR -ChildPath ".test_symlink_$([guid]::NewGuid().ToString())"
    $testTargetPath = Join-Path -Path $SRCDIR -ChildPath ".test_target"
    
    # Create a temporary target file
    "test" | Out-File -FilePath $testTargetPath -Force -ErrorAction Stop
    
    # Try to create a test symlink
    New-Item -ItemType SymbolicLink -Path $testLinkPath -Target $testTargetPath -Force -ErrorAction Stop | Out-Null
    
    # Clean up test files
    Remove-Item -Path $testLinkPath -Force -ErrorAction SilentlyContinue
    Remove-Item -Path $testTargetPath -Force -ErrorAction SilentlyContinue
    
} catch {
    if ($_.Exception.Message -match "privilege") {
        Write-Host "$($colors.Yellow)WARNING: Insufficient privileges to create symbolic links!$($colors.Reset)"
        Write-Host "$($colors.Yellow)The script will attempt to continue, but creating symlinks will likely fail.$($colors.Reset)"
        Write-Host ""
        Write-Host "To fix this, either:"
        Write-Host "  1. Run PowerShell as Administrator (right-click > Run as administrator)"
        Write-Host "  2. Enable Developer Mode:"
        Write-Host "     Settings > Update & Security > For Developers > Developer Mode: ON"
        Write-Host ""
        
        # Ask if user wants to continue
        $response = Read-Host "Continue anyway? (y/N)"
        if ($response -notmatch '^[Yy]') {
            Write-Host "Cancelled by user."
            exit 1
        }
        Write-Host ""
    }
}

# Create destination subdirectories if they don't exist
$mediaTypes = @('audio', 'photo', 'video')
foreach ($type in $mediaTypes) {
    $dir = Join-Path -Path $DESTDIR -ChildPath $type
    if (-not (Test-Path -Path $dir)) {
        New-Item -Path $dir -ItemType Directory -Force | Out-Null
    }
}

# Clear existing symlinks in destination directories
Write-Host "$($colors.Yellow)Clearing existing symlinks...$($colors.Reset)"
foreach ($type in $mediaTypes) {
    $dir = Join-Path -Path $DESTDIR -ChildPath $type
    if (Test-Path -Path $dir) {
        Get-ChildItem -Path $dir -File | Where-Object {
            $_.LinkType -eq 'SymbolicLink'
        } | Remove-Item -Force
    }
}
Write-Host "$($colors.Green)OK: Destination directories cleared.$($colors.Reset)"
Write-Host ""

# Function to check if path should be excluded
function Test-ShouldExclude {
    param([string]$Path)
    
    $relativePath = $Path
    if ($Path.StartsWith($SRCDIR)) {
        $relativePath = $Path.Substring($SRCDIR.Length).TrimStart('\', '/')
    }
    
    $baseName = Split-Path -Path $Path -Leaf
    
    foreach ($ex in $EXCLUDES) {
        if ($relativePath -eq $ex -or 
            $baseName -eq $ex -or 
            $relativePath.StartsWith("$ex\") -or
            $relativePath.StartsWith("$ex/")) {
            return $true
        }
    }
    
    return $false
}

# Function to handle individual file
function Handle-MediaFile {
    param(
        [string]$FilePath,
        [string]$MediaType
    )
    
    $fileName = Split-Path -Path $FilePath -Leaf
    $destPath = Join-Path -Path $DESTDIR -ChildPath "$MediaType\$fileName"
    
    if (Test-Path -Path $destPath) {
        # Check if it's a symlink and get its target
        $item = Get-Item -Path $destPath -Force
        if ($item.LinkType -eq 'SymbolicLink') {
            $existingTarget = $item.Target
            Write-Host "  $($colors.Yellow)WARNING:$($colors.Reset) File already exists: $($colors.Gray)$fileName -> $existingTarget$($colors.Reset)"
        } else {
            Write-Host "  $($colors.Yellow)WARNING:$($colors.Reset) Non-symlink file exists: $($colors.Gray)$fileName$($colors.Reset)"
        }
        $script:stats.warnings++
    } else {
        try {
            # Create symbolic link using mklink via New-Item
            New-Item -ItemType SymbolicLink -Path $destPath -Target $FilePath -Force -ErrorAction Stop | Out-Null
            Write-Host "  $($colors.Green)>>$($colors.Reset) Created: $($colors.Gray)$fileName$($colors.Reset)"
        } catch {
            Write-Host "  $($colors.Red)ERROR:$($colors.Reset) Failed to create symlink: $($colors.Gray)$fileName$($colors.Reset)"
            Write-Host "    $($colors.Red)Error: $($_.Exception.Message)$($colors.Reset)"
            $script:stats.errors++
            
            # Check if it's a permissions issue
            if ($_.Exception.Message -match "privilege") {
                Write-Host "    $($colors.Yellow)INFO:$($colors.Reset) Tip: Run PowerShell as Administrator to create symlinks"
            }
        }
    }
}

# Function to process file based on extension
function Process-File {
    param([string]$FilePath)
    
    if (Test-ShouldExclude -Path $FilePath) {
        return
    }
    
    $extension = [System.IO.Path]::GetExtension($FilePath).ToLower()
    
    switch ($extension) {
        '.jpg' {
            Handle-MediaFile -FilePath $FilePath -MediaType 'photo'
        }
        '.jpeg' {
            Handle-MediaFile -FilePath $FilePath -MediaType 'photo'
        }
        '.mov' {
            Handle-MediaFile -FilePath $FilePath -MediaType 'video'
        }
        '.mp4' {
            Handle-MediaFile -FilePath $FilePath -MediaType 'video'
        }
        '.mp3' {
            Handle-MediaFile -FilePath $FilePath -MediaType 'audio'
        }
    }
}

# Function to create links for a directory (up to 2 levels deep)
function Create-Links {
    param([string]$Directory)
    
    if (Test-ShouldExclude -Path $Directory) {
        return
    }
    
    # Process files in the current directory
    Get-ChildItem -Path $Directory -File -ErrorAction SilentlyContinue | ForEach-Object {
        Process-File -FilePath $_.FullName
    }
    
    # Process subdirectories (one level deep)
    Get-ChildItem -Path $Directory -Directory -ErrorAction SilentlyContinue | ForEach-Object {
        $subdir = $_.FullName
        
        if (Test-ShouldExclude -Path $subdir) {
            return
        }
        
        # Process files in subdirectory
        Get-ChildItem -Path $subdir -File -ErrorAction SilentlyContinue | ForEach-Object {
            Process-File -FilePath $_.FullName
        }
    }
}

# Main processing
Write-Host "$($colors.Bright)Creating symlinks for media files...$($colors.Reset)"
Write-Host ""

$script:stats = @{
    photo = 0
    video = 0
    audio = 0
    warnings = 0
    errors = 0
}

# Process all top-level directories in source
Get-ChildItem -Path $SRCDIR -Directory -ErrorAction SilentlyContinue | ForEach-Object {
    $dirName = $_.Name
    Write-Host "$($colors.Cyan)Processing:$($colors.Reset) $dirName"
    
    # Count files created (use @() to force array for reliable .Count)
    $beforePhoto = @(Get-ChildItem -Path (Join-Path $DESTDIR 'photo') -File -ErrorAction SilentlyContinue).Count
    $beforeVideo = @(Get-ChildItem -Path (Join-Path $DESTDIR 'video') -File -ErrorAction SilentlyContinue).Count
    $beforeAudio = @(Get-ChildItem -Path (Join-Path $DESTDIR 'audio') -File -ErrorAction SilentlyContinue).Count
    
    Create-Links -Directory $_.FullName
    
    $afterPhoto = @(Get-ChildItem -Path (Join-Path $DESTDIR 'photo') -File -ErrorAction SilentlyContinue).Count
    $afterVideo = @(Get-ChildItem -Path (Join-Path $DESTDIR 'video') -File -ErrorAction SilentlyContinue).Count
    $afterAudio = @(Get-ChildItem -Path (Join-Path $DESTDIR 'audio') -File -ErrorAction SilentlyContinue).Count
    
    $stats.photo += ($afterPhoto - $beforePhoto)
    $stats.video += ($afterVideo - $beforeVideo)
    $stats.audio += ($afterAudio - $beforeAudio)
    
    Write-Host ""
}

# Display summary
Write-Host "$($colors.Bright)===============================================================$($colors.Reset)"
Write-Host "$($colors.Bright)Summary:$($colors.Reset)"
Write-Host "$($colors.Bright)---------------------------------------------------------------$($colors.Reset)"
Write-Host "  Photos:      $($colors.Cyan)$($stats.photo)$($colors.Reset) symlinks created"
Write-Host "  Videos:      $($colors.Cyan)$($stats.video)$($colors.Reset) symlinks created"
Write-Host "  Audio:       $($colors.Cyan)$($stats.audio)$($colors.Reset) symlinks created"
Write-Host "  Total:       $($colors.Cyan)$($stats.photo + $stats.video + $stats.audio)$($colors.Reset) symlinks"
if ($stats.warnings -gt 0) {
    Write-Host "  Warnings:    $($colors.Yellow)$($stats.warnings)$($colors.Reset) (duplicate filenames)"
}
if ($stats.errors -gt 0) {
    Write-Host "  Errors:      $($colors.Red)$($stats.errors)$($colors.Reset) (permission or other issues)"
}
Write-Host "$($colors.Bright)===============================================================$($colors.Reset)"
Write-Host ""
if ($stats.errors -eq 0) {
    Write-Host "$($colors.Green)OK: Done! Symlinks created from $SRCDIR to $DESTDIR$($colors.Reset)"
} else {
    Write-Host "$($colors.Yellow)COMPLETED WITH ERRORS: $($stats.errors) file(s) failed to create symlinks$($colors.Reset)"
    Write-Host "$($colors.Yellow)Tip: Run as Administrator or enable Developer Mode in Windows Settings$($colors.Reset)"
}
Write-Host ""
