#!/usr/bin/env bash
# sync.sh — Sync dotfiles between this repo and the live system
# Usage: ./sync.sh <command> [args]
#   status          Show drift between repo and live system
#   diff [file]     Show colored diffs (repo vs live)
#   pull            Copy live configs into repo (scans for secrets first)
#   push            Copy repo configs to live system (backs up first)
#   link            Replace live copies with symlinks to repo (backs up first)

set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
BACKUP_BASE="$HOME/.dotfiles-backup"

RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
CYAN='\033[0;36m'
BOLD='\033[1m'
NC='\033[0m'

# ── File mapping: repo path → live path ──────────────────────────────
# Associative array: keys are relative repo paths, values are absolute live paths
declare -A FILE_MAP=(
    # Home directory files
    [".zshrc"]="$HOME/.zshrc"
    [".zprofile"]="$HOME/.zprofile"
    [".p10k.zsh"]="$HOME/.p10k.zsh"
    [".vimrc"]="$HOME/.vimrc"
    [".gitconfig"]="$HOME/.gitconfig"
    [".psqlrc"]="$HOME/.psqlrc"
    [".config/hyprwhspr/config.json"]="$HOME/.config/hyprwhspr/config.json"
)

declare -A DIR_MAP=(
    # .config directories
    [".config/hypr"]="$HOME/.config/hypr"
    [".config/kitty"]="$HOME/.config/kitty"
    [".config/waybar"]="$HOME/.config/waybar"
    [".config/mako"]="$HOME/.config/mako"
    [".config/rofi"]="$HOME/.config/rofi"
    [".config/wofi"]="$HOME/.config/wofi"
)

# ── Helpers ──────────────────────────────────────────────────────────

die() { echo -e "${RED}Error:${NC} $*" >&2; exit 1; }

# Check if a path is a symlink pointing to the repo
is_repo_symlink() {
    local live_path="$1"
    local repo_path="$2"
    [[ -L "$live_path" ]] && [[ "$(readlink -f "$live_path")" == "$(readlink -f "$repo_path")" ]]
}

# Scan a file for secret patterns (same patterns as pre-commit hook)
scan_secrets() {
    local file="$1"
    local found=0

    [[ -f "$file" ]] || return 0

    # Skip binary files
    if file --mime-encoding "$file" 2>/dev/null | grep -q "binary"; then
        return 0
    fi

    local line_num=0
    while IFS= read -r line; do
        ((line_num++)) || true

        [[ "$line" == *"# nosecret"* ]] && continue
        [[ "$line" == *"// nosecret"* ]] && continue

        local matched=""
        if echo "$line" | grep -qP -- 'AKIA[0-9A-Z]{16}' 2>/dev/null; then
            matched="AWS Access Key"
        elif echo "$line" | grep -qP -- '(ghp_[a-zA-Z0-9]{36}|github_pat_[a-zA-Z0-9_]{82}|gho_[a-zA-Z0-9]{36}|ghs_[a-zA-Z0-9]{36})' 2>/dev/null; then
            matched="GitHub Token"
        elif echo "$line" | grep -qP -- 'sk-[a-zA-Z0-9]{20,}' 2>/dev/null; then
            matched="API Secret Key"
        elif echo "$line" | grep -qP -- 'xox[bporas]-[a-zA-Z0-9-]+' 2>/dev/null; then
            matched="Slack Token"
        elif echo "$line" | grep -qP -- '-----BEGIN\s+(RSA|DSA|EC|OPENSSH|PGP)?\s*PRIVATE KEY-----' 2>/dev/null; then
            matched="Private Key"
        elif echo "$line" | grep -qPi -- '(password|api_key|apikey|secret_key|secret|token|auth_token)\s*[=:]\s*["\x27][^\s"'\'']{8,}' 2>/dev/null; then
            matched="Hardcoded Secret"
        elif echo "$line" | grep -qPi -- 'export\s+\w*(TOKEN|SECRET|PASSWORD|API_KEY|APIKEY)\w*\s*=\s*["\x27]?[^\s"'\''#]{8,}' 2>/dev/null; then
            matched="Exported Secret"
        fi

        if [[ -n "$matched" ]]; then
            if [[ $found -eq 0 ]]; then
                echo -e "  ${RED}Secrets found in ${file}:${NC}"
            fi
            echo -e "    ${YELLOW}Line $line_num:${NC} $matched"
            found=1
        fi
    done < "$file"

    return $found
}

# Create timestamped backup directory
make_backup_dir() {
    local ts
    ts=$(date +%Y%m%d-%H%M%S)
    local dir="$BACKUP_BASE/$ts"
    mkdir -p "$dir"
    echo "$dir"
}

