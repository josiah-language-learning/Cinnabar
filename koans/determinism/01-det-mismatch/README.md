# Koan: `det` predicate missing its else branch

**Broken concept:** declaring a predicate as `det` but writing an if-then-else without
an else branch — the compiler sees a potential failure path

## Prerequisites

- `katas/determinism/01-six-categories` — the six determinism categories, `det` vs `semidet`

---

A `det` predicate must succeed exactly once. An if-then-else without an else (`( Cond -> Then )`)
can fail when `Cond` is false. The compiler detects this: the actual determinism
is `semidet`, not `det`.

---

## Try it

```
mmc --make --grade asm_fast.par.gc.stseg det_koan
```

The error: "determinism error: declared det, but inferred semidet" (or similar). The
compiler is telling you that the if-then-else can fail.

---

## What to observe

`( Cond -> Then )` without an else is equivalent to `( Cond -> Then ; fail )`. It can
fail. A `det` predicate cannot fail.

---

## Your task

Fix by adding an else branch. What should happen when the condition is false?
The predicate signature tells you: it must produce an `int` either way.
