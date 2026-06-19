# Solution

Use if-then-else to handle both the matching and fallback cases:

```mercury
eval(neg(E)) = Result :-
    ( eval(E) = int_val(N) ->
        Result = int_val(-N)
    ;
        Result = error_val
    ).
eval(add(A, B)) = Result :-
    ( eval(A) = int_val(NA), eval(B) = int_val(NB) ->
        Result = int_val(NA + NB)
    ;
        Result = error_val
    ).
```

The pattern `eval(E) = int_val(N)` is a unification that can fail (if `eval(E)`
returns `error_val`). Wrapping it in an if-then-else makes the clause `det`: both
branches produce exactly one result.

Functions in Mercury are implicitly `det`. If any clause body can fail — even
through a single fallible unification — Mercury infers `semidet`, which conflicts
with the function type. The fix is always to make every path produce a result:
either the successful value or a sentinel like `error_val`.
