# Solution: use `func(int) = int` instead of `pred(int, int)`

The cleanest fix: use a `func` type instead of a `pred` type. `func(int) = int` has an
implied inst of `func(in) = out is det` — it is callable without further annotation.

```mercury
:- type transform_table == map(string, func(int) = int).

:- func double(int) = int.
double(X) = X * 2.

:- func negate(int) = int.
negate(X) = -X.

:- func build_table = transform_table.
build_table = map.from_assoc_list([
    "double" - double,
    "negate" - negate
]).

main(!IO) :-
    Table = build_table,
    ( map.search(Table, "double", Transform) ->
        Result = Transform(5),   % OK: func type is callable
        io.format("Result: %d\n", [i(Result)], !IO)
    ;
        io.write_string("Not found\n", !IO)
    ).
```

## Why `func` works and `pred` does not

`func(int) = int` is a fully-determined callable type: the compiler knows the argument
mode (`in`) and the result mode (`out`) from the type alone. `pred(int, int)` is
ambiguous — either argument could be `in` or `out`, and the determinism is not specified.
The inst annotation `pred(in, out) is det` is required to make it callable.

`func` types carry their calling convention in the type; `pred` types require an explicit
inst annotation on the call site.
