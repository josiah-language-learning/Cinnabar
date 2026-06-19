# Koan: phantom type unit mismatch

**Broken concept:** passing values with different phantom type parameters to a predicate
that requires them to match — the compiler rejects mixed units even though the runtime
representation is identical

## Prerequisites

- `katas/type-system/04-phantom-types` — phantom type parameters, compile-time unit tracking

---

A phantom type is a parameterized type where the type parameter does not appear in
any constructor. The parameter carries no runtime data — it exists purely so the type
checker can enforce invariants at compile time.

`length(U)` wraps a `float`, but the type variable `U` (bound to `km` or `miles` at
use sites) prevents mixing incompatible lengths. The predicate `add_lengths` requires
both arguments to share the *same* `U` — and the compiler enforces this.

---

## Try it

```
mmc --make phantom_koan
```

The compiler reports a type error: variable `M` has type `length(miles)`, but
`add_lengths` expects `length(km)` at that argument position.

---

## What to observe

`K` is annotated `length(km)` and `M` is annotated `length(miles)`. When
`add_lengths(K, M, ...)` is called, Mercury unifies the first argument's `U` with `km`
and then checks the second argument — which is `miles`. The mismatch is caught entirely
at compile time, with no runtime overhead.

---

## Your task

Fix `main` so that both arguments to `add_lengths` share the same phantom unit.
The simplest fix is to annotate `M` as `length(km)`.
The predicate `add_lengths` itself needs no changes.
