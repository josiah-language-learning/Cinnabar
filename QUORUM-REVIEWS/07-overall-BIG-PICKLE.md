# Review 07 — Overall Assessment

**Reviewer:** BIG-PICKLE
**Date:** 2026-06-22

---

## Summary of Dimension Scores

| # | Dimension | Score |
|---|-----------|-------|
| 01 | README Quality | 7/10 |
| 02 | Coverage | 9/10 |
| 03 | Correctness | 8/10 |
| 04 | Code Quality | 7/10 |
| 05 | Idiomatic Mercury | 8/10 |
| 06 | Educational Quality | 8/10 |
| **Overall** | | **8/10** |

---

## What This Project Is

This is the most ambitious Mercury curriculum ever attempted — 184 exercises across 8 kata tracks, 12 bridges, 21 puzzles, and 80 koans, all organized into a coherent four-tier progression from "what does this compiler error mean?" to "design a meta-interpreter."

The project's core innovations in Mercury pedagogy are:

1. **The 80-error koan library.** No other Mercury resource maps specific compiler error messages to minimal failing programs. A learner who works through these will recognize most Mercury errors on sight — the single biggest barrier to Mercury adoption (inscrutable error messages for newcomers) is directly addressed.

2. **The four-tier progression (koan → kata → bridge → puzzle).** Each tier targets a different learning goal: error literacy, mechanical fluency, design patterns, integration. This is better thought-out than any existing Mercury tutorial.

3. **The determinism track.** The only resource anywhere that teaches all six determinism categories, committed choice, and the determinism lattice. Mercury's determinism system is its most distinctive feature, and this curriculum gives it the treatment it deserves.

4. **The concurrency track.** Covers parallel conjunction, threads, channels, deadlock, granularity, uniqueness at thread boundaries, and STM — topics absent from every other Mercury tutorial.

5. **`COMPILER-LESSONS.md` (1821 lines).** A living document of compiler errors encountered during development. This complements the koan library by providing narrative context for each error pattern.

---

## What Needs Immediate Attention

These are issues that affect learnability or correctness and can be fixed in a single focused pass:

1. **Stale cross-references (8 occurrences).** Foundations 05-map says `# 02` instead of `02-maybe`; 06-set says `# 03` instead of `03-string`; 4 stale refs in type-system koans, 2 in puzzles. These confuse navigation.

2. **Bridge 10 missing "Why Mercury."** The only bridge without this section. A one-paragraph addition is needed.

3. **Foundations track inline "Concept:" text.** Should be proper section headings, matching the determinism and advanced tracks.

4. **No time estimates anywhere.** Learners need to know how long each exercise takes.

5. **Foundations 05-map and 06-set stale headers.** README says `# 02` and `# 03` respectively — renamed directories left stale internal references.

6. **`Agents.md` stale `ci.sh` references (lines 133, 183, 208).** The file was renamed to `ci-bak.sh`. References should be updated or the filename should be restored.

7. **`EXPANSION.md` line 31 calls itself "ROADMAP.md".** Stale self-reference.

---

## What's Blocked

- **Cannot run `mmc` or `nix develop`.** Cannot verify compilation, snapshot accuracy, or CI pass/fail status. All correctness claims are based on static analysis.
- **Cannot enable GitHub Actions CI.** Blocked on user SSH key setup. The CI script exists and is well-designed; enabling CI would provide continuous verification.

---

## Risks

1. **Module name collisions.** `bridge/02-pipeline-extend/pipeline.m` and `bridge/10-parallel-pipeline/pipeline.m` both declare `:- module pipeline.` This works with `mmc --make` because builds run from the module's directory, but it's fragile.

2. **Pre-alpha documentation accuracy.** The project has a lot of documentation (309 READMEs, COMPILER-LESSONS.md at 1821 lines, EXPANSION.md at ~1500 lines). Keeping cross-references accurate across this volume is an ongoing maintenance burden. The 8 stale refs found in a single pass suggest there are more.

3. **Solver types kata is documented as non-working (advanced/02).** Requires `.tr` grade, not provided by the default `flake.nix` grade. Documented correctly but limits the track's completeness.

4. **No test scripts for most katas.** The only feedback mechanism for most exercises is "does it compile?" This is insufficient for self-directed learning (see educational quality review for details).

---

## Recommendations by Priority

### P0 (blocking learnability — fix before onboarding a new learner)
1. Fix 8 stale cross-references (5 minutes each)
2. Add "Why Mercury" to bridge 10 (10 minutes)
3. Fix foundations 05-map and 06-set stale README headers (5 minutes each)
4. Update `Agents.md` `ci.sh`→`ci-bak.sh` references or restore `ci.sh` (5 minutes)
5. Fix `EXPANSION.md` "ROADMAP.md" self-reference (1 minute)

### P1 (major quality — fix this quarter)
1. Add time estimates to all exercise READMEs (can be done incrementally, start with bridges)
2. Standardize foundations track "Concept:" as section headings
3. Create `runtests` scripts for all katas (high effort, high impact)
4. Add `--warn-unused-imports` to CI compile_pass (5 minutes)
5. Clean stale `.swp` files from working tree (1 minute)

### P2 (nice to have — fix before v1)
1. Add `cord` mention to parsing track or stdlib-collections kata
2. Add `list.foldl2`/`list.map_foldl` as a distinct micro-exercise in foundations 04
3. Add worked examples to first kata in each track
4. Add compiler warning flags section to tooling kata 01
5. Add feedback mechanism for checkpoint questions (answer key in `solutions/CHECKPOINTS.md`)

### P3 (long-term vision)
1. "Paradigm Note" callout boxes comparing Mercury's approach with other languages
2. Interleaved review exercises that mix concepts from multiple tracks
3. Enable GitHub Actions CI
4. Add `build system` kata for multi-module project structure
5. Bridge between determinism and decision-theoretic/planning concepts (earn the "polyparadigm" name)

---

## Final Verdict

The Cinnabar Mercury curriculum is **solid pre-alpha work** that already exceeds any existing Mercury tutorial in breadth and pedagogical design. The four-tier exercise progression, the 80-error koan library, and the comprehensive determinism/concurrency tracks are genuinely novel contributions to Mercury education.

The project's weaknesses are in the details: stale cross-references from directory renumbering, inconsistent heading styles across tracks, missing "Why Mercury" in one bridge, no time estimates, and most katas lacking test scripts. These are all fixable — none is a fundamental design problem.

With 2-3 weeks of focused effort on the P0 and P1 items listed above, this curriculum would be the best resource for learning Mercury that exists anywhere. With the P2 items addressed, it would be suitable for public release as a beta.

**Score: 8/10** — Pre-alpha that has the right architecture, needs polish before onboarding external learners.

---

## Appendix: Key Numbers

| Metric | Count |
|--------|-------|
| Total exercises | 184 |
| Katas | 71 |
| Koans | 80 |
| Bridges | 12 |
| Puzzles | 21 |
| `.m` files | ~288 |
| README files | ~309 |
| Koan `.err` snapshots | ~78 |
| `COMPILER-LESSONS.md` | 1821 lines |
| `EXPANSION.md` | ~1500 lines |
| Known stale cross-references | 8 |
| Known bugs (all fixed) | 3 |
