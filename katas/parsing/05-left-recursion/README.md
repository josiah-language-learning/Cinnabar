# 05 — Left recursion

**Concept:** why left-recursive DCG rules loop; accumulator-based refactoring for
left-associative expression parsing

**Not in the Mercury tutorial.**

---

## The problem with left recursion

A left-recursive grammar loops immediately before consuming any input:

```mercury
% INFINITE LOOP — never use this:
expr(N) --> expr(L), [plus], term(R), { N = L + R }.
expr(N) --> term(N).
```

Mercury's DCG rules are plain predicates. When the compiler calls `expr(N)`, it tries
the first clause — which calls `expr(N)` again before consuming any input. This is an
infinite recursion.

DCGs in Mercury (as in Prolog) are top-down, depth-first. Left recursion is not allowed.

---

## The fix: accumulator-based "rest" parsing

The standard refactoring splits the grammar into:
- `expr(N)`: parse a `term`, then pass it as the initial accumulator to `expr_rest`
- `expr_rest(Acc, N)`: consume zero or more `op term` pairs, accumulating the result

```mercury
:- pred expr(int::out, list(token)::in, list(token)::out) is semidet.
expr(N) --> term(T), expr_rest(T, N).

:- pred expr_rest(int::in, int::out, list(token)::in, list(token)::out) is det.
expr_rest(Acc, Acc) --> [].                % base: no more operators
expr_rest(Acc0, N) -->
    [plus], term(T), { Acc1 = Acc0 + T },
    expr_rest(Acc1, N).
expr_rest(Acc0, N) -->
    [minus], term(T), { Acc1 = Acc0 - T },
    expr_rest(Acc1, N).
```

The accumulator holds the "result so far". Each `expr_rest` call consumes one `op term`
pair and recurses. When no more operators appear, the accumulator is the final result.

---

## Left-associativity is preserved

Because the accumulator is updated *before* the recursive call, the result is
left-associative:

```
"10 - 3 - 2" parses as:
  expr_rest(10 - 3, N)   →   expr_rest(7, N)   →   N = 7 - 2 = 5
```

This gives `5`, not `10 - (3 - 2) = 9`. The accumulator threading provides
left-associativity for free.

---

## Precedence via grammar structure

Operator precedence is handled by grammar stratification:
- High-precedence operators (`*`, `/`) appear in `term` / `term_rest`
- Low-precedence operators (`+`, `-`) appear in `expr` / `expr_rest`
- `expr` calls `term`; `term` never calls `expr` — so `*` binds tighter

---

## What you will build

### Token type and `term`

```mercury
:- type token ---> num(int) ; plus ; minus ; times ; divide.
:- pred term(int::out, list(token)::in, list(token)::out) is semidet.
term(N) --> [num(N)].
```

### `expr_rest` — base case and `+`/`-` cases

The base case (no operator): `expr_rest(Acc, Acc) --> [].`

Add `plus` and `minus` cases using the accumulator pattern above.

### `expr` — parse term, hand off to `expr_rest`

```mercury
expr(N) --> term(T), expr_rest(T, N).
```

### Verify left-associativity

Test `[num(10), minus, num(3), minus, num(2)]` — should give `5`, not `9`.
Test `[num(3), plus, num(4), times, num(2)]` — requires `times` in `term`; result
depends on whether you implement `term_rest` (if not, this is out of scope).

---

## Checkpoint

- `expr_rest` and `expr` compile
- `"10 - 3 - 2"` (as tokens) parses to `5`
- You can state: why does left recursion cause infinite recursion in top-down parsers?
- You can state: how does the accumulator pattern provide left-associativity?
