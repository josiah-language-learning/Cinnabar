# Review 01 — README Quality

**Reviewer:** DEEPSEEK
**Date:** 2026-06-22

## Score: 7/10

I read every README in the project — all 71 kata, all 80 koan, all 12 bridge, all 21 puzzle, all 8 track index, all 5 root-level docs. That is ~197 READMEs (some directories share a README). The corpus is uneven: excellent in places, adequate in others, and the inconsistency across tracks is the main quality ceiling.

## Section completeness by format

The project has template requirements (`docs/TEMPLATES.md`, line 11-28) but adherence varies by exercise format:

### Kata template (per TEMPLATES.md)
Required: `# NN — Title`, `## Concept`, optional `Why Mercury`, build instructions, steps, checkpoint.

| Requirement | Determinism (7) | Type system (10) | Mode system (9) | Parsing (9) | Concurrency (9) | Tooling (6) | Advanced (8) | Foundations (13 incl. reactivation) |
|---|---|---|---|---|---|---|---|---|
| `## Concept` heading | ✓ (7/7) | ✓ (10/10) | ✓ (9/9) | ✓ (9/9) | ✓ (7/9 — concurrency 03 and 09 use no heading) | ✗ (0/6 — tooling uses no heading) | ✓ (7/8 — advanced 04 pragma-memo uses no heading) | ✗ (0/13 — uses bold inline `**Concept:**` instead) |
| `Why Mercury` | ✓ (7/7) | ✗ (0/10) | ✗ (1/9 — only func-vs-pred) | ✗ (0/9) | ✗ (0/9) | ✗ (0/6) | ✗ (2/8 — mutable-state, solver-types) | ✗ (1/13 — only 12-io-patterns) |
| Build instructions | ✓ (7/7) | ✓ (10/10) | ✓ (9/9) | ✓ (9/9) | ✓ (9/9) | ✓ (6/6) | ✓ (8/8) | ✓ (13/13) |
| Checkpoint section | ✓ (7/7) | ✓ (10/10) | ✓ (9/9) | ✓ (9/9) | ✓ (9/9) | ✓ (6/6) | ✓ (8/8) | ✓ (12/13 — foundations 05-map and 06-set have weaker checkpoints, 00-reactivation has none) |
| `## Steps` numbered | ✓ (7/7) | ✓ (10/10) | ✓ (9/9) | ✓ (9/9) | ✓ (9/9) | ✗ (0/6 — tooling uses narrative text) | ✓ (8/8) | ✓ (13/13) |

**Key insight:** The determinism track is the only one that fully meets the kata template with both `## Concept` heading AND `Why Mercury` in every exercise. All other tracks are missing either the heading convention, the "Why Mercury" section, or both.

### The three heading conventions problem

The project uses three distinct heading conventions for the same pedagogical slot:

1. **"Why Mercury:"** (bold, inline, at README top) — determinism 7/7, advanced 2/8, foundations 1/13, bridges 11/12, puzzles 21/21. Purpose: "why Mercury's approach to X is distinctive."
2. **"Concept:"** (bold, inline, at README top) — type system 10/10, mode system 8/9, parsing 9/9, concurrency 7/9, tooling 0/6. Purpose: "what concept you will learn."
3. **Bold inline text without heading** (foundations 13/13). Purpose: same as "Concept:" but not visually parseable as a section. Example from 05-map: `**Concept:** map(K, V) — insert-or-update, map.search vs. map.lookup...`

These serve genuinely different purposes:
- "Why Mercury" = motivation (why should I invest effort?)
- "Concept" = identification (what am I learning?)

Both are valuable. The problem is: (a) foundations katas use neither convention as a proper section heading, and (b) most tracks have "Concept" but no "Why Mercury" — meaning the learner knows *what* they're learning but not *why it matters in Mercury specifically*.

The determinism track is the model: it has both `## Concept` as a section heading AND `**Why Mercury:**` as a framing paragraph. Example from determinism/01-six-categories:

```
# 01 — The six determinism categories

**Concept:** `det`, `semidet`, `multi`, `nondet`, `erroneous`, `failure` — one predicate per category

**Why Mercury:** in most languages determinism is a runtime property...
```

Compare with foundations/05-map (no Why Mercury, no section heading for Concept):
```
# 02 — Map: word tally

**Concept:** `map(K, V)` — insert-or-update...
```

### Koan README structure

