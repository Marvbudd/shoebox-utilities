# Shoebox Utilities Installation Script for Windows (PowerShell)
#
# This script creates symlinks in your user bin directory for all utilities
# compatible with Windows.
#
# Usage:
#   .\install.ps1 [-Uninstall]
#
# Options:
#   -Uninstall    Remove installed symlinks
#
# Note: Requires Windows 10/11 with Developer Mode enabled OR run as Administrator

param(
    [switch]$Uninstall
)

# Set strict mode
Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

# Installation directory (user's bin folder)
$InstallDir = Join-Path $env:USERPROFILE "bin"

# Get script directory
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path

# PowerShell utilities for Windows
$PowerShellUtils = @(
    @{Name = "mklinks"; Path = "mklinks\windows\mklinks.ps1"}
)

# Batch wrappers for Windows
$BatchUtils = @(
    @{Name = "mklinks"; Path = "mklinks\windows\mklinks.bat"}
)

# Node.js utilities (cross-platform)
$NodeUtils = @(
    "convert-numeric-months",
    "mkcol",
    "unsymlink"
)

# Test if we can create symlinks
function Test-SymlinkCapability {
    $testDir = Join-Path $env:TEMP "shoebox-symlink-test"
    $testFile = Join-Path $testDir "testfile.txt"
    $testLink = Join-Path $testDir "testlink.txt"
    
    try {
        # Create test directory and file
        New-Item -ItemType Directory -Path $testDir -Force | Out-Null
        "test" | Out-File -FilePath $testFile -Encoding ASCII
        
        # Try to create symlink
        New-Item -ItemType SymbolicLink -Path $testLink -Target $testFile -Force -ErrorAction Stop | Out-Null
        
        # Clean up
        Remove-Item -Path $testDir -Recurse -Force
        
        return $true
    }
    catch {
        # Clean up
        if (Test-Path $testDir) {
            Remove-Item -Path $testDir -Recurse -Force -ErrorAction SilentlyContinue
        }
        return $false
    }
}

# Uninstall function
function Uninstall-Utilities {
    Write-Host "Uninstalling Shoebox Utilities from $InstallDir..." -ForegroundColor Cyan
    Write-Host ""
    
    $removed = 0
    
    # Remove PowerShell utilities
    foreach ($util in $PowerShellUtils) {
        $target = Join-Path $InstallDir "$($util.Name).ps1"
        if (Test-Path $target) {
            Remove-Item $target -Force
            Write-Host "  Removed: $($util.Name).ps1" -ForegroundColor Green
            $removed++
        }
    }
    
    # Remove batch wrappers
    foreach ($util in $BatchUtils) {
        $target = Join-Path $InstallDir "$($util.Name).bat"
        if (Test-Path $target) {
            Remove-Item $target -Force
            Write-Host "  Removed: $($util.Name).bat" -ForegroundColor Green
            $removed++
        }
    }
    
    # Remove Node.js utilities
    foreach ($util in $NodeUtils) {
        # Remove .bat wrapper we created
        $target = Join-Path $InstallDir "$util.bat"
        if (Test-Path $target) {
            Remove-Item $target -Force
            Write-Host "  Removed: $util.bat" -ForegroundColor Green
            $removed++
        }
    }
    
    Write-Host ""
    if ($removed -eq 0) {
        Write-Host "No utilities were installed." -ForegroundColor Yellow
    }
    else {
        Write-Host "Successfully removed $removed utility(ies)." -ForegroundColor Green
    }
    
    exit 0
}

# Add directory to user PATH
function Add-ToPath {
    param([string]$Directory)
    
    # Get current user PATH
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    
    # Check if already in PATH
    if ($currentPath -split ';' | Where-Object { $_ -eq $Directory }) {
        return $false  # Already in PATH
    }
    
    # Add to PATH
    $newPath = "$currentPath;$Directory"
    [Environment]::SetEnvironmentVariable("Path", $newPath, "User")
    
    # Update current session
    $env:Path = "$env:Path;$Directory"
    
    return $true  # Added to PATH
}

