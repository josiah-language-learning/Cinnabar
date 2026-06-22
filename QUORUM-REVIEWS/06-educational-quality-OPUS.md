# Review 06 — Educational Quality

**Reviewer:** OPUS (Claude Opus 4.8)
**Date:** 2026-06-22

## Assessment

The pedagogical architecture is the project's most *original* contribution — more novel
than even its coverage. The four-format model (kata → bridge → puzzle → koan) maps cleanly
onto four distinct learning modes (drill → guided extension → open synthesis → error
recognition), and the curriculum executes all four well.

## What works (verified, not assumed)

- **The four-tier structure** gives a learner a deliberate path: isolate a concept (kata),
  apply it with scaffolding (bridge), synthesize under ambiguity (puzzle), and learn to
  read the compiler (koan). No other Mercury resource is structured this way.
- **Every kata has a `runtests` feedback loop — all 71 of them.** I verified this on disk
  (`71/71` kata `start.m` dirs have a `runtests`; the 7 reactivation sub-katas too). **This
  directly refutes both prior reviewers**, who claimed "most katas don't have test scripts"
  and that the only feedback is eyeballing output. The learner gets compile-and-check
  feedback on every kata. (The script compiles `start` and diffs expected output — so it
  red-flags an unfinished or wrong solution.)
- **Predict-verify reactivation.** Starting the learner in a "write your prediction, then
  open the source" mode (foundations/00) builds the metacognitive habit the rest of the
  curriculum rewards.
- **`COMPILER-LESSONS.md`.** A large, hard-won catalog of real `mmc` errors with cause and
  fix. This is the single most practically useful file for day-to-day Mercury work and
  exists nowhere else. (It does want a table of contents.)
- **Checkpoints.** Most exercises end with "you can now state/explain X," which tells the
  learner *how to know they're done* — metacognition, not just task completion.

## What holds it back

1. **First-contact methodology whiplash.** The reactivation track (the literal first thing
   START-HERE points to) is predict-verify; every later track is read-then-code. Worth one
   sentence in START-HERE naming the shift so the learner isn't disoriented.
2. **Checkpoint/heading inconsistency in foundations.** Foundations uses `**Concept:**`
   inline and several of its katas lack a checkpoint, while determinism/type-system/mode
   are uniformly headed and checkpointed. The first track a learner hits is the least
   polished — the inverse of what you want.
3. **No time estimates.** For a self-paced solo learner, "~20 min" vs "~2 hr" is real
   planning signal and currently absent everywhere. Cheap to add.
4. **Koan READMEs are spartan.** Intentional to a degree (the compiler is the teacher),
   but a one-line "what invariant this protects" would raise several from cryptic to
   crisp. Lower priority.

## Where I correct the record
Both prior reviewers docked educational quality partly on a *false* premise (missing
feedback mechanism). With `runtests` universal, the feedback story is actually a
**strength**, not a gap. The real educational weak spots are narrower: the foundations
polish gap and the missing time estimates.

## Score: **8/10**
An genuinely innovative, well-realized pedagogical design with a universal feedback loop
the other reviewers missed. Docked for the foundations-track polish inconsistency (it's
the first impression) and the absent time estimates.