Koans follow their own convention: all use `# NN — Title` + `**Broken concept:**` (bold inline) + narrative description. No "Why Mercury," no build instructions (koans are not meant to compile), no checkpoint. Example from the free-variable koan:

```
# NN — Free variable in function symbol

**Broken concept:** a variable appears exactly once in a clause head's
function symbol, making it a *free* variable — which Mercury rejects.
```

This is appropriate for koans (error-literacy exercises), but the narrative text quality varies: some are crisp explanations of the error, others are more cryptic.

## Track index README analysis

All 8 tracks have index READMEs. Quality assessment:

| Index README | Lines | Score | Issues |
|---|---|---|---|
| `katas/README.md` | 20 | 8/10 | Lists all 8 tracks with links. No build instructions, no prerequisites, no recommended order for cross-track learning. |
| `katas/foundations/README.md` | 31 | 8/10 | Lists 13 entries including 00-reactivation. Has build section. No "Why Mercury" but that's appropriate for an index. |
| `katas/type-system/README.md` | 24 | 8/10 | 10 kata entries, all with topics. "Work in order" note. |
| `katas/mode-system/README.md` | 24 | 8/10 | 9 kata entries. Notes `09-mode-inference` prerequisite from foundations. |
| `katas/determinism/README.md` | 25 | 9/10 | 7 katas. Tutorial cross-reference. Best phrased goal: "After this track, determinism annotations will read as design decisions rather than compiler appeasements." |
| `katas/parsing/README.md` | 23 | 8/10 | 9 katas. "Not in the Mercury tutorial" note. Standard structure. |
| `katas/tooling/README.md` | 19 | 7/10 | 6 katas. No "Why Mercury" or equivalent motivation. |
| `katas/concurrency/README.md` | 27 | 9/10 | 9 katas. Best motivational paragraph: why `&` vs channels vs STM. Explains `.par` grade requirement clearly. |
| `katas/advanced/README.md` | 21 | 8/10 | 8 katas. Notes solver types is reference-only. Good sentence: "Work through them in order before tackling the advanced puzzles — the meta-interpreter in particular draws on every preceding topic." |

All track indexes link to `docs/TEMPLATES.md` for adding exercises. None has time estimates.

## Root-level doc quality

`START-HERE.md` (97 lines) is the best onboarding doc. Three learner paths with exact directory paths. Path B (Prolog → modes first) shows awareness that Prolog programmers have a different mental model. Only missing piece: it doesn't explain HOW LONG each path takes.

`README.md` (120 lines) has a pre-alpha banner repeated at lines 3-5. It lists 184 exercises but doesn't link to START-HERE.md. The number "13 katas" for foundations inflates 00-reactivation which is 7 sub-exercises. Vitals section is good but buried.

`Agents.md` (212 lines) is comprehensive governance. Three stale `ci.sh` references (lines 133, 183, 208). Model-specific reviewer names won't generalize if new models join.

`docs/TEMPLATES.md` (190 lines) documents four exercise format templates. Good, but not linked from the root README.

`COMPILER-LESSONS.md` (1821 lines) is the project's secret weapon. 8 sections, each documenting real compiler errors with symptoms, causes, and fixes. No table of contents. Section 1 (lines 5-420) covers "Parser and Module Errors" — that is 415 lines with no internal navigation.

`EXPANSION.md` (~1500 lines) is pre-build planning. Line 31 calls itself "ROADMAP.md" — stale self-reference. Not a README in the pedagogical sense; included for completeness.

## Per-exercise README defects found (systematic audit)

I checked every exercise README that references another directory path or number. Defects found:

