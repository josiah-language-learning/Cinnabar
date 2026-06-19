# Koan: multi-clause DCG rules infer `nondet`, not `semidet`

**Broken concept:** declaring a multi-clause DCG rule `semidet` when each clause
is a separate alternative

## Prerequisites

- `katas/parsing/01-dcg-basics` — DCG rule syntax and alternatives
- `katas/parsing/04-dcg-determinism` — determinism in DCG rules

---

```
mmc dcg_nondet_koan.m
```

```
error: determinism declaration not satisfied.
  Declared `semidet', inferred `nondet'.
  Disjunction has multiple clauses with solutions.
```

---

## What to observe

Multiple clauses for a DCG rule are logical alternatives. Mercury treats them
exactly like multi-clause predicates: any subset of clauses can potentially
succeed on a given input. The compiler cannot statically prove that only one
alternative matches, so it infers `nondet` (multiple solutions possible).

To get a `semidet` result, collapse the alternatives into a single clause
with if-then-else. The if-then-else is a committed-choice construct — once
a branch's condition succeeds, Mercury commits to it and does not try the others:

```mercury
token(T) -->
    ( digit(_) ->
        { T = int_tok }
    ; ['+'] ->
        { T = plus_tok }
    ; ['*'] ->
        { T = star_tok }
    ;
        { fail }
    ).
```

This is how virtually all production DCG parsers in Mercury are written. The
multi-clause style, while natural from a Prolog background, almost never gives
the determinism you intend.

---

## Your task

Rewrite `token` as a single clause with if-then-else. The final `{ fail }` branch
makes the semidet contract explicit: if nothing matched, the rule fails.
