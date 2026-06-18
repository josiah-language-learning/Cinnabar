# 04 — Tabling: `pragma memo` and `pragma loop_check`

**Concept:** `pragma memo`, `pragma loop_check`, memoization at the compiler level,
cycle detection in recursive queries

**Not in the Mercury tutorial.** Requires C backend (not Java grade).

---

## Background

Mercury's tabling system lets the compiler memoize predicate calls at the language level —
no manual cache management, no `map` threading. The runtime maintains a call table; if
`fib(30)` is called twice, the second call returns the cached result immediately.

Two pragma variants:
- `pragma memo(fib/1)` — memoize all calls (standard memoization)
- `pragma loop_check(pred/arity)` — detect recursive calls that would loop; fail or throw
  instead of looping infinitely

---

## Exercise 1: Exponential Fibonacci

Start with the exponential naive Fibonacci (same as in `03-profiling`):

```mercury
:- func fib(int) = int.
fib(0) = 0.
fib(1) = 1.
fib(N) = fib(N - 1) + fib(N - 2).
```

Add `pragma memo`:

```mercury
:- pragma memo(fib/1).
```

Measure the difference:
- `fib(40)` without memo: time it
- `fib(40)` with memo: time it

Note: `pragma memo` requires a C backend grade. The default `asm_fast.par.gc.stseg` satisfies this.

## Exercise 2: `pragma loop_check`

Mutual recursion without a base case loops forever:

```mercury
:- pred even(int::in) is semidet.
:- pred odd(int::in) is semidet.

even(0).
even(N) :- N > 0, odd(N - 1).
odd(N) :- N > 0, even(N - 1).
```

This works correctly. Now remove the base case `even(0)` and the guards (`N > 0`):

```mercury
even(N) :- odd(N).
odd(N) :- even(N).
```

Calling `even(0)` loops forever. Add `pragma loop_check`:

```mercury
:- pragma loop_check(even/1).
:- pragma loop_check(odd/1).
```

Now calling `even(0)` fails rather than looping. The tabling system detects that `even(0)`
is called again while already being evaluated, and treats the cycle as failure.

This is the mechanism that makes tabling useful for graph reachability queries (see
`puzzles/data-structures/03-graph-reachability`).

---

## Checkpoint

- `pragma memo` measurably speeds up `fib(40)` (should be several orders of magnitude)
- `pragma loop_check` on the cyclic even/odd pair: calling `even(0)` fails rather than loops
- You can explain: what is the difference between `pragma memo` and `pragma loop_check`
  in terms of what they cache and what they do on a cycle?
