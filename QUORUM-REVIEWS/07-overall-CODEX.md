# Review 07 — Overall Assessment

**Reviewer:** CODEX  
**Date:** 2026-06-22  
**Overall score:** 8/10, conditional on compiler verification

## Scorecard

| Dimension | Score | Basis |
|---|---:|---|
| README quality | 7.5 | Strong architecture; stale prerequisite paths and CI command drift |
| Coverage | 8 | Broad, deep Mercury-specific material; limited package-scale synthesis |
| Correctness | 7 | Static review found confirmed navigation/operational defects; `mmc` gate could not run |
| Code quality | 8 | Clear exercise isolation and CI structure; ambiguous gate/artifact hygiene |
| Idiomatic Mercury | 8.5 | Excellent core idioms; production-scale library/style decisions underemphasized |
| Educational quality | 8 | Strong practice ladder and test-script coverage; needs retrieval and planning aids |

## Highest-priority actions

1. **Restore one executable, documented CI entry point.** Make `ci.sh`, workflow references, and `Agents.md` agree; do not leave `ci-bak.sh` as the only discoverable gate.
2. **Mechanically audit all learner-facing paths.** Fix the known stale prerequisites and fail CI whenever a referenced local exercise path is missing.
3. **Run and publish the full Mercury gate in a writable Nix environment.** This review attempted the pinned command but Nix could not open a store lock file in the restricted environment. Compilation status is therefore unproven, not failed.
4. **Improve learner orientation without expanding content.** Add duration bands, end-of-track retrieval prompts, and one annotated solution per track.

## Important calibration

The project is stronger than a generic “large collection of exercises.” Its coherent four-format model, intensive treatment of modes/determinism, and error-focused koans address the hardest parts of becoming productive in Mercury. Conversely, documentation drift is not a minor polish problem in a self-guided curriculum: broken prerequisite paths and a missing canonical verification command interrupt the learning route.

The reported absence of kata tests is not supported by the repository inventory: all kata starters have `runtests` scripts. The appropriate follow-up is to execute and assess those scripts, not to create a redundant test layer based on a false premise.

## Final verdict

Cinnabar has the structure and depth of a serious Mercury curriculum. It should prioritize operational integrity—working, documented CI and machine-checked navigation—before adding more exercises. Once the full gate is demonstrably green, the remaining work is targeted pedagogical refinement rather than a redesign.
