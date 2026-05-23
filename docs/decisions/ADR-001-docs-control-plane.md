---
id: ADR-001
title: Use Docs-Based Control Plane
status: Accepted
date: 2026-05-23
areas: [template, documentation, agents]
tags: [adr, scaffold, control-plane]
---

# ADR-001: Use Docs-Based Control Plane

## Context

The original template kept control-plane folders at the repository root. The public template should keep the root cleaner while preserving the same agent-friendly project brain.

## Decision

Use `docs/` as the canonical location for the control plane:

- `docs/architecture/`
- `docs/context/`
- `docs/decisions/`
- `docs/features/`
- `docs/memory/`
- `docs/plans/`
- `docs/prompts/`
- `docs/workflows/`

Keep root-level agent entrypoints, including `AGENTS.md`, `CLAUDE.md`, and `.github/copilot-instructions.md`, and have them direct agents to the `docs/` control plane.

## Consequences

### Positive

- The template root is easier to scan for users browsing the public repository.
- Project-brain files are grouped under a familiar documentation namespace.
- Agent entrypoints remain discoverable at the root and in `.github/`.

### Negative

- Existing references to root-level control-plane folders must be updated when migrating older repos.
- Agents must read the entrypoint files carefully so they do not recreate root-level folders.

## Follow-Up

- [x] Move control-plane folders under `docs/`.
- [x] Update root agent entrypoints to point to `docs/`.
- [x] Update templates, prompts, workflows, and README references.