---
id: S-BOOTSTRAP-ORCHESTRATOR
title: Bootstrap Orchestrator In A New Repo
status: Template
date: 2026-05-15
target: shared
tags: [prompt, bootstrap, orchestrator, product-factory]
---

# Bootstrap Orchestrator In A New Repo

## Goal

Set up this repository with an agent-friendly `docs/` control plane: agent instructions, architecture, project context, memory templates, decision records, feature specs, workflows, and model-agnostic prompt templates.

The result should make this repo self-documenting and agent-friendly. When I ask for a feature, bug fix, architectural decision, or product change, the agent should first read project context, memory, and decisions, then create or update specs and prompts before touching product code unless I explicitly ask for direct implementation.

## Operating Rules

- Inspect this repository first.
- Do not rewrite, reorganize, or refactor product code.
- Do not modify app/source files unless I explicitly approve implementation mode.
- Prefer creating or updating orchestration/documentation files only.
- Preserve existing README files, package files, source code, configs, test setup, and deployment notes.
- If existing agent, instruction, memory, docs, or architecture files exist, merge carefully instead of overwriting.
- Use this repository's actual stack, folders, product names, test commands, and conventions.
- Do not assume this repository has the same domain or stack as the source scaffold.

## Create Or Update This Scaffold

Create or update these files and folders as appropriate for this repo:

```text
AGENTS.md
.github/copilot-instructions.md
docs/architecture/
docs/context/
docs/decisions/
docs/features/
docs/memory/
docs/plans/
docs/prompts/
docs/workflows/
```

Keep the control plane under `docs/` unless an existing repository convention or an explicit ADR requires another layout.

## Validation

After creating or updating the scaffold:

- Check that no product-code files were modified.
- Check that existing instructions were preserved.
- Check that file names and folder names match this repo.
- Check that markdown links point to files that exist.
- Check that prompt templates remain model-agnostic.
- Check that workflows are actionable for this repo.

## Final Response

Summarize:

- Files created or updated.
- Assumptions made.
- Missing information I should fill in.
- The first recommended next prompt to use in this repo.