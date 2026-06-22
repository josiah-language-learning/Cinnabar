# Review 06 — Educational Quality

**Reviewer:** CODEX  
**Date:** 2026-06-22  
**Score:** 8/10

## Strengths

### A well-designed practice ladder

The project gives each format a distinct educational job: koans teach error interpretation, katas isolate deliberate practice, bridges provide constrained extension work, and puzzles require design choices. That progression is a credible route from recognizing a compiler error to building a program.

### Feedback is better than a prose-only audit suggests

The current tree has a `runtests` script for every kata starter, plus scripts for nested reactivation exercises. That is a significant strength. The koans additionally have expected compilation polarity and diagnostic snapshots. Whether each script has sufficient edge cases still needs execution, but the feedback mechanism exists across the kata corpus.

### Excellent treatment of Mercury-specific difficulty

Mercury learners often stall on compiler diagnostics, modes, determinism, and uniqueness rather than on basic syntax. The koan corpus and `COMPILER-LESSONS.md` directly address that difficulty instead of assuming learners will absorb it from successful examples.

## Findings

### P2 — Provide session-planning signals

The curriculum is self-directed but provides almost no way to distinguish a ten-minute koan, a one-hour bridge, and a multi-session puzzle before opening them. Add coarse durations and prerequisite confidence labels to each index first; per-exercise estimates can follow.

### P2 — Add explicit retrieval and synthesis checkpoints

The sequence has good scaffolding but weak planned recall. Add three to five no-peek questions or a tiny mixed exercise at the end of each track. These should combine prior concepts rather than repeat a local task, for example a parser with a declared error type and a determinism argument.

### P3 — Add one worked, fully annotated solution per track

Solutions for koans and bridges are useful, but a novice needs a model of the reasoning that chooses modes, determinism, and data representations before coding. The first kata in each track should include an optional annotated walkthrough after the learner attempt, not merely a final answer.

### P3 — Make solution-access discipline explicit

Adjacent `solution/` directories make answers easy to find, which is appropriate for self-study but invites premature inspection. Add a short standard sentence: attempt, run verification, record the prediction/error, then compare the solution. This turns access to solutions into a deliberate feedback loop.

## Verdict

This is a notably strong instructional design: it practices compiler literacy instead of treating it as an incidental inconvenience, and it supplies automated checks throughout the kata set. Its next educational gains are metacognition—time planning, retrieval, and worked reasoning—not more content volume.
