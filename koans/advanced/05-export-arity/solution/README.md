# Solution: add the missing argument mode to the export pragma

## The error

```
export_arity_koan.m: Error: `:- pragma foreign_export' declaration for
    predicate `scale'/2 without corresponding `:- pred' declaration.
    `scale' does exist with arity 3.
```

Mercury looks up the predicate by name and arity derived from the mode list.
`(in, out)` has two modes → arity 2. No `scale/2` exists. The compiler
correctly identifies that `scale` with arity 3 does exist and hints at the fix.

## The fix

```mercury
:- pragma foreign_export("C", scale(in, in, out), "mercury_scale").
```

All three argument modes must be present. Mercury generates a C function with
the signature:

```c
void mercury_scale(MR_Integer X, MR_Integer Factor, MR_Integer *Y);
```

Each `in` becomes a value parameter; each `out` becomes a pointer parameter.
The arity of the mode list must match the predicate's arity exactly.

## Multiple modes of the same predicate

A multi-mode predicate can be exported multiple times with different mode lists:

```mercury
:- pred eq(T::in, T::in) is semidet.
:- pred eq(T::in, T::out) is det.

:- pragma foreign_export("C", eq(in, in),  "mercury_eq_check").
:- pragma foreign_export("C", eq(in, out), "mercury_eq_copy").
```

Each export specifies which mode to use. The C name disambiguates them.
