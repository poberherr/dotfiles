# User Preferences (global, applies to every session)

## Subagent-first by default

When a task has any of these traits, dispatch a subagent via the Agent tool instead of doing it inline:

- **Research / exploration** spanning more than one or two files — use `Explore` (read-only, fast) or `general-purpose`.
- **Multi-step independent work** that can run in parallel — dispatch multiple agents in a single message.
- **Specialized work** matching a named subagent (`code-review-specialist`, `debug-error-resolver`, `Plan`, etc.) — use that one rather than doing the work inline.
- **Heavy tool-result output** that would otherwise blow up the main context (large file reads, large search results, MCP responses > a few KB) — let the subagent read it, summarize, and return only the findings.

Skip subagent dispatch when:

- The target file/symbol is already known and the task is a direct edit.
- A skill is actively orchestrating the work and explicitly says to handle steps inline (e.g. brainstorming, debugging, TDD skills).
- Single-step lookups where one `Read` or `grep` will obviously do it.

When dispatching, brief the subagent self-contained: state the goal, what's been ruled out, what to return, and a length cap on the report. Don't duplicate research — if a subagent is searching, don't also search yourself.

## Git operations: subagents append, never force-push

When a subagent (or you, when acting on a remote branch the user doesn't own exclusively) needs to add changes to an already-pushed branch:

- **Default to append-commit.** `git commit ... && git push` adds a new commit on top. Reviewers see a clean "what changed since my review" diff. CI re-runs cleanly. Squash-merge at PR merge time consolidates the history anyway.
- **Do NOT use `--amend`, interactive rebase, or `git push --force-with-lease`** on remote branches without an explicit user instruction in the current turn. Even `--force-with-lease` can drop coauthor commits silently when another collaborator (or another subagent) pushed in parallel.
- **Subagent briefs must say so explicitly.** When dispatching a subagent that will push to an existing remote branch, include "Append a new commit (do not amend or force-push)." in the brief. Subagents default to whatever they think is cleaner; spell out the rule.
- **Exceptions are user-driven.** If the user says "amend" / "squash" / "force-push" in the current turn, follow the instruction.

**Why:** PR review threads anchor on commit SHAs and line numbers. Force-push invalidates that anchoring, surfaces a security warning in the harness, and risks silently dropping in-flight work from a parallel push (other reviewer, another agent, the user). Append-commit costs one extra commit in the per-PR history; squash-merge erases it at merge time.
