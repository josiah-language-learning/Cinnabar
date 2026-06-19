# Koan: typeclass method used without constraint declaration

**Broken concept:** a polymorphic predicate calls a typeclass method on type variable `T`
but does not declare `<= show(T)` in its signature — the constraint is unsatisfiable
for an unconstrained type variable

## Prerequisites

- `katas/type-system/03-typeclasses` — typeclass declarations, instance syntax, constraints
- `koans/type-system/05-missing-instance` — what "unsatisfiable typeclass constraint" means
  for a concrete type

---

Mercury's constraint system requires that every typeclass method call be backed by
a provable constraint. For a concrete type like `color`, the proof is an `instance`
declaration. For a type variable like `T`, the proof must come from the predicate's
own declared constraint: `<= show(T)`.

Without that declaration, Mercury treats `T` as completely unconstrained — and correctly
rejects the attempt to call `show` on something with no known structure.

---

## Try it

```
mmc --make constraint_koan
```

The compiler reports "unsatisfiable typeclass constraint: `show(T)'" — the same
error message as koan 05, but here the problem is in the *signature*, not in a
missing *instance*.

---

## What to observe

`print_value` is polymorphic in `T`. It calls `show(X, Str)` where `X :: T`.
An instance `show(int)` exists, but that doesn't help for an arbitrary `T`.
The predicate must declare that it *requires* `show(T)` from its callers.

---

## Your task

Add a typeclass constraint to `print_value`'s `:- pred` declaration so that
callers are required to provide evidence that `T` satisfies `show`.
The predicate body and `main` need no changes.
