#!/usr/bin/env bash
set -euo pipefail

TOOLKIT_VERSION="1.1.7"
echo "sh-scripts-linux toolkit Version: $TOOLKIT_VERSION"
echo "=== sh-scripts-linux Setup Starting ==="

# ===============================
# CONFIG
# ===============================
REPO_USER="therajatshahare"
REPO_NAME="sh-scripts-linux"
BRANCH="main"

BASE_RAW="https://raw.githubusercontent.com/$REPO_USER/$REPO_NAME/$BRANCH"
TARGET_DIR="$HOME/.local/bin"

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
# CREATE DIRECTORY & DOWNLOAD
# ===============================
mkdir -p "$TARGET_DIR"
echo "Using install directory: $TARGET_DIR"
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
# SHELL CONFIG & ENHANCEMENTS
# ===============================
echo ""
echo "Configuring shell environment..."

if [[ "${SHELL:-}" == */zsh ]]; then
    SHELL_CONFIG="$HOME/.zshrc"
else
    SHELL_CONFIG="$HOME/.bashrc"
fi

touch "$SHELL_CONFIG"

if [[ ":$PATH:" != *":$TARGET_DIR:"* ]] && ! grep -qF "$TARGET_DIR" "$SHELL_CONFIG"; then
    cat << EOF >> "$SHELL_CONFIG"

# sh-scripts-linux toolkit PATH
export PATH="$TARGET_DIR:\$PATH"
EOF
    echo "✔ PATH updated in $SHELL_CONFIG"
else
    echo "✔ PATH already configured"
fi

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
    AUTOSUGGEST_DIR="$HOME/.zsh/zsh-autosuggestions"
    if [ ! -d "$AUTOSUGGEST_DIR" ] && command -v git >/dev/null 2>&1; then
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
# SYSTEM DEPENDENCIES
# ===============================
echo ""
echo "Detecting package manager and installing system dependencies..."

PM=""
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
        apt)    sudo apt install -y "$@" || true ;;
        dnf)    sudo dnf install -y "$@" || true ;;
        pacman) sudo pacman -S --noconfirm "$@" || true ;;
        zypper) sudo zypper install -y "$@" || true ;;
        apk)    sudo apk add "$@" || true ;;
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
    install_pkg ffmpeg ffmpeg
    install_pkg aria2c aria2
    install_pkg python3 python3
    install_pkg pipx pipx
    install_pkg curl curl
    install_pkg git git
    install_pkg unzip unzip

    case "$PM" in
        apt)
            install_pkg exiftool libimage-exiftool-perl
            install_pkg gpg gnupg
            ;;
        dnf|zypper)
            install_pkg exiftool perl-Image-ExifTool
            install_pkg gpg gnupg2
            ;;
        pacman|apk)
            install_pkg exiftool perl-image-exiftool
            install_pkg gpg gnupg
            ;;
    esac

    install_fetch_tool
fi

if command -v pipx >/dev/null 2>&1; then
    pipx ensurepath >/dev/null 2>&1 || true
fi

# -------------------------------
# Install Deno (JS runtime for yt-dlp)
# -------------------------------
echo ""
echo "Installing/checking deno..."

if command -v deno >/dev/null 2>&1; then
    echo "  ✔ deno already installed ($(deno --version | head -n1))"
elif [ -x "$HOME/.deno/bin/deno" ]; then
    echo "  ✔ deno found in ~/.deno/bin ($("$HOME/.deno/bin/deno" --version | head -n1))"
else
    curl -fsSL https://deno.land/install.sh | sh -s -- -y >/dev/null 2>&1 || true
    if command -v deno >/dev/null 2>&1 || [ -x "$HOME/.deno/bin/deno" ]; then
        echo "  ✔ deno installed"
    else
        echo "  ⚠ Could not install deno automatically; yt-dlp may warn about missing JS runtime."
    fi
fi

# -------------------------------
# Install/update yt-dlp from PyPI (pipx / pip3)
# -------------------------------
echo ""
echo "Installing/updating yt-dlp from PyPI..."

# Remove outdated apt yt-dlp package so pipx/pip3 takes priority
if command -v dpkg >/dev/null 2>&1 && dpkg -s yt-dlp >/dev/null 2>&1; then
    echo "  [*] Removing outdated apt yt-dlp package..."
    sudo apt remove -y yt-dlp >/dev/null 2>&1 || true
fi

if command -v pipx >/dev/null 2>&1; then
    pipx install --force "yt-dlp[default]" >/dev/null 2>&1 || pipx upgrade yt-dlp >/dev/null 2>&1 || true
elif command -v pip3 >/dev/null 2>&1; then
    pip3 install --user -U --break-system-packages "yt-dlp[default]" >/dev/null 2>&1 || pip3 install --user -U "yt-dlp[default]" >/dev/null 2>&1 || true
fi

if ! command -v yt-dlp >/dev/null 2>&1 && [ ! -x "$HOME/.local/share/pipx/venvs/yt-dlp/bin/yt-dlp" ]; then
    echo "  [*] Fallback: downloading lightweight Unix zipimport binary via aria2c/curl..."
    if command -v aria2c >/dev/null 2>&1; then
        aria2c -x 8 -s 8 -k 1M --allow-overwrite=true \
            "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp" \
            --dir "$TARGET_DIR" -o yt-dlp >/dev/null 2>&1 || true
    else
        curl -fsSL "https://github.com/yt-dlp/yt-dlp/releases/latest/download/yt-dlp" -o "$TARGET_DIR/yt-dlp" || true
    fi
    [ -f "$TARGET_DIR/yt-dlp" ] && chmod +x "$TARGET_DIR/yt-dlp"
fi

if command -v yt-dlp >/dev/null 2>&1; then
    echo "  ✔ yt-dlp ready ($(yt-dlp --version))"
elif [ -x "$HOME/.local/share/pipx/venvs/yt-dlp/bin/yt-dlp" ]; then
    echo "  ✔ yt-dlp installed via pipx ($("$HOME/.local/share/pipx/venvs/yt-dlp/bin/yt-dlp" --version))"
else
    echo "  ✖ Failed to install yt-dlp"
fi

# ===============================
# PYTHON TOOLS & LIBRARIES
# ===============================
echo ""
echo "Installing/updating instaloader..."

if command -v pipx >/dev/null 2>&1; then
    pipx install instaloader >/dev/null 2>&1 || pipx upgrade instaloader >/dev/null 2>&1 || true
elif command -v pip3 >/dev/null 2>&1; then
    pip3 install --user -U --break-system-packages instaloader >/dev/null 2>&1 || pip3 install --user -U instaloader >/dev/null 2>&1 || true
fi

echo ""
echo "Installing Python packages..."
if command -v pip3 >/dev/null 2>&1; then
    pip3 install --user --upgrade --break-system-packages pip lyricsgenius >/dev/null 2>&1 || pip3 install --user --upgrade pip lyricsgenius >/dev/null 2>&1 || true
fi

echo ""
echo "=== Setup Complete ==="
echo ""
echo "Restart your terminal or run:"
echo "  source ~/.bashrc  (or ~/.zshrc depending on your shell)"
echo ""
echo "Try running:"
echo "  fastfetch || neofetch"
echo "  yt-dlp --version"
echo "  toolkit-help"
