#!/usr/bin/env bash
set -euo pipefail

TOOLKIT_VERSION="1.1.3"
echo "sh-scripts-linux toolkit Version: $TOOLKIT_VERSION"
echo "=== sh-scripts-linux Setup Starting ==="

# ===============================
# CONFIG
# ===============================
REPO_USER="therajatshahare"
REPO_NAME="sh-scripts-linux"
BRANCH="main"

BASE_RAW="https://raw.githubusercontent.com/$REPO_USER/$REPO_NAME/$BRANCH"

# Target directory
TARGET_DIR="$HOME/.local/bin"

# Complete Script list (including utilities & python fallbacks)
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
encrypt
insta_fallback.py
toolkit-help
update-scripts
toolkit-uninstall
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
        echo "  ✔ $script"
    else
        echo "  ✖ Failed: $script"
    fi
done

# ===============================
# ADD TO PATH & ENHANCE SHELL CONFIG
# ===============================
echo ""
echo "Configuring shell environment..."

if [[ "$SHELL" == */zsh ]]; then
    SHELL_CONFIG="$HOME/.zshrc"
else
    SHELL_CONFIG="$HOME/.bashrc"
fi

# Ensure PATH is updated
if [[ ":$PATH:" != *":$TARGET_DIR:"* ]]; then
    echo "" >> "$SHELL_CONFIG"
    echo "# sh-scripts-linux toolkit PATH" >> "$SHELL_CONFIG"
    echo "export PATH=\"$TARGET_DIR:\$PATH\"" >> "$SHELL_CONFIG"
    echo "✔ PATH updated in $SHELL_CONFIG"
else
    echo "✔ PATH already configured"
fi

# Configure shell-specific productivity enhancements
if [[ "$SHELL_CONFIG" == */.bashrc ]]; then
    if ! grep -q "history-search-backward" "$SHELL_CONFIG"; then
        cat << 'EOF' >> "$SHELL_CONFIG"

# sh-scripts-linux: Smart History Search (Type prefix and use Up/Down arrows)
bind '"\e[A": history-search-backward'
bind '"\e[B": history-search-forward'
EOF
        echo "✔ Configured Bash smart history search"
    fi
elif [[ "$SHELL_CONFIG" == */.zshrc ]]; then
    # Setup zsh-autosuggestions
    AUTOSUGGEST_DIR="$HOME/.zsh/zsh-autosuggestions"
    if [ ! -d "$AUTOSUGGEST_DIR" ]; then
        echo "[*] Installing zsh-autosuggestions..."
        git clone https://github.com/zsh-users/zsh-autosuggestions.git "$AUTOSUGGEST_DIR" >/dev/null 2>&1 || true
    fi

    if ! grep -q "zsh-autosuggestions.zsh" "$SHELL_CONFIG"; then
        cat << 'EOF' >> "$SHELL_CONFIG"

# sh-scripts-linux: Zsh Autosuggestions
if [ -f "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh" ]; then
    source "$HOME/.zsh/zsh-autosuggestions/zsh-autosuggestions.zsh"
fi
EOF
        echo "✔ Configured Zsh command autosuggestions"
    fi
fi

# Configure fastfetch (with neofetch fallback) on terminal startup
if ! grep -q "sh-scripts-linux: Startup system info" "$SHELL_CONFIG"; then
    cat << 'EOF' >> "$SHELL_CONFIG"

# sh-scripts-linux: Startup system info
if command -v fastfetch >/dev/null 2>&1; then
    fastfetch
elif command -v neofetch >/dev/null 2>&1; then
    neofetch
fi
EOF
    echo "✔ Configured startup system info display"
fi

# ===============================
# INSTALL SYSTEM DEPENDENCIES
# ===============================
echo ""
echo "Detecting package manager and installing system dependencies..."

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
    echo "⚠ Unsupported package manager. Please install dependencies manually."
    PM=""
fi

install_pkg() {
    local cmd_name="$1"
    shift
    if command -v "$cmd_name" >/dev/null 2>&1; then
        echo "  ✔ $cmd_name already installed"
        return 0
    fi

    echo "  [*] Installing $cmd_name..."
    case "$PM" in
        apt) sudo apt install -y "$@" ;;
        dnf) sudo dnf install -y "$@" ;;
        pacman) sudo pacman -S --noconfirm "$@" ;;
        zypper) sudo zypper install -y "$@" ;;
        apk) sudo apk add "$@" ;;
    esac
}

