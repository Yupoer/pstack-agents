### Opening a PR

Invoked at the end of every other playbook.

Work from a git worktree off trunk, and keep unrelated work out of it. Rebase into small, landable commits. Run `/deslop` from `cursor-team-kit` over the diff before commit.

Title: `type(scope): subject`, naming a real symbol when one carries the change. Body: a one-minute briefing under 40 lines with these `##` headings in order, dropping empty ones: `## Why`, `## What changed`, `## Scope`, `## Tradeoffs` (only rejected alternatives a reviewer would otherwise ask about), `## Blast Radius`, `## Verification`.

Stack follow-ups by base branch. Open PRs ready, through the run's PR tool with `draft: false`. Without one, use `gh pr create` without `--draft`, or `origin pr create --status open` when Origin's CLI resolves the repository. Opening a PR does not start a babysit.

Run the repository's applicable local checks before pushing and inspect their result. During edits, use the affected checks; before push, use the shared quick entrypoint when one exists. CI runs the full relevant suite and environment-specific gates from the same maintained commands. Reuse a pass only while the checked content, dependencies, configuration, and relevant environment remain unchanged. A local pass does not replace the remote gate on the reviewed revision. When CI latency is the task, use [CI performance diagnosis](../../benchmark-checklist/references/ci-performance.md). Installing hooks or reducing CI coverage needs the corresponding task scope.

For CI or CD changes, use [CI recovery](../references/ci-recovery.md). Check workflow dependencies, selected toolchains, required PR metadata, and affected coverage contracts when relevant. Read the exact head's job results before claiming a gate passed. A skipped gate does not prove recovery.
