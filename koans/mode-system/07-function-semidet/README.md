# Koan: function body with fallible unification → `semidet`

**Broken concept:** writing function clauses whose bodies contain unifications
that can fail, making the function `semidet` rather than the required `det`

## Prerequisites

- `katas/mode-system/` — determinism categories
- `katas/determinism/01-six-categories` — det, semidet, nondet, their meanings

---

```
mmc func_semidet_koan.m
```

Error: "determinism declaration not satisfied — declared `det', inferred `semidet'.
The clause body for the function `eval'/1 can fail."

---

## What to observe

Functions in Mercury are implicitly `det` — they must succeed exactly once for
every input. A function clause whose body contains a goal that can fail is `semidet`,
which conflicts with the function's contract.

The failing goals:
```mercury
eval(E) = int_val(N)   % can fail if eval(E) returns error_val
```

This unification succeeds only when `eval(E)` produces `int_val(_)`. If `eval`
returns `error_val`, the unification fails — making the clause `semidet`.

---

## Your task

Rewrite each `eval` clause that has a fallible unification using if-then-else.
Handle both the matching case (int_val) and the fallback case (error_val):

```mercury
eval(neg(E)) = Result :-
    ( eval(E) = int_val(N) ->
        Result = int_val(-N)
    ;
        Result = error_val
    ).
```