install_fetch_tool() {
    if command -v fastfetch >/dev/null 2>&1; then
        echo "  ✔ fastfetch already installed"
        return 0
    fi

    echo "  [*] Installing fastfetch..."
    case "$PM" in
        apt)    sudo apt install -y fastfetch >/dev/null 2>&1 || true ;;
        dnf)    sudo dnf install -y fastfetch >/dev/null 2>&1 || true ;;
        pacman) sudo pacman -S --noconfirm fastfetch >/dev/null 2>&1 || true ;;
        zypper) sudo zypper install -y fastfetch >/dev/null 2>&1 || true ;;
        apk)    sudo apk add fastfetch >/dev/null 2>&1 || true ;;
    esac

    if command -v fastfetch >/dev/null 2>&1; then
        echo "  ✔ fastfetch installed"
        return 0
    fi

    echo "  ⚠ fastfetch not found in repo; installing neofetch instead..."
    if command -v neofetch >/dev/null 2>&1; then
        echo "  ✔ neofetch already installed"
        return 0
    fi

    case "$PM" in
        apt)    sudo apt install -y neofetch >/dev/null 2>&1 || true ;;
        dnf)    sudo dnf install -y neofetch >/dev/null 2>&1 || true ;;
        pacman) sudo pacman -S --noconfirm neofetch >/dev/null 2>&1 || true ;;
        zypper) sudo zypper install -y neofetch >/dev/null 2>&1 || true ;;
        apk)    sudo apk add neofetch >/dev/null 2>&1 || true ;;
    esac

    if command -v neofetch >/dev/null 2>&1; then
        echo "  ✔ neofetch installed"
    else
        echo "  ⚠ Neither fastfetch nor neofetch could be installed; skipping."
    fi
}

if [ -n "$PM" ]; then
    case "$PM" in
        apt)
            install_pkg ffmpeg ffmpeg
            install_pkg aria2c aria2
            install_pkg python3 python3 python3-pip
            install_pkg pipx pipx
            install_pkg exiftool libimage-exiftool-perl
            install_pkg gpg gnupg
            install_pkg curl curl
            install_pkg git git
            install_fetch_tool
            ;;
        dnf)
            install_pkg ffmpeg ffmpeg
            install_pkg aria2c aria2
            install_pkg python3 python3 python3-pip
            install_pkg pipx pipx
            install_pkg exiftool perl-Image-ExifTool
            install_pkg gpg gnupg2
            install_pkg curl curl
            install_pkg git git
            install_fetch_tool
            ;;
        pacman)
            install_pkg ffmpeg ffmpeg
            install_pkg aria2c aria2
            install_pkg python3 python python-pip
            install_pkg pipx python-pipx
            install_pkg exiftool perl-image-exiftool
            install_pkg gpg gnupg
            install_pkg curl curl
            install_pkg git git
            install_fetch_tool
            ;;
        zypper)
            install_pkg ffmpeg ffmpeg
            install_pkg aria2c aria2
            install_pkg python3 python3 python3-pip
            install_pkg pipx python3-pipx
            install_pkg exiftool perl-Image-ExifTool
            install_pkg gpg gnupg
            install_pkg curl curl
            install_pkg git git
            install_fetch_tool
            ;;
        apk)
            install_pkg ffmpeg ffmpeg
            install_pkg aria2c aria2
            install_pkg python3 python3 py3-pip
            install_pkg pipx py3-pipx
            install_pkg exiftool perl-image-exiftool
            install_pkg gpg gnupg
            install_pkg curl curl
            install_pkg git git
            install_fetch_tool
            ;;
    esac
fi

# Ensure pipx PATH
if command -v pipx >/dev/null 2>&1; then
    pipx ensurepath >/dev/null 2>&1 || true
fi

# -------------------------------
# Install yt-dlp (LATEST)
# -------------------------------
echo ""
echo "Installing/updating yt-dlp..."

if command -v pipx >/dev/null 2>&1; then
    pipx install yt-dlp >/dev/null 2>&1 || pipx upgrade yt-dlp || true
else
    pip3 install --user -U yt-dlp >/dev/null 2>&1 || true
fi

# -------------------------------
# Install instaloader (LATEST)
# -------------------------------
echo ""
echo "Installing/updating instaloader..."

if command -v pipx >/dev/null 2>&1; then
    pipx install instaloader >/dev/null 2>&1 || pipx upgrade instaloader || true
else
    pip3 install --user -U instaloader >/dev/null 2>&1 || true
fi

# -------------------------------
# Install Python libraries
# -------------------------------
echo ""
echo "Installing Python packages..."

pip3 install --user --upgrade pip >/dev/null 2>&1 || true
pip3 install --user lyricsgenius >/dev/null 2>&1 || true

# ===============================
# DONE
# ===============================
echo ""
echo "=== Setup Complete ==="
echo ""
echo "Restart your terminal or run:"
echo "  source ~/.bashrc  (or ~/.zshrc depending on your shell)"
echo ""
echo "Try running:"
echo "  fastfetch || neofetch"
echo "  toolkit-help"
