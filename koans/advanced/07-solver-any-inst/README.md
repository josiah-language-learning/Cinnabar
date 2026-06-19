# Koan: solver type variables have inst `any`, not `ground`

**Broken concept:** calling a predicate that expects a `ground` argument with a
variable produced by a solver predicate — which has inst `any`

## Prerequisites

- `katas/advanced/02-solver-types` — solver types, `any` inst
- `katas/advanced/01-ffi-depth` — `foreign_proc`

---

```
mmc solver_any_koan.m
```

```
mode error: variable `T' has instantiatedness `any',
expected instantiatedness was `ground'.
```

---

## What to observe

Mercury's `solver type` introduces a third instantiatedness alongside `free`
and `ground`:

```
free    — unbound variable
any     — constrained but not yet fully determined (in the constraint store)
ground  — fully instantiated value
```

A predicate that produces a solver variable returns `out(any)`, not `out`:

```mercury
:- pred make_var(token_var::out(any)) is det.
```

Any predicate that **operates on** a solver variable must also declare the
`any` inst explicitly:

```mercury
:- pred extract(token_var::in(any), int::out) is det.
```

Plain `::in` is shorthand for `::in(ground)`. Passing an `any` value where
`ground` is expected is a mode error — the mode checker enforces this
statically, with no constraint engine needed.

---

## Your task

Change the mode annotation on `extract/2`'s first argument from `::in` to
`::in(any)`. Update both the `:- pred` declaration and the `:- pragma
foreign_proc` signature to match.
