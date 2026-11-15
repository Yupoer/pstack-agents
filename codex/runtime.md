# pstack in Codex

This installation is owned by Codex. Read this file once before following a pstack skill. User and project instructions take precedence over skill defaults. Preserve poteto-mode's goals, scope, autonomous execution, and observable verification while following those instructions.

## Files and updates

`~/.agents/skills/<name>` points to `~/.codex/pstack/runtime/skills/<name>`. The runtime holds a versioned copy of this fork's skills, agents, and license, with Codex-specific skill overrides from `codex/skills/`. Resolve relative links from the runtime skill's actual location. Upstream setup guides remain in the checkout for reference and are not installed. No other coding application, plugin installation, or external CLI delegation is required.

Run `~/.codex/pstack/sync-pstack.ps1 -SourceRoot <checkout>` to install the checkout's current content. Git synchronization is a separate operation. The installer preserves previous runtime versions, link targets, and changed integration files under `~/.codex/pstack/backups/`. Change maintained files in the checkout, then reinstall.

## Native tools

| Upstream wording | Codex behavior |
| --- | --- |
| `/name` | Invoke the installed skill by its discovered name, or read its `SKILL.md`. |
| Run another pstack skill | Read `../<name>/SKILL.md` from the current runtime skill. |
| `Read`, `Glob`, `Grep`, `Bash` | Use native file and shell tools. Prefer `rg` and PowerShell-safe commands on Windows. |
| `AskQuestion`, `AskUserQuestion` | Use the available user-input tool for necessary questions. |
| `TodoWrite`, todolist | Use the available planning tool or one concise local handoff. |
| `Task`, `Agent`, `generalPurpose` | Use native subagents when the current instructions authorize delegation. Use only supported tool fields. |
| `poteto-agent` | Brief a native subagent with this runtime, `skills/poteto-mode/SKILL.md`, the goal, scope, and acceptance criteria. |
| `comment-sicko` | Brief a read-only native subagent with `agents/comment-sicko.md`. |
| `readonly: true` | Require inspection only and check the working tree afterward. |
| `environment: "cloud"` | Use a git worktree when isolation is needed. |
| `.cursor/skills/` | Use the project's `.agents/skills/` or the user's `~/.agents/skills/`. |
| `.cursor/rules/`, always-applied rules | Use the relevant `AGENTS.md`. Model roles have their own file below. |

## Model roles

Read `~/.codex/pstack/pstack-models.md` before the first delegation. It owns the role choices. The supplied configuration uses `gpt-6.1-sol max` for judgment and specialist roles and retains two seats for panels. Use native model and reasoning-effort fields when supported. With `spawn_agent`, set `fork_turns: "none"` for a model or effort override and include the necessary context in the brief.

Use only the latest released version within the selected provider's model family or tier, and only identifiers exposed by the current tools. As of 2026-11-06, the approved OpenAI versions are Luna `gpt-6-luna`, Terra `gpt-6.1-terra`, Sol `gpt-6.1-sol`, and Astra `gpt-6-astra`. Newer confirmed releases replace these dated versions. Older versions remain forbidden even if listed as available. Apply the same rule to other providers; verify new or uncertain releases against official sources. Preserve the configured provider, family, tier, effort, and panel seats.

If the latest configured model cannot run or cannot be verified, stop that call and report the limitation. Never fall back to an older version, a different provider, a shell delegate, or an opaque routing alias. An `auto`, `inherit-parent`, or omitted override is allowed only when the resolved parent/default is verified compliant. These rules override older model and fallback examples in skills and playbooks. A same-model panel is independent review, not provider diversity.

Unless a role has an explicit default here, missing role lines use the current Codex model only when it satisfies this policy. `setup-pstack` edits this Codex-owned model file. It does not write another application's settings. Background memory extraction and consolidation have separate `memories.extract_model` and `memories.consolidation_model` settings; the chat model does not configure them. Instruction rules and defaults do not provide an API-level denylist or control an internal service's unexposed model choice.

## Work in parallel

Apply this to any Codex task. Playbooks still set the required checks and dependencies. Start independent work as soon as its inputs are ready, even when a playbook lists it later.

1. Identify each piece's inputs, output, and write targets. If the result is useful regardless of which piece finishes first, run the pieces together. Pin reads to a revision, build, or captured log when another piece can change the input. Give writers separate worktrees or output paths. Give one operator exclusive control of each device or browser session it drives. Only conflicting operations on shared state and steps that need a later result have to wait.
2. Batch cheap independent tool calls. Start self-contained work that can overlap in native background calls or authorized subagents. Group work that shares reasoning or needs frequent coordination. Use available capacity for useful work without filling slots for their own sake.
3. Keep doing useful work in the parent while calls run. Wait only when the next decision needs a result, and start newly unblocked work without waiting for the whole group. Review the required results before reporting completion.

### Delegate mechanical execution

Use the `mechanical execution` role for command-only requests and scripted operations that need no interpretation. Use the configured model, or default to the latest verified Terra at `low` (`gpt-6.1-terra low` in the model list above) if an existing model file lacks the role. Luna is also a configurable choice when the latest version supports the required tools. Keep the model policy above. If there is no suitable delegate, use the available native tools directly within the same authorization.

Give the worker only the command or scripted steps, working directory or target ID, input revision or build when relevant, permitted changes, and an evidence path the parent can read. Tell it to run the steps as written. For commands, return the command, exit status, and unchanged output, or paths to the raw output. For interactions, return the actions taken, observed states, and any requested screenshots or logs. Stop and report an unexpected state that calls for a decision. The worker can operate the actual tool for a required reproduction or check. The parent inspects the evidence and owns the verdict.

- **Simulator or browser checks.** Give one operator the specified simulator or browser session and the known build. Inspect the code or run independent checks while it works. Read its screenshots and logs when they arrive. A test of a new build still waits for that build.
- **Bug repair.** Once the work has enough evidence to start, let one owner repair the bug, another assess prevention against the captured failure, and another look for relevant upstream issues or open source examples, if those results can help. Let prevention propose a check or own a disjoint change against a stable contract. Review and verify the combined result after the fix.
- **Logs and test runs.** Collect existing logs or run independent checks against a fixed revision in separate output directories. Interpret the evidence as it arrives. Wait for both results only when a comparison needs both.

## Platform limits

Use the actual native browser, skill-creator, review, and automation tools where available. A reference to a tool or API does not make it available. For an unavailable platform step, state `Skipped in Codex: <step>. <reason>.` and continue work that does not depend on it. Do not invent verification evidence.

Cursor Custom Modes, Bugbot, cloud agents, `/loop`, and provider panels are not supplied by this installation. Scheduling requires a user request and the native automation capability. Do not start it from a playbook's suggestion alone.

For a UI, visual prototype, diagram, chart, or interactive explanation, read `runtime/skills/poteto-mode/references/visual-design.md` relative to `~/.codex/pstack/`. Apply the relevant guidance within the brief and the actual host's capabilities.
