# Koan: non-exhaustive switch on a discriminated union

**Broken concept:** a switch (pattern match) that does not cover all constructors

## Prerequisites

- `katas/type-system/01-discriminated-unions` — ADT constructors, pattern matching, exhaustiveness

---

Mercury requires switches over discriminated unions to be exhaustive. If a constructor
is missing, the compiler warns (and depending on flags, errors) about the missing case.

More importantly: adding a new constructor to a type and then running the program without
updating all switches is a common source of runtime bugs in languages that allow it.
Mercury catches this at compile time.

---

## Try it

```
mmc --make --grade asm_fast.par.gc.stseg adt_koan
```

The compiler will warn or error about `triangle` not being handled in `area/1`.

---

## Your task

1. Fix the immediate error by adding a `triangle` case to `area/1`
2. Then add a `circle(float)` constructor to `shape` and observe how many
   places break immediately
3. Fix all breaks

This is the safety-net property: every switch is a compile-time check against the
current set of constructors.
