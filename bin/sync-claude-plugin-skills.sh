#!/usr/bin/env bash
# Re-link Claude Code plugin skills into ~/.claude/skills/ so opencode discovers them too.
# Plugins live at ~/.claude/plugins/cache/<marketplace>/<plugin>/<version>/skills/.
# Run after `/plugin install` or `/plugin update` to refresh the symlinks.
set -euo pipefail

PLUGIN_CACHE="$HOME/.claude/plugins/cache"
SKILLS_DIR="$HOME/.claude/skills"
mkdir -p "$SKILLS_DIR"

# Plugins to bridge: name -> glob path under plugin cache.
declare -a PLUGINS=(
    "superpowers:claude-plugins-official/superpowers"
    "impeccable:impeccable/impeccable"
)

linked=0
for entry in "${PLUGINS[@]}"; do
    name="${entry%%:*}"
    rel="${entry#*:}"
    base="$PLUGIN_CACHE/$rel"
    [[ -d "$base" ]] || { echo "skip $name: $base missing"; continue; }

    # Pick highest version dir (semver-sortable via -V).
    latest=$(ls -1 "$base" | sort -V | tail -1)
    src="$base/$latest/skills"
    [[ -d "$src" ]] || { echo "skip $name: no skills/ in $latest"; continue; }

    ln -sfn "$src" "$SKILLS_DIR/$name"
    echo "linked $name -> $src"
    linked=$((linked+1))
done

echo "done: $linked skill set(s) linked into $SKILLS_DIR"
