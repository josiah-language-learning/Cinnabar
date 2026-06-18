# N-queens solution notes

## The key insight: one queen per row

By representing the solution as `list(int)` (one column per row), we eliminate all
row conflicts by construction. We only need to check column and diagonal conflicts.
This reduces the search space from N^(N*N) (all placements) to N^N (one per row).

## Why `safe` gets `Dist` as an argument

`Dist` is the *row distance* between the new queen (in the current row) and a
previously-placed queen. At each recursive step, `Dist` increases by 1 as we check
further back through the already-placed queens.

Diagonal conflict: `abs(new_col - placed_col) = row_distance`.

## Counting without storing: `aggregate`

For large N, storing all solutions in a list may be memory-intensive. Use `aggregate/4`
to count without storing:

```mercury
aggregate(queens(N), (pred(_::in, C0::in, C::out) is det :- C = C0 + 1), 0, Count).
```

`aggregate/4` calls the accumulator for each solution but does not build a list.
For N=15, there are 2,279,184 solutions — storing them all at once is wasteful.
