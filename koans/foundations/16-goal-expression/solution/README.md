# Solution

Separate the equality test (a goal) from the constructor application:

```mercury
tag_equal(A, B) = Result :-
    ( A = B -> Result = flagged(yes) ; Result = flagged(no) ).
```

`A = B` is unification — it succeeds if A and B can be made equal, fails otherwise.
It does not produce a value. The if-then-else captures the success/failure and maps
it to a `bool` value (`yes` or `no`) to pass to `flagged`.

Mercury's design: goals succeed or fail; functions return values. To turn a goal
outcome into a value, use an if-then-else that binds a result variable.
