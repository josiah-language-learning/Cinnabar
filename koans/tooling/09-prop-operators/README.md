# Koan: `int.between` and `list.length` type ambiguity

**Broken concept:** two property-testing errors — a nonexistent generator predicate
and a type-ambiguous length comparison

## Prerequisites

- `katas/tooling/06-property-testing` — generator/property/runner pattern
- `koans/tooling/08-property-generator` — det generator mode mismatch

---

```
mmc prop_ops_koan.m
```

Two errors:

1. `undefined symbol 'between'/3` in module `int`
2. Ambiguous overloading for `list.length` in an equality expression

---

## What to observe

**Part 1:** `int.between/3` does not exist in Mercury 22. The correct predicate is:

```mercury
:- pred int.nondet_int_in_range(int::in, int::in, int::out) is nondet.
```

`int.between` is a Prolog library convention not found in Mercury's standard library.

**Part 2:** `list.length(Xs) = list.length(Ys)` causes "ambiguous overloading"
because `list.length` has both a function form (returning `int`) and a predicate
form (partial application yields `pred(int)`). The type checker cannot determine
which form is intended when used in an equality expression.

Fix: use the predicate form with a shared variable:

```mercury
list.length(Xs, Len),
list.length(Ys, Len)
```

---

## Your task

Fix both bugs: replace `int.between` with `int.nondet_int_in_range`, and rewrite
the length property using the predicate form.
