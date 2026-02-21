# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Overview

Personal dotfiles for an EndeavourOS + Hyprland (Wayland) desktop environment with NVIDIA GPU optimization. Deployment is via symlinks managed by `sync.sh` from `~/Development/dotfiles/` to `$HOME`.

## Repository Structure

- **`.config/hypr/hyprland.conf`** — Hyprland compositor config (NVIDIA env vars, dual-monitor layout, all keybindings)
- **`.config/waybar/`** — Status bar: `config` (JSON modules), `style.css` (Catppuccin-Mocha theme), `power-menu.sh`
- **`.config/mako/config`** — Notification daemon
- **`.config/rofi/`** — App launcher: `config.rasi` + `themes/dark.rasi`
- **`.config/wofi/`** — Alternative Wayland launcher
- **`.config/kitty/kitty.conf`** — Terminal emulator (minimal config)
- **`.zshrc`** — Shell config (oh-my-zsh, Powerlevel10k, aliases, tool integrations)
- **`.vimrc`** — Vim with vim-plug (NERDTree, FZF, Airline, language support)
- **`.gitconfig`** — Git with SSH commit signing
- **`.psqlrc`** — PostgreSQL client
- **`bin/`** — Custom scripts (rofi-apps, fix-gpg-lock, chrome-x11)
- **`sync.sh`** — Config sync tool (status/diff/pull/push/link)
- **`.githooks/pre-commit`** — Secret scanner (blocks commits with credentials)
- **`setup-hooks.sh`** — Activates git hooks (run once after clone)

## Sync Tool

The repo and live system configs may differ. Always check with `./sync.sh status` before assuming they match.

| Command | Description |
|---------|-------------|
| `./sync.sh status` | Show drift between repo and live system |
| `./sync.sh diff [file]` | Colored diffs (repo vs live) |
| `./sync.sh pull` | Copy live → repo (scans for secrets, asks confirmation) |
| `./sync.sh push` | Copy repo → live (backs up to `~/.dotfiles-backup/` first) |
| `./sync.sh link` | Replace live copies with symlinks to repo |

### File Mapping

The sync tool manages these paths:

**Files:** `.zshrc`, `.zprofile`, `.p10k.zsh`, `.vimrc`, `.gitconfig`, `.psqlrc` → `$HOME/`

**Directories:** `.config/hypr`, `.config/kitty`, `.config/waybar`, `.config/mako`, `.config/rofi`, `.config/wofi` → `$HOME/.config/`

## Key Conventions

- **Color scheme:** Catppuccin-Mocha is used consistently across Waybar, Rofi, Mako, and Vim (Palenight). Key colors: background `#1e1e2e`, text `#cdd6f4`, accent blue `#89b4fa`.
- **Symlink deployment:** Configs can be symlinked via `./sync.sh link`. When symlinked, changes in repo are live immediately.
- **Secrets:** Not stored in this repo. Tokens go in `~/.zshrc.local` (not tracked). A pre-commit hook scans for credential patterns. Exempt lines with `# nosecret`.
- **Shell aliases to know:** `ls`→eza, `cd`→zoxide, `v`→nvim, `dots`→sync status, `gpom`→git pull origin main, `ti`/`tp`/`taaa`→terraform init/plan/apply.

## When Editing Configs

- Hyprland keybindings use `$mainMod = SUPER`. Reload with `hyprctl reload`.
- Waybar style uses CSS; config is JSON (not JSON5 — no trailing commas).
- Rofi uses `.rasi` format. The theme file is at `themes/dark.rasi` referenced via `@theme "dark"`.
- After editing `.zshrc`, changes apply on new shell sessions (`source ~/.zshrc` to test).
- The pre-commit hook will block commits containing secrets. Add `# nosecret` to exempt false positives.
