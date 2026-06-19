# Solution: change `extract_int` to `semidet` and handle failure

## The error

```
univ_det_koan.m: In `extract_int'(in, out):
    error: determinism declaration not satisfied.
    Declared `det', inferred `semidet'.
    The reason for the difference is the following.
    Call to `univ.univ_to_type'(in, out) can fail.
```

`univ_to_type` is `semidet` by design. At runtime, a `univ` holds a type
descriptor alongside the value. If that descriptor doesn't match the requested
output type, the cast fails. There's no Mercury equivalent of C's undefined
behavior on a bad cast — the failure is first-class.

## The fix

```mercury
:- pred extract_int(univ::in, int::out) is semidet.
extract_int(U, N) :-
    univ_to_type(U, N).
```

And handle failure at the call site:

```mercury
main(!IO) :-
    type_to_univ(42, U),
    ( extract_int(U, N) ->
        io.write_int(N, !IO), io.nl(!IO)
    ;
        io.write_string("not an int\n", !IO)
    ).
```

## The RTTI determinism pattern

All RTTI operations that inspect or cast types are at most `semidet`:

| Operation | Determinism |
|---|---|
| `type_to_univ` | `det` — always succeeds (boxes any value) |
| `univ_to_type` | `semidet` — fails on type mismatch |
| `deconstruct/5` | `det` — always succeeds (returns constructor + args) |
| `arg/4` | `semidet` — fails on out-of-range index |

Wrapping a `semidet` RTTI operation in a `det` predicate requires handling the
failure explicitly — either with if-then-else, or with `det_univ_to_type`
(which throws an exception on mismatch rather than failing).
