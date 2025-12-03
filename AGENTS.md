# Agent Guide for Microsoft365DSC

Purpose: concise, enforceable rules for AI coding agents editing this repository.

- Default branch target: feature branch according to naming standards. Start from `dev` and never modify `master`.
- Workflow: open a todo via `manage_todo_list`, mark `in-progress`, apply focused patches, rethink your changes, present to the user for approval, mark `completed`.
- Always present the changes to the user before marking work completed.
- Never add secrets or credentials to commits; if a change requires secrets, create a placeholder and document required manual steps in the PR.

Quick checklist:

1. Add a todo and mark `in-progress`.
2. Make minimal `apply_patch` edits.
3. Rethink changes and present to the user.
4. If accepted, mark todo `completed` and summarize results.
