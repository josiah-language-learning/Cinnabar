# Review 03 — Correctness

**Reviewer:** CODEX  
**Date:** 2026-06-22  
**Score:** 7/10 (static review; compilation not established)

## Verification status

I attempted the documented pinned Nix invocation using the current committed revision and `XDG_CACHE_HOME=/tmp/cinnabar-nix-cache`. It did not reach `mmc`: Nix failed opening a lock file under `/nix/store` because that store is read-only in this environment. `mmc` is not otherwise on PATH. Therefore this review makes no claim that the suite compiles or that expected diagnostics match.

## Confirmed issues

### P1 — Learner-visible prerequisite paths are incorrect

The stale paths described in Review 01 are correctness issues: the curriculum's navigation contract is false where it points at a non-existent exercise. This is particularly damaging in koans and puzzles because their prerequisite lists are a learner's primary route to missing context.

### P1 — The documented CI entry point is not executable in the current worktree

The operational contract says `./ci.sh`; the checked-out executable is `ci-bak.sh`, while `ci.sh` is recorded as deleted in the worktree. This also weakens the GitHub workflow's reliability if it invokes the documented filename. Resolve the canonical filename before judging the suite green.

### P2 — CI currently cannot establish the full semantic correctness of bridge README snippets

The gate extracts Mercury blocks from bridge solution READMEs and checks them in isolation. This is valuable, but isolated snippet checking cannot prove that a snippet's calls, imports, or types are correct in the surrounding example. Keep the syntax/interface check, then add at least one integration build per bridge solution (or compile an extracted complete module with explicit expected imports).

### P2 — Compiler-version diagnostics are intentionally brittle and need an upgrade policy

Koan `.err` snapshots are a sound regression oracle for Mercury 22.01.8, but diagnostic wording is compiler-version-sensitive. The CI compares expected diagnostic phrases, so a toolchain upgrade can fail many otherwise-correct exercises. Document the supported compiler version at the gate, add a version assertion, and define an explicit snapshot-refresh procedure.

## Positive evidence

- The CI design has the right high-level split: koans are expected to fail, solutions and starters are expected to compile, indexes are checked, and bridge prose is subjected to machine validation.
- The source intentionally uses unsafe-looking Mercury promises as teaching subjects and generally labels their contracts. Those uses should not be recorded as defects merely because a text search finds them.
- The project keeps source-level code paths localized by exercise, limiting accidental coupling despite repeated conventional module names such as `start` and `pipeline`.

## Required next verification

Run the canonical gate in an environment where the pinned dev shell can obtain its lock/store access, record pass/fail totals, and fix only failures reproduced there. Static analysis is not sufficient for Mercury modes, determinism, FFI attributes, or compiler diagnostic snapshots.

## Verdict

No runtime or type-level code defect was proven in this pass, but the project cannot presently demonstrate correctness from this environment and has confirmed documentation/CI-entrypoint defects. The score is deliberately provisional rather than a code-quality verdict.
