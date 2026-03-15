# Dotfiles

EndeavourOS + Hyprland (Wayland) desktop environment with NVIDIA GPU optimization. Configs deploy as symlinks managed by `sync.sh` from `~/Development/dotfiles/` to `$HOME`.

## Sync Tool

The repo and live system configs may differ. ALWAYS run `./sync.sh status` before assuming they match.

| Command | Description |
|---------|-------------|
| `./sync.sh status` | Show drift between repo and live system |
| `./sync.sh diff [file]` | Colored diffs (repo vs live) |
| `./sync.sh pull` | Copy live → repo (scans for secrets, asks confirmation) |
| `./sync.sh push` | Copy repo → live (backs up to `~/.dotfiles-backup/` first) |
| `./sync.sh link` | Replace live copies with symlinks to repo |

## Key Conventions

- **Color scheme:** Catppuccin-Mocha everywhere. Key colors: background `#1e1e2e`, text `#cdd6f4`, accent blue `#89b4fa`.
- **Symlinks:** When deployed via `./sync.sh link`, changes in repo are live immediately.
- **Secrets:** NEVER stored in this repo. Tokens go in `~/.zshrc.local` (not tracked). A pre-commit hook scans for credential patterns. Exempt with `# nosecret`.
- **Shell aliases:** `ls`→eza, `cd`→zoxide, `v`→nvim, `dots`→sync status.
