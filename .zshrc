# Enable Powerlevel10k instant prompt. Should stay close to the top of ~/.zshrc.
# Initialization code that may require console input (password prompts, [y/n]
# confirmations, etc.) must go above this block; everything else may go below.
if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

# ── Shared config (both platforms) ───────────────────────────────────
source ~/.zshrc.shared

# ── Platform-specific config ─────────────────────────────────────────
case "$(uname -s)" in
  Linux)  [[ -f ~/.zshrc.linux ]]  && source ~/.zshrc.linux  ;;
  Darwin) [[ -f ~/.zshrc.darwin ]] && source ~/.zshrc.darwin ;;
esac

# ── Powerlevel10k config ─────────────────────────────────────────────
[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

# ── Local overrides and secrets (not tracked by git) ─────────────────
[[ -f ~/.zshrc.local ]] && source ~/.zshrc.local
