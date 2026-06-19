# Solution

Replace the `!Acc` argument with explicit `Acc0::in, Acc::out` annotations, and
update the body to read from `Acc0` and bind `Acc`:

```mercury
sum_list(Xs, Total) :-
    list.foldl(
        (pred(X::in, Acc0::in, Acc::out) is det :-
            Acc = Acc0 + X),
        Xs, 0, Total).
```

The `!Acc` shorthand is syntactic sugar for two arguments — the old and new
values of a state variable. In a lambda head you must name them separately
because the body needs to refer to both: `Acc0` (the incoming accumulator) and
`Acc` (the outgoing accumulator).

The `N0` / `N` (or `Acc0` / `Acc`) naming convention is Mercury idiom for "the
value before and after this operation." You will see it wherever state is
threaded manually without the `!` shorthand.
