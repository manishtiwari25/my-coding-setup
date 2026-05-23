# CLAUDE.md

Instructions for Claude-based agents working in this repository.

## Start Here

- Read `AGENTS.md` first and treat it as the primary operating guide.
- Use the `docs/` control-plane folders as the source of truth: `docs/architecture/`, `docs/context/`, `docs/decisions/`, `docs/features/`, `docs/memory/`, `docs/plans/`, `docs/prompts/`, and `docs/workflows/`.
- Keep this source repository generic, reusable, and product-code-free until a repo created from it defines a real product direction.
- Do not create parallel root-level control-plane folders or a repo-local `.amistio/` folder.
- Do not assume stale product architecture or implementation choices. Inspect files or ask when context is missing.

## Operating Mode

- Default to orchestrator/template mode: clarify direction, read relevant control-plane context, and update plans, prompts, ADRs, feature specs, workflows, or memory only when they are useful.
- Enter implementation mode only when the user explicitly asks for product/source changes and the target product structure exists.
- Prefer durable template improvements over one-off project artifacts when maintaining this template repository.
- Keep prompts, workflows, and guidance model-agnostic unless the file is explicitly a tool-specific entry point like this one.

## Repository Conventions

- Use `docs/plans/` for non-trivial work plans.
- Use `docs/decisions/` for accepted or proposed architectural/product choices.
- Use `docs/features/` for product behavior specs.
- Use `docs/memory/` only for durable lessons, mistakes, product rules, or conventions that future agents should reuse.
- Use `docs/prompts/` for reusable or generated implementation prompts.
- Verify with available commands after implementation. If no product stack exists yet, do not invent build or test commands.

## Claude-Specific Notes

- Keep edits scoped, minimal, and consistent with the existing scaffold.
- Avoid adding product assumptions, stack choices, or generated source code to the template before the product direction is documented.
- When creating a new repo from this template, update stale template names and assumptions in `README.md`, `AGENTS.md`, `.github/copilot-instructions.md`, `docs/context/`, and `docs/architecture/` before implementation.
- If `AGENTS.md` and this file diverge, follow `AGENTS.md` and update this file to match the current repository rules.
