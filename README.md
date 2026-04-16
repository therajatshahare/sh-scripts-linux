# ⚙️ Cmd-Scripts Toolkit (Linux)

A personal **Linux CLI toolkit** for everyday automation, media handling, and utilities — install everything with **one command**.

---

## 🚀 One-Line Install

```bash
curl -fsSL https://raw.githubusercontent.com/therajatshahare/sh-scripts-linux/main/install.sh | bash
```

> ⚠️ Restart your terminal or run `source ~/.bashrc` after installation.

---

## 📂 What This Does

- Installs all scripts to:

  ```
  ~/.local/bin
  ```

- Makes scripts executable
- Adds directory to PATH (if not already added)
- Installs required dependencies:

  - yt-dlp
  - ffmpeg
  - aria2
  - python3
  - instaloader
  - lyricsgenius

---

## 🧰 Available Commands

### 🎥 Media / YouTube

```bash
ytvideo
vytvideo
ytaudio
```

---

### 🎵 Metadata / Lyrics

```bash
showmeta
showformat
showlyrics
```

---

### 📁 File Utilities

```bash
folders
hide
unhide
exifpic
```

---

### ⚡ System Utilities

```bash
update
upgrade
aria
```

---

### 📸 Instagram

```bash
insta <username> full
insta <username> update
```

---

### 📖 Help System

Get help directly in terminal:

```bash
toolkit-help
```

Command-specific help:

```bash
toolkit-help ytvideo
toolkit-help insta
toolkit-help exifpic
```

---

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

---

## 📦 Project Structure

```
sh-scripts-linux/
│
├── install.sh
└── scripts/
    ├── ytvideo
    ├── vytvideo
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
    ├── toolkit-help
    └── lyrics.py
```

---

## 🧠 Design Philosophy

- One-command setup
- No root required (installs to user space)
- Native Linux CLI design (no wrappers)
- Modular and extensible
- Minimal dependencies

---

## ⚠️ Notes

- Designed for Linux (Ubuntu, Fedora, Arch, etc.)
- Works with bash and zsh
- Some features depend on external tools (ffmpeg, yt-dlp, etc.)

---

## ⭐ Author

Rajat Shahare  
https://github.com/therajatshahare

---

## 🛠️ License

Personal toolkit — use freely and modify as needed.
