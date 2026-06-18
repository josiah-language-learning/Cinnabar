# 01 — Parallel conjunction: `&`

**Concept:** `&` operator, `det`/`cc_multi` requirement, timing comparison with sequential `,`

**Requires:** `.par` grade

**Not in the Mercury tutorial.**

---

## Background

Mercury's parallel conjunction `A & B` evaluates `A` and `B` concurrently. Both must be
`det` or `cc_multi` — if either can fail, it is unclear how to handle failure in the other
concurrent branch.

This is pure fork-join parallelism: both branches run simultaneously and the conjunction
completes when both are done. No shared state, no explicit synchronization. The IO state
is *not* shared — only `det` computations (not those with `!IO`) can run in parallel.

---

## What you will build

Two range-sum computations run in parallel, then timed against sequential.

### The computation

```mercury
:- func range_sum(int, int) = int.
range_sum(Lo, Hi) =
    ( Lo > Hi ->
        0
    ;
        Lo + range_sum(Lo + 1, Hi)
    ).
```

This is deliberately naive (not tail-recursive) to create real work.

### Sequential version

```mercury
:- pred sum_seq(int::out, int::out) is det.
sum_seq(S1, S2) :-
    S1 = range_sum(1, 500000),
    S2 = range_sum(500001, 1000000).
```

### Parallel version

```mercury
:- pred sum_par(int::out, int::out) is det.
sum_par(S1, S2) :-
    S1 = range_sum(1, 500000)
    &
    S2 = range_sum(500001, 1000000).
```

The `&` tells Mercury to evaluate both conjuncts concurrently.

### Build with parallel grade

```bash
mmc --make --grade asm_fast.par.gc.stseg range_demo
```

or `asm_fast.par.gc` if available.

### Measure

Use the Unix `time` command or `io.clock/3` for timing. For small range sizes, sequential
will be faster due to thread spawn overhead. Find the crossover point.

### The `semidet` compile error

Try placing a `semidet` predicate in a parallel conjunction:

```mercury
:- pred maybe_find(int::out) is semidet.
maybe_find(42).

:- pred broken_par(int::out, int::out) is det.
broken_par(S, M) :-
    S = range_sum(1, 1000000)
    &
    maybe_find(M).  % ERROR: semidet in parallel conjunction
```

Read the error. `semidet` in `&` is a compile-time error — not a runtime check.

---

## Checkpoint

- Sequential and parallel versions compile (parallel with `.par` grade)
- Parallel version is measurably faster for large ranges
- `semidet` in `&` gives the expected compile error
- You can explain: why does `&` require `det`/`cc_multi`, not `semidet`?
