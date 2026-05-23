# Architecture Overview

## Status

Draft. The product direction is a SaaS/app brain with a UI, but the concrete stack and deployment model are not decided yet.

## Intended Shape

Amistio should become a product brain that helps define, remember, plan, and execute software work through a structured control plane:

- Context and architecture understanding
- ADRs and product decisions
- Feature specs and plans
- Prompt generation
- Memory and lessons learned
- Future UI/workflow for operating the brain

## Open Decisions

- Web SaaS, desktop app, CLI/TUI, or hybrid first surface
- Hosted backend and database requirements
- Auth and billing model
- Execution model: manual prompt execution, local runner, or future cloud execution
- Storage model for project brain data