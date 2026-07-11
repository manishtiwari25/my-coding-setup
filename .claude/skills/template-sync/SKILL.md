---
name: template-sync
description: Check the upstream template repository for changes and sync the latest rules, workflows, scripts, and scaffold into this repo. Use when the user asks to sync with the template, check for template updates, refresh repo rules, or run a periodic template check. Pass "check" to only report drift without applying anything.
---

# Template Sync

Sync this repository with its upstream template so it always operates under the latest rules and scaffold. The full model-agnostic procedure lives in `docs/workflows/template-sync.md` — read it first and follow it exactly; this skill is only the Claude Code entry point.

## Modes

- **Default (no argument):** check for upstream changes, apply sync-safe updates, and present review-first (rule) diffs for user approval.
- **`check`:** report-only. Fetch the template, list what changed since the last sync, classify it (sync-safe / review-first / never-sync), and stop without modifying any file except optionally `lastSyncedAt` in `.template-sync`.

## Execution summary

1. Read `docs/workflows/template-sync.md` and the `.template-sync` state file (root of the repo; create it on first sync).
2. Resolve and fetch the `template` remote. If this repo's `origin` **is** the template URL, report that this is the template itself and stop.
3. Diff the recorded `lastSyncedCommit` (or `HEAD` on first sync) against the template head, restricted to the paths classified in the workflow.
4. Apply sync-safe files with `git checkout template/<branch> -- <path>`; never overwrite review-first files (`AGENTS.md`, `CLAUDE.md`, `README.md`, `.github/copilot-instructions.md`, `docs/**/README.md`) — show their upstream diffs and ask the user (AskUserQuestion) before merging rule changes into the local versions by hand.
5. Never touch project-owned content: `docs/context/`, `docs/architecture/`, non-template files in `docs/decisions|features|memory|plans/`, `docs/usage/usage-log.md` rows, or any product code.
6. Update `.template-sync` with the new commit and date. Leave everything uncommitted for the user to review; do not commit or push unless asked.
7. Report: what was synced, what needs manual review, what was skipped, and whether the repo is now up to date with the template.

## Periodic use

Suggest (don't set up unasked) a cadence: run `/template-sync check` weekly or before major work; a scheduled agent or CI job can run check-only mode and flag drift.
