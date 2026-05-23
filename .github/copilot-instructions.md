# Copilot Instructions - Amistio Template SaaS Brain Scaffold

Use `AGENTS.md` as the primary operating guide. This repository is a reusable template with a `docs/`-based control plane: `docs/architecture/`, `docs/context/`, `docs/decisions/`, `docs/features/`, `docs/memory/`, `docs/plans/`, `docs/prompts/`, and `docs/workflows/`.

## Default Behavior

- Read `AGENTS.md` and relevant `docs/` control-plane files before planning non-trivial work.
- Use `docs/` as the project brain; do not create parallel root-level control-plane folders.
- Do not assume any previous product architecture still exists.
- Create ADRs, feature specs, plans, prompts, or memory notes only when they are relevant to the new direction.
- Modify product/source code only when the user explicitly asks for implementation.
- Do not create or require a repo-local `.amistio/` folder.
- Do not guess missing context. Inspect files or ask.

## Template Behavior

- Keep the source template product-code-free until a repo created from it defines a real product direction.
- Prefer durable template improvements over one-off artifacts when maintaining this template repo.
- In a new repo created from this template, update stale names, assumptions, product context, and architecture notes before implementation.
