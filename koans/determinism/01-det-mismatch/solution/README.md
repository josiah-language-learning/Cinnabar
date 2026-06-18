# Solution: add the else branch

```mercury
:- pred abs_val(int::in, int::out) is det.
abs_val(N, Abs) :-
    ( N >= 0 ->
        Abs = N
    ;
        Abs = -N    % FIX: else branch makes it det
    ).
```

## Why the compiler catches this

`( Cond -> Then )` without an else desugars to `( Cond -> Then ; fail )`. The `fail` in
the else branch makes the predicate's determinism `semidet` — it can fail.

The compiler checks the *actual* determinism (inferred from the code) against the
*declared* determinism (`det`). They do not match, so it errors.

## A common variation

Sometimes the else branch "cannot happen" — you know the condition is always true from
context that the compiler cannot see. Options:
1. Add an `else` that throws: `; throw(software_error("abs_val: impossible negative input"))`
2. Change the declaration to `semidet` and let the caller handle failure
3. Use `require_complete_switch` or `require_det` to document the guarantee

Option 1 is idiomatic: make the impossible branch `erroneous` rather than silently failing.
