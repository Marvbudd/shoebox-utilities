#!/bin/bash

# Shoebox Utilities Installation Script for Linux and macOS
# 
# This script creates symlinks in ~/.local/bin for all utilities
# compatible with your operating system.
#
# Usage:
#   ./install.sh [--uninstall]
#
# Options:
#   --uninstall    Remove installed symlinks

set -e  # Exit on error

# Detect OS
OS=$(uname -s | tr '[:upper:]' '[:lower:]')
case "$OS" in
  linux*)
    OS_DIR="linux"
    ;;
  darwin*)
    OS_DIR="macos"
    ;;
  *)
    echo "Error: Unsupported operating system: $OS"
    echo "This script supports Linux and macOS only."
    echo "For Windows, please use install.bat instead."
    exit 1
    ;;
esac

# Installation directory (user's local bin)
INSTALL_DIR="${HOME}/.local/bin"

# Get the absolute path to this script's directory
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# List of bash utilities (organized by utility/OS/utility)
BASH_UTILS=(
  "changeprefix"
  "finddups"
  "mklinks"
  "resymlink"
)

# List of Node.js utilities (cross-platform, in utility root)
NODE_UTILS=(
  "convert-numeric-months"
  "mkcol"
  "unsymlink"
)

# Uninstall function
uninstall() {
  echo "Uninstalling Shoebox Utilities from ${INSTALL_DIR}..."
  
  REMOVED=0
  
  # Remove bash utility symlinks
  for util in "${BASH_UTILS[@]}"; do
    TARGET="${INSTALL_DIR}/${util}"
    if [ -L "$TARGET" ]; then
      rm "$TARGET"
      echo "  Removed: ${util}"
      REMOVED=$((REMOVED + 1))
    fi
  done
  
  # Remove Node.js utility symlinks
  for util in "${NODE_UTILS[@]}"; do
    TARGET="${INSTALL_DIR}/${util}"
    if [ -L "$TARGET" ]; then
      rm "$TARGET"
      echo "  Removed: ${util}"
      REMOVED=$((REMOVED + 1))
    fi
  done
  
  if [ $REMOVED -eq 0 ]; then
    echo "No utilities were installed."
  else
    echo ""
    echo "Successfully removed ${REMOVED} utility(ies)."
  fi
  
  exit 0
}

# Install function
install() {
  echo "Installing Shoebox Utilities for ${OS_DIR}..."
  echo ""
  
  # Create install directory if it doesn't exist
  if [ ! -d "$INSTALL_DIR" ]; then
    mkdir -p "$INSTALL_DIR"
    echo "Created directory: ${INSTALL_DIR}"
  fi
  
  INSTALLED=0
  SKIPPED=0
  
  # Install bash utilities
  for util in "${BASH_UTILS[@]}"; do
    SOURCE="${SCRIPT_DIR}/${util}/${OS_DIR}/${util}"
    TARGET="${INSTALL_DIR}/${util}"
    
    if [ -f "$SOURCE" ]; then
      # Remove existing symlink or file
      if [ -e "$TARGET" ] || [ -L "$TARGET" ]; then
        rm "$TARGET"
      fi
      
      # Create symlink
      ln -s "$SOURCE" "$TARGET"
      echo "  Installed: ${util}"
      INSTALLED=$((INSTALLED + 1))
    else
      echo "  Skipped: ${util} (not available for ${OS_DIR})"
      SKIPPED=$((SKIPPED + 1))
    fi
  done
  
  # Install Node.js utilities
  for util in "${NODE_UTILS[@]}"; do
    SOURCE="${SCRIPT_DIR}/${util}/${util}"
    TARGET="${INSTALL_DIR}/${util}"
    
    if [ -f "$SOURCE" ]; then
      # Check if it's executable (should have #!/usr/bin/env node)
      if [ -x "$SOURCE" ]; then
        # Remove existing symlink or file
        if [ -e "$TARGET" ] || [ -L "$TARGET" ]; then
          rm "$TARGET"
        fi
        
        # Create symlink
        ln -s "$SOURCE" "$TARGET"
        echo "  Installed: ${util}"
        INSTALLED=$((INSTALLED + 1))
      else
        echo "  Warning: ${util} is not executable, skipping"
        SKIPPED=$((SKIPPED + 1))
      fi
    else
      echo "  Skipped: ${util} (not found)"
      SKIPPED=$((SKIPPED + 1))
    fi
  done
  
  echo ""
  echo "Installation complete!"
  echo "  Installed: ${INSTALLED} utility(ies)"
  if [ $SKIPPED -gt 0 ]; then
    echo "  Skipped: ${SKIPPED} utility(ies)"
  fi
  echo ""
  
  # Check if install directory is in PATH
  if [[ ":$PATH:" != *":${INSTALL_DIR}:"* ]]; then
    echo "⚠️  WARNING: ${INSTALL_DIR} is not in your PATH"
    echo ""
    echo "To use these utilities, add this line to your shell profile:"
    echo ""
    
    # Detect shell and provide appropriate instructions
    if [ -n "$BASH_VERSION" ]; then
      echo "    echo 'export PATH=\"\${HOME}/.local/bin:\${PATH}\"' >> ~/.bashrc"
      echo "    source ~/.bashrc"
    elif [ -n "$ZSH_VERSION" ]; then
      echo "    echo 'export PATH=\"\${HOME}/.local/bin:\${PATH}\"' >> ~/.zshrc"
      echo "    source ~/.zshrc"
    else
      echo "    export PATH=\"\${HOME}/.local/bin:\${PATH}\""
      echo ""
      echo "Add this to your shell profile (.bashrc, .zshrc, etc.)"
    fi
    echo ""
  else
    echo "✓ ${INSTALL_DIR} is already in your PATH"
    echo ""
    echo "You can now use the utilities from anywhere!"
    echo "Try running: mklinks --help"
  fi
}

# Main script
if [ "$1" = "--uninstall" ]; then
  uninstall
else
  if [ -n "$1" ]; then
    echo "Error: Unknown option: $1"
    echo ""
    echo "Usage: $0 [--uninstall]"
    exit 1
  fi
  install
fi
