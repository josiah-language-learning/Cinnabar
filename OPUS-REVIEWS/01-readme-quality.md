# Cinnabar README and conceptual-quality review

*Reviewed 2026-06-19 by Claude Opus 4.8. Independent read of the root README, all
index/track READMEs, a sample of kata/koan/bridge/puzzle exercise READMEs, and several
solution READMEs. Where my findings differ from the parallel CODEX review, I say so
explicitly.*

## Overall README quality: 6.5/10

The individual exercise prose is genuinely strong — frequently better than what
comparable language-learning repositories ship. The best READMEs give a learner a
concrete starting state, ordered steps, an executable checkpoint, and a question that
ties the result back to a *Mercury-specific* mechanism. What holds the score down is
not the writing but the **navigation layer**: most track/category index files are stale
and under-report the curriculum that actually exists on disk, and at least one root-level
description contradicts the exercise it points to. A learner who navigates by the local
READMEs will not see most of the curriculum.

## 1. Clarity and self-containment

When an exercise README is good here, it is very good. `katas/foundations/02-maybe/README.md`
is the model: it supplies a compilable module skeleton (`:12-43`), names the type to
define (`:51-57`), walks the `bind_maybe`/`map_maybe` derivation with both the explicit
and the chained form (`:75-101`), and closes with a checkpoint that asks an *explanatory*
question — "when does `bind_maybe` return `no` without the inner function running?"
(`:118`) — rather than "does it compile." That is the right shape for a guided kata.

The puzzle READMEs that decompose a hard problem into checkpointed sub-parts are similarly
effective; the meta-interpreter puzzle is the standout (rename → deref → unify → solve,
each with an isolated signature).

The qualification is that "self-contained" depends on a working local navigation graph,
and that graph is currently broken in two ways (section 4).

## 2. "Why Mercury" framing

The best framings name a *checked language property that changes the design*, not a
generic virtue. `puzzles/concurrent/02-pipeline/README.md:7-13` is now a good example —
it names `!IO` uniqueness across thread boundaries, `channel(T)` as the only sanctioned
inter-thread mechanism, and `maybe(T)` as the natural close sentinel. (This section was
evidently rewritten recently; it is specific where a generic "Mercury composes cleanly"
claim would have been hollow.)

Coverage is uneven across bridges. The root bridge table and `bridge/README.md` give a
one-line skill summary per bridge, but only some bridges (04, 05, 06, 11) carry a
mechanism-specific "Why Mercury" paragraph in their own README; 01–03 and 07–10 go
straight to the starter program. For a format whose entire purpose is to teach a *design
decision*, every bridge should state which checked Mercury property the extension exposes.

## 3. Task scope

Koans correctly isolate one lesson; katas give ordered steps; most puzzles fix observable
behaviour while leaving implementation open. The scope problem is the opposite of
under-specification: **two puzzles hand the learner the answer.**
`puzzles/concurrent/02-pipeline/README.md:54-84` supplies complete, copyable
implementations of all three stages (`reader`, `transformer`, `writer`) in a "Stage
implementations" section immediately after stating the task. After reading it, the puzzle
is transcription. The same material would be fine behind a collapsed "Hint" or reduced to
signatures plus the sentinel invariant. (I agree with CODEX here.)

## 4. Prerequisite chains and navigation — the release blocker

This is the load-bearing problem, and I verified it directly against the current tree
(not the older review snapshot).

**Stale index files** (each omits exercises that exist on disk):

| Index | Lists | Actually present |
|---|---|---|
| `katas/README.md` | foundations only, "More tracks will follow" (`:11`) | 8 tracks |
| `katas/type-system/README.md` | 01–05 | 01–10 |
| `katas/parsing/README.md` | 01–03 | 01–09 |
| `katas/mode-system/README.md` | 01–05, 08 | 01–08 (omits 06, 07) |
| `katas/determinism/README.md` | 01–03, 07 | 01–07 (omits 04, 05, 06) |
| `katas/foundations/README.md` | 00–09 | 00–11 (omits 10, 11) |
| `bridge/README.md` | 01, 02, 03, 11 | 01–11 |
| `puzzles/README.md` | concurrent omits 03; advanced lists only 2 of 7 | all present |

By contrast, the indexes that **are** current: the root README track table (counts match
the tree exactly), `katas/advanced/README.md` (01–07), `katas/concurrency/README.md`
(01–09), and `katas/tooling/README.md` (01–06). So this is mid-cleanup, not uniform rot —
which is precisely why it needs a single pass to finish.

**Divergence from CODEX:** the CODEX review reported a longer list of *broken individual
prerequisite paths* (e.g. `katas/type-system/01-adt`, `katas/concurrency/03-basic-spawning`).
I did not re-verify each of those line-by-line, but I did find one concrete, still-live
broken prerequisite of the same kind: `bridge/README.md:25` lists the "After" for bridge 11
as `katas/foundations/07-io-error-handling`, but the actual kata is
`katas/foundations/07-exceptions`. A path-resolution check in CI would catch this whole
class.

**Contradiction between root and exercise:** the root table calls bridge 02
"Channel-based concurrent pipelines" (`README.md:58`), but `bridge/02-pipeline-extend/README.md`
is "extend the sales pipeline" — a *sequential* filter/map/fold over a higher-order
grouping key (`:1-12`), and `bridge/README.md` itself lists its skills as "higher-order,
map, grouping." The root description is simply wrong, and it is wrong at exactly the spot
where the learner forms their mental map of the curriculum.

## 5. Voice and consistency

Tonally consistent: direct, technical, respectful of learner agency. The recurring
"What to observe" / "Checkpoint" / "What you are practising" rhythm is useful. The
inconsistency is structural, not tonal: puzzles reliably carry "Primary skills" / "Why
Mercury" / "Prerequisites" / "Design questions"; bridges vary; some tasks have executable
checkpoints and others say "test it." Adopting one per-format template (purpose → why
Mercury → prerequisites → starting point → task → acceptance criterion → reflection)
would remove most of the unevenness without touching the prose.

## 6. Notable outliers

**Better than average:** `katas/foundations/02-maybe` (the model guided kata);
`puzzles/advanced/07-mercury-in-mercury` (decomposition + checkpoints); the design-question
sets in `bridge/05-mode-reversal` and `puzzles/concurrent/02-pipeline`.

**Worse than average:** `katas/README.md` (materially stale as the main kata index);
`puzzles/concurrent/02-pipeline` (excellent framing, but gives away the full
implementation); every index in the table above.

## 7. Fix before public release

1. **Regenerate or complete every index** and add a CI check that every README path
   resolves and every track count matches the tree. This is the release blocker — the
   prose quality is wasted if the map is wrong.
2. **Fix the root↔bridge-02 contradiction** and the `07-io-error-handling` →
   `07-exceptions` prerequisite.
3. **Add a mechanism-specific "Why Mercury"** to bridges 01–03 and 07–10.
4. **Demote the full stage code** in the pipeline puzzle (and audit other puzzles for the
   same) to an optional hint; keep signatures, examples, and the sentinel invariant.
5. **Adopt a per-format README template** so structure (not just tone) is consistent.
