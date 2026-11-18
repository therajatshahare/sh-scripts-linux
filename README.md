# ⚙️ sh-scripts-linux toolkit

A personal **Linux CLI toolkit** for everyday automation, media handling, and utilities — install everything with **one command**.

## 🚀 One-Line Install

```bash
curl -fsSL https://raw.githubusercontent.com/therajatshahare/sh-scripts-linux/main/install.sh | bash
```

> ⚠️ Restart your terminal or run `source ~/.bashrc` (or `source ~/.zshrc`) after installation.

## 📂 What This Does

- Installs all scripts to:
  ```
  ~/.local/bin
  ```
- Makes all scripts executable
- Automatically adds the install directory to your shell `PATH` (if not already present)
- Installs required system and Python dependencies:
  - `yt-dlp`
  - `ffmpeg`
  - `aria2`
  - `python3`
  - `instaloader`
  - `lyricsgenius`
  - `exiftool`
  - `gnupg`

## 🧰 Available Commands

### 🎥 Media / YouTube
```bash
ytvideo [res] [filename] <url>
vytvideo [res] [filename] <url>
hytvideo [res] [filename] <url>
ytaudio <url>
```

### 🎵 Metadata / Lyrics
```bash
showmeta <file>
showformat <url>
showlyrics <file>
```

### 📁 File & Security Utilities
```bash
folders
hide <file>
unhide <file>
exifpic <date> [file]
encrypt <target> [encrypt/decrypt]
```

### ⚡ System Utilities
```bash
update
upgrade
aria <url> [options]
```

### 📸 Instagram
```bash
insta <username> full
insta <username> update
```

### 📖 Help System
Get help directly in the terminal:
```bash
toolkit-help
```

## 🎵 Lyrics Setup (Required for lyrics features)

Set your Genius API token:

```bash
export GENIUS_TOKEN="your_token_here"
```

To make it permanent:

```bash
echo 'export GENIUS_TOKEN="your_token_here"' >> ~/.bashrc
source ~/.bashrc
```

## 📦 Project Structure

```
sh-scripts-linux/
│
├── README.md
├── LICENSE
├── install.sh
└── scripts/
    ├── ytvideo
    ├── vytvideo
    ├── hytvideo
    ├── ytaudio
    ├── showmeta
    ├── showlyrics
    ├── showformat
    ├── hide
    ├── unhide
    ├── update
    ├── upgrade
    ├── aria
    ├── exifpic
    ├── folders
    ├── insta
    ├── encrypt
    ├── insta_fallback.py
    ├── toolkit-help
    ├── update-scripts
    ├── toolkit-uninstall
    └── lyrics.py
```

### 🔁 Toolkit Management

#### Update Toolkit
Update all scripts to the latest version from GitHub:
```bash
update-scripts
```
- Pulls the latest version from GitHub
- Reinstalls all scripts and updates permissions

#### Uninstall Toolkit
Remove all installed scripts and clean up configuration:
```bash
toolkit-uninstall
```
- Removes scripts from `~/.local/bin`
- Cleans PATH entries from shell configuration files (`.bashrc` / `.zshrc`)
- Optionally removes `yt-dlp` and `instaloader` packages installed via `pipx`

## 🧠 Design Philosophy

- One-command setup
- No root required for scripts (installs to user space in `~/.local/bin`)
- Native Linux CLI design (pure Bash/Python wrappers)
- Modular, lightweight, and extensible
- Minimal external friction

## ⚠️ Notes

- Designed for Linux distributions (Ubuntu, Fedora, Arch, Alpine, openSUSE, etc.)
- Fully compatible with both Bash and Zsh shells
- Relies on standard external CLI tools (`ffmpeg`, `yt-dlp`, `aria2c`, `exiftool`, `gpg`)

## ⭐ Author

**Rajat Shahare**  
[GitHub Profile](https://github.com/therajatshahare)

## 🛠️ License

This project is licensed under the [MIT License](LICENSE).
