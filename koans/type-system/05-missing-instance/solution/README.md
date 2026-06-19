# Solution: add the missing instance for `color`

## The error

```
instance_koan.m: unsatisfiable typeclass constraint:
    `instance_koan.show(instance_koan.color)'.
```

`print_color` calls `show(C, Str)` where `C :: color`. Mercury looks for an
`instance show(color)` declaration and finds none. This is a compile-time error —
Mercury's typeclass system is closed-world: if no instance is declared, no instance exists.

## The fix

```mercury
:- instance show(color) where [
    show(red,   S) :- S = "red",
    show(green, S) :- S = "green",
    show(blue,  S) :- S = "blue"
].
```

One clause per constructor. Mercury checks that all clauses together cover the declared
modes — here `show(T::in, string::out)` — and that the body determinism is `det`.

## Why this matters

Mercury's typeclass dispatch is entirely static. The compiler emits a specialized call
at every typeclass method use site; if the instance is absent, there is nothing to emit.
This is both the strength (no runtime dispatch overhead, full type safety) and the
constraint (you must explicitly declare every instance you need).

Compare to koan `06-missing-constraint`, where the same error message appears but the
cause is different: there the instance *exists* for some types, but the predicate fails
to declare that it *requires* the constraint on a type variable `T`.
