# Parallel sort solution notes

## Why `&` is clean here

Mergesort is naturally expressed as "sort left half AND sort right half, then merge."
The `&` operator maps directly onto this — no channels, no spawning, no explicit
thread management. The runtime handles the parallelism.

Compare to a thread-based parallel mergesort in most languages: you need to create threads,
synchronize, and collect results. In Mercury, `&` does all of this.

## The catch: merge is sequential

Even with infinite cores, mergesort's parallel speedup is bounded by the merge step,
which is sequential. The theoretical speedup is O(log^2 N) at best. In practice,
overhead means the crossover point is often in the tens of thousands of elements.

## The threshold idiom

```mercury
:- func threshold = int.
threshold = 1000.

mergesort(List, Sorted) :-
    ( list.length(List) =< threshold ->
        list.sort(List, Sorted)     % sequential stdlib sort
    ;
        ... parallel split ...
    ).
```

`list.sort` from the standard library is a highly optimized sequential sort. Below the
threshold, it beats a hand-rolled parallel split with thread overhead.

## Amdahl's law in practice

If the parallel portion is 50% of the work (the other 50% is merge), the theoretical
maximum speedup is 2× regardless of how many cores you have. Real mergesort parallelism
is more efficient because merges at different levels can overlap, but the principle holds:
parallel code is only as fast as its sequential bottleneck.
