# 04 — Determinism in DCG rules

**Concept:** why multi-clause DCG rules infer `multi`/`nondet`; using if-then-else to
get `det`/`semidet` DCG rules; the empty-alternative hazard

**Not in the Mercury tutorial.**

---

## The multi-clause problem

Every DCG rule with multiple clauses is, by default, `nondet` or `multi` — because
Mercury cannot prove mutual exclusion between alternatives at compile time:

```mercury
% This infers `nondet`, not `semidet`:
sign(1)  --> ['+'].
sign(-1) --> ['-'].
```

Mercury sees two clauses that could both apply and infers `nondet`. Even though `'+'` and
`'-'` are obviously distinct, the compiler's mutual-exclusion analysis doesn't extend to
DCG terminals in the general case.

---

## When Mercury *can* prove exclusion

For single-character terminal alternatives, Mercury sometimes proves exclusion and infers
`semidet`:
```mercury
% Mercury proves ['+'] and ['-'] are mutually exclusive → semidet:
sign_semidet(1)  --> ['+'].
sign_semidet(-1) --> ['-'].
```

This works because the terminals are different bound values. But this is a special case —
do not rely on it for general alternatives.

---

## If-then-else for guaranteed `det`/`semidet`

The reliable pattern: if-then-else *commits* to one branch and prevents backtracking:

```mercury
% Always det — picks a sign or defaults to 1:
opt_sign_det(Sign) -->
    ( ['-'] -> { Sign = -1 } ; { Sign = 1 } ).
```

`( [C] -> body ; alternative )` inside a DCG rule reads: "if the next token is `C`,
take this branch; otherwise take the other." This is `det` (always produces a result)
and does not backtrack.

---

## Getting genuine `multi`

To make a DCG rule `multi`, add an alternative that always succeeds (empty consumption):

```mercury
% multi — always matches (empty) and also matches '-':
opt_sign_multi(1)  --> [].      % empty alternative: always succeeds
opt_sign_multi(-1) --> ['-'].   % matches if '-' present
```

The `[]` (epsilon) alternative always succeeds, guaranteeing at least one solution.
Combined with the `['-']` alternative, the rule is `multi`.

---

## The empty-alternative hazard

`( rule --> ... ; [] )` means "optionally match." It always succeeds. This is sometimes
correct — but be careful: if you use this as part of a larger parser and the inner rule
fails, the empty alternative silently hides the failure. Your parser proceeds with no
input consumed, producing a wrong result instead of a useful error.

---

## Calling DCG rules via `solutions/2`

DCG rules are predicates. To collect all solutions from a `multi` or `nondet` DCG rule,
wrap it in a lambda:

```mercury
solutions(
    (pred(V::out) is nondet :- opt_sign_multi(V, Input, _)),
    Results
)
```

The lambda takes the input list and discards the remainder (`_`).

---

## What you will build

### `opt_sign_multi` — `multi`

Produces `1` (empty) and `-1` (`['-']`). Verify via `solutions/2`.

### `opt_sign_det` — `det`

If-then-else: commits to `Sign = -1` if `'-'` present, else `Sign = 1`.

### `sign_semidet` — `semidet`

Two clauses for `'+'` and `'-'`. Mercury proves exclusion → `semidet`.

---

## Checkpoint

- `opt_sign_multi` infers `multi`; `solutions` returns both `1` and `-1` on `['-']`
- `opt_sign_det` infers `det`
- `sign_semidet` infers `semidet`; fails on empty input
- You can state: why do multiple DCG clauses default to `nondet`?
- You can state: what does the if-then-else buy you over a plain disjunction?
