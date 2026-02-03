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

# Create symlinks (backup existing files first!)
ln -sf ~/Development/dotfiles/.zshrc ~/.zshrc
ln -sf ~/Development/dotfiles/.zprofile ~/.zprofile
ln -sf ~/Development/dotfiles/.p10k.zsh ~/.p10k.zsh
ln -sf ~/Development/dotfiles/.vimrc ~/.vimrc
ln -sf ~/Development/dotfiles/.gitconfig ~/.gitconfig
ln -sf ~/Development/dotfiles/.psqlrc ~/.psqlrc

# Config directories
mkdir -p ~/.config
ln -sf ~/Development/dotfiles/.config/hypr ~/.config/hypr
ln -sf ~/Development/dotfiles/.config/kitty ~/.config/kitty
ln -sf ~/Development/dotfiles/.config/waybar ~/.config/waybar
ln -sf ~/Development/dotfiles/.config/mako ~/.config/mako
ln -sf ~/Development/dotfiles/.config/rofi ~/.config/rofi
ln -sf ~/Development/dotfiles/.config/wofi ~/.config/wofi

# Make scripts executable
chmod +x ~/Development/dotfiles/bin/*
chmod +x ~/Development/dotfiles/.config/waybar/power-menu.sh

# Add bin to PATH (already in .zshrc)
```

### Post-Install

1. **Change shell to zsh**: `chsh -s /bin/zsh`
2. **Configure Powerlevel10k**: Run `p10k configure` for customization
3. **Reload Hyprland**: `hyprctl reload` or log out and back in
4. **Set up secrets**: Add any tokens/secrets to `~/.zshrc.local` (not tracked)

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
