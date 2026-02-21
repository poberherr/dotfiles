# Patrick's Dotfiles

Personal dotfiles for EndeavourOS + Hyprland development setup.

## What's Included

### Shell

- `.zshrc` - Zsh configuration with oh-my-zsh, Powerlevel10k theme
- `.zprofile` - Zsh profile
- `.p10k.zsh` - Powerlevel10k prompt configuration

### Window Manager (Hyprland)

- `.config/hypr/hyprland.conf` - Hyprland window manager config (NVIDIA optimized)

### Status Bar & Notifications

- `.config/waybar/` - Waybar (status bar) config and styling
- `.config/mako/config` - Mako notification daemon config

### Application Launchers

- `.config/rofi/` - Rofi launcher config and themes
- `.config/wofi/` - Wofi launcher config (Wayland native)
- `bin/rofi-apps` - Custom rofi script

### Terminal & Editors

- `.config/kitty/kitty.conf` - Kitty terminal config
- `.vimrc` - Vim configuration
- `.gitconfig` - Git configuration (SSH signing enabled)

### Other

- `.psqlrc` - PostgreSQL client config
- `bin/` - Custom scripts

## Installation

### Prerequisites

Install required packages on EndeavourOS/Arch:

```bash
# Window manager & desktop
sudo pacman -S hyprland waybar mako wofi rofi

# Terminal & shell
sudo pacman -S kitty zsh oh-my-zsh-git zsh-theme-powerlevel10k zsh-syntax-highlighting zsh-autosuggestions

# CLI tools
sudo pacman -S neovim eza zoxide fzf direnv

# Clipboard & screenshots
sudo pacman -S wl-clipboard cliphist hyprshot

# Fonts
sudo pacman -S ttf-jetbrains-mono-nerd ttf-font-awesome
```

### Deploy Dotfiles

```bash
# Clone the repo
git clone https://github.com/YOUR_USERNAME/dotfiles.git ~/Development/dotfiles
cd ~/Development/dotfiles

# Activate git hooks (secret scanning on commit)
./setup-hooks.sh

# Create symlinks for all configs (backs up existing files first)
./sync.sh link
```

### Post-Install

1. **Change shell to zsh**: `chsh -s /bin/zsh`
2. **Configure Powerlevel10k**: Run `p10k configure` for customization
3. **Reload Hyprland**: `hyprctl reload` or log out and back in
4. **Set up secrets**: Add any tokens/secrets to `~/.zshrc.local` (not tracked)

## Syncing Configs

The `sync.sh` script keeps your repo and live system in sync:

```bash
# Check what's different between repo and live system
./sync.sh status

# Show colored diffs (optionally filter by filename)
./sync.sh diff
./sync.sh diff waybar

# Pull live configs into repo (scans for secrets first, asks confirmation)
./sync.sh pull

# Push repo configs to live system (backs up to ~/.dotfiles-backup/ first)
./sync.sh push

# Replace live copies with symlinks to repo (one-time migration)
./sync.sh link
```

**Typical workflow:** edit live configs → test → `./sync.sh pull` → review with `git diff` → commit.

Quick status check from anywhere: `dots` (shell alias for `./sync.sh status`).

## Security

### Pre-commit Secret Scanner

A pre-commit hook (`.githooks/pre-commit`) scans staged files for credential patterns:
- AWS access keys, GitHub PATs, OpenAI/Stripe keys, Slack tokens
- Private key headers (`-----BEGIN...PRIVATE KEY-----`)
- Generic `password/api_key/secret = "..."` patterns
- Exported tokens (`export *TOKEN*=...`)

To activate after cloning: `./setup-hooks.sh`

Exempt specific lines with `# nosecret` comments. The `.p10k.zsh` file is skipped automatically (false positives).

### Secrets Storage

Never commit secrets to this repo. Store tokens and credentials in `~/.zshrc.local` which is sourced by `.zshrc` but not tracked in git.

## Customization

### Monitor Setup

Edit `.config/hypr/hyprland.conf` to match your monitor configuration:

```conf
monitor=DP-2,preferred,0x0,1
monitor=DP-3,preferred,2560x0,1
```

Use `hyprctl monitors` to see available monitors.

### NVIDIA Notes

The hyprland config includes NVIDIA-specific environment variables. Remove or modify these if using AMD/Intel.

## Key Bindings (Hyprland)

| Binding               | Action                   |
| --------------------- | ------------------------ |
| `Super + Return`      | Open terminal (kitty)    |
| `Super + Q`           | Kill window              |
| `Super + R`           | App launcher (rofi)      |
| `Super + V`           | Toggle floating          |
| `Super + F`           | Fullscreen               |
| `Super + 1-9`         | Switch workspace         |
| `Super + Shift + 1-9` | Move window to workspace |
| `Super + Arrow/hjkl`  | Move focus               |
| `Ctrl + Shift + O`    | Screenshot region        |

## License

Feel free to use and adapt these configs for your own setup.
