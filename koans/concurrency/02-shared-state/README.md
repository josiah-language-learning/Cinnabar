# Koan: parallel conjunction and unique state

## Prerequisites
- `katas/concurrency/01-parallel-conjunction`
- `koans/mode-system/04-uniqueness-violation`

The `&` operator runs goals in parallel. Each branch receives the same input state — but `!IO` is **unique**: it can only be consumed once, by one branch.

Compile this:

```
mmc --make shared_state_koan
```

The compiler rejects both branches consuming the same IO token.

---

`&` is safe for **pure** goals that share no unique variables. The solution is to separate computation from IO: run pure computations in parallel with `&`, then do IO sequentially once both results are ready.

```mercury
( A = compute_a() & B = compute_b() ),
io.format("A=%d B=%d\n", [i(A), i(B)], !IO).
```

Here the two computations share no state. IO happens after both complete.

---

## What to observe

The error names the unique variable being consumed by multiple branches. Mercury catches
this statically — the uniqueness checker is part of the mode system, not a runtime check.
Notice the error fires even if the branches would never actually run concurrently.

---

## Your task

Separate the pure computation from the IO in the broken code. Run the pure parts in
parallel with `&`, then sequence the IO afterward. If the original code has no pure part
to extract, restructure it so the parallel conjunction only touches non-unique values.
