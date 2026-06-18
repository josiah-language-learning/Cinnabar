# 01 — Discriminated unions: expression evaluator

**Concept:** recursive discriminated unions, exhaustive pattern matching, changing
determinism when a constructor can fail

**Tutorial cross-reference:** Mercury Tutorial §2 covers basic type declarations. This
kata uses a *recursive* discriminated union — a self-referential ADT — which the tutorial
does not cover.

---

## What you will build

An expression evaluator for a small arithmetic language.

### Phase 1: Basic evaluator (`det`)

Define the `expr` type:
```mercury
:- type expr
    --->    num(int)
    ;       add(expr, expr)
    ;       mul(expr, expr)
    ;       neg(expr).
```

Write:
```mercury
:- func eval(expr) = int.
eval(num(N)) = N.
eval(add(A, B)) = eval(A) + eval(B).
eval(mul(A, B)) = eval(A) * eval(B).
eval(neg(E)) = -eval(E).
```

This is `det` — every `expr` has exactly one `int` value. Build an example expression and
evaluate it:
```
(3 + 4) * neg(2)   →   add(num(3), num(4)) |> mul(neg(num(2)))
```

### Phase 2: Add `div` — change to `semidet`

Add:
```mercury
;       div(expr, expr)
```

Division by zero should fail (not throw). Change `eval` to:
```mercury
:- func eval(expr) = int.
:- mode eval(in) = out is semidet.

eval(div(A, B)) = eval(A) // eval(B) :-
    eval(B) \= 0.
```

Wait — this changes the determinism of the whole `eval`. Every case must now be `semidet`
(can fail). The compiler will complain that `eval(num(N)) = N` is `det`, not `semidet`.
How do you reconcile this? (Answer: Mercury allows a predicate to be *at most* as
deterministic as declared — `det` is a subset of `semidet`, so this actually works.)

Try dividing by zero and calling `eval` from a context that handles failure.

### Phase 3: Force exhaustive pattern matching

Add a new constructor:
```mercury
;       sub(expr, expr)
```

Without adding a clause for `sub` in `eval`, build and observe the compiler warning or
error. Then add the clause.

This is the property the `koans/type-system/01-adt` koan exploits from the other side.

---

## Checkpoint

- Phase 1 builds and evaluates correctly
- Phase 2: `eval(div(num(10), num(0)))` fails gracefully
- Phase 3: adding a constructor without a clause gives a compiler diagnostic
- You can explain: why is a recursive ADT more expressive than a flat `switch` over an enum?
