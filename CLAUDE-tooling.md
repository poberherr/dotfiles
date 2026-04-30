# Claude Code + opencode tooling cheatsheet

Reference companion to `CLAUDE.md`. Covers skill stack, memory model, auth, and workflow conventions used in this dotfiles env.

## Skill stack (when to reach for what)

| Skill | Trigger | Cost | Notes |
|---|---|---|---|
| **Superpowers** | Larger features (multi-file, multi-step). Brainstorm → spec → plan → subagent execute → two-stage review. | High tokens. Skip for small fixes. | Replaces vanilla `/plan` mode. Each subagent gets fresh ctx, exact paths, pre-written commit msg. Auto-creates `worktree-*` branches via `using-git-worktrees`. |
| **Impeccable** | UI/frontend polish: typography, color, layout, micro-interactions. Audit → critique → polish. | Medium. | Builds on Anthropic's `frontend-design`. 23 commands (`polish`, `audit`, `critique`, `typeset`, `colorize`, `delight`...). Two modes: `brand` vs `product`. |
| **databricks-ai-dev-kit** | Anything Databricks: Spark, Jobs, DLT/SDP, Unity Catalog, Vector Search, Model Serving, Lakebase, Apps. | Medium (skill auto-loads). | 20+ sub-skills under `~/.claude/skills/databricks/`. Pulls patterns from official Databricks docs — beats Claude's stale guesswork. |
| **hex** (app.hex.tech CLI) | Driving Hex projects/apps/cells from terminal — create, run, query, manage connections. | Low (single skill). | Binary `/opt/homebrew/bin/hex` from tap `hex-inc/hex-cli`. Skill installed via `hex install agent-skill --claude` (add `--global` for system-wide). |

Existing in this setup: `frontend-design`, `code-review`, `caveman`, `ccrc`, `swift-lsp`. Don't double-install.

## Install commands

### Claude Code (interactive — paste in `claude` REPL)

```
/plugin marketplace add obra/superpowers-marketplace
/plugin install superpowers@superpowers-marketplace

/plugin marketplace add pbakaus/impeccable
/plugin install impeccable@impeccable
```

### Hex CLI (app.hex.tech)

```bash
brew install hex-inc/hex-cli/hex
hex auth login
hex install agent-skill --claude --global   # system-wide skill (drop --global for cwd only)
```

### Databricks (already installed via this dotfiles repo)

Symlink at `~/.claude/skills/databricks` → `~/Development/ai-dev-kit/databricks-skills`. Update with:

```bash
git -C ~/Development/ai-dev-kit pull
```

Both `claude` and `opencode` see this dir automatically — no separate opencode install.

### Bridging plugin skills to opencode

Plugin skills (Superpowers, Impeccable) live at `~/.claude/plugins/cache/<marketplace>/<plugin>/<version>/skills/` — opencode does **not** scan that path. Bridge them into `~/.claude/skills/` with:

```bash
~/Development/dotfiles/bin/sync-claude-plugin-skills.sh
```

Run this **after every `/plugin install` or `/plugin update`** in Claude Code. The script symlinks the latest version dir, so plugin upgrades just need a re-run.

## Claude Code ↔ opencode parity

| Concept | Claude Code | opencode |
|---|---|---|
| Project memory | `CLAUDE.md` (root, `/init` to bootstrap) | `AGENTS.md` (root, `/init` to bootstrap) |
| Subdir memory | nested `CLAUDE.md` walked up from cwd | nested `AGENTS.md` walked up from cwd to git root |
| Global memory | `~/.claude/CLAUDE.md` | `~/.config/opencode/AGENTS.md` |
| Skills dir | `~/.claude/skills/<name>/SKILL.md` | reads `~/.claude/skills/`, `~/.config/opencode/skills/`, `.opencode/skills/`, `.claude/skills/` |
| Plugins | `/plugin marketplace add ...` + `/plugin install ...` | no plugin marketplace; install via skills or `.opencode/agents/` |
| Auth | `/login` (Anthropic) | `opencode auth login <provider>` |
| Model switch | `/model` | `/model` or `model` field in `~/.config/opencode/opencode.json` |
| Refresh model list | `claude doctor` (rare) | `opencode models --refresh` |

opencode auto-discovers anything inside `~/.claude/skills/`. Skills installed as raw `SKILL.md` dirs (e.g. databricks) are read directly. Skills shipped via plugin marketplace need bridging — see "Bridging plugin skills to opencode" above.

## opencode auth toggle (oauth ↔ API key overflow)

Default: ChatGPT-Team oauth (cheaper, included). Switch to API key only when rate-limited, then back. API key lives in 1Password (`Employee` vault → `ChatGPT - patrick opencode_m5 api token`), fetched on demand by the toggle script.

```bash
ocauth status        # show active auth type
ocapi                # switch to API key (overflow)
octeam               # switch back to oauth
```

Script: `~/Development/dotfiles/bin/opencode-auth.sh`. Backs up oauth section to `~/.local/share/opencode/auth-backup/oauth.json` on switch, restores on switch-back — no need to re-run `opencode auth login`.

API-key billing is **separate** from ChatGPT Team. Hard cap set at https://platform.openai.com/settings → Limits.

ChatGPT Team oauth has a server-side allowlist that lags behind models.dev (this is what initially hid gpt-5.5 from us). The base `gpt-5.5` non-codex model only resolves on the API-key path; codex variants resolve on both.

## Worktree workflow (Superpowers convention)

Superpowers' `using-git-worktrees` skill creates a worktree per feature: `worktree-<short-name>` branch under `~/Development/<repo>-<slug>/`. Avoid mixing in-flight work in the main checkout.

Audit existing worktrees:

```bash
~/Development/dotfiles/bin/dev-worktree-report.sh
```

Read-only. Lists path, branch, size, age, whether merged, whether remote branch is gone. Decide manually:

```bash
git -C ~/Development/mono worktree remove ~/Development/mono-foo
git -C ~/Development/mono branch -D patrick/foo
```

`.opencode/node_modules` inside worktrees is bloat (~200MB each). Add `.opencode/node_modules` to your global gitignore if not already.

## Common slash / CLI commands

| Need | Claude Code | opencode |
|---|---|---|
| List loaded skills | "what skills can you load?" | `/skills` |
| Init project memory | `/init` | `/init` |
| Switch model | `/model` | `/model` |
| Refresh model cache | n/a | `opencode models --refresh` |
| List plugins | `/plugin list` | n/a |
| Run one-shot prompt | `claude "..."` | `opencode run "..."` |
| Specific model run | `claude --model ...` | `opencode run --model openai/gpt-5.5 "..."` |
