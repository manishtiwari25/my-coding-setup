# Workflow - Prompt Generation

1. Read the relevant feature spec, ADRs, context, and memory.
2. Decide whether one prompt or multiple ordered prompts are needed.
3. Use `docs/prompts/shared/_feature-prompt-template.md` as the base.
4. Include likely files, requirements, approach, acceptance criteria, and verification.
5. Keep prompts model-agnostic and execution-environment agnostic.
6. Do not create shell scripts to batch-run prompts.