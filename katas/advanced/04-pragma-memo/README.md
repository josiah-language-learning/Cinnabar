# Kata: pragma memo

`pragma memo` tells the Mercury compiler to memoize a pure predicate: the first call with given ground inputs computes the result and caches it; subsequent calls with the same inputs return the cached value without recomputing.

```mercury
:- pragma memo(fibonacci/2).
:- pred fibonacci(int::in, int::out) is det.
fibonacci(0, 0).
fibonacci(1, 1).
fibonacci(N, F) :-
    N > 1,
    fibonacci(N - 1, F1),
    fibonacci(N - 2, F2),
    F = F1 + F2.
```

Without `pragma memo`, `fibonacci(40, _)` recomputes every sub-problem from scratch — exponential time. With it, each sub-problem is computed once — linear time.

## When pragma memo applies

`pragma memo` requires:
- The predicate is **pure** (no IO, no impure calls)
- All inputs are **ground** at call time
- The grade supports tabling (default `asm_fast.gc` does)

It does **not** apply to:
- `impure` or `semipure` predicates
- Predicates with partially instantiated inputs
- `nondet` predicates (use `pragma minimal_model` for those)

## pragma memo vs pragma minimal_model

| | `pragma memo` | `pragma minimal_model` |
|---|---|---|
| Determinism | `det` or `semidet` | `nondet` or `multi` |
| Purpose | cache results | compute fixed points |
| Use case | pure function optimisation | tabled search, Datalog-style queries |

`pragma minimal_model` is covered in `katas/tooling/04-tabling`. This kata focuses on `memo` for deterministic predicates.

## Steps

### 1. Memoize a recursive computation

Add `pragma memo` to a naive recursive implementation of:

```mercury
:- pred ack(int::in, int::in, int::out) is det.
```

The Ackermann function. Time `ack(3, 7, _)` before and after. (Use `time` or just observe whether it completes in reasonable time.)

### 2. Understand the cache scope

`pragma memo` caches across calls within a single program run. It does **not** persist across runs.

Write a predicate `expensive(int::in, int::out) is det` that takes a noticeable amount of time (e.g., loops 10M times). Call it twice with the same argument. Observe that the second call is instantaneous.

### 3. Verify purity requirement

Try adding `pragma memo` to a predicate that calls `io.write_string`. The compiler rejects it. Read the error. Understand why: memoization would suppress the IO effect on repeated calls, breaking the IO monad.

### 4. Manual memoisation with map

`pragma memo` is not always available (some grades, some targets). Write a manual memoised Fibonacci using `map.search` and `map.set` threaded through state:

```mercury
:- pred fib_memo(int::in, int::out,
                 map(int, int)::in, map(int, int)::out) is det.
```

Compare the interface to `pragma memo`. Note what `pragma memo` eliminates: the need to thread the cache manually.

### 5. Memoize a semidet lookup

```mercury
:- pragma memo(lookup/2).
:- pred lookup(string::in, config_value::out) is semidet.
```

Both success and failure are cached. A second call with a key that previously failed will fail immediately without re-running the predicate body.

## Getting started

```mercury
:- module pragma_memo.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.
:- implementation.
:- import_module int.
:- import_module map.
:- import_module string.

main(!IO) :- true.
```
