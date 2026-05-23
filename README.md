# Amistio Template

A reusable root-level control-plane template for shaping a SaaS/app product brain before product code exists.

This repository is intentionally lightweight. It gives future projects a place to define product context, architecture, ADRs, feature specs, memory, execution plans, workflows, and implementation prompts before the first app folder appears.

## Use This Template

1. Create a new repository from this template.
2. Rename the project and update product assumptions in `README.md`, `AGENTS.md`, `.github/copilot-instructions.md`, `context/product.md`, and `architecture/overview.md`.
3. Fill in the first product context and open questions under `context/`.
4. Create the first product-definition plan in `plans/` from `plans/_template.md`.
5. Record real architecture and stack choices as ADRs in `decisions/` before adding source code.
6. Add product code only after the MVP behavior is captured in `features/` and the initial stack decision is accepted.

## What This Template Provides

- Agent operating instructions that make the root control plane canonical.
- Product and stack context files for early discovery.
- ADR, feature spec, plan, memory, workflow, and prompt templates.
- Shared prompts for bootstrapping another repo, code style, feature implementation, and review.
- Minimal repository hygiene for future web, backend, and local-tooling code.

## Repository Map

```text
AGENTS.md                         Primary operating guide for coding agents
CLAUDE.md                         Claude-specific entrypoint that delegates to AGENTS.md
.github/copilot-instructions.md   Concise Copilot entrypoint
architecture/                     System architecture and product design
context/                          Product and stack context
decisions/                        ADR template and future decisions
features/                         Feature/spec template and future specs
memory/                           Memory templates, patterns, and mistakes
plans/                            Work-plan template and future plans
prompts/                          Reusable and generated prompts
workflows/                        Repeatable orchestrator workflows
```

Future product code can live under `src/`, `apps/`, `packages/`, `services/`, or another structure after the product direction is defined.

## Agent Workflow

- Read `AGENTS.md` first, then relevant files in `context/`, `architecture/`, `decisions/`, and `memory/`.
- Use `plans/` for non-trivial work, `features/` for product behavior, and `decisions/` for architectural choices.
- Keep prompts model-agnostic and testable.
- Do not introduce product source code until the product direction, MVP behavior, and initial stack are documented.
- Update `memory/` only when a durable convention, product rule, lesson, or mistake appears.

## First Product Pass

For a new project created from this template, start with these files:

```text
context/product.md
context/stack.md
architecture/overview.md
plans/_template.md
decisions/_template.md
features/_template.md
```

The first useful deliverables are usually:

- A product-definition plan in `plans/`.
- An initial MVP feature spec in `features/`.
- An ADR for the first user surface and stack in `decisions/`.
- A short prompt in `prompts/` that can hand implementation work to an agent once the product boundary is clear.

## Template Publishing Checklist

- Confirm this repository has fresh Git history before publishing.
- Set the GitHub repository as a template repository.
- Add a license if the template will be shared outside a private workspace.
- Replace stale product assumptions after creating a new repo from the template.
- Add real test, build, and verification commands only after a product stack exists.
