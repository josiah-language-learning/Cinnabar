# Koan: `list.foldl` takes a predicate, not a function

**Broken concept:** passing a `func(L, A) = A` lambda to `list.foldl`, which
expects a `pred(L, A, A)` lambda

## Prerequisites

- `koans/foundations/10-foldl-accumulator` — `!X` in lambda heads
- `katas/foundations/` — higher-order predicates

---

```
mmc foldl_func_koan.m
```

Type or mode error on the lambda passed to `list.foldl`.

---

## What to observe

`list.foldl` signature:

```mercury
:- pred foldl(pred(L, A, A), list(L), A, A).
:- mode foldl(pred(in, in, out) is det, in, in, out) is det.
```

It expects a **predicate** of three arguments: the element, the old accumulator,
and the new accumulator. A `func(L, A) = A` (two-argument function returning a
value) is a fundamentally different type.

Common mistake: writing `func(X, Acc) = Acc + X`, porting a style from Haskell
(`foldl (+) 0 list`) or Python (`functools.reduce(lambda x, acc: acc + x, lst)`).

The Mercury fix uses a pred lambda with three explicit arguments:

```mercury
list.foldl(pred(X::in, Acc0::in, Acc::out) is det :- Acc = Acc0 + X,
           List, 0, Sum)
```

---

## Your task

Replace the `func` lambda with a `pred` lambda that takes `(Element, OldAcc, NewAcc)`.

Note: this is distinct from `koans/foundations/10-foldl-accumulator`, which covers
the `!X` shorthand restriction in lambda heads. Here the bug is `func` vs `pred`.
