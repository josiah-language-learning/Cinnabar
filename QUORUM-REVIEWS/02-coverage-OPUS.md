# Review 02 — Coverage

**Reviewer:** OPUS (Claude Opus 4.8)
**Date:** 2026-06-22

## Assessment

Coverage is unambiguously the curriculum's strongest dimension, and it has *grown* since
the 06-21 synthesis. On-disk (verified): **71 katas** across 8 tracks, **80 koans**,
**12 bridges**, **21 puzzles** = 184 exercises. Three of the synthesis's P3 "missing"
items are now present:

- `katas/mode-system/09-func-vs-pred` (the function-vs-predicate gap),
- `katas/advanced/08-mutable-state` (`store`/`io_mutvar` threading),
- `katas/foundations/12-io-patterns` (IO design patterns).

So the most-cited coverage holes from the prior round are closed. What remains is genuine
breadth with a few honest edges.

## Track-by-track (verified counts)

| Track | Katas | Koans | Verdict |
|---|---|---|---|
| Foundations | 13 | 23 | broad; the koan ladder (23!) is exceptional |
| Type system | 10 | 10 | most complete; ADTs → typeclass depth → phantom → GADT-approx |
| Mode system | 9 | 8 | deepest public Mercury resource; uniqueness + clause-selection unmatched |
| Determinism | 7 | 8 | only determinism-lattice resource that exists; complete |
| Parsing | 9 | 7 | DCG basics → packrat → desugaring; well-sequenced |
| Tooling | 6 | 9 | thinnest *kata* track (grades is reference-only) |
| Concurrency | 9 | 7 | STM + granularity + the documented `&` backend bugs are rare gold |
| Advanced | 8 | 8 | FFI/RTTI/memo/store; solver-types is honestly marked reference-only |

## Genuine remaining gaps (independently assessed)

1. **No paradigm-comparison content** — the repo is "polyparadigm-project" but every
   exercise teaches Mercury declarative idioms. I agree with BIG-PICKLE this is a
   name-vs-content expectation gap, but I rate it **lower priority**: the value is in
   depth-first Mercury, and a thin paradigm-compare layer would dilute that. A handful of
   "Paradigm Note" callouts (mode reversal, STM, uniqueness) is the right dose.
2. **Tooling is the weakest track**, not Advanced. Grades is reference-only, leaving ~5
   real exercises, and there is no *build-system* kata (multi-module `mmc --make`, `.mh`
   interface files, module resolution) even though bridges/puzzles lean on it constantly.
   DEEPSEEK's "no mdb exercise that tests the learner" is also fair.
3. **stdlib edges**: `cord` (the actually-correct fix for the puzzle-08 quadratic append
   the reviewers keep citing), `list.foldl2`/`map_foldl` threading variants, and
   `string.format` vs `io.format` are used but never drilled. Minor.
4. **Determinism kata 07 is short** (DEEPSEEK: ~63 lines vs 96–126 for siblings) — a
   depth dip in an otherwise-deep track, worth a second look.

## A note the other reviewers missed
The new `bridge/04-determinism-ratchet` content now teaches **three** first-solution
idioms for a `nondet` goal (`solutions`+head, `list.find_first_match`, and `cc_multi`
committed choice) with a trade-off table — this materially *deepens* determinism coverage
beyond what any reviewer credited, because it was added this session and post-dates their
passes. It also ties the bridge to determinism koans 03 and 07, which is exactly the
kata→koan reinforcement the educational design aims for.

## Score: **8.5/10**
Breadth and depth that no other Mercury resource approaches, with the prior round's top-3
gaps now filled. Docked half a point for the tooling/build-system thinness and the
unmet "polyparadigm" promise — both deliberate, neither thin where it counts.