# Backup a file or directory
backup_item() {
    local src="$1"
    local backup_dir="$2"
    local rel_path="$3"

    [[ -e "$src" ]] || return 0

    local dest="$backup_dir/$rel_path"
    mkdir -p "$(dirname "$dest")"

    if [[ -d "$src" ]] && [[ ! -L "$src" ]]; then
        cp -a "$src" "$dest"
    else
        cp -a "$src" "$dest"
    fi
    echo -e "  ${CYAN}Backed up${NC} $src"
}

# Reload Hyprland if running (picks up config changes)
reload_hyprland() {
    if command -v hyprctl &>/dev/null && hyprctl monitors &>/dev/null 2>&1; then
        hyprctl reload &>/dev/null
        echo -e "  ${GREEN}Reloaded${NC} Hyprland config"
    fi
}

# ── Commands ─────────────────────────────────────────────────────────

cmd_status() {
    echo -e "${BOLD}Dotfiles Status${NC}"
    echo -e "${BOLD}===============${NC}"
    echo ""

    local linked=0 modified=0 missing_live=0 missing_repo=0 extra=0

    # Check individual files
    echo -e "${BOLD}Files:${NC}"
    for repo_rel in "${!FILE_MAP[@]}"; do
        local repo_path="$REPO_DIR/$repo_rel"
        local live_path="${FILE_MAP[$repo_rel]}"

        if [[ ! -e "$repo_path" ]]; then
            if [[ -e "$live_path" ]]; then
                echo -e "  ${YELLOW}extra${NC}     $repo_rel  (live only, not in repo)"
                ((extra++)) || true
            fi
            continue
        fi

        if [[ ! -e "$live_path" ]]; then
            echo -e "  ${RED}missing${NC}   $repo_rel  (not deployed)"
            ((missing_live++)) || true
        elif is_repo_symlink "$live_path" "$repo_path"; then
            echo -e "  ${GREEN}linked${NC}    $repo_rel"
            ((linked++)) || true
        elif diff -q "$repo_path" "$live_path" &>/dev/null; then
            echo -e "  ${GREEN}synced${NC}    $repo_rel"
            ((linked++)) || true
        else
            echo -e "  ${YELLOW}modified${NC}  $repo_rel"
            ((modified++)) || true
        fi
    done

    echo ""
    echo -e "${BOLD}Directories:${NC}"
    for repo_rel in "${!DIR_MAP[@]}"; do
        local repo_path="$REPO_DIR/$repo_rel"
        local live_path="${DIR_MAP[$repo_rel]}"

        if [[ ! -d "$repo_path" ]]; then
            if [[ -d "$live_path" ]]; then
                echo -e "  ${YELLOW}extra${NC}     $repo_rel/  (live only)"
                ((extra++)) || true
            fi
            continue
        fi

        if [[ ! -e "$live_path" ]]; then
            echo -e "  ${RED}missing${NC}   $repo_rel/  (not deployed)"
            ((missing_live++)) || true
        elif [[ -L "$live_path" ]] && is_repo_symlink "$live_path" "$repo_path"; then
            echo -e "  ${GREEN}linked${NC}    $repo_rel/"
            ((linked++)) || true
        else
            # Compare directory contents
            local diff_count
            diff_count=$(diff -rq "$repo_path" "$live_path" 2>/dev/null | wc -l) || true
            if [[ "$diff_count" -eq 0 ]]; then
                echo -e "  ${GREEN}synced${NC}    $repo_rel/"
                ((linked++)) || true
            else
                echo -e "  ${YELLOW}modified${NC}  $repo_rel/  ($diff_count files differ)"
                ((modified++)) || true
            fi
        fi
    done

    echo ""
    echo -e "${BOLD}Summary:${NC} ${GREEN}$linked synced/linked${NC}, ${YELLOW}$modified modified${NC}, ${RED}$missing_live missing (live)${NC}, ${YELLOW}$extra extra (live only)${NC}"
}

