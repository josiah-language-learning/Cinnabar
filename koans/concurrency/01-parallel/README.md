# Koan: `semidet` predicate in parallel conjunction

**Broken concept:** using `&` (parallel conjunction) with a `semidet` goal

## Prerequisites

- `katas/concurrency/01-parallel-conjunction` — `&` operator, determinism requirements, `.par` grade

---

Mercury's `&` operator requires both conjuncts to be `det` or `cc_multi`. A `semidet`
goal in `&` is a compile-time error — not a runtime problem.

---

## Try it

```
mmc --make --grade asm_fast.par.gc.stseg parallel_koan
```

The error: a `semidet` goal in a parallel conjunction — determinism mismatch.

---

## What to observe

`find_something` is `semidet`. Placing it in `A & B` is an error because parallel
conjunction has no backtracking semantics — if one conjunct fails, there is no defined
way to abort the other concurrently-running conjunct.

---

## Your task

Fix by either:
1. Making `find_something` return `maybe(int)` with `det` determinism
2. Replacing the parallel conjunction with a sequential conjunction for the `semidet` part
3. Wrapping `find_something` in a `det` predicate that handles failure

The solution uses option 1.
