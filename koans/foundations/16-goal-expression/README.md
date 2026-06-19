# Koan: `=` is a goal, not an expression

**Broken concept:** using Mercury's unification operator inside a functor
application as if it were an equality-testing expression that returns a value

## Prerequisites

- `katas/foundations/` — Mercury types, ADTs
- `katas/type-system/01-adt` — discriminated union types

---

```
mmc goal_expr_koan.m
```

Error: "the language construct `='/2` should be used as a goal, not as an
expression."

---

## What to observe

In Mercury, `=` is unification — a *goal* (predicate), not an expression that
returns a value. Writing `flagged(A = B)` tries to apply the `flagged` functor
to the "result" of `A = B`. But goals do not return values — they succeed or fail.

The fix is to separate the test from the construction using if-then-else:

```mercury
tag_equal(A, B) = Result :-
    ( A = B -> Result = flagged(yes) ; Result = flagged(no) ).
```

---

## Your task

Rewrite `tag_equal` so the equality test is an if-then-else goal and the
`flagged` constructor is applied to the result `yes` or `no`.
