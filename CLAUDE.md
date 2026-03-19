# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Cross-platform personal dotfiles for EndeavourOS + Hyprland (Linux) and macOS. Deployment is via symlinks managed by `sync.sh` from `~/Development/dotfiles/` to `$HOME`. The shell config is split into shared and platform-specific modules; `sync.sh` auto-detects the OS and only deploys relevant files.

## Repository Structure

### Shell (modular)

- **`.zshrc`** — Thin entrypoint: sources shared → platform → p10k → local
- **`.zshrc.shared`** — oh-my-zsh, aliases, FZF, direnv, zoxide, shared PATH/env (both platforms)
- **`.zshrc.linux`** — NVM/p10k/zsh-plugins from `/usr/share/`, Hyprland aliases, Android SDK, jenv (Linux only)
- **`.zshrc.darwin`** — Homebrew setup, NVM/p10k/zsh-plugins from Homebrew paths (macOS only)
- **`.zshrc.local`** — Machine-specific secrets/overrides (untracked)

### Configs

- **`.config/hypr/hyprland.conf`** — Hyprland compositor config (Linux only)
- **`.config/waybar/`** — Status bar (Linux only)
- **`.config/mako/config`** — Notification daemon (Linux only)
- **`.config/rofi/`** — App launcher (Linux only)
- **`.config/wofi/`** — Alternative Wayland launcher (Linux only)
- **`.config/hyprwhspr/config.json`** — HyprWhisper speech-to-text (Linux only)
- **`.config/kitty/kitty.conf`** — Terminal emulator (both platforms)
- **`iterm2/catppuccin-mocha.json`** — iTerm2 Dynamic Profile with Catppuccin Mocha theme (macOS only)
- **`.vimrc`** — Vim with vim-plug (both platforms)
- **`.gitconfig`** — Git with SSH commit signing (both platforms)
- **`.psqlrc`** — PostgreSQL client (both platforms)

### Scripts

- **`sync.sh`** — Config sync tool (status/diff/pull/push/link) — platform-aware
- **`setup-mac.sh`** — One-time macOS dependency installer (Homebrew, shell tools, fonts)
- **`setup-hooks.sh`** — Activates git hooks (run once after clone)
- **`bin/`** — Custom scripts (rofi-apps, fix-gpg-lock, chrome-x11)
- **`.githooks/pre-commit`** — Secret scanner (blocks commits with credentials)

## Sync Tool

The repo and live system configs may differ. Always check with `./sync.sh status` before assuming they match.

| Command | Description |
|---------|-------------|
| `./sync.sh status` | Show drift between repo and live system |
| `./sync.sh diff [file]` | Colored diffs (repo vs live) |
| `./sync.sh pull` | Copy live → repo (scans for secrets, asks confirmation) |
| `./sync.sh push` | Copy repo → live (backs up to `~/.dotfiles-backup/` first) |
| `./sync.sh link` | Replace live copies with symlinks to repo |

### Platform-Aware File Mapping

`sync.sh` detects the OS via `uname -s` and merges platform-specific maps into the shared maps.

**Shared (both):** `.zshrc`, `.zshrc.shared`, `.zprofile`, `.p10k.zsh`, `.vimrc`, `.gitconfig`, `.psqlrc`, `.config/kitty`

**Linux only:** `.zshrc.linux`, `.config/hyprwhspr/config.json`, `.config/hypr`, `.config/waybar`, `.config/mako`, `.config/rofi`, `.config/wofi`

**macOS only:** `.zshrc.darwin`, `iterm2/catppuccin-mocha.json` → iTerm2 DynamicProfiles

## Key Conventions

- **Color scheme:** Catppuccin-Mocha across Waybar, Rofi, Mako, and Vim. Key colors: background `#1e1e2e`, text `#cdd6f4`, accent blue `#89b4fa`.
- **Symlink deployment:** Configs can be symlinked via `./sync.sh link`. When symlinked, changes in repo are live immediately.
- **Secrets:** Not stored in this repo. Tokens go in `~/.zshrc.local` (not tracked). A pre-commit hook scans for credential patterns. Exempt lines with `# nosecret`.
- **Shell aliases to know:** `ls`→eza, `cd`→zoxide, `v`→nvim, `dots`→sync status, `gpom`→git pull origin main, `ti`/`tp`/`taaa`→terraform init/plan/apply.
- **Cross-platform:** All shell config shared across Linux/macOS lives in `.zshrc.shared`. Platform-specific tools/paths go in `.zshrc.linux` or `.zshrc.darwin`.

## When Editing Configs

- Hyprland keybindings use `$mainMod = SUPER`. Reload with `hyprctl reload`. (Linux only)
- Waybar style uses CSS; config is JSON (not JSON5 — no trailing commas). (Linux only)
- Rofi uses `.rasi` format. The theme file is at `themes/dark.rasi` referenced via `@theme "dark"`. (Linux only)
- After editing `.zshrc*`, changes apply on new shell sessions (`source ~/.zshrc` to test).
- The pre-commit hook will block commits containing secrets. Add `# nosecret` to exempt false positives.
