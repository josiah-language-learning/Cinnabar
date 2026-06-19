# Solution: add the missing superclass instance

## The error

```
superclass_koan.m: In instance declaration for `describable/1':
    the following superclass constraint is not satisfied:
    `superclass_koan.printable(superclass_koan.shape)'.
```

`describable` declares `<= (printable(T))`. When you write
`instance describable(shape)`, Mercury requires that `instance printable(shape)` already
exists. It doesn't — so the instance declaration is rejected.

## The fix

Add `instance printable(shape)` before the `describable` instance:

```mercury
:- instance printable(shape) where [
    do_print(S, !IO) :- print_shape(S, !IO)
].
```

The `do_print` body delegates to a module-level predicate `print_shape` rather than
inlining the IO goals. This is necessary because the comma inside `where [...]` is
an **item separator**, not a goal conjunction. Writing:

```mercury
    do_print(S, !IO) :- describe(S, Str), io.write_string(Str ++ "\n", !IO)
```

would cause Mercury to parse `io.write_string(...)` as a second method clause and
report "the type class has no predicate method named `write_string'/3`".

The fix is always to delegate multi-goal method bodies to a named predicate:

```mercury
:- pred print_shape(shape::in, io::di, io::uo) is det.
print_shape(S, !IO) :-
    describe(S, Str),
    io.write_string(Str ++ "\n", !IO).
```

## Ordering matters

The superclass instance must be declared **before** the subclass instance, because
Mercury checks the constraint at the declaration site. Ordering `printable` before
`describable` in the source file satisfies this requirement.
