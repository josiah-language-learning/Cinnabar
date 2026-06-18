# Solution notes

## Task 1: first solution via committed choice

The if-then-else condition in Mercury commits to the first solution of a `nondet` goal:

```mercury
:- func first_coloring = maybe(coloring).
first_coloring = Result :-
    ( valid_coloring(C) ->
        Result = yes(C)
    ;
        Result = no
    ).
```

No `solutions/2`, no explicit `cc_nondet` declaration. The if-then-else `->` already
does the committing. This is the idiomatic Mercury pattern for "first solution or no."

The overall determinism of `first_coloring` is `det`: the then-branch binds `Result`
to `yes(C)` and the else-branch binds it to `no` — both are `det`, so the function is `det`.

## Task 2: parallel search

```mercury
:- pred colorings_with_c1(color::in, list(coloring)::out) is det.
colorings_with_c1(C1, Colorings) :-
    solutions(
        (pred(C::out) is nondet :-
            valid_coloring(C),
            C = coloring(C1, _, _)),
        Colorings).

:- pred par_search(list(coloring)::out) is det.
par_search(All) :-
    ( colorings_with_c1(red,   Reds)  &
      colorings_with_c1(green, Greens) &
      colorings_with_c1(blue,  Blues) ),
    All = Reds ++ Greens ++ Blues.
```

The lambda inside `solutions` captures `C1` from the outer scope. Each call to
`colorings_with_c1` is `det` (returns a list), which satisfies `&`'s requirement.

**Mercury 22.01.8 note:** If you use `All` (a variable produced by `&`) in an
if-then-else condition in the same clause, you may hit backend bug 1 from
`COMPILER-LESSONS.md`. Avoid this by extracting the `&` call into a named predicate
(`par_search`) and using its output only in sequential code.

The parallel result is equivalent to the sequential result but with colorings
grouped by node-1 color rather than the depth-first ordering of `solutions`. If order
matters, sort both lists before comparing.

## Task 3: parameterized early exit

```mercury
:- pred first_where(pred(coloring::in) is semidet, maybe(coloring)::out) is det.
first_where(Criterion, Result) :-
    ( valid_coloring(C), call(Criterion, C) ->
        Result = yes(C)
    ;
        Result = no
    ).
```

The condition `valid_coloring(C), call(Criterion, C)` is a conjunction. Mercury
commits to the first solution of the entire conjunction — the first `C` for which
both `valid_coloring(C)` succeeds and `call(Criterion, C)` succeeds.

Usage:
```mercury
first_where((pred(C::in) is semidet :- C = coloring(_, _, blue)), R1),
first_where((pred(C::in) is semidet :- C^node1 = C^node3), R2),
```

The second criterion (node 1 = node 3) demonstrates that C1 and C3 can be the same
color — the graph has no edge between them. The first result should be `yes(coloring(red, green, blue))`.
