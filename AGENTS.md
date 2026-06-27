# Agents - Project Brain Template

## Repository Scope

This repository is a reusable template for a clean `docs/`-based control-plane scaffold. It is designed for a future product, app, service, or workflow that needs a durable project brain before product code exists.

The `docs/` control-plane folders are the source of truth:

```text
docs/architecture/   System architecture and high-level design
docs/context/        Product, stack, and implementation context
docs/decisions/      ADRs and architectural/product decisions
docs/features/       Feature and product behavior specs
docs/memory/         Patterns, lessons, mistakes, and conventions
docs/plans/          Work plans for non-trivial tasks
docs/prompts/        Generated and reusable implementation prompts
docs/workflows/      Repeatable agent procedures
```

Future product code may live in `src/`, `apps/`, `packages/`, `services/`, or another structure after the product direction is decided in the repo created from this template.

## Operating Modes

- **Planning mode (default):** read `docs/` control-plane files, clarify the desired outcome, then create or update plans, feature specs, ADRs, prompts, workflows, and memory as needed.
- **Implementation mode (explicit):** modify product/source code only after the user explicitly asks for implementation and the target product structure exists.
- **Template mode:** keep this source template generic, reusable, and product-code-free. Improve enduring onboarding, templates, workflows, and agent instructions instead of adding one-off project artifacts.
- **Bootstrap mode:** adapt this scaffold into another repository while preserving that repository's existing source code and instructions.

## Critical Rules

- The `docs/` control plane is canonical. Do not create parallel root-level control-plane folders unless a new ADR changes this decision.
- Do not assume any previous product architecture still exists.
- Do not create or require a repo-local hidden control folder.
- Do not add product code before the new direction is defined or explicitly requested.
- Keep plans, prompts, and templates model-agnostic.
- When creating a new repo from this template, update stale template assumptions in `README.md`, `AGENTS.md`, `.github/copilot-instructions.md`, `docs/context/`, and `docs/architecture/` before implementation.
- If context is missing, inspect files or ask before inventing requirements.

## Work Accounting & Cost Reporting (required)

End **every** completed task or work response with a Work Accounting footer reporting model, tokens, and cost. Use the real usage the active runner already reports — never guess or estimate from a static price table.

Figures are interim, timestamped snapshots: token counts and credit/AIC/USD counters are cumulative and keep climbing while the session runs, so any committed value is point-in-time and only finalized at session close. If the runtime does not expose an exact figure, report the model plus whatever the runner's usage view shows, and label anything unreadable as `≈ estimate`. Never fabricate. Never omit the footer.

In addition to the footer, append one entry per session to `usage/usage-log.md` (see that file's header for the recording rules). The ledger is agent-driven: there is no automatic git or CLI hook, and the AIC/credit value must be pasted by a human from the runner's status line.

### Per-runner source map

| Runner               | Model source  | Token usage source      | Cost / spend unit                      |
| -------------------- | ------------- | ----------------------- | -------------------------------------- |
| GitHub Copilot CLI   | `/model`      | `/context`, `/usage`    | AIC used (status line / `/usage`)      |
| OpenCode             | runner banner | runner usage output     | direct money (USD)                     |
| Anthropic/Claude API | request/model | provider response usage | input/output tokens (+ USD if shown)   |
| Other API runner     | request/model | provider response usage | tokens, or USD if the runner prints it |

### Footer template

Append this block at the very end of the final response:

```text
---
### 🧮 Work Accounting
- Model(s): <actual model id(s)> (+ sub-agent models, if any)
- Tokens: <input> in / <output> out / <total> total   — source: <Copilot /usage + /context · OpenCode usage · API response>
- Cost: <runner-native figure as of HH:MM>   — "$0.0123 USD" (OpenCode) · "~N AIC used @ HH:MM, interim" (Copilot) · "≈ estimate" only if nothing is exposed
```

For GitHub Copilot CLI sessions, `scripts/usage-snapshot.sh` extracts the real model and output-token figures from the local event log; the AIC counter is a live status-line value (`Session: N AIC used`) and must be pasted manually.

## Template Map

- `docs/decisions/_template.md` for architectural decisions.
- `docs/features/_template.md` for feature specs.
- `docs/plans/_template.md` for execution plans.
- `docs/memory/_template.md` for future lessons and conventions.
- `docs/prompts/shared/` for reusable prompt templates.

## Workflow

1. Understand the user's desired new product, template update, or scaffold change.
2. Read `docs/memory/`, `docs/decisions/`, `docs/architecture/`, and `docs/context/` before planning.
3. If the product direction is not documented, ask or infer only the first required intake facts: project name, users, problem, first outcome, existing code boundaries, stack constraints, integrations, verification commands, and the first decision/spec/plan to draft.
4. Create or update a plan using `docs/plans/_template.md` when the work is non-trivial.
5. Create ADRs only for real architectural choices.
6. Create feature specs only for real product behavior.
7. Generate implementation prompts before implementation when useful.
8. Implement only after the user explicitly asks for code changes.
9. Verify with the commands available in the new product structure.
10. Update memory when a durable pattern, lesson, or mistake is discovered.

## Routing

| Request Type              | Read First                                                                                                       | Write To                                                            |
| ------------------------- | ---------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------- |
| New product idea          | `docs/context/`, `docs/memory/`, `docs/decisions/`, `docs/architecture/`                                         | `docs/plans/`, `docs/features/`, `docs/decisions/`, `docs/prompts/` |
| Architecture decision     | `docs/decisions/`, `docs/architecture/`, `docs/context/`                                                         | `docs/decisions/`, `docs/architecture/`, `docs/memory/`             |
| Feature prompt generation | `docs/features/`, `docs/context/`, `docs/memory/`                                                                | `docs/prompts/`                                                     |
| Learning or mistake       | `docs/memory/`                                                                                                   | `docs/memory/`                                                      |
| Template maintenance      | `AGENTS.md`, `README.md`, `.github/copilot-instructions.md`, `docs/*/README.md`                                  | durable template docs/config                                        |
| Bootstrap another repo    | `docs/workflows/bootstrap-control-plane.md`, `docs/prompts/shared/bootstrap-control-plane-in-new-repo.prompt.md` | `docs/prompts/shared/`, `docs/workflows/`                           |

## Product Direction Notes

This template does not assume a product domain, UI, runtime, or deployment model. In a repo created from this template, the first durable step is to define the actual product through `docs/context/`, `docs/plans/`, `docs/features/`, and `docs/decisions/`; implementation code should follow only after those documents exist.
