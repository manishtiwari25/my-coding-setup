---
id: ADR-002
title: Work Accounting — Per-Task Model, Token & Cost Reporting
status: Accepted (amended 2026-07-11)
date: 2026-06-27
areas: [agents, operations, documentation]
tags: [adr, work-accounting, cost, tokens, observability]
---

# ADR-002: Work Accounting — Per-Task Model, Token & Cost Reporting

## Context

Agent runs consume model tokens and paid credits (GitHub Copilot AIC, OpenCode/API USD), but that spend was invisible per task. Without a standing rule, usage is forgotten, under-reported, or — worse — guessed from a static price table that does not match what the runner actually billed.

The template is runner-portable (GitHub Copilot CLI, OpenCode, Claude Code, Cursor, raw API), so any accounting approach must work across runners and degrade honestly when a runtime does not expose exact figures. Token counts and credit/AIC/USD counters are cumulative, live counters that keep climbing while a session runs, so a single "final" number does not exist mid-session.

## Decision

Require Work Accounting on every completed task or work response:

1. **Footer on every response.** End each completed task/work response with a `🧮 Work Accounting` footer reporting model(s), tokens, and cost, sourced from the runner's own usage view — never a static price-table estimate.
2. **Committed ledger.** Append one entry per session to `usage/usage-log.md`. Cost is recorded in the runner's native unit (AIC, USD, or token cost).
3. **Interim vs. finalized.** Figures are point-in-time, timestamped snapshots; values are finalized at session close. Anything the runtime does not expose is labeled `≈ estimate`. Never fabricate, never omit.
4. **Per-runner units.** The per-runner source map in `AGENTS.md` defines where model, tokens, and cost come from for each runner.
5. **Copilot CLI helper.** `scripts/usage-snapshot.sh` reads the Copilot CLI local event log for real figures. For a closed session it reports the canonical `session.shutdown` totals — real input/output/cache tokens, AI units (`totalNanoAiu` ÷ 1e9 ≈ AIC), and premium-request count — and always sums subagent tokens. For a still-running session it gives an interim main+subagent sum and the AIC is pasted from the live `Session: N AIC used` status line.

The rule is recorded in the agent-instruction surfaces: `AGENTS.md` (full source map + footer template), with concise pointers in `.github/copilot-instructions.md` and `CLAUDE.md`.

This decision originally introduced two root-level directories — `usage/` (the committed ledger) and `scripts/` (operational tooling). **Amended 2026-07-11:** both were relocated under the `docs/` control plane as `docs/usage/` and `docs/scripts/`, so the repository keeps a single canonical control-plane root and no parallel root-level folders exist.

**Amended 2026-07-11 (helpers):** `scripts/usage-snapshot.sh` was renamed to `docs/scripts/usage-copilot.sh` (now also tracks mid-session `session.model_change`). New collectors were added — `usage-codex.sh` (OpenAI Codex CLI/IDE, session-cumulative `total_token_usage`), `usage-vscode.sh` (VS Code Copilot Chat — sessions/models/turns only; VS Code stores no local token/cost data), and `usage-cursor.sh` (Cursor — sessions only; spend is server-side). `usage-claude.sh` no longer prints a fabricated `$0.0000` — subscription-plan logs carry no `costUSD`, so cost reads `n/a (plan)`. A unified dispatcher `docs/scripts/usage.sh` auto-detects installed harnesses and runs the matching collectors.

## Consequences

### Positive

- Per-task spend is visible and auditable in a committed ledger.
- Figures reflect what the runner actually billed, not a guessed price table.
- The approach is runner-portable and honest about values a runtime does not expose.

### Negative

- The ledger is agent-driven: there is no automatic git or CLI hook, so an agent (or human) must remember to append the row.
- The AIC/credit value is finalized in the log at session close (`totalNanoAiu`); only a still-running session needs a manual paste from the status line.
- Mid-session rows are interim and must be reconciled at session close.

## Follow-Up

- [x] Add the Work Accounting section to the agent-instruction files.
- [x] Create `usage/usage-log.md` with recording rules and an example row (now `docs/usage/usage-log.md`).
- [x] Add `scripts/usage-snapshot.sh` for Copilot CLI sessions (now `docs/scripts/usage-copilot.sh`).
- [x] Add `scripts/usage-opencode.sh` (OpenCode, real USD) and `scripts/usage-claude.sh` (Claude Code, ccusage schema).
- [x] Move `usage/` and `scripts/` under `docs/`; add `usage.sh` dispatcher plus `usage-codex.sh`, `usage-vscode.sh`, `usage-cursor.sh` collectors.
- [ ] Revisit if a runner exposes a reliable automated per-session cost export.
