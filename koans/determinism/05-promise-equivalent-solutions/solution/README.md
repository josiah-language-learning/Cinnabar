# Solution

The declaration says `det` but the compiler infers `semidet` because the inner
goal can fail when the list is empty.

**Fix option 1 — change the declaration:**

```mercury
:- pred list_max(list(int)::in, int::out) is semidet.
list_max(Xs, Max) :-
    promise_equivalent_solutions [Max] (
        list.member(Max, Xs),
        \+ (list.member(Y, Xs), Y > Max)
    ).
```

Honest about the empty-list case. Callers handle `no` / `yes(Max)` via
if-then-else or `maybe`.

**Fix option 2 — ensure at least one solution:**

```mercury
:- pred list_max(list(int)::in, int::out) is det.
list_max([], 0).    % or int.min_int, or an error — your design decision
list_max([H | T], Max) :-
    promise_equivalent_solutions [Max] (
        list.member(Max, [H | T]),
        \+ (list.member(Y, [H | T]), Y > Max)
    ).
```

The non-empty clause body is now `cc_multi` (always has at least one maximum),
so `promise_equivalent_solutions` gives `det`. The empty clause is `det` by
definition. The overall predicate is `det`.

**The rule:**

`promise_equivalent_solutions [Vars] (G)` is equivalent to `det` only when `G`
is `cc_multi`. If `G` is `cc_nondet` (can fail), the result is `semidet`. The
pragma is about *which* solution to commit to, not about *whether* there is one.