cmd_diff() {
    local filter="${1:-}"

    diff_item() {
        local repo_path="$1"
        local live_path="$2"
        local label="$3"

        if [[ ! -e "$repo_path" ]] || [[ ! -e "$live_path" ]]; then
            return
        fi

        if [[ -L "$live_path" ]] && is_repo_symlink "$live_path" "$repo_path"; then
            return
        fi

        if [[ -d "$repo_path" ]] && [[ -d "$live_path" ]]; then
            local output
            output=$(diff -ru --color=always "$repo_path" "$live_path" 2>/dev/null) || true
            if [[ -n "$output" ]]; then
                echo -e "${BOLD}=== $label ===${NC}"
                echo "$output"
                echo ""
            fi
        elif [[ -f "$repo_path" ]] && [[ -f "$live_path" ]]; then
            local output
            output=$(diff -u --color=always "$repo_path" "$live_path" 2>/dev/null) || true
            if [[ -n "$output" ]]; then
                echo -e "${BOLD}=== $label ===${NC}"
                echo "$output"
                echo ""
            fi
        fi
    }

    local found=0

    for repo_rel in "${!FILE_MAP[@]}"; do
        if [[ -n "$filter" ]] && [[ "$repo_rel" != *"$filter"* ]]; then
            continue
        fi
        diff_item "$REPO_DIR/$repo_rel" "${FILE_MAP[$repo_rel]}" "$repo_rel"
        found=1
    done

    for repo_rel in "${!DIR_MAP[@]}"; do
        if [[ -n "$filter" ]] && [[ "$repo_rel" != *"$filter"* ]]; then
            continue
        fi
        diff_item "$REPO_DIR/$repo_rel" "${DIR_MAP[$repo_rel]}" "$repo_rel/"
        found=1
    done

    if [[ -n "$filter" ]] && [[ $found -eq 0 ]]; then
        echo -e "${RED}No matching config found for:${NC} $filter"
        exit 1
    fi
}

cmd_pull() {
    echo -e "${BOLD}Pulling live configs into repo...${NC}"
    echo ""

    # Scan live files for secrets first
    echo -e "${BOLD}Scanning live configs for secrets...${NC}"
    local secrets_found=0
    for repo_rel in "${!FILE_MAP[@]}"; do
        local live_path="${FILE_MAP[$repo_rel]}"
        # Skip .p10k.zsh (false positives)
        [[ "$(basename "$repo_rel")" == ".p10k.zsh" ]] && continue
        if ! scan_secrets "$live_path" 2>/dev/null; then
            secrets_found=1
        fi
    done

    for repo_rel in "${!DIR_MAP[@]}"; do
        local live_path="${DIR_MAP[$repo_rel]}"
        if [[ -d "$live_path" ]]; then
            while IFS= read -r -d '' f; do
                if ! scan_secrets "$f" 2>/dev/null; then
                    secrets_found=1
                fi
            done < <(find "$live_path" -type f -print0 2>/dev/null)
        fi
    done

    if [[ $secrets_found -eq 1 ]]; then
        echo ""
        echo -e "${YELLOW}Warning: Potential secrets detected in live configs (see above).${NC}"
        echo -e "Review carefully before committing. Lines can be exempted with ${CYAN}# nosecret${NC}"
        echo ""
    else
        echo -e "  ${GREEN}No secrets detected.${NC}"
        echo ""
    fi

    # Show what will change
    local changes=0
    echo -e "${BOLD}Changes to pull:${NC}"

    for repo_rel in "${!FILE_MAP[@]}"; do
        local repo_path="$REPO_DIR/$repo_rel"
        local live_path="${FILE_MAP[$repo_rel]}"

        [[ -f "$live_path" ]] || continue

        if [[ -L "$live_path" ]] && is_repo_symlink "$live_path" "$repo_path"; then
            continue
        fi

        if [[ ! -f "$repo_path" ]] || ! diff -q "$repo_path" "$live_path" &>/dev/null; then
            echo -e "  ${YELLOW}←${NC} $repo_rel"
            ((changes++)) || true
        fi
    done

    for repo_rel in "${!DIR_MAP[@]}"; do
        local repo_path="$REPO_DIR/$repo_rel"
        local live_path="${DIR_MAP[$repo_rel]}"

        [[ -d "$live_path" ]] || continue

        if [[ -L "$live_path" ]] && is_repo_symlink "$live_path" "$repo_path"; then
            continue
        fi

        local diff_count
        diff_count=$(diff -rq "$repo_path" "$live_path" 2>/dev/null | wc -l) || diff_count=999
        if [[ "$diff_count" -gt 0 ]]; then
            echo -e "  ${YELLOW}←${NC} $repo_rel/  ($diff_count files)"
            ((changes++)) || true
        fi
    done

    if [[ $changes -eq 0 ]]; then
        echo -e "  ${GREEN}Everything is in sync.${NC}"
        exit 0
    fi

    echo ""
    read -rp "Pull $changes item(s) into repo? [y/N] " confirm
    if [[ "$confirm" != [yY] ]]; then
        echo "Aborted."
        exit 0
    fi

    # Copy live → repo
    for repo_rel in "${!FILE_MAP[@]}"; do
        local repo_path="$REPO_DIR/$repo_rel"
        local live_path="${FILE_MAP[$repo_rel]}"

        [[ -f "$live_path" ]] || continue
        [[ -L "$live_path" ]] && is_repo_symlink "$live_path" "$repo_path" && continue

        if [[ ! -f "$repo_path" ]] || ! diff -q "$repo_path" "$live_path" &>/dev/null; then
            cp "$live_path" "$repo_path"
            echo -e "  ${GREEN}Pulled${NC} $repo_rel"
        fi
    done

    for repo_rel in "${!DIR_MAP[@]}"; do
        local repo_path="$REPO_DIR/$repo_rel"
        local live_path="${DIR_MAP[$repo_rel]}"

        [[ -d "$live_path" ]] || continue
        [[ -L "$live_path" ]] && is_repo_symlink "$live_path" "$repo_path" && continue

        rsync -a --delete "$live_path/" "$repo_path/"
        echo -e "  ${GREEN}Pulled${NC} $repo_rel/"
    done

    echo ""
    echo -e "${GREEN}Done.${NC} Review changes with ${CYAN}git diff${NC} then commit."
}

