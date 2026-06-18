# 07 — Clause selection

**Concept:** how Mercury selects which clause body to execute based on calling mode;
`pragma promise_equivalent_clauses`; mode-specific implementations

**Not in the Mercury tutorial.**

---

## Modes select clause bodies at compile time

Mercury resolves modes statically. When a predicate has multiple mode declarations, the
compiler determines *at compile time* which clause body to use for each call site, based
on which arguments are bound and which are free. This is different from Prolog, where
clause selection is purely a runtime operation based on pattern matching.

```mercury
:- pred isqrt(int, int).
:- mode isqrt(in, out) is det.     % forward: given N, compute S
:- mode isqrt(out, in) is det.     % reverse: given S, compute N = S*S
```

The two modes have genuinely different implementations:
```mercury
isqrt(N::in, S::out) :-
    S = round(float.sqrt(float(N))).   % compute square root

isqrt(N::out, S::in) :-
    N = S * S.                         % square the input
```

---

## `pragma promise_equivalent_clauses`

When you provide mode-specific clause bodies, you assert to the compiler that all
implementations are logically equivalent — they all define the same mathematical relation,
just traversed in different directions.

```mercury
:- pragma promise_equivalent_clauses(isqrt/2).
```

The compiler cannot verify this. If your implementations disagree (compute different
things), the program is *wrong* but Mercury cannot detect it. The pragma is a contract
you must honour.

---

## Clause selection at call sites

```mercury
isqrt(9, S),   % compiler selects the (in, out) clause: S = 3
isqrt(N, 4),   % compiler selects the (out, in) clause: N = 16
```

Both calls are fully resolved at compile time. There is no runtime dispatch.

---

## The ambiguity error

If two clauses could both fire for the same mode, the compiler reports an error.
If no clause covers a declared mode, the compiler also errors. Every declared mode must
be covered by exactly one clause.

---

## What you will build

### `isqrt/2` — integer square root, two modes

Forward `(in, out)`: compute integer square root (floor of sqrt).
Reverse `(out, in)`: compute `N = S * S`.

Use `float.sqrt` and `float.truncate_to_int` for the forward mode.

### `list_sum/2` — two modes

Forward `(in, out)`: sum a list.
Reverse `(out, in)`: generate a list that sums to the given value (simplest: `[Sum]`).

Add `pragma promise_equivalent_clauses`. Both modes must produce the same logical
relation.

### Understanding clause selection

Add a traced print (or a comment) to each clause body. Confirm from the test output
that the correct body fires for each calling mode.

---

## Extension: adding a third mode

Try adding `isqrt(in, in) is semidet` — succeeds iff `N` is a perfect square whose
root is `S`. What clause body does this require? What must change in the pragma?

---

## Checkpoint

- Both modes of `isqrt` compile and produce correct results
- `list_sum([1,2,3,4,5], Sum)` gives `Sum = 15`
- `list_sum(Gen, 42)` produces a list that sums to 42
- You can state: when is `pragma promise_equivalent_clauses` required?
- You can state: what happens if your two mode implementations compute different things?
