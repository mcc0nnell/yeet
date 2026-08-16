---
name: "yeet"
description: "Use when the user wants an already-understood repository change shipped with minimum ceremony (for example: 'yeet it', 'ship it', 'land it', or a contextually clear 'do it then'). Preserve the user's explicitly chosen destination and write path, choose the fastest safe transport available, validate proportionally, and verify the resulting remote state. Yeet is an execution mode, not permission escalation: never bypass branch protection, credentials, policy, required review, or destructive-safety constraints."
---

# Yeet

## Purpose

Turn a settled coding decision into a verified repository result with the least unnecessary process.

The operating principle is:

> **Minimum ceremony, maximum certainty.**

`yeet` exists for the moment after the user has already decided what should happen. Do not restart planning, invent a new workflow, or substitute a generic publishing ritual when the requested destination and scope are already clear.

Examples:
- "Yeet it."
- "Ship that."
- "Do it then." — when the immediately preceding context clearly defines the change and destination.
- "Commit this directly to main."
- "Patch it and land it."
- "Fix those URL/image issues before merge, then merge."

Do **not** trigger merely because the word "yeet" appears in prose, documentation, tests, or an unrelated discussion.

## Core contract

1. **Carry forward explicit intent.**
   - Reuse the repository, branch, PR, destination, scope, and constraints already established in the conversation.
   - A later explicit instruction overrides a generic default workflow.
   - Do not ask the user to repeat information that is already known or can be resolved from the repository.

2. **Execution over ceremony.**
   - If the task is settled, act.
   - Do not create a plan document, draft PR, issue, branch, or approval loop unless it is required by the repository, the available transport, or the user's instruction.
   - Do not narrate every command. Report the meaningful result.

3. **Safety over speed when they conflict.**
   - Never bypass branch protection, required review, credentials, signing requirements, repository policy, or platform safety constraints.
   - Never force-push, rewrite shared history, delete unrelated work, or silently widen scope just to make the operation succeed.
   - "Yeet" is not authorization to escalate privileges.

4. **Verify, don't assume.**
   - A local edit is not completion.
   - A commit is not completion when the user asked for a push/merge.
   - A connector write is not completion until the resulting remote state is re-read or otherwise verified.
   - Report the commit/PR/branch state actually observed.

## Resolve the target before writing

Infer these from context and repository state:

- repository
- intended change
- scope boundary
- destination:
  - working tree only
  - commit on current branch
  - push branch
  - update existing PR
  - merge existing PR
  - direct write to default branch
- validation expectation
- whether CI must be checked after the write

If one of these is genuinely ambiguous **and the ambiguity could cause a materially different write**, ask one concise question. Otherwise resolve it from context and proceed.

### Contextual "do it"

Treat short follow-ups such as "do it", "do it then", "ship it", and "fix it" as authorization to execute the immediately preceding concrete operation when:
- the repository or artifact is already established,
- the requested change is already specific enough to implement,
- and the destination has been stated or is unambiguous from the preceding exchange.

Do not reinterpret a vague "do it" as permission to merge, deploy, delete, publish, or write to `main` when those actions were not already established.

## Choose the fastest safe transport

Use the best available write path. Do not insist on a local checkout if a connected repository tool can complete the task safely.

### A. Local git + GitHub CLI

Prefer this when a usable checkout exists and the requested operation involves multiple files, tests, or an atomic commit.

Typical flow:
1. inspect `git status`, branch, remotes, and upstream
2. fetch the relevant remote refs
3. inspect repository instructions (`AGENTS.md`, `CONTRIBUTING`, local policy files) when relevant
4. make only the intended changes
5. run proportional validation
6. review the diff
7. commit atomically
8. push or merge as requested
9. verify the remote SHA / PR state / checks

### B. Connected GitHub write path

Use this when the workspace has connector-only repository access or when it is clearly the most direct supported path.

Rules:
- Fetch the current file/blob SHA before replacing an existing file.
- Use SHA-guarded updates when available.
- Re-read the file, branch, commit, or PR state after the write.
- For sequential multi-file writes, preflight all target paths first and stop on the first conflict or stale SHA.
- Prefer a transport capable of one atomic multi-file commit when available.
- Do not pretend sequential content-API writes are atomic.

### C. Existing PR

When the requested target is an existing PR:
- update that PR's branch rather than opening a duplicate
- preserve its intended base branch unless the user says otherwise
- inspect unresolved review comments/check failures that materially block merge
- if the user has already authorized merge, merge once required conditions are satisfied
- verify merged state and resulting base-branch SHA

### D. Direct-to-default-branch

Use only when direct write is explicitly requested or unambiguously established in the preceding context.

Before writing:
- confirm the current remote head
- confirm the change is narrowly scoped
- check whether branch protection or required checks prohibit direct writes
- prefer one atomic commit for multi-file changes

