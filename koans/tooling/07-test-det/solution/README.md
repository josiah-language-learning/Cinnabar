# Solution: wrap unification in if-then-else with `error/1`

## The error

```
test_det_koan.m: In `test_sum':
    error: determinism declaration not satisfied.
    Declared `det', inferred `semidet'.
    The reason for the difference is the following.
    Unification of `Got' and `6' can fail.
```

`Got = 6` is a semidet goal — it fails when `Got \= 6`. A `det` predicate
cannot contain a goal that can fail without handling the failure. The compiler
catches this at the declaration site.

## The fix

```mercury
:- import_module require.

test_sum :-
    sum_list([1, 2, 3], Got),
    ( Got = 6 ->
        true
    ;
        error("test_sum failed: expected 6, got " ++ string.int_to_string(Got))
    ).
```

The if-then-else makes both branches `det`:
- Then: `true` — succeeds once, deterministically
- Else: `error(...)` — throws an exception, never returns; Mercury treats
  exception-throwing as `det` (it does produce exactly one outcome: an exception)

## Why `det`, not `semidet`, for tests

A `semidet` test predicate that fails is *invisible*:
```mercury
main(!IO) :-
    ( test_sum ->        % test fails — goes to else
        io.write_string("passed\n", !IO)
    ;
        io.write_string("failed\n", !IO)
    ).
```
This is correct code but a poor convention — the test is now mixed with control
flow at the call site. `det` tests using `error/1` make the failure unconditional
and explicit: the program terminates with an error message pointing to the
test predicate, not the caller.
