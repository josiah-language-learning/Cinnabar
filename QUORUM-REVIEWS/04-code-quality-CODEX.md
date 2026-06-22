# Review 04 — Code Quality

**Reviewer:** CODEX  
**Date:** 2026-06-22  
**Score:** 8/10 (static review)

## Strengths

- Exercise directories are self-contained and consistently use predictable names (`start.m`, `runtests`, `solution/` where appropriate). This is good curriculum hygiene and supports local compilation.
- The project preserves intentional failures separately from their fixed counterparts. That keeps koans honest and avoids the common failure mode where a teaching error silently ceases to reproduce.
- Comments tend to explain the language invariant being exercised—modes, determinism, uniqueness, or IO state—rather than narrating syntax.
- The CI script expresses test intent in functions (`compile_fail`, `compile_pass`, index checking) instead of duplicating shell fragments. Its file enumeration is explicit and excludes known library-only modules from executable linking.

## Findings

### P2 — The repository's operational surface is currently ambiguous

`Agents.md` calls `ci.sh` authoritative, while the worktree carries `ci-bak.sh` and a deleted `ci.sh`. A backup-named file should not be the only active quality gate. This is codebase hygiene as well as correctness: contributors cannot determine which script is contractual.

### P2 — Generated artifacts need a clearer ownership policy

The working tree contains numerous binaries and `.err` files beside source. Some diagnostics are deliberate koan snapshots; others are build output. The ignore rules may handle them, but directory-local artifacts make manual review noisy and invite stale-output confusion. Prefer a documented build-output directory where the Mercury tooling permits it, or state explicitly which adjacent files are fixtures versus disposable artifacts.

### P3 — A source linter would complement compile-only checks

Mercury compilation catches an extraordinary amount, but it does not replace style checks: unused imports, dead exports, README code drift, shell portability, and accidental generated files. Add a lightweight CI stage for shell syntax, executable-bit checks, dead-link/path checks, and the Mercury warning set supported by the pinned compiler.

### P3 — Naming collisions are locally safe but make aggregate builds fragile

Several independent exercises use common module names such as `pipeline`. That is appropriate for directory-local `mmc --make` learning tasks. It becomes a liability if the repository ever gains a single aggregate build, IDE indexing, or generated documentation. Document the local-build assumption now; only namespace modules if aggregate tooling becomes a goal.

## Verdict

The code organization is clean for a large pedagogical repository. The most important quality work is operational: make the canonical gate unambiguous, distinguish fixtures from build residue, and add low-cost non-compiler hygiene checks.
