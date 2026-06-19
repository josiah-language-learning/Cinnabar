# Solution: add `<= show(T)` to the predicate signature

## The error

```
constraint_koan.m: unsatisfiable typeclass constraint: `constraint_koan.show(T)'.
```

Same message as koan 05, different cause. There the instance for a concrete type was
absent. Here the instance for `int` exists — but `print_value` is polymorphic in `T`,
and Mercury cannot prove `show(T)` holds for an arbitrary, unconstrained `T`.

## The fix

```mercury
:- pred print_value(T::in, io::di, io::uo) is det <= show(T).
```

The `<= show(T)` clause declares that `print_value` *requires* its callers to supply
`T` with a `show` instance. Mercury then propagates this requirement outward: every
call site must satisfy `show(T)` or pass the constraint along in its own signature.

In `main`, the call is `print_value(42, !IO)`. Mercury unifies `T = int`, finds
`instance show(int)`, and the constraint is satisfied.

## The distinction from koan 05

| Koan | Problem | Fix |
|---|---|---|
| 05 | concrete type `color` has no instance | add `instance show(color)` |
| 06 | type variable `T` has no declared constraint | add `<= show(T)` to pred signature |

Mercury's error message is identical in both cases. The difference is whether you need
to write an instance (for a concrete type you own) or propagate a constraint
(for a type variable your callers control).
