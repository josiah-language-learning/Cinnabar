# Bridge: determinism ratchet

**After:** `katas/determinism/02-committed-choice`

**Why Mercury:** determinism is a type-level constraint, not a convention. The `&`
operator won't compile unless both conjuncts are `det` — the compiler enforces the
boundary between nondeterministic search and deterministic parallel execution.
`solutions/2` is the bridge; committed choice is the gate.

`search.m` is a working program that finds all valid 3-colorings of a path graph
(three nodes, edges 1-2 and 2-3) using a `nondet` generator and `solutions/2`.

Build and run it first:

```
mmc --make --grade asm_fast.par.gc.stseg search
./search
```

You should see 12 colorings. Understand how `valid_coloring` generates them and
why `solutions/2` is needed to call it from a `det` context.

---

## Extension tasks

### 1. First solution only

Write a function that returns the first valid coloring, or `no` if none exists:

```mercury
:- func first_coloring = maybe(coloring).
```

The key: Mercury's `( Cond -> Then ; Else )` commits to the first solution of
`Cond` if it is `nondet` or `multi`. You do not need `solutions/2` here.

After writing it, add a call to `main` that prints the first coloring found.

### 2. Parallel search

Parallelize the search by splitting on the color of node 1.

Write a helper that collects all valid colorings with a fixed node-1 color:

```mercury
:- pred colorings_with_c1(color::in, list(coloring)::out) is det.
```

Then write `all_colorings_parallel` that calls this helper three times — once per
color — using `&` so the three calls run in parallel:

```mercury
:- pred all_colorings_parallel(list(coloring)::out) is det.
```

Why does `&` work here when it would not work on `valid_coloring` directly?
The `&` operator requires both conjuncts to be `det`. `colorings_with_c1` is `det`
because it wraps the `nondet` generator in `solutions/2`. The generator alone is
`nondet`, which `&` cannot run.

Add a call to `main` that prints all colorings via the parallel search and verifies
the count matches the sequential result.

Note: compile with `--grade asm_fast.par.gc.stseg` to enable parallel execution.
See `COMPILER-LESSONS.md` for known `&` backend limitations in Mercury 22.01.8.

### 3. Parameterized early exit

Write a predicate that finds the first coloring satisfying an additional criterion:

```mercury
:- pred first_where(pred(coloring::in) is semidet, maybe(coloring)::out) is det.
```

The criterion is a `semidet` predicate: if it succeeds on a coloring, that
coloring is accepted; if it fails, the search continues.

Test it with two criteria:
- Node 3 must be blue
- Node 1 and node 3 must have the same color

Notice that the if-then-else condition can conjoin `valid_coloring(C)` (nondet)
with `call(Criterion, C)` (semidet) — Mercury commits to the first solution where
both succeed. The committed-choice mechanism works on the conjunction, not just a
single goal.

---

## What you are practising

- The if-then-else condition as Mercury's implicit committed-choice mechanism
- Wrapping a `nondet` predicate in `solutions/2` to produce a `det` result
- Using `&` on `det` predicates to parallelize a search that was inherently `nondet`
- How a `semidet` criterion composes with a `nondet` generator inside committed choice
