# Agents - Amistio Template SaaS Brain Scaffold

## Repository Scope

This repository is a reusable template for a clean root-level control-plane scaffold. It is designed for a future SaaS product that acts as a project/product "brain" through a UI or local workflow. The product source has not been defined yet.

Root control-plane folders are the source of truth:

```text
architecture/   System architecture and high-level design
context/        Product, stack, and implementation context
decisions/      ADRs and architectural/product decisions
features/       Feature and product behavior specs
memory/         Patterns, lessons, mistakes, and conventions
plans/          Work plans for non-trivial tasks
prompts/        Generated and reusable implementation prompts
workflows/      Repeatable orchestrator procedures
```

Future product code may live in `src/`, `apps/`, `packages/`, `services/`, or another structure after the product direction is decided in the repo created from this template.

## Operating Modes

- **Orchestrator mode (default):** read root control-plane files, clarify the desired outcome, then create or update plans, feature specs, ADRs, prompts, workflows, and memory as needed.
- **Implementation mode (explicit):** modify product/source code only after the user explicitly asks for implementation and the target product structure exists.
- **Template mode:** keep this source template generic, reusable, and product-code-free. Improve enduring onboarding, templates, workflows, and agent instructions instead of adding one-off project artifacts.
- **Bootstrap/Product Factory mode:** adapt this scaffold into another repository while preserving that repository's existing source code and instructions.

## Critical Rules

- The root control plane is canonical. Do not create a parallel `docs/` brain unless a new ADR changes this decision.
- Do not assume any previous product architecture still exists.
- Do not create or require a repo-local `.amistio/` folder.
- Do not add product code before the new direction is defined or explicitly requested.
- Keep plans, prompts, and templates model-agnostic.
- When creating a new repo from this template, update stale template assumptions in `README.md`, `AGENTS.md`, `.github/copilot-instructions.md`, `context/`, and `architecture/` before implementation.
- If context is missing, inspect files or ask before inventing requirements.

## Template Map

- `decisions/_template.md` for architectural decisions.
- `features/_template.md` for feature specs.
- `plans/_template.md` for execution plans.
- `memory/_template.md` for future lessons and conventions.
- `prompts/shared/` for reusable prompt templates.

## Workflow

1. Understand the user's desired new product, template update, or scaffold change.
2. Read `memory/`, `decisions/`, `architecture/`, and `context/` before planning.
3. Create or update a plan using `plans/_template.md` when the work is non-trivial.
4. Create ADRs only for real architectural choices.
5. Create feature specs only for real product behavior.
6. Generate implementation prompts before implementation when useful.
7. Implement only after the user explicitly asks for code changes.
8. Verify with the commands available in the new product structure.
9. Update memory when a durable pattern, lesson, or mistake is discovered.

## Routing

| Request Type              | Read First                                                                                           | Write To                                        |
| ------------------------- | ---------------------------------------------------------------------------------------------------- | ----------------------------------------------- |
| New SaaS/product idea     | `context/`, `memory/`, `decisions/`, `architecture/`                                                 | `plans/`, `features/`, `decisions/`, `prompts/` |
| Architecture decision     | `decisions/`, `architecture/`, `context/`                                                            | `decisions/`, `architecture/`, `memory/`        |
| Feature prompt generation | `features/`, `context/`, `memory/`                                                                   | `prompts/`                                      |
| Learning or mistake       | `memory/`                                                                                            | `memory/`                                       |
| Template maintenance      | `AGENTS.md`, `README.md`, `.github/copilot-instructions.md`, root control-plane READMEs              | durable template docs/config                    |
| Bootstrap another repo    | `workflows/bootstrap-orchestrator.md`, `prompts/shared/bootstrap-orchestrator-in-new-repo.prompt.md` | `prompts/shared/`, `workflows/`                 |

## Product Direction Notes

The expected product direction is a SaaS/app that provides an orchestrator brain through a UI. In a repo created from this template, the first durable step is to define the product through `plans/`, `features/`, and `decisions/`; implementation code should follow only after those documents exist.
