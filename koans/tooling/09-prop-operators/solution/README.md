# Solution

Two fixes:

**1.** Replace `int.between` with `int.nondet_int_in_range`:

```mercury
gen_small_int(N) :-
    int.nondet_int_in_range(0, 10, N).
```

**2.** Replace the equality of function calls with the predicate form sharing
a variable:

```mercury
prop_length_eq(Xs) :-
    list.length(Xs, Len),
    list.length(list.reverse(Xs), Len).
```

`list.length(List, Len)` (predicate form) has an unambiguous type: `Len` is `int`.
`list.length(List)` in an expression context is ambiguous because Mercury sees both
the function returning `int` and a partial application of the predicate as candidates.
Naming the variable explicitly resolves the ambiguity.
