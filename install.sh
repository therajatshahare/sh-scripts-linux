#!/bin/bash

set -e

TOOLKIT_VERSION="1.0.0"
echo "Cmd-Scripts Linux Version: $TOOLKIT_VERSION"
echo "=== Cmd-Scripts Setup Starting ==="

# ===============================
# CONFIG
# ===============================
REPO_USER="therajatshahare"
REPO_NAME="sh-scripts-linux"
BRANCH="main"

BASE_RAW="https://raw.githubusercontent.com/$REPO_USER/$REPO_NAME/$BRANCH"

# Target directory (Linux standard)
TARGET_DIR="$HOME/.local/bin"

# Script list
SCRIPTS=(
ytvideo
vytvideo
ytaudio
showmeta
showlyrics
showformat
hide
unhide
update
upgrade
aria
exifpic
folders
insta
toolkit-help
lyrics.py
)

# ===============================
# CREATE DIRECTORY
# ===============================
mkdir -p "$TARGET_DIR"
echo "Using install directory: $TARGET_DIR"

# ===============================
# DOWNLOAD SCRIPTS
# ===============================
echo ""
echo "Downloading scripts..."

for script in "${SCRIPTS[@]}"; do
    url="$BASE_RAW/scripts/$script"
    out="$TARGET_DIR/$script"

    if curl -fsSL "$url" -o "$out"; then
        chmod +x "$out"
        echo "✔ $script"
    else
        echo "✖ Failed: $script"
    fi
done

# ===============================
# ADD TO PATH (if needed)
# ===============================
if [[ ":$PATH:" != *":$TARGET_DIR:"* ]]; then
    echo ""
    echo "Adding $TARGET_DIR to PATH..."

    SHELL_CONFIG=""

    if [ -n "$ZSH_VERSION" ]; then
        SHELL_CONFIG="$HOME/.zshrc"
    else
        SHELL_CONFIG="$HOME/.bashrc"
    fi

    echo "" >> "$SHELL_CONFIG"
    echo "# Cmd-Scripts PATH" >> "$SHELL_CONFIG"
    echo "export PATH=\"$TARGET_DIR:\$PATH\"" >> "$SHELL_CONFIG"

    echo "✔ PATH updated in $SHELL_CONFIG"
    echo "👉 Run: source $SHELL_CONFIG"
else
    echo ""
    echo "PATH already configured"
fi

# ===============================
# INSTALL DEPENDENCIES
# ===============================
echo ""
echo "Installing dependencies..."

install_pkg() {
    if command -v "$1" >/dev/null 2>&1; then
        echo "$1 already installed"
        return
    fi

    case "$PM" in
        apt) sudo apt install -y "$2" ;;
        dnf) sudo dnf install -y "$2" ;;
        pacman) sudo pacman -S --noconfirm "$2" ;;
        zypper) sudo zypper install -y "$2" ;;
        apk) sudo apk add "$2" ;;
    esac
}

# Detect package manager
if command -v apt >/dev/null 2>&1; then
    PM="apt"
    sudo apt update
elif command -v dnf >/dev/null 2>&1; then
    PM="dnf"
elif command -v pacman >/dev/null 2>&1; then
    PM="pacman"
elif command -v zypper >/dev/null 2>&1; then
    PM="zypper"
elif command -v apk >/dev/null 2>&1; then
    PM="apk"
else
    echo "⚠ Unsupported package manager. Install dependencies manually."
    PM=""
fi

# Install core tools
if [ -n "$PM" ]; then
    install_pkg yt-dlp yt-dlp
    install_pkg ffmpeg ffmpeg
    install_pkg aria2c aria2
    install_pkg python3 python3
fi

# Python packages
echo ""
echo "Installing Python packages..."
pip3 install --user --upgrade pip >/dev/null 2>&1 || true
pip3 install --user lyricsgenius instaloader >/dev/null 2>&1 || true

# ===============================
# DONE
# ===============================
echo ""
echo "=== Setup Complete ==="
echo ""
echo "Restart terminal or run:"
echo "  source ~/.bashrc"
echo ""
echo "Try:"
echo "  toolkit-help"
