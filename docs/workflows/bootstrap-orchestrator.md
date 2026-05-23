# Workflow - Bootstrap Orchestrator In Another Repo

Use this workflow when setting up another repository with an Amistio-style control plane.

## Steps

1. Inspect the target repo first.
2. Preserve existing instructions and product code.
3. Use `docs/` control-plane folders by default unless the target repository already has a documented alternative.
4. Create or merge `AGENTS.md`, `.github/copilot-instructions.md`, `docs/architecture/`, `docs/context/`, `docs/decisions/`, `docs/features/`, `docs/memory/`, `docs/plans/`, `docs/prompts/`, and `docs/workflows/` as appropriate.
5. Keep prompts model-agnostic.
6. Summarize assumptions and missing information.

## Layout Rule

- Prefer `docs/` control-plane folders for new Amistio-style scaffolds.
- Preserve an existing documented layout if the target repository already has one.