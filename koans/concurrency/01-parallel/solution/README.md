# Solution: make both conjuncts `det`

`&` requires both sides to be `det` or `cc_multi`. Fix by making `find_something` return
`maybe(int)` with `det` determinism, then handle the `maybe` after the parallel join:

```mercury
:- func find_something = maybe(int).
find_something = yes(42).

main(!IO) :-
    S = range_sum(1, 100000)
    &
    MaybeX = find_something,
    (
        MaybeX = yes(X),
        io.format("Sum: %d, Found: %d\n", [i(S), i(X)], !IO)
    ;
        MaybeX = no,
        io.format("Sum: %d, Not found\n", [i(S)], !IO)
    ).
```

## Why `&` requires `det`

If one branch of `A & B` fails, the other branch is already running concurrently. There
is no safe way to "cancel" a running Mercury thread. Mercury avoids this problem by
requiring both branches to be `det` (never fail) or `cc_multi` (commit to one result).

For operations that can fail, do the failure handling *outside* the parallel conjunction:
compute in parallel, then handle the results sequentially.