# Install function
function Install-Utilities {
    Write-Host "Installing Shoebox Utilities for Windows..." -ForegroundColor Cyan
    Write-Host ""
    
    # Check symlink capability
    $canSymlink = Test-SymlinkCapability
    
    if (-not $canSymlink) {
        Write-Host "WARNING: Cannot create symlinks" -ForegroundColor Yellow
        Write-Host "  This may be because:" -ForegroundColor Yellow
        Write-Host "  - Developer Mode is not enabled" -ForegroundColor Yellow
        Write-Host "  - Script is not running as Administrator" -ForegroundColor Yellow
        Write-Host ""
        Write-Host "  Falling back to file copies instead of symlinks." -ForegroundColor Yellow
        Write-Host "  (Updates to utilities will require running install again)" -ForegroundColor Yellow
        Write-Host ""
    }
    
    # Create install directory if it doesn't exist
    if (-not (Test-Path $InstallDir)) {
        New-Item -ItemType Directory -Path $InstallDir -Force | Out-Null
        Write-Host "Created directory: $InstallDir" -ForegroundColor Green
    }
    
    $installed = 0
    $skipped = 0
    
    # Install PowerShell utilities (as symlinks or copies)
    foreach ($util in $PowerShellUtils) {
        $source = Join-Path $ScriptDir $util.Path
        $target = Join-Path $InstallDir "$($util.Name).ps1"
        
        if (Test-Path $source) {
            # Remove existing file/symlink
            if (Test-Path $target) {
                Remove-Item $target -Force
            }
            
            if ($canSymlink) {
                # Create symlink
                New-Item -ItemType SymbolicLink -Path $target -Target $source -Force | Out-Null
                Write-Host "  Installed: $($util.Name).ps1 (symlink)" -ForegroundColor Green
            }
            else {
                # Copy file
                Copy-Item $source $target -Force
                Write-Host "  Installed: $($util.Name).ps1 (copy)" -ForegroundColor Green
            }
            $installed++
        }
        else {
            Write-Host "  Skipped: $($util.Name).ps1 (not found)" -ForegroundColor Yellow
            $skipped++
        }
    }
    
    # Install batch wrappers
    foreach ($util in $BatchUtils) {
        $source = Join-Path $ScriptDir $util.Path
        $target = Join-Path $InstallDir "$($util.Name).bat"
        
        if (Test-Path $source) {
            # Remove existing file/symlink
            if (Test-Path $target) {
                Remove-Item $target -Force
            }
            
            if ($canSymlink) {
                # Create symlink
                New-Item -ItemType SymbolicLink -Path $target -Target $source -Force | Out-Null
                Write-Host "  Installed: $($util.Name).bat (symlink)" -ForegroundColor Green
            }
            else {
                # Copy file
                Copy-Item $source $target -Force
                Write-Host "  Installed: $($util.Name).bat (copy)" -ForegroundColor Green
            }
            $installed++
        }
        else {
            Write-Host "  Skipped: $($util.Name).bat (not found)" -ForegroundColor Yellow
            $skipped++
        }
    }
    
    # Install Node.js utilities (create .bat wrappers)
    foreach ($util in $NodeUtils) {
        $source = Join-Path $ScriptDir "$util\$util"
        $target = Join-Path $InstallDir "$util.bat"
        
        if (Test-Path $source) {
            # Create .bat wrapper that calls node
            $wrapper = @"
@echo off
node "$source" %*
"@
            $wrapper | Out-File -FilePath $target -Encoding ASCII -Force
            Write-Host "  Installed: $util.bat (wrapper)" -ForegroundColor Green
            $installed++
        }
        else {
            Write-Host "  Skipped: $util (not found)" -ForegroundColor Yellow
            $skipped++
        }
    }
    
    Write-Host ""
    Write-Host "Installation complete!" -ForegroundColor Green
    Write-Host "  Installed: $installed utility(ies)" -ForegroundColor Green
    if ($skipped -gt 0) {
        Write-Host "  Skipped: $skipped utility(ies)" -ForegroundColor Yellow
    }
    Write-Host ""
    
    # Check and add to PATH
    $currentPath = [Environment]::GetEnvironmentVariable("Path", "User")
    if ($currentPath -notlike "*$InstallDir*") {
        Write-Host "Adding $InstallDir to your PATH..." -ForegroundColor Cyan
        
        try {
            $added = Add-ToPath $InstallDir
            
            if ($added) {
                Write-Host ""
                Write-Host "✓ Successfully added to PATH" -ForegroundColor Green
                Write-Host ""
                Write-Host "Please restart your terminal/command prompt for PATH changes to take effect." -ForegroundColor Yellow
                Write-Host "After restarting, you can use the utilities from anywhere!" -ForegroundColor Green
                Write-Host "Try running: mklinks.bat --help" -ForegroundColor Cyan
            }
        }
        catch {
            Write-Host ""
            Write-Host "⚠ Could not automatically add to PATH" -ForegroundColor Yellow
            Write-Host ""
            Write-Host "To add manually:" -ForegroundColor Yellow
            Write-Host "  1. Open System Properties > Advanced > Environment Variables" -ForegroundColor Yellow
            Write-Host "  2. Under 'User variables', select 'Path' and click Edit" -ForegroundColor Yellow
            Write-Host "  3. Click New and add: $InstallDir" -ForegroundColor Yellow
            Write-Host "  4. Click OK on all dialogs" -ForegroundColor Yellow
            Write-Host "  5. Restart your terminal" -ForegroundColor Yellow
        }
    }
    else {
        Write-Host "✓ $InstallDir is already in your PATH" -ForegroundColor Green
        Write-Host ""
        Write-Host "You can now use the utilities from anywhere!" -ForegroundColor Green
        Write-Host "Try running: mklinks.bat --help" -ForegroundColor Cyan
    }
}

# Main script
if ($Uninstall) {
    Uninstall-Utilities
}
else {
    Install-Utilities
}
