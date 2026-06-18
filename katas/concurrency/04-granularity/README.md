# 04 — Granularity and spark cost

**Concept:** parallel conjunction overhead; the threshold pattern; when not to parallelize

**Not in the Mercury tutorial.**

---

## Sparks and their cost

The `&` operator creates a *spark* — a lightweight work item that may be stolen by an
idle CPU and executed in parallel. Spark creation is not free: it involves registering
the work item and may involve memory allocation.

For small work units, spark overhead exceeds the parallel benefit. Parallelizing a
computation that takes 10 microseconds with a spark overhead of 5 microseconds only
achieves 2× speedup at best — and may be *slower* than sequential if no idle CPUs exist.

---

## The threshold pattern

Only parallelize when the work is large enough:

```mercury
par_sum(Lo, Hi, Threshold) = Sum :-
    ( Hi - Lo =< Threshold ->
        Sum = sum_range(Lo, Hi)          % too small: sequential
    ;
        Mid = (Lo + Hi) / 2,
        ( par_sum(Lo, Mid, Threshold) = Left
        & par_sum(Mid + 1, Hi, Threshold) = Right
        ),
        Sum = Left + Right               % large enough: parallel
    ).
```

The threshold is the crossover point: below it, sequential is faster; above it,
parallel wins. The right threshold depends on the hardware, the grain of computation,
and the number of available CPUs.

---

## Mercury's work-stealing scheduler

When `&` creates a spark, the *right* branch is sparked and the *left* branch continues
on the current thread. An idle CPU may steal the right-branch spark.

- If another CPU is idle: both branches run truly in parallel.
- If no CPU is idle: the right branch runs sequentially *after* the left branch completes.

The asymmetry (right is sparked, left continues) matters for task sizing: the left branch
is the "hot path" that runs immediately; the right branch is offloaded.

---

## What you will build

### `sum_range(int, int) = int`

Sequential sum of integers in `[Lo, Hi]`.

### `par_sum(int, int, int) = int`

Parallel sum with threshold. Split at `Mid = (Lo + Hi) / 2`. If `Hi - Lo > Threshold`,
use `&`; otherwise use sequential `sum_range`.

### `par_map(func(T) = U, list(T), int) = list(U)`

Parallel map with threshold. Split the list in half; apply `par_map` recursively to each
half in parallel if the list is longer than `Threshold`; otherwise use `list.map`.

### `measure_sum(int, int, int, int)`

Call both `sum_range` and `par_sum` on the same range and return both results.
From `main`, verify they match.

---

## Timing comparison

To measure the effect of threshold tuning, compile with the parallel grade and run with
multiple CPUs:
```bash
mmc --make --grade asm_fast.par.gc.stseg start
MERCURY_THREAD_COUNT=4 ./start
```

Try thresholds of 1, 100, 1000, 10000 on a large range. The optimal threshold
minimises runtime; too small creates too many sparks, too large leaves CPUs idle.

---

## Checkpoint

- `par_sum(1, 1000, 100)` equals `sum_range(1, 1000)` = 500500
- `par_sum(1, 50, 100)` falls back to sequential (range < threshold); still correct
- `par_map(square, [1..5], 3)` equals `[1, 4, 9, 16, 25]`
- You can state: what is a spark and when does spark overhead dominate?
- You can state: which branch does `&` spark — left or right?
