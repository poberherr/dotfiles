#!/usr/bin/env bash
# Read-only audit of git worktrees under ~/Development.
# Prints: path | branch | size | age (days since HEAD) | merged | remote-gone
# Sorted by size desc. Modifies nothing.
set -euo pipefail

DEV="${HOME}/Development"
[[ -d "$DEV" ]] || { echo "no $DEV"; exit 1; }

repos=()
for repo in "$DEV"/*/; do
    [[ -d "$repo/.git" ]] || continue
    git -C "$repo" worktree list >/dev/null 2>&1 || continue
    if [[ "$(git -C "$repo" worktree list | wc -l)" -gt 1 ]]; then
        repos+=("${repo%/}")
    fi
done

[[ ${#repos[@]} -gt 0 ]] || { echo "no repos with worktrees in $DEV"; exit 0; }

now=$(date +%s)
rows=()

for repo in "${repos[@]}"; do
    base_branch=$(git -C "$repo" symbolic-ref --short refs/remotes/origin/HEAD 2>/dev/null | sed 's|origin/||' || echo main)
    git -C "$repo" fetch --quiet origin "$base_branch" 2>/dev/null || true

    while IFS= read -r line; do
        path=$(awk '{print $1}' <<<"$line")
        [[ -d "$path" ]] || continue
        # Skip the main worktree itself for cleanup table — it's the root repo.
        if [[ "$path" == "$repo" ]]; then continue; fi

        branch=$(git -C "$path" symbolic-ref --short HEAD 2>/dev/null || echo "(detached)")
        size=$(du -sh "$path" 2>/dev/null | awk '{print $1}')
        size_bytes=$(du -sk "$path" 2>/dev/null | awk '{print $1}')
        head_ts=$(git -C "$path" log -1 --format=%ct 2>/dev/null || echo 0)
        age_days=$(( (now - head_ts) / 86400 ))

        if git -C "$path" merge-base --is-ancestor HEAD "origin/$base_branch" 2>/dev/null; then
            merged=yes
        else
            merged=no
        fi

        if [[ "$branch" == "(detached)" ]]; then
            remote_gone=n/a
        elif git -C "$path" ls-remote --exit-code --heads origin "$branch" >/dev/null 2>&1; then
            remote_gone=no
        else
            remote_gone=yes
        fi

        rows+=("${size_bytes}|${path}|${branch}|${size}|${age_days}d|${merged}|${remote_gone}")
    done < <(git -C "$repo" worktree list --porcelain | awk '/^worktree /{print $2}' | while read -r p; do echo "$p"; done)
done

printf "\n%-65s %-55s %6s %6s %7s %6s\n" "PATH" "BRANCH" "SIZE" "AGE" "MERGED" "GONE"
printf '%.0s-' {1..150}; echo
printf "%s\n" "${rows[@]}" | sort -t'|' -k1 -nr | while IFS='|' read -r _ path branch size age merged gone; do
    printf "%-65s %-55s %6s %6s %7s %6s\n" "${path/#$HOME/~}" "$branch" "$size" "$age" "$merged" "$gone"
done

echo
echo "Hint: remove a worktree with -> git -C <repo> worktree remove <path>"
echo "      then delete the branch -> git -C <repo> branch -D <branch>"
