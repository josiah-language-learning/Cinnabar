# Review 07 — Overall Assessment

**Reviewer:** DEEPSEEK
**Date:** 2026-06-22

---

## Dimension Scores

| # | Dimension | My Score | Big Pickle Score | Delta |
|---|-----------|----------|------------------|-------|
| 01 | README Quality | 7/10 | 7/10 | 0 |
| 02 | Coverage | 8/10 | 9/10 | -1 |
| 03 | Correctness | 6.5/10 | 8/10 | -1.5 |
| 04 | Code Quality | 8/10 | 7/10 | +1 |
| 05 | Idiomatic Mercury | 8/10 | 8/10 | 0 |
| 06 | Educational Quality | 7/10 | 8/10 | -1 |
| **Overall** | | **7.5/10** | **8/10** | **-0.5** |

## Disagreements with Big Pickle

**Correctness (6.5 vs 8):** I score this lower because I weight systematic stale references (8 from one root cause) more heavily. The CI is renamed to `.bak` with no replacement, meaning there is no active verification. Big Pickle sees "3 bugs found and fixed" as a positive signal; I see "12 stale cross-references across the project, no CI, and a factual claim error in `koans/foundations/15-int-operators`" as a structural issue. Both are valid perspectives; the truth is that the *code* is probably correct (Mercury's compiler enforces most important properties) but the *reference layer* has significant drift.

**Code Quality (8 vs 7):** I score this higher because the puzzle solutions are genuinely excellent — the combinator library with `failure` determinism and inst aliases, the meta-interpreter with type-safe variable freshness, the multi-module config with abstract types. These are production-quality Mercury implementations. The comment density variance and repository noise that Big Pickle flags are real but less important than the consistent module structure, formatting, and naming conventions.

**Educational Quality (7 vs 8):** Both of us see the four-format ladder, koan library, and bridge solution READMEs as excellent. I weight the missing test scripts and absence of time estimates more heavily — without tests, the learner has no feedback loop for most exercises; without time estimates, the learner cannot plan their session. Big Pickle sees these as "fixable in a focused pass" (which they are) but I see them as active quality barriers today.

## What the project does better than any existing Mercury resource

1. **80-koan error literacy library.** No other Mercury resource maps specific compiler error messages to minimal failing programs. This is the project's defining innovation.

2. **Determinism track (7 katas).** The only resource teaching all six determinism categories, `erroneous`/`failure`, the determinism lattice, `cc_multi`/`cc_nondet`, and `promise_equivalent_solutions`. Mercury's determinism system is its most distinctive feature, and this curriculum gives it the treatment it deserves.

3. **Mode system track (9 katas).** The deepest public resource on Mercury's mode system. Unique coverage: inst hierarchy, parametric insts, uniqueness in disjunctions, clause selection by calling mode, `promise_equivalent_clauses` with third-mode trap.

4. **Concurrency track with STM (9 katas).** Covers `&`, threads, channels, granularity, deadlock, uniqueness at thread boundaries, and STM. The STM kata is unique. Kata 08 documents 3 real Mercury 22.01.8 `&` backend bugs with workarounds.

5. **Bridge format with solution READMEs.** The "extend working code" format reduces blank-page dread. The solution READMEs consistently teach design reasoning, not just code.

6. **COMPILER-LESSONS.md.** 1821 lines of annotated compiler errors from real development. Nothing else like it in the Mercury ecosystem.

7. **Four-format ladder (koan → kata → bridge → puzzle).** A pedagogical progression that targets different learning goals at each level. No other Mercury tutorial has this structure.

## What needs fixing before external learners arrive

### P0 — Fix on day one

| Issue | Location | Fix |
|---|---|---|
| 8 stale cross-references | 4 type-system koans, 2 puzzles, 2 kata headers | Update directory references to actual paths |
| No active CI | `ci-bak.sh` exists, no `ci.sh`, `Agents.md` stale | Rename `ci-bak.sh` → `ci.sh` or fix references |
| Bridge 10 solution stale claim | `bridge/10-parallel-pipeline/solution/README.md` line 39 | Update "the task text says" to match current main README |
| `Agents.md` stale `ci.sh` refs | Lines 133, 183, 208 | Update to `ci-bak.sh` or restore `ci.sh` |
| `EXPANSION.md` self-reference | Line 31 | Fix "ROADMAP.md" → "EXPANSION.md" |
| `koans/foundations/15-int-operators` factual claim | README line 34 | Verify and fix `//` vs `/` claim |
| 3 stale `.swp` files | Working tree | `find . -name '*.swp' -delete` |

### P1 — Fix this quarter

| Issue | Effort | Impact |
|---|---|---|
| Add test scripts to katas | 1-2 hours per kata (batch: 15-20 hours for all) | High — closes the feedback loop |
| Add time estimates to all exercises | 1-2 hours for all (batch: same template for similar exercises) | Medium — enables session planning |
| Standardize foundations headings (bold text → `## Concept`) | 30 minutes | Medium — visual consistency |
| Add "Why Mercury" to bridge 10 | 10 minutes | Medium — closes only gap in bridge track |
| Add "Why Mercury" to type-system track (10 katas) | 1-2 hours | Medium — motivational framing for 1/3 of curriculum |
| Add TOC to `COMPILER-LESSONS.md` | 15 minutes | Low — navigation improvement |
| Document cross-track dependencies | 30 minutes | Medium — helps learners plan their route |

### P2 — Fix before v1

| Issue | Effort | Notes |
|---|---|---|
| Add `cord` mention to foundations/11 | 5 minutes | Stdlib completeness |
| Add `list.foldl2`/`list.map_foldl` micro-exercise | 1 hour | Production pattern |
| Add worked example to first kata in each track | 2-3 hours total | High learning impact |
| Add review questions to track index READMEs | 2 hours | Spaced repetition |
| Add `--warn-unused-imports` to CI | 5 minutes | Code quality check |
| Add module system kata (submodules, `.int` pipeline) | 3-4 hours | Fills biggest coverage gap |
| Add FFI bridge | 4-6 hours | Fills second-biggest coverage gap |

## Risks

1. **Module name collision.** `bridge/02-pipeline-extend/pipeline.m` and `bridge/10-parallel-pipeline/pipeline.m` both declare `:- module pipeline.` Works with `mmc --make` (directory-local builds) but fragile outside the curriculum structure.

2. **Compiler version drift.** The koan `.err` snapshots capture Mercury 22.01.8 error messages. If a new Mercury version changes error phrasing, the CI diagnostic-check step will fail for every affected koan. The snapshot mechanism handles this correctly (fails loudly, requires snapshot update), but the maintenance burden is linear in the number of koans (80). Each new Mercury compiler version could require updating 80 `.err` files.

3. **Pre-alpha documentation decay.** At 197 READMEs, 1821-line COMPILER-LESSONS.md, and ~1500-line EXPANSION.md, the project has a lot of prose to maintain. The 8 stale cross-references found in a single pass suggest there may be more in COMPILER-LESSONS.md and EXPANSION.md.

4. **Solver types kata (advanced/02) is non-buildable.** Requires `.tr` trailing grade, dev shell provides `.par` grade. Documented as reference-only, but a learner who tries to build it will hit a grade mismatch error.

5. **CI testing doesn't verify bridge solution README code blocks fully.** The `mmc --make-short-interface` workaround checks syntax and declaration well-formedness but not type correctness. A code block with wrong predicate arity would pass the check.

## Final Verdict

This is the most ambitious Mercury curriculum ever attempted — 184 exercises, 288 `.m` files, 197 READMEs, 78 `.err` snapshots, organized into a four-tier progression from error literacy to open-ended puzzle design.

The project has three world-class strengths:
- **80-error koan library**: the only resource teaching compiler-error literacy at scale
- **Determinism + mode system tracks**: 33 combined exercises covering topics absent from every other Mercury resource
- **Bridge solution READMEs**: consistently the best Mercury teaching content available, with design reasoning, multiple approaches, and real-world gotchas

The project has four structural weaknesses:
- **12 stale cross-references** from directory renumbering (fixable in 30 minutes)
- **No active CI** — script exists but is renamed, no automated verification
- **No tests for most katas** — learner has no feedback loop
- **No time estimates** — learner cannot plan sessions

**Score: 7.5/10**

The project's architecture (four-format ladder, track structure, koan/snapshot system) is sound and production-ready. The implementation (code, solutions, exercise content) is 80% of the way there. The missing 20% is polish: stale references, missing tests, no estimates, missing Why Mercury sections. A focused 2-3 week effort on the P0 and P1 items above would bring this curriculum from "promising pre-alpha" to "best Mercury resource available."

---

## Appendix: Key numbers

| Metric | Count |
|---|---|
| Total exercises | 184 |
| Katas | 71 (8 tracks) |
| Koans | 80 (71 .m files, 9 text-only, 78 .err snapshots) |
| Bridges | 12 |
| Puzzles | 21 (5 categories) |
| `.m` files | ~288 total |
| README files | ~197 (exercises + track indexes + root) |
| `COMPILER-LESSONS.md` | 1,821 lines |
| `EXPANSION.md` | ~1,500 lines |
| `ci-bak.sh` | 350 lines |
| Stale cross-references found | 8 (systematic: directory renumbering) |
| Additional correctness defects | 4 (bridge 10 stale claim, int-op factual claim, Agents.md stale ref, EXPANSION.md stale ref) |
| Known bugs (all fixed this session) | 3 (CI snapshot counter, quadratic append, float import) |
| Exercises with test scripts | ~5 (estimated — only foundations/12 confirmed) |
| Exercises with time estimates | 0 of 184 |