After writing:
- verify the default branch contains the intended commit/content
- check immediately observable CI/check state when relevant

If repository policy prevents direct write, do not work around it. Use the narrowest compliant path and explain the constraint.

## Scope lock

Before editing, state internally what files or behaviors are in scope.

During execution:
- do not fix unrelated lint, formatting, dependency, or test issues unless they block the requested change
- do not opportunistically refactor adjacent code
- do not update generated files unless the repository expects them
- preserve unrelated local modifications
- never clean/reset/stash another user's work without explicit necessity and authorization

If a necessary change expands scope, keep it minimal and explain why in the completion summary.

## Proportional validation

Validation should match the risk.

### Tier 0 — metadata/docs-only
Use structural validation as relevant:
- file exists
- syntax parses
- links/paths referenced by the change resolve when cheaply checkable
- no accidental diff outside scope

### Tier 1 — narrow code/config change
Run the smallest relevant checks:
- targeted unit test
- formatter/linter on touched files
- typecheck for affected package/module
- config parser/validator
- repository-provided focused test command

### Tier 2 — behavior or integration change
Run:
- targeted tests
- the relevant package/module test suite
- build/typecheck when the change affects compilation or packaging

### Tier 3 — release/deployment/critical-path change
Run the repository's required preflight plus relevant build/integration checks.

Do not run a huge test suite merely to appear thorough when a focused check gives the same confidence. Do not skip a cheap, directly relevant test merely to be fast.

If a required test cannot run because of environment/tooling limitations, state that explicitly and compensate with the best available static/structural verification.

## Diff gate

Before the final write/commit/merge:
- inspect the actual diff or replacement content
- confirm only intended files changed
- confirm no secrets, tokens, generated junk, debug output, or accidental binary files were introduced
- confirm filenames, URLs, IDs, and paths match the user's requested values exactly
- confirm no merge markers remain

For generated assets or captures:
- verify non-empty output
- verify expected filename/path
- verify provenance/source mapping when the repository tracks it
- never overwrite an existing authentic artifact unless overwrite was explicitly intended

## Failure semantics

Hard-fail rather than paper over uncertainty when:
- the remote head changed and would invalidate the planned write
- a required file/blob SHA is stale
- branch protection blocks the requested operation
- a merge has conflicts
- a required check fails because of the proposed change
- the target file/path is not the one expected
- validation shows the change is wrong
- the write path would require destructive history rewriting

On failure:
1. preserve the repository in the safest recoverable state
2. gather the smallest useful diagnostic
3. fix automatically when the correction is clearly within scope
4. otherwise report the exact blocker and smallest next action

Do not loop endlessly. Do not weaken tests or remove safeguards just to produce green status.

## CI handling

If CI starts as a direct consequence of the write:
- inspect the immediately available status
- if checks complete quickly, verify them
- if they are still running, report that truthfully rather than claiming success
- if a failure is clearly caused by the change and can be fixed within scope, fix it
- if the failure is pre-existing or external, distinguish that explicitly

Do not claim "done" when the requested outcome included passing checks and those checks are known to be failing.

## Completion standard

The final response should be short and concrete.

Include only what matters:
- what was changed
- where it landed (branch / PR / default branch)
- verification performed
- commit SHA / PR number when available
- any remaining CI or external blocker

Good:
> Patched the 10 capture strategies and pushed them to `main` as `abc1234`. The pending-map sync check and overwrite protection are in place; targeted tests pass. GitHub shows `main` at `abc1234`.

Bad:
> I have begun working on the changes and will now inspect...

Bad:
> Done!  
when only local files were edited and nothing was pushed.

## Interaction with other skills

`yeet` is a terminal execution skill. It may use specialized skills for implementation or diagnostics, but those skills must not replace an already-settled user destination with their own default publishing ceremony.

Examples:
- A CI skill may diagnose a failed check, then return control to `yeet` for the already-authorized write/merge.
- A deployment skill may perform the platform-specific deploy, while `yeet` preserves the user's chosen branch/release semantics.
- A generic PR-publishing skill should **not** force a new draft PR when the user explicitly requested direct-to-`main`.

When instructions conflict, honor:
1. platform/system safety and repository policy
2. the user's explicit current instruction
3. established conversation context
4. specialized implementation requirements
5. generic workflow defaults

## Anti-patterns

Do not:
- restart discovery after the task is already settled
- ask "would you like me to..." for the action the user just authorized
- create a PR because "that's the standard workflow" when direct-to-main was explicitly requested and allowed
- claim a remote result from a local-only action
- silently switch repositories or branches
- widen the patch because nearby code "could be improved"
- use force push as a convenience
- skip verification
- turn `yeet` into recklessness

## Mental model

`yeet` does not mean "throw it over the wall."

It means:

**Take the already-decided change, choose the shortest compliant path to the requested repository state, execute it cleanly, and prove that it landed.**
