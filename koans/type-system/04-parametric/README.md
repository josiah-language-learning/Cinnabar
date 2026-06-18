# Koan: type variable in body but not in head

**Broken concept:** using a type variable in a predicate's body that does not appear
in the head — a type variable scoping error

## Prerequisites

- `katas/type-system/02-parametric-polymorphism` — type variables, parametric types, scoping

---

In Mercury, every type variable used in a clause body must either appear in the head's
type signature or be explicitly quantified. Using a "fresh" type variable only in the
body causes a type error because the compiler cannot determine what type it should be.

---

## Try it

```
mmc --make --grade asm_fast.par.gc.stseg parametric_koan
```

The compiler reports a type error about an ambiguous type variable or an unbound
type variable in the clause body.

---

## What to observe

The `make_pair` predicate tries to pair two values of *independent* types. But the
way it is written, the second value's type is a fresh variable that does not appear
in the predicate's declared type signature — the compiler cannot infer what type `B` is.

---

## Your task

Fix the predicate so that both type parameters appear in the type signature. You may
need to introduce a pair type or change the signature.
