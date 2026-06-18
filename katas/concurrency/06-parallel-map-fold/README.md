# 06 — Parallel map and fold

**Concept:** order-preserving parallel map using channels; why naive parallel fold is
wrong; map-then-fold as the correct pattern

**Not in the Mercury tutorial.**

---

## Order-preserving parallel map

To apply an operation to each list element in parallel while preserving order:
1. Allocate one channel per element *before* spawning
2. Spawn a thread for each element; each thread writes to its own channel
3. Read from channels in *original order*

```mercury
par_map(F, [X | Xs], [Y | Ys], !IO) :-
    channel.init(Chan, !IO),
    thread.spawn((pred(IO0::di, IO1::uo) is cc_multi :-
        F(X, Result),
        channel.put(Chan, Result, IO0, IO1)),
        !IO),
    par_map(F, Xs, Ys, !IO),       % spawn remaining threads
    channel.take(Chan, Y, !IO).    % collect THIS thread's result
```

Note the ordering: this implementation spawns threads and collects in LIFO order (the
last spawned thread's result is collected first, due to the recursive structure). The
stub is a correct starting point; a fully parallel version pre-allocates all channels
then collects all in order.

---

## Why naive parallel fold is wrong

Fold requires a sequential accumulator — each step depends on the previous result. A
naive parallel fold forks the accumulator:

```
par_fold on [1,2,3,4]:
  Left half:  fold [] 1 2 → result1
  Right half: fold [] 3 4 → result2
  combine(result1, result2) = ?
```

This only works correctly if the fold operation is *associative* and the initial value is
the *identity element*. For addition: `combine(1+2, 3+4) = 3 + 7 = 10 = fold([1..4])`.
For subtraction: `combine(1-2, 3-4) = -1 + (-1) = -2 ≠ fold([1..4]) = -8`.

Mercury's type system does not enforce associativity. The compiler will not warn you.
The bug appears only at runtime.

---

## Map-then-fold: the correct pattern

Parallelize only the *independent* part (the map), then fold sequentially:

```mercury
par_map_fold(F, G, List, Acc0, Acc, !IO) :-
    par_map(F, List, Mapped, !IO),     % parallel: F applied independently
    list.foldl(G, Mapped, Acc0, Acc). % sequential: G requires ordered accumulation
```

The map step is fully parallel. The fold step is sequential — but if `F` is the
expensive computation, most of the work is already done.

---

## What you will build

### `par_map(pred(T, U), list(T), list(U), !IO)` — `cc_multi`

Parallel map: spawn one thread per element, collect in order. Uses `thread.channel`.

### `par_map_fold(pred(T, U), pred(U, A, A), list(T), A, A, !IO)` — `cc_multi`

Map in parallel, fold sequentially. Verify on "square each element, then sum":
`par_map_fold(square, (+), [1,2,3,4,5], 0, Sum)` → `Sum = 55`.

### `broken_par_fold_demo(list(int), int, !IO)` — `det`

Document the wrong approach. Show that parallel-forking the accumulator gives a
wrong answer for subtraction even if it gives the right answer for addition.

---

## Checkpoint

- `par_map(double, [1,2,3,4,5])` returns `[2,4,6,8,10]` (in order)
- `par_map_fold(square, (+), [1..5], 0, SumSq)` gives `SumSq = 55`
- You can state: why does naive parallel fold require associativity?
- You can state: what is the correct pattern for parallelizing a map-reduce?
