# Review 07 — Overall

**Reviewer:** OPUS (Claude Opus 4.8)
**Date:** 2026-06-22
**Distinguishing method:** I am the only reviewer in this round who **compiled with `mmc`
22.01.8** in the dev shell and verified every path/file claim against the tree. That
changed several conclusions.

## Scorecard

| # | Dimension | OPUS | BIG-PICKLE | DEEPSEEK |
|---|-----------|------|-----------|----------|
| 01 | README quality | **7.5** | 7 | 7 |
| 02 | Coverage | **8.5** | 9 | 8 |
| 03 | Correctness | **7.5** | 8 | 6.5 |
| 04 | Code quality | **7.5** | 7 | 8 |
| 05 | Idiomatic Mercury | **8.5** | 8 | 8 |
| 06 | Educational quality | **8** | 8 | 7 |
| **Overall** | | **8/10** | 8 | 7 |

## The one-paragraph verdict

Cinnabar is the most complete and most pedagogically thoughtful Mercury learning resource
in existence, and it is *better than the 06-21 synthesis describes* — three of that
round's top "missing" items (func-vs-pred, mutable-state, IO-patterns katas) are now
present, the bridge "Why Mercury" pass is mostly done, and the snippet gate is fixed. It
is held back from a clear 8.5 by connective-tissue defects (broken type-system koan links,
foundations numbering/heading drift, bridge-10 gaps) and by one acute working-tree
regression: **`ci.sh` is currently deleted in favor of an untracked `ci-bak.sh`**, so the
documented gate doesn't run as written.

## Highest-value findings (mine, independently verified)

1. **`ci.sh` is missing from the working tree** (`D ci.sh`, untracked `ci-bak.sh`; HEAD
   and `Agents.md` still say `ci.sh`). Restore or rename-consistently. *(New — neither
   reviewer framed this; DEEPSEEK saw the rename but called it merely "confusing.")*
2. **Bridge 04 taught non-compiling `det` code** (if-then-else "commits" a `nondet`
   witness — false; it's `multi`). Found by compiling; **fixed this session** (three
   correct first-solution idioms + table). The §6 gate can't catch this class because it
   checks syntax, not determinism — a real audit gap. *(New — no prior reviewer caught it.)*
3. **Type-system koan prerequisites are broken** (`03-typeclasses`→`04-type-classes` ×3,
   `04-phantom-types`→`09-phantom-types` ×1). *(DEEPSEEK correct; BIG-PICKLE's competing
   "foundations" version is a misread of H1 titles.)*
4. **Every kata has a `runtests` feedback loop (71/71)** — the prior reviewers' "no
   feedback mechanism" critique is **factually wrong**.
5. **`combinators.m :- fail` is correct**; the 06-21 four-model consensus to "fix" it
   would break compilation (mmc-verified). Keep it.

## Prioritized backlog

### P0 — restore trust (the gate)
- **Restore `ci.sh`** (or commit the rename + update `Agents.md` and the rev workflow).
  Right now the project's headline quality claim — "run the gate" — fails at step one.
- **Regenerate the 8 drifted koan `.err` snapshots** from live `mmc` output. (Koans
  themselves are fine — they still fail correctly; only secondary diagnostic lines drift.)

### P1 — connective tissue (cheap, high learner-impact)
- Fix the 4 broken type-system koan kata-links.
- Fix foundations title/dir numbering (`# 02 — Map` lives in `05-map/`) and standardize
  `## Concept` headings across the foundations track.
- Add "Why Mercury" to bridge 10; reword its now-self-stale solution note about the writer.

### P2 — polish / hardening
- Determinism audit of solution-README snippets (compile each as a self-contained module
  with stub types) — bridge 04 proves syntax-only checking misses real determinism bugs.
- Remove root cruft (`.README.md.swp`); consider `--halt-at-warn` in the (restored) gate.
- Add time estimates; a `COMPILER-LESSONS.md` table of contents; one START-HERE sentence
  on the reactivation predict-verify method.

### P3 — scope (post-release)
- Build-system kata (multi-module `mmc --make`, `.mh`); `cord`/fold-variant drills; a thin
  "Paradigm Note" layer to honor the "polyparadigm" name.

## Calibration of this round's reviewers
- **BIG-PICKLE**: best on pedagogical structure and "Why Mercury" appreciation, but its
  inability to compile produced **fabricated specifics** — non-existent koan paths
  (`koans/types/00-free-variable`) and an invented foundations cross-reference. Treat its
  line-level file claims as unverified.
- **DEEPSEEK**: the more reliable of the two on paths and code quality (its broken-ref
  count and combinator-library analysis hold up). Still missed the `ci.sh` deletion's
  severity and, like BIG-PICKLE, the feedback-mechanism reality and the bridge-04 bug.
- **Net**: both are useful for breadth and prose judgment; **neither is reliable for
  correctness**, because neither ran the compiler. For a curriculum whose entire thesis is
  "the compiler is the teacher," the review process needs at least one compiling reviewer
  in every quorum.

## Score: **8/10**
A genuinely excellent, near-release Mercury curriculum. Restore the gate, fix ~6 broken
links and the bridge-10 gap, and this is an 8.5 — the best Mercury teaching resource
available, full stop.
