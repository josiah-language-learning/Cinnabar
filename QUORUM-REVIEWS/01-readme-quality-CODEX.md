# Review 01 — README Quality

**Reviewer:** CODEX  
**Date:** 2026-06-22  
**Score:** 7.5/10

## Scope

I reviewed the root navigation, track indexes, exercise templates, and a representative set of kata, koan, bridge, and puzzle READMEs. This is an independent documentation review; claims below distinguish confirmed path defects from editorial recommendations.

## Strengths

- The root README gives a clear audience boundary, a sensible track order, and a useful explanation of the four exercise formats. It does not pretend the pre-alpha material is authoritative.
- The format taxonomy is unusually legible. Katas, koans, bridges, and puzzles have distinct purposes, and `docs/TEMPLATES.md` makes the intended learner-facing structure concrete.
- Exercise READMEs generally explain the Mercury-specific reason for the exercise rather than merely restating its task. Bridge solution READMEs, in particular, preserve design rationale and trade-offs.
- `START-HERE.md` supports three materially different learner backgrounds. That is better navigation than a single universal linear path.

## Confirmed findings

### P1 — Renumbering left learner-facing prerequisites stale

Several README references use directories that are not present in the current tree. Examples include `katas/type-system/03-typeclasses` in the missing-instance / missing-constraint / superclass-instance koans, `katas/type-system/04-phantom-types` in the phantom-mismatch koan, `02-map` in the frequency-histogram puzzle, and old concurrency directory names in the unique-state pipeline puzzle. The foundations map and set README titles also retain their former numbers.

This is a navigation defect, not cosmetic drift: the curriculum repeatedly asks learners to follow prerequisite paths. Audit all backticked `katas/`, `koans/`, `bridge/`, and `puzzles/` paths against the filesystem, then make that check part of CI.

### P2 — The documentation promises a canonical CI command that is absent in this checkout

`Agents.md` names `ci.sh` as the authoritative gate, while the current worktree contains `ci-bak.sh` and `git status` reports `ci.sh` as deleted. The GitHub workflow and documentation should name one canonical executable. A learner or contributor following the documented command currently reaches a missing file.

Because this could be a transient in-progress change, the correction should be made as part of the active CI restoration rather than by editing docs alone.

### P2 — Navigation density is high at the top level

The root README's recommended-order paragraph carries track ordering, bridge placement, advanced-track exceptions, and puzzle suggestions in one long sentence. It is accurate but difficult to scan. A small table with `Start after`, `format`, and `estimated session size` would make the same information usable without adding prose.

### P3 — Template adherence is intentionally flexible but not discoverably so

`docs/TEMPLATES.md` says sections are optional, yet learners encounter materially different conventions: some katas use a `##` concept heading, while some use inline bold `Concept:` text; some exercises include a checkpoint or expected output and others do not. The variation is defensible, but the templates should mark which elements are baseline requirements for each format. That would turn inconsistency from accidental-looking variation into deliberate adaptation.

## Recommendations

1. Add a CI path-reference audit and fix the current stale references in the same change.
2. Restore or deliberately rename the canonical CI executable; update the workflow and `Agents.md` atomically.
3. Replace the root ordering paragraph with a compact route table and add coarse duration labels (`short`, `medium`, `long`) at least to indexes.
4. Define a minimum README contract per format: prerequisites, task, verification, and next step; keep optional pedagogical sections optional.

## Verdict

The documentation architecture is strong and unusually learner-oriented. Its main weakness is maintenance discipline: paths and operational commands must be mechanically checked because the curriculum is now too large to keep correct by manual prose review.
