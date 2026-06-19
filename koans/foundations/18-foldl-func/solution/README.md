# Solution

Replace the `func` lambda with a `pred` lambda with three arguments:

```mercury
list.foldl(pred(X::in, Acc0::in, Acc::out) is det :- Acc = Acc0 + X,
           List, 0, Sum)
```

`list.foldl` is declared with a `pred(L, A, A)` argument — it threads the
accumulator as a pair of (old, new) values, matching Mercury's state-threading
convention. A `func(L, A) = A` is a fundamentally different type.

You can also use state variable notation (note: `!X` requires explicit mode
annotations in lambda heads — see `koans/foundations/10-foldl-accumulator`):

```mercury
list.foldl(pred(X::in, !.Acc::in, !:Acc::out) is det :- !:Acc = !.Acc + X,
           List, 0, Sum)
```
