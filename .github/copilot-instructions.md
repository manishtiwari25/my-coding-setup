# Copilot Instructions - Amistio Template SaaS Brain Scaffold

Use `AGENTS.md` as the primary operating guide. This repository is a reusable template with a root-level control plane: `architecture/`, `context/`, `decisions/`, `features/`, `memory/`, `plans/`, `prompts/`, and `workflows/`.

## Default Behavior

- Read `AGENTS.md` and relevant root control-plane files before planning non-trivial work.
- Do not use `docs/` as the project brain; root control-plane folders are canonical.
- Do not assume any previous product architecture still exists.
- Create ADRs, feature specs, plans, prompts, or memory notes only when they are relevant to the new direction.
- Modify product/source code only when the user explicitly asks for implementation.
- Do not create or require a repo-local `.amistio/` folder.
- Do not guess missing context. Inspect files or ask.

## Template Behavior

- Keep the source template product-code-free until a repo created from it defines a real product direction.
- Prefer durable template improvements over one-off artifacts when maintaining this template repo.
- In a new repo created from this template, update stale names, assumptions, product context, and architecture notes before implementation.
