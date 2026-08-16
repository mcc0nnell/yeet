# Yeet transport matrix

Use this as a quick chooser when more than one write path is available.

| Situation | Preferred transport | Why |
|---|---|---|
| Multi-file code change + local checkout | local git + `gh` | Atomic commit, easy diff/test/rollback |
| Single-file replacement + connector-only workspace | SHA-guarded contents update | Minimal and direct |
| Multi-file connector-only change | Multi-file commit API if available; otherwise guarded sequential writes | Avoid pretending per-file commits are atomic |
| Existing PR already represents the work | update PR branch | Avoid duplicate PRs |
| User explicitly requested direct `main` and repo permits it | atomic direct commit / allowed connector write | Honor explicit destination |
| Branch protection requires PR | branch + PR/merge | Policy wins |
| Merge requested but checks are pending | wait only if the current tool/run can observe them; otherwise report pending truthfully | Never fake completion |
| Remote moved since preflight | refetch and re-evaluate | Prevent stale writes |
| Unrelated dirty local tree | preserve unrelated changes; use scoped edits/commit | Don't destroy other work |

## Selection rule

Prefer the path that minimizes:
1. risk of partial writes
2. risk of overwriting concurrent work
3. unnecessary ceremony
4. tool assumptions that do not hold in the current environment

Speed matters, but correctness of the resulting repository state matters more.
