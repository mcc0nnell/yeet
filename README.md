# yeet

**Minimum ceremony. Maximum certainty.**

A skill for the moment when the decision has already been made.  
Stop replanning. Stop inventing process. Execute the smallest safe path to the requested repository state — and prove that it landed.

---

## What Yeet is

Yeet is an execution-mode skill for agentic coding systems. It activates when the human has already settled the change, the destination, and the scope. Its job is to:

1. carry forward that explicit intent,
2. choose the shortest *compliant* transport,
3. execute cleanly,
4. verify the resulting remote state.

It is **not** permission to bypass branch protection, required review, credentials, security controls, or repository policy.

> **Yeet is an execution mode, not permission escalation.**

## When it triggers

- “yeet it”
- “ship it”
- “do it then” (when the preceding context already defined the change and destination)
- “commit this directly to main”
- “patch it and land it”
- any clear signal that the decision is settled and the agent should stop ceremony and ship

It does **not** trigger merely because the word “yeet” appears in prose or documentation.

## Low ceremony ≠ recklessness

Yeet deliberately removes *unnecessary* process after the decision is made. It never removes the safety rails that the repository or platform actually requires.

- Direct-to-main is used only when explicitly requested **and** the repository permits it.
- Branch protection always wins.
- Connector-only environments use SHA-guarded writes and re-verification.
- Scope is locked before any write.
- Validation is proportional to risk.
- Hard failure is preferred over papering over uncertainty.
- Remote state is always re-read or otherwise proven.

## The contract (summary)

From the canonical `SKILL.md`:

- **Carry forward explicit intent** — reuse the repository, branch, destination, and constraints already established.
- **Execution over ceremony** — if the task is settled, act; do not invent a draft-PR ritual when direct write was requested and allowed.
- **Safety over speed when they conflict**.
- **Verify, don’t assume** — a local edit or a connector write is not completion until the remote state is confirmed.
- **Scope lock** — do not opportunistically expand the change.
- **Proportional validation** — match the checks to the risk.
- **Hard failure** instead of silent degradation.

## Transport matrix

See [`references/transport-matrix.md`](references/transport-matrix.md) for the decision table used when multiple write paths exist.

## Installation / use

Compatible with Agent Skills environments that load skills from a repository or zip.

```bash
# example — clone or download the skill
git clone https://github.com/mcc0nnell/yeet.git
# or download the release archive and place the skill where your agent discovers skills
```

Point your agent at the `SKILL.md` (or the skill package). Once loaded, phrases such as “yeet it” or a contextually clear “do it then” engage the execution contract.

## Repository structure

```
yeet/
├── README.md
├── SKILL.md                 # canonical behavioral specification
├── CHANGELOG.md
├── LICENSE                  # MIT
├── references/
│   └── transport-matrix.md
└── scripts/
    └── preflight.sh         # non-mutating local preflight helper
```

## Version

**v2.0.0 — Minimum ceremony, maximum certainty**

v2 formalizes contextual “do it then / ship it” semantics, explicit user destination over generic publishing ceremony, connector-only GitHub workflows, SHA-guarded writes, direct-to-main rules, scope locks, proportional validation, diff gates, hard-failure semantics, CI verification, and proof that the requested remote state actually landed.

## License

MIT © Robert McConnell
