# Review 01 — README Quality

**Reviewer:** OPUS (Claude Opus 4.8)
**Date:** 2026-06-22
**Method:** Independent pass. Unlike the other two reviewers in this round, I compiled
against `mmc` 22.01.8 in the nix dev shell and verified every file/path claim against
the actual tree before asserting it. Where I contradict BIG-PICKLE or DEEPSEEK, I show
the evidence.

## Assessment

The README corpus is the curriculum's second-strongest asset (after coverage). The
"Why Mercury" framing, concrete `mmc` build commands, and per-exercise checkpoints are
genuinely above the bar for any Mercury learning material in existence. The problems are
all in the *connective tissue* — cross-references, numbering, and per-track consistency —
not in the explanatory content.

## Strengths (confirmed)

- **"Why Mercury" sections** are the standout. The pattern (name the familiar pain →
  show the type-level Mercury solution → let the compiler enforce it) is consistent and
  pedagogically sound. Bridge 05 (mode reversal) and determinism 01 are the exemplars.
- **Every exercise builds-commands and checkpoints.** Concrete `mmc --make --grade
  asm_fast.par.gc.stseg <module>` lines everywhere — rare in Mercury docs.
- **Index integrity is machine-checked.** The track-README tables match on-disk dirs
  (the gate's `check_index` enforces this; I re-verified all 8 kata tracks + bridges).

## Weaknesses (independently verified)

### 1. Broken kata cross-references in type-system koans — REAL (DEEPSEEK correct)
Four type-system koan READMEs link to kata dirs that do not exist:
- `koans/type-system/{05-missing-instance,06-missing-constraint,07-superclass-instance}`
  reference `katas/type-system/03-typeclasses` — **the dir is `04-type-classes`**.
- `koans/type-system/08-phantom-mismatch` references `katas/type-system/04-phantom-types`
  — **the dir is `09-phantom-types`**.
I confirmed each with `[ -d ... ]`. A learner following these prerequisites hits a dead
path. **Fix:** `03-typeclasses`→`04-type-classes`, `04-phantom-types`→`09-phantom-types`.

### 2. BIG-PICKLE's foundations "stale cross-reference" claim is FALSE — but a real
numbering artifact hides underneath
BIG-PICKLE asserts `katas/foundations/05-map` says *"This kata builds on `# 02`
(maybe)"*. That text does not exist. The actual line 1 is the H1 **title** `# 02 — Map:
word tally`. So the cited broken reference is fabricated. **However**, the title number
(`02`) does not match the directory number (`05-map`) — a renumbering leftover that *is*
worth fixing (titles should read `# 05 — …` or drop the number). This is a good example
of why compile/path verification matters: the prior reviewer pattern-matched a number
and invented a sentence around it.

### 3. Bridge 10 still has no "Why Mercury" — CONFIRMED
`grep -ci 'why mercury' bridge/10-parallel-pipeline/README.md` = 0. It is the lone bridge
without one, despite covering the least-obvious concepts (bounded channels, sentinel
fan-in, `cc_multi` blocking gets). The framing material already exists in the concurrency
track and the solution notes — port it up.

### 4. Bridge 10 solution note is now self-stale
`solution/README.md:39` says *'The task text says "the writer does not need to change."
That is wrong'* — but the task README was since corrected to *"**The writer does need to
change**"* (`README.md:39`). The solution is now rebutting a sentence that no longer
exists. Reword to drop the meta-correction.

### 5. Foundations "Concept:" rendered as bold inline, not a heading — CONFIRMED
`05-map`, `06-set`, `07-exceptions` (and the rest of foundations) open with
`**Concept:**` inline; determinism/type-system/mode-system use `##` headings. Both
reviewers flagged this and it reproduces. Low severity, real consistency cost.

## Where I land vs the other reviewers
- DEEPSEEK's stale-ref count (type-system koans) is **correct and the higher-value
  finding**; BIG-PICKLE's foundations version is **a misread**. The synthesis should
  trust DEEPSEEK here.
- Both correctly flag bridge 10's missing "Why Mercury" and the foundations heading
  style.

## Score: **7.5/10**
Excellent explanatory content, let down by ~5 broken type-system koan links, the
title/dir number mismatch in foundations, and the bridge-10 gaps. All are minutes-to-fix
and none touch the prose quality, which is genuinely strong.
