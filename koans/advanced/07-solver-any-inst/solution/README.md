# Solution: add `in(any)` inst annotation

Change `extract/2` in both the `:- pred` declaration and the
`:- pragma foreign_proc` signature:

```mercury
:- pred extract(token_var::in(any), int::out) is det.

:- pragma foreign_proc("C",
    extract(X::in(any), V::out),
    [will_not_call_mercury, promise_pure, thread_safe],
    "V = X;").
```

The mode checker now sees that `extract` accepts `any`-inst arguments.
`make_var` produces `out(any)`, which satisfies `in(any)`. The program
compiles and prints `42`.

All predicates that operate on solver variables must carry explicit `(any)`
inst annotations — `::in` without an annotation means `::in(ground)`.
