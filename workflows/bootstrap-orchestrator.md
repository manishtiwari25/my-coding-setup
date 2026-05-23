# Workflow - Bootstrap Orchestrator In Another Repo

Use this workflow when setting up another repository with an Amistio-style control plane.

## Steps

1. Inspect the target repo first.
2. Preserve existing instructions and product code.
3. Decide whether the target should use root control-plane folders or `docs/` control-plane folders.
4. Create or merge `AGENTS.md`, `.github/copilot-instructions.md`, `architecture/`, `context/`, `decisions/`, `features/`, `memory/`, `plans/`, `prompts/`, and `workflows/` as appropriate.
5. Keep prompts model-agnostic.
6. Summarize assumptions and missing information.

## Layout Rule

- If the repo is itself an orchestrator/product-brain product, prefer root control-plane folders.
- If the repo is a normal product that only uses orchestrator discipline, prefer `docs/` control-plane folders.