# Koan: instance declared for a concrete list type

**Broken concept:** declaring a typeclass instance for `list(int)` rather than `list(T)`

## Prerequisites

- `katas/type-system/04-type-classes` — `:- typeclass`, `:- instance`, constraint syntax

---

Mercury's typeclass instance system restricts what types can appear as instance parameters.
An instance for `list(int)` is a *concrete* instantiation — it overlaps with any instance
for `list(T)` if you later want to add one. Mercury forbids this to prevent overlapping
instances.

The allowed forms: instances with fully-abstract type parameters (`list(T)`) or fully
concrete types (`int`, `string`, `point`). Not: `list(int)` (a concrete type applied
to a type constructor).

---

## Try it

```
mmc --make --grade asm_fast.par.gc.stseg typeclass_koan
```

The compiler reports an error about the instance for `list(int)` violating the
instance parameter constraints.

---

## Your task

Fix the instance declaration. You have two options:
1. Declare the instance for `list(T)` instead of `list(int)` (requires that `T` have
   a `showable` instance, expressed as a constraint)
2. Use a wrapper type for `int_list` and declare the instance for that

The solution uses option 1 — the general parametric instance.