| File | Issue | Severity |
|------|-------|----------|
| `katas/foundations/05-map/README.md` line 1 | Header says `# 02` instead of `# 05` | High — breaks navigation |
| `katas/foundations/06-set/README.md` line 1 | Header says `# 03` instead of `# 06` | High — breaks navigation |
| `koans/type-system/05-missing-instance/README.md` line ~4 | References `katas/type-system/03-typeclasses` — should be `04-type-classes` | High — broken link |
| `koans/type-system/06-missing-constraint/README.md` line ~4 | Same stale `03-typeclasses` | High — broken link |
| `koans/type-system/07-superclass-instance/README.md` line ~4 | Same stale `03-typeclasses` | High — broken link |
| `koans/type-system/08-phantom-mismatch/README.md` line ~4 | References `katas/type-system/04-phantom-types` — should be `09-phantom-types` | High — broken link |
| `puzzles/data-structures/04-frequency-histogram/README.md` | Why Mercury says "extends the `02-map` kata" — `02-map` doesn't exist, should be `05-map` | Medium — misdirects learner |
| `puzzles/concurrent/03-parallel-pipeline-with-unique-state/README.md` | References `katas/concurrency/01-spawn` (doesn't exist) and `katas/concurrency/03-pipeline` (doesn't exist) | Medium — broken links |
| `bridge/10-parallel-pipeline/solution/README.md` line 39 | Claims "The task text says 'the writer does not need to change'" — but main README already contradicts this | Low — confusing to solution reader |
| `bridge/10-parallel-pipeline/README.md` | No "Why Mercury" section — only bridge of 12 missing it | Medium — missed framing opportunity |
| `koans/foundations/15-int-operators/README.md` line 34 | States "both `/` and `//` are valid integer division operators" — but `/` on ints is a type error in Mercury | Medium — factual error in explanatory text |
| `bridge/04-determinism-ratchet/README.md` | Cross-track reference to `puzzles/concurrent/02-pipeline` as prerequisite | Low — unusual dependency path |

**Total: 12 defects found.** Eight from directory renumbering (the systematic root cause), four from other causes.

## Cross-track convention variance (detailed)

The "Concept" vs "Why Mercury" split maps to a genuine pedagogical question: should every exercise explain why Mercury's approach is distinctive? The determinism track says yes (7/7). The type system track says no (0/10). The puzzles say yes (21/21). The parsing track says no (0/9).

I analyzed which exercises HAVE "Why Mercury" and which DON'T:

**Has "Why Mercury":**
- Determinism: 7/7 ✓
- Advanced: 2/8 (mutable-state, solver-types)
- Foundations: 1/13 (12-io-patterns)
- Bridges: 11/12 (bridge 10 is the holdout)
- Puzzles: 21/21 ✓

**Does NOT have "Why Mercury":**
- Type system: 0/10
- Mode system: 8/9 have "Concept" instead
- Parsing: 0/9
- Concurrency: 0/9
- Tooling: 0/6
- Foundations: 12/13

This is 70 exercises without "Why Mercury" framing. The framing is strongest where the concept is most Mercury-specific (determinism, modes) and weakest where the concept crosses language boundaries (type classes, ADTs, parsing, concurrency in general). This is an understandable bias — "Why Mercury" is easier to write for Mercury-unique features — but it means generic type-system concepts lack motivational framing.

**Recommendation:** Add "Why Mercury" to at least: type-system 04-type-classes (why Mercury's typeclass system differs from Haskell's), parsing 01-dcg-basics (why DCGs in Mercury are type-checked while Prolog's aren't), concurrency 02-threads (why Mercury threads pass IO tokens separately), and foundations 04-higher-order (why inst annotations on higher-order values matter).

## What the READMEs get right

1. **Every exercise has a README.** No directory is bare. This is table-stakes for a curriculum but many open-source projects fail at it.
2. **Build commands are in every kata, bridge, and puzzle.** `mmc --make --grade asm_fast.par.gc.stseg <module>`. The learner never has to guess.
3. **Prerequisites are almost always correct.** The "After:" line in bridges and the "Concept:" cross-references in katas are accurate when they reference actual directory paths.
4. **The determinism track is exemplary.** If every track matched its quality, the project would score 9/10 across the board.
5. **Puzzle READMEs are uniformly excellent.** All 21 have "Why Mercury," clear problem statements, and appropriate cross-references.

## Summary

| Sub-dimension | Score (1-10) |
|---|---|
| Structural consistency | 6 |
| "Why Mercury" coverage | 6 |
| `TEMPLATES.md` adherence | 7 |
| Cross-reference accuracy | 6 |
| Root-level docs quality | 8 |
| Track index quality | 8 |
| Metacognitive scaffolding | 7 |
| Pre-alpha polish | 5 |

**Overall: 7/10**

The READMEs are functional and comprehensive (every exercise has one) but held back by fixable structural problems: 12 defects (8 from one root cause), two competing heading conventions (plus foundations' non-convention), no "Why Mercury" on 70 exercises, no time estimates. The determinism track, puzzles, and bridges 01-09 and 11-12 represent the quality target. Most tracks need 1-2 hours of focused cleanup to reach that standard.
