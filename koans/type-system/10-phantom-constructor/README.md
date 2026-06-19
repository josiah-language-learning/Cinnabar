# Koan: `:- type tag.` declares an abstract type, not an empty type

**Broken concept:** using `:- type metres.` to create a phantom type tag, but
getting an "abstract type with no definition" error

## Prerequisites

- `katas/type-system/` — ADT types
- `koans/type-system/08-phantom-mismatch` — phantom type tags in practice

---

```
mmc phantom_con_koan.m
```

Error: "the abstract type declaration for type `metres/0' has no corresponding
non-abstract declaration."

---

## What to observe

In Mercury, `:- type metres.` in the interface declares `metres` as an **abstract
type** — a type whose definition is hidden from callers. Mercury expects the
implementation section to supply the concrete definition (`---> ...`). Without
one, you get the error.

This surprises programmers who expect `:- type metres.` to create a concrete
empty type, analogous to Haskell's `data Metres`.

To create a phantom type tag that is concrete (and never-used at runtime):

```mercury
:- type metres ---> metres_unit.
:- type seconds ---> seconds_unit.
```

The constructor `metres_unit` is never called — it exists only to satisfy
Mercury's requirement that a non-abstract type has at least one constructor.

---

## Your task

Add a dummy constructor to each phantom type tag declaration.
