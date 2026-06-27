# Copilot Instructions - Project Brain Template

Use `AGENTS.md` as the primary operating guide. This repository is a reusable template with a `docs/`-based control plane: `docs/architecture/`, `docs/context/`, `docs/decisions/`, `docs/features/`, `docs/memory/`, `docs/plans/`, `docs/prompts/`, and `docs/workflows/`.

## Default Behavior

- Read `AGENTS.md` and relevant `docs/` control-plane files before planning non-trivial work.
- Use `docs/` as the project brain; do not create parallel root-level control-plane folders.
- Do not assume any previous product architecture still exists.
- Create ADRs, feature specs, plans, prompts, or memory notes only when they are relevant to the new direction.
- Modify product/source code only when the user explicitly asks for implementation.
- Do not create or require a repo-local hidden control folder.
- Do not guess missing context. Inspect files or ask.

## Template Behavior

- Keep the source template product-code-free until a repo created from it defines a real product direction.
- Prefer durable template improvements over one-off artifacts when maintaining this template repo.
- In a new repo created from this template, update stale names, assumptions, product context, and architecture notes before implementation.

## Work Accounting & Cost Reporting (required)

End every completed task or work response with a Work Accounting footer reporting model · tokens · cost, and append one entry per session to `usage/usage-log.md`. Use the real usage the active runner reports (Copilot CLI `/usage` + `/context`, OpenCode usage output, or the API response) — never guess from a static price table. Figures are interim, timestamped snapshots finalized at session close; label anything the runtime does not expose as `≈ estimate`, and never fabricate or omit the footer. See `AGENTS.md` → "Work Accounting & Cost Reporting (required)" for the per-runner source map.

Append this block at the very end of the final response:

```text
---
### 🧮 Work Accounting
- Model(s): <actual model id(s)> (+ sub-agent models, if any)
- Tokens: <input> in / <output> out / <total> total   — source: <Copilot /usage + /context · OpenCode usage · API response>
- Cost: <runner-native figure as of HH:MM>   — "$0.0123 USD" (OpenCode) · "~N AIC used @ HH:MM, interim" (Copilot) · "≈ estimate" only if nothing is exposed
```
