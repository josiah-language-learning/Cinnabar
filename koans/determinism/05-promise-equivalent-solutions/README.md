# Koan: `promise_equivalent_solutions` does not remove can-fail

**Broken concept:** using `promise_equivalent_solutions` expecting to produce `det`,
not realising it only removes the multi-solution property — a can-fail inner goal
still gives `semidet`

## Prerequisites

- `katas/determinism/02-committed-choice` — `cc_multi`, `cc_nondet`, single-solution contexts
- `katas/determinism/01-six-categories` — the det/semidet/multi/nondet grid

---

## Try it

```
mmc --make --grade asm_fast.par.gc.stseg promise_solutions_koan
```

The error: `list_max` is declared `det` but the compiler infers `semidet`.

---

## What to observe

`promise_equivalent_solutions [Max] ( Goal )` tells the compiler: "all solutions
for Max are equivalent — commit to the first." This is a determinism cast:

| inner goal | result |
|------------|--------|
| `cc_multi` | `det`  |
| `cc_nondet` | `semidet` |

The pragma removes the *multi-solution* problem. It does not remove the *can-fail*
problem. `list.member(Max, Xs)` can fail when `Xs` is empty — so the inner goal
is `cc_nondet`, and the whole expression is `semidet`, not `det`.

The analogous pure determinism rule: `solutions/2` wraps a `nondet` goal into a
`det` list. But if the goal is `semidet`, `solutions` gives a list that is always
`[]` or `[X]` — still `det`. `promise_equivalent_solutions` is the committed-choice
analogue: it commits to one solution, but if there might be zero, the result can
still fail.

---

## Your task

Fix the determinism mismatch. Two valid approaches:

1. Change the declaration to `is semidet` and let callers handle the
   empty-list case.

2. Keep `is det` by adding an explicit base case that handles empty lists,
   ensuring the wrapped goal always succeeds.

The fix should not change the observable behaviour for non-empty lists.