cmd_push() {
    echo -e "${BOLD}Pushing repo configs to live system...${NC}"
    echo ""

    local changes=0
    echo -e "${BOLD}Changes to push:${NC}"

    for repo_rel in "${!FILE_MAP[@]}"; do
        local repo_path="$REPO_DIR/$repo_rel"
        local live_path="${FILE_MAP[$repo_rel]}"

        [[ -f "$repo_path" ]] || continue

        if [[ -L "$live_path" ]] && is_repo_symlink "$live_path" "$repo_path"; then
            continue
        fi

        if [[ ! -f "$live_path" ]] || ! diff -q "$repo_path" "$live_path" &>/dev/null; then
            echo -e "  ${YELLOW}→${NC} $repo_rel"
            ((changes++)) || true
        fi
    done

    for repo_rel in "${!DIR_MAP[@]}"; do
        local repo_path="$REPO_DIR/$repo_rel"
        local live_path="${DIR_MAP[$repo_rel]}"

        [[ -d "$repo_path" ]] || continue

        if [[ -L "$live_path" ]] && is_repo_symlink "$live_path" "$repo_path"; then
            continue
        fi

        if [[ ! -d "$live_path" ]]; then
            echo -e "  ${YELLOW}→${NC} $repo_rel/  (new)"
            ((changes++)) || true
        else
            local diff_count
            diff_count=$(diff -rq "$repo_path" "$live_path" 2>/dev/null | wc -l) || diff_count=999
            if [[ "$diff_count" -gt 0 ]]; then
                echo -e "  ${YELLOW}→${NC} $repo_rel/  ($diff_count files)"
                ((changes++)) || true
            fi
        fi
    done

    if [[ $changes -eq 0 ]]; then
        echo -e "  ${GREEN}Everything is in sync.${NC}"
        exit 0
    fi

    echo ""
    read -rp "Push $changes item(s) to live system? (backup created first) [y/N] " confirm
    if [[ "$confirm" != [yY] ]]; then
        echo "Aborted."
        exit 0
    fi

    # Create backup
    local backup_dir
    backup_dir=$(make_backup_dir)
    echo -e "${BOLD}Backing up to $backup_dir${NC}"

    for repo_rel in "${!FILE_MAP[@]}"; do
        backup_item "${FILE_MAP[$repo_rel]}" "$backup_dir" "$repo_rel"
    done
    for repo_rel in "${!DIR_MAP[@]}"; do
        backup_item "${DIR_MAP[$repo_rel]}" "$backup_dir" "$repo_rel"
    done

    echo ""

    # Copy repo → live
    for repo_rel in "${!FILE_MAP[@]}"; do
        local repo_path="$REPO_DIR/$repo_rel"
        local live_path="${FILE_MAP[$repo_rel]}"

        [[ -f "$repo_path" ]] || continue
        [[ -L "$live_path" ]] && is_repo_symlink "$live_path" "$repo_path" && continue

        if [[ ! -f "$live_path" ]] || ! diff -q "$repo_path" "$live_path" &>/dev/null; then
            mkdir -p "$(dirname "$live_path")"
            cp "$repo_path" "$live_path"
            echo -e "  ${GREEN}Pushed${NC} $repo_rel"
        fi
    done

    for repo_rel in "${!DIR_MAP[@]}"; do
        local repo_path="$REPO_DIR/$repo_rel"
        local live_path="${DIR_MAP[$repo_rel]}"

        [[ -d "$repo_path" ]] || continue
        [[ -L "$live_path" ]] && is_repo_symlink "$live_path" "$repo_path" && continue

        mkdir -p "$live_path"
        rsync -a --delete "$repo_path/" "$live_path/"
        echo -e "  ${GREEN}Pushed${NC} $repo_rel/"
    done

    echo ""
    reload_hyprland
    echo -e "${GREEN}Done.${NC} Backup at ${CYAN}$backup_dir${NC}"
}

