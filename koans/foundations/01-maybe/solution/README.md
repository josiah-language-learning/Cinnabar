# Solution: use a func, not a pred

`map_maybe` is defined to accept `func(T) = U` — a Mercury function type, not a predicate.

The fix: change `double_it` from a `pred` to a `func`.

```mercury
% Before (broken):
:- pred double_it(int::in, int::out) is det.
double_it(X, X * 2).

% After (fixed):
:- func double_it(int) = int.
double_it(X) = X * 2.
```

A `func` in Mercury is syntactic sugar for a `pred` with exactly one output argument in
the last position, but the *type* is different: `func(int) = int` vs `pred(int, int)`.
They are not interchangeable at call sites that expect one or the other.

Alternative fix without changing `double_it` — wrap it in an inline func lambda:
```mercury
MaybeDoubled = map_maybe((func(X) = X * 2), MaybeN).
```
