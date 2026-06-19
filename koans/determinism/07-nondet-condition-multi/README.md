# Koan: `nondet` predicate in if-then-else condition → `multi`

**Broken concept:** using a `nondet` predicate as the condition of an if-then-else
inside a `det` predicate, making the outer predicate `multi`

## Prerequisites

- `katas/determinism/02-committed-choice` — `cc_nondet`, committed-choice semantics
- `koans/determinism/02-nondet-in-det` — nondet called directly in det context

---

```
mmc nondet_cond_koan.m
```

Error: "declared `det', inferred `multi'. Call to `find_tag/2' can succeed more
than once."

---

## What to observe

An if-then-else condition is NOT a committed-choice context for `nondet` goals.
A `nondet` condition can succeed multiple times — Mercury treats each solution as
a branch of the if-then-else, making the expression `multi`. The outer `det`
declaration then fails.

This is subtly different from `koans/determinism/02-nondet-in-det`, where `nondet`
is called directly (not via an if-then-else condition). The if-then-else does NOT
automatically commit to the first solution of a `nondet` condition.

```mercury
( nondet_pred(X) -> use(X) ; fallback )
% If nondet_pred can succeed twice, this produces TWO results — multi, not det.
```

---

## Your task

Replace the `nondet` predicate in the condition with a `semidet` alternative.
`list.find_first_match/3` is `semidet` — it finds the first match and stops:

```mercury
list.find_first_match(pred(T::in) is semidet :- string.length(T) > 3, Tags, Tag)
```
