---
id: ADR-002
title: Work Accounting — Per-Task Model, Token & Cost Reporting
status: Accepted
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

This decision introduces two root-level directories — `usage/` (the committed ledger) and `scripts/` (operational tooling). These are operational, not control-plane, folders; per ADR-001 a later ADR may bless such additions, and this ADR does so explicitly. The `docs/` control plane remains canonical.

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
- [x] Create `usage/usage-log.md` with recording rules and an example row.
- [x] Add `scripts/usage-snapshot.sh` for Copilot CLI sessions.
- [x] Add `scripts/usage-opencode.sh` (OpenCode, real USD) and `scripts/usage-claude.sh` (Claude Code, ccusage schema).
- [ ] Revisit if a runner exposes a reliable automated per-session cost export.
