# Koan: unique value consumed in two branches

**Broken concept:** passing a unique (di) value to two branches of a disjunction

## Prerequisites

- `katas/mode-system/01-insts-and-modes` — insts, modes, `bound(...)` syntax
- `katas/mode-system/03-uniqueness-deep` — `di`/`uo`, `array` uniqueness, `version_array`

---

Mercury's uniqueness system guarantees that a `di` (destructive input) value has exactly
one owner. In a disjunction, the compiler cannot guarantee this — one branch might take
the value and the other branch also try to use it. This is a mode error.

---

## Try it

```
mmc --make --grade asm_fast.par.gc.stseg inst_koan
```

The compiler reports a mode error about uniqueness: the array argument loses its unique
inst in the disjunction context.

---

## What to observe

The code tries to use the same `array` in two branches of an if-then-else. The then-branch
calls `array.set` which consumes (di) the array. The else-branch also tries to use the
same original array. Mercury detects this: the original array cannot be unique in both
branches simultaneously.

---

## Your task

Fix the code using one of:
1. Use `version_array` instead of `array` (supports shared access)
2. Restructure so only one branch uses the array and the other gets a copy
3. Thread the array through both branches so only one branch at a time uses it

The solution uses option 1 (`version_array`).
