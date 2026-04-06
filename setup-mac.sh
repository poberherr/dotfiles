#!/usr/bin/env bash
# setup-mac.sh — Install dependencies for dotfiles on macOS
# Run once after cloning on a new Mac

set -euo pipefail

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

echo -e "${BOLD}macOS Dotfiles Setup${NC}"
echo -e "${BOLD}====================${NC}"
echo ""

# ── Homebrew ─────────────────────────────────────────────────────────
if ! command -v brew &>/dev/null; then
    echo -e "${YELLOW}Installing Homebrew...${NC}"
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
    eval "$(/opt/homebrew/bin/brew shellenv)"
else
    echo -e "${GREEN}Homebrew already installed${NC}"
fi

# ── Shell & Prompt ───────────────────────────────────────────────────
echo ""
echo -e "${BOLD}Installing shell tools...${NC}"
brew install --quiet \
    zsh \
    powerlevel10k \
    zsh-syntax-highlighting \
    zsh-autosuggestions

# ── oh-my-zsh ────────────────────────────────────────────────────────
if [[ ! -d "$HOME/.oh-my-zsh" ]]; then
    echo -e "${YELLOW}Installing oh-my-zsh...${NC}"
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
else
    echo -e "${GREEN}oh-my-zsh already installed${NC}"
fi

# ── CLI Tools ────────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}Installing CLI tools...${NC}"
brew install --quiet \
    neovim \
    eza \
    zoxide \
    fzf \
    direnv \
    nvm \
    tree \
    jq \
    rsync \
    uv

# ── Terminal & Window Management ──────────────────────────────────────
echo ""
echo -e "${BOLD}Installing terminal & window management...${NC}"
brew install --quiet --cask kitty
brew install --quiet --cask nikitabobko/tap/aerospace

# ── iTerm2 config ────────────────────────────────────────────────────
REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
if defaults read com.googlecode.iterm2 &>/dev/null 2>&1; then
    echo ""
    echo -e "${BOLD}Configuring iTerm2 to load prefs from dotfiles repo...${NC}"
    defaults write com.googlecode.iterm2 PrefsCustomFolder -string "$REPO_DIR/.config/iterm2"
    defaults write com.googlecode.iterm2 LoadPrefsFromCustomFolder -bool true
    echo -e "${GREEN}iTerm2 will load preferences from${NC} $REPO_DIR/.config/iterm2"
    echo -e "${YELLOW}Restart iTerm2 to apply.${NC}"
else
    echo -e "${YELLOW}iTerm2 not installed — skipping prefs config${NC}"
fi

# ── Fonts ────────────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}Installing fonts...${NC}"
brew install --quiet --cask font-jetbrains-mono-nerd-font

# ── macOS Defaults ────────────────────────────────────────────────────
echo ""
echo -e "${BOLD}Configuring macOS defaults...${NC}"
# Fast key repeat (requires logout to take effect)
defaults write -g KeyRepeat -int 2
defaults write -g InitialKeyRepeat -int 15
echo -e "${GREEN}Keyboard:${NC} repeat=2, initial delay=15"
echo -e "${YELLOW}Log out and back in for keyboard settings to take effect.${NC}"

# ── NVM setup ────────────────────────────────────────────────────────
export NVM_DIR="$HOME/.nvm"
mkdir -p "$NVM_DIR"
if [[ ! -f "$NVM_DIR/nvm.sh" ]] && [[ -s "/opt/homebrew/opt/nvm/nvm.sh" ]]; then
    source "/opt/homebrew/opt/nvm/nvm.sh"
    echo -e "${GREEN}NVM initialized${NC}"
fi

# ── Deploy dotfiles ──────────────────────────────────────────────────
echo ""
echo -e "${BOLD}Setup complete!${NC}"
echo ""
echo -e "Next steps:"
echo -e "  1. ${CYAN}./setup-hooks.sh${NC}        # activate git hooks"
echo -e "  2. ${CYAN}./sync.sh link${NC}           # symlink configs to home"
echo -e "  3. ${CYAN}chsh -s /bin/zsh${NC}         # set default shell (if not already zsh)"
echo -e "  4. Open a new terminal and run ${CYAN}p10k configure${NC}"
echo -e "  5. Add secrets to ${CYAN}~/.zshrc.local${NC}"