cmd_link() {
    echo -e "${BOLD}Replacing live configs with symlinks to repo...${NC}"
    echo ""
    echo -e "${YELLOW}This is a one-time migration. Existing files will be backed up.${NC}"
    echo ""

    local to_link=0

    for repo_rel in "${!FILE_MAP[@]}"; do
        local repo_path="$REPO_DIR/$repo_rel"
        local live_path="${FILE_MAP[$repo_rel]}"

        [[ -f "$repo_path" ]] || continue

        if is_repo_symlink "$live_path" "$repo_path" 2>/dev/null; then
            echo -e "  ${GREEN}already linked${NC}  $repo_rel"
        else
            echo -e "  ${YELLOW}will link${NC}       $repo_rel"
            ((to_link++)) || true
        fi
    done

    for repo_rel in "${!DIR_MAP[@]}"; do
        local repo_path="$REPO_DIR/$repo_rel"
        local live_path="${DIR_MAP[$repo_rel]}"

        [[ -d "$repo_path" ]] || continue

        if [[ -L "$live_path" ]] && is_repo_symlink "$live_path" "$repo_path" 2>/dev/null; then
            echo -e "  ${GREEN}already linked${NC}  $repo_rel/"
        else
            echo -e "  ${YELLOW}will link${NC}       $repo_rel/"
            ((to_link++)) || true
        fi
    done

    if [[ $to_link -eq 0 ]]; then
        echo ""
        echo -e "  ${GREEN}Everything is already symlinked.${NC}"
        exit 0
    fi

    echo ""
    read -rp "Create $to_link symlink(s)? (backup created first) [y/N] " confirm
    if [[ "$confirm" != [yY] ]]; then
        echo "Aborted."
        exit 0
    fi

    local backup_dir
    backup_dir=$(make_backup_dir)
    echo -e "${BOLD}Backing up to $backup_dir${NC}"

    # Link files
    for repo_rel in "${!FILE_MAP[@]}"; do
        local repo_path="$REPO_DIR/$repo_rel"
        local live_path="${FILE_MAP[$repo_rel]}"

        [[ -f "$repo_path" ]] || continue
        is_repo_symlink "$live_path" "$repo_path" 2>/dev/null && continue

        backup_item "$live_path" "$backup_dir" "$repo_rel"
        rm -f "$live_path"
        ln -sf "$repo_path" "$live_path"
        echo -e "  ${GREEN}Linked${NC} $repo_rel → $live_path"
    done

    # Link directories
    for repo_rel in "${!DIR_MAP[@]}"; do
        local repo_path="$REPO_DIR/$repo_rel"
        local live_path="${DIR_MAP[$repo_rel]}"

        [[ -d "$repo_path" ]] || continue
        [[ -L "$live_path" ]] && is_repo_symlink "$live_path" "$repo_path" 2>/dev/null && continue

        backup_item "$live_path" "$backup_dir" "$repo_rel"
        rm -rf "$live_path"
        ln -sf "$repo_path" "$live_path"
        echo -e "  ${GREEN}Linked${NC} $repo_rel/ → $live_path"
    done

    echo ""
    reload_hyprland
    echo -e "${GREEN}Done.${NC} Backup at ${CYAN}$backup_dir${NC}"
    echo -e "Changes to configs are now ${BOLD}live immediately${NC}."
}

cmd_help() {
    echo -e "${BOLD}Usage:${NC} ./sync.sh <command> [args]"
    echo ""
    echo -e "${BOLD}Commands:${NC}"
    echo "  status          Show drift between repo and live system"
    echo "  diff [file]     Show colored diffs (repo ← vs → live)"
    echo "  pull            Copy live configs into repo (scans for secrets)"
    echo "  push            Copy repo configs to live system (backs up first)"
    echo "  link            Replace live copies with symlinks to repo"
    echo "  help            Show this help"
}

# ── Main ─────────────────────────────────────────────────────────────

command="${1:-help}"
shift || true

case "$command" in
    status) cmd_status ;;
    diff)   cmd_diff "$@" ;;
    pull)   cmd_pull ;;
    push)   cmd_push ;;
    link)   cmd_link ;;
    help|--help|-h) cmd_help ;;
    *)
        echo -e "${RED}Unknown command:${NC} $command"
        cmd_help
        exit 1
        ;;
esac
