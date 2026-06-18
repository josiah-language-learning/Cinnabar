# Solution: bind `Threshold` before the if-then-else

The fix is to bind `Threshold` unconditionally *before* it is used in the condition:

```mercury
:- pred classify(int::in, string::out) is det.
classify(N, Category) :-
    Threshold = 100,      % bound here — before the if-then-else
    ( N > Threshold ->
        Category = "high"
    ;
        Category = "low"
    ).
```

## Why mode inference cannot help here

Mode inference reorders *goals* (complete goal structures), but an if-then-else is a
single goal. The compiler cannot move code from inside a branch to before the condition —
that would change the program's semantics.

The reordering `Threshold = 100, (N > Threshold -> ...)` is a different computation than
`(N > Threshold -> Threshold = 100, ... ; Threshold = 100, ...)`.

## The general principle

Variables used in if-then-else conditions must be bound *before* the if-then-else.
Variables used in a branch body can be bound later by goals within that branch — but
the condition itself is a "wall" that mode inference cannot look past.
