# Review 05 — Idiomatic Mercury

**Reviewer:** OPUS (Claude Opus 4.8)
**Date:** 2026-06-22

## Assessment

This is the curriculum's best *quality* dimension. The material does not just use Mercury
correctly — it teaches the idioms that distinguish a Mercury programmer from a Prolog or
Haskell programmer writing Mercury. After compiling and reading widely across the corpus,
I'd call several tracks reference-grade: I would point a new Mercury hire at the
mode-system and determinism tracks over the official tutorial for these specific topics.

## What it gets idiomatically right

- **Determinism as a design decision, not an afterthought.** The six-category lattice,
  `cc_multi`/`cc_nondet`, and `promise_equivalent_solutions` (taught with both an honest
  and a deliberately-lying use) are presented as *contracts you choose*. This is the
  Mercury mindset.
- **Modes/insts as first-class.** Higher-order args carry insts (`pred(in) is semidet`);
  the curriculum consistently puts inst info in the **mode** position, not the type — I
  verified the corrected bridge-04/06 declarations compile, and the mode-system track
  drills this directly.
- **Pure state threading before impurity.** `!State` threading is taught early; `store`/
  `io_mutvar` and `impure`/`promise_pure` are introduced as the *later, costlier* options
  with the pure accumulator framed as the default. That ordering is the idiomatic value
  judgment, and the new mutable-state kata makes it explicit ("a pure accumulator usually
  wins").
- **Committed choice taught honestly.** The reworked bridge-04 now distinguishes
  "if-then-else commits the *existence test*" from "a `cc_multi` context commits the
  *witness*" — a subtlety most Mercury docs gloss. This is exactly the idiom a learner
  needs and (per Review 03) it is now compiler-verified rather than asserted.
- **Function-vs-predicate as a teachable decision.** The new kata articulates a principle
  experienced Mercury programmers internalize but rarely write down (det/one-mode/
  expression-nesting for funcs; failure/multi-solution/reversibility for preds).

## Minor non-idioms / gaps

- **`cord` is never taught**, yet the curriculum repeatedly hits the `Acc ++ [x]`
  quadratic-append trap (puzzle 08) whose *idiomatic* answer is `cord` or
  cons-then-reverse. Teaching the reverse idiom (which puzzle 08's fix uses) is fine, but
  `cord` deserves a mention as the standard efficient-append type.
- **`list.foldl2` / `list.map_foldl`** threading variants appear in solutions but are
  never isolated; a learner meets the multi-accumulator idiom only incidentally.
- **`solutions/2` sort-dedup**: correctly taught (determinism koan 02). I reaffirm the
  standing advisory — Mercury's canonical term order makes this sorted+deduped; do **not**
  "fix" it.

## vs the other reviewers
Strong agreement here — both prior reviewers rate this 8/10 and credit the determinism/
mode depth. DEEPSEEK's note that concurrency kata 08 documents three real 22.01.8 `&`
backend bugs is correct and is genuinely rare, valuable Mercury-specific knowledge.

## Score: **8.5/10**
Reference-grade idiomatic instruction in the mode/determinism/uniqueness core, now
strengthened by the func-vs-pred and committed-choice additions. The only gaps are a few
stdlib idioms (`cord`, fold variants) that are used-but-not-drilled.
