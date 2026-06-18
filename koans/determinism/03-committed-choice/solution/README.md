# Solution: use `det` with `maybe` return

The fix: change `find_first` to `det` with a `maybe(int)` return type. Inside a `det`
predicate, `cc_nondet` is allowed.

```mercury
:- pred find_first(maybe(int)::out) is det.
find_first(Result) :-
    ( generate_option(N), N > 0 ->
        Result = yes(N)
    ;
        Result = no
    ).

main(!IO) :-
    find_first(MaybeN),
    (
        MaybeN = yes(N),
        io.format("Found: %d\n", [i(N)], !IO)
    ;
        MaybeN = no,
        io.write_string("Not found\n", !IO)
    ).
```

The if-then-else `( generate_option(N), N > 0 -> ... )` creates a committed-choice
context. The condition is `cc_nondet` — it commits to the first `N > 0` that
`generate_option` produces, or fails if none.

## Why not `semidet`?

The committed-choice paradigm and `semidet` have incompatible failure semantics. A
`semidet` predicate's failure means "no result was found." A `cc_nondet`'s committed
first-solution means "one specific result was chosen." Mercury requires you to resolve
this by choosing one: either use `det`+`maybe` (contain the cc choice), or restructure
the logic to avoid the mismatch.
