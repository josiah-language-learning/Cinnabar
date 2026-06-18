# 08 — Deterministic parallelism with `&`

**Concept:** parallel conjunction (`&`); deterministic parallelism; when `&` is safe;
Mercury 22.01.8 backend constraints

**Not in the Mercury tutorial.**

---

## Parallel conjunction

`&` is Mercury's parallel conjunction operator. Both sides are evaluated in parallel;
the overall expression completes when both sides are done:

```mercury
( range_sum(1, 500000, LeftSum) & range_sum(500001, 1000000, RightSum) ),
TotalSum = LeftSum + RightSum.
```

Unlike `thread.spawn`, `&` is *deterministic* — the result is identical to sequential
execution. There are no channels, no mutexes, no explicit synchronisation. The compiler
ensures both sides produce values that the continuation can use.

---

## When `&` is safe

Both sides of `&` must be independent: they cannot read *and* write the same variable,
and they cannot share `unique` values. The compiler enforces this via mode analysis:

- Variables produced by one branch can be consumed *after* the `&`
- Variables cannot be threaded *through* a `&` (no `!State` across `&`)

The grade must be `asm_fast.par.gc.stseg` or another parallel grade. In a sequential
grade, `&` is treated as `,`.

---

## Use predicates, not functions, in `&` conjuncts

Mercury 22.01.8 has a backend bug: *function calls* (`= expr`) in `&` conjuncts crash
the code generator. Use predicates with `out` modes instead:

```mercury
% CRASHES:
( Left = heavy_compute(500) & Right = heavy_compute(600) ),

% WORKS:
( heavy_compute(500, Left) & heavy_compute(600, Right) ),
```

Define the predicate form explicitly:

```mercury
:- pred heavy_compute(int::in, int::out) is det.
heavy_compute(N, Result) :- Result = ... .
```

---

## Mercury 22.01.8: if-then-else after `&` output

A second backend bug: if-then-else using a variable produced by `&` in the same clause
body crashes the code generator:

```mercury
% CRASHES (Mercury 22.01.8):
( heavy_compute(X, A) & heavy_compute(Y, B) ),
( A = B -> io.write_string("equal\n", !IO) ; io.write_string("unequal\n", !IO) ).
```

Workaround: move the `&` call into a named predicate; use a separate predicate for
the comparison:

```mercury
:- pred two_heavy(int::out, int::out) is det.
two_heavy(A, B) :- ( heavy_compute(500, A) & heavy_compute(600, B) ).

:- pred check_eq(string::in, int::in, int::in, io::di, io::uo) is det.
check_eq(Name, Got, Expected, !IO) :-
    ( Got = Expected ->
        io.format("PASS: %s\n", [s(Name)], !IO)
    ;
        io.format("FAIL: %s (got %d, expected %d)\n", [s(Name), i(Got), i(Expected)], !IO)
    ).
```

---

## Mercury 22.01.8: call ordering for multiple `&` predicates

A third backend bug: when multiple predicates that internally use `&` are called in the
same clause, the order matters. The rule: call them in *definition order* — the predicate
defined first must be called first.

If `two_heavy` is defined before `par_square2`, then in `main`:

```mercury
two_heavy(A, B),         % defined first → call first
...
par_square2(3, 5, S3, S5).  % defined second → call second
```

Swapping the call order triggers `clobber_lval_in_var_state_map/6: Unexpected: empty
state`. This is a compiler bug, not a logic error in your code.

---

## What you will build

### `range_sum(Lo, Hi, Sum)` — `det` predicate

Sequential sum of integers in `[Lo, Hi]`. Used as the workload for parallel conjunction.

### `par_sum(Lo, Mid, Hi, Sum)` — `det` predicate

Sum `[Lo, Mid]` and `[Mid+1, Hi]` in parallel using `&`, then add results.

### `square(X, Y)` — `det` predicate

`Y = X * X`. Wraps as a predicate so it can appear in `&` conjuncts safely.

### `par_square2(X, Y, SqX, SqY)` — `det` predicate

Square two numbers in parallel: `( square(X, SqX) & square(Y, SqY) )`.

### `two_heavy(A, B)` — `det` predicate

Wrap a `&` over two `heavy_compute` calls. Defined *before* `par_square2` — required
by the 22.01.8 backend ordering constraint.

### `check_eq(Name, Got, Expected, !IO)` — `det` predicate

Compare `Got` and `Expected`; print PASS/FAIL. Used instead of inline if-then-else
after `&` output variables (workaround for backend bug).

---

## Checkpoint

- `par_sum(1, 500000, 1000000, S)` gives `S = 500000500000`
- `par_square2(3, 5, Sq3, Sq5)` gives `Sq3 = 9`, `Sq5 = 25`
- `two_heavy` called before `par_square2` in `main`; swapping order crashes the build
- All checks print PASS
- You can state: what does `&` guarantee that `thread.spawn` does not?
- You can state: the three backend bugs in Mercury 22.01.8 involving `&` and their workarounds
