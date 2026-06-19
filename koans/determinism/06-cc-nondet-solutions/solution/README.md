# Solution: use `nondet` with `solutions/2`; use `cc_nondet` directly from `cc_multi`

## The error

```
in call to predicate `solutions.solutions'/2:
  mode error: arguments `V_7, All' have the following insts:
    /* unique */ (pred(out) is cc_nondet),
    free
  which does not match any of the modes for predicate `solutions.solutions'/2.
  The first argument `V_7' has inst `/* unique */ (pred(out) is cc_nondet)',
  which does not match any of those modes.
```

`solutions/2` has the signature:

```mercury
:- pred solutions(pred(T)::in(pred(out) is nondet), list(T)::out) is det.
```

The inst annotation `pred(out) is nondet` is exact — `cc_nondet` does not satisfy it.

## Why `cc_nondet ≠ nondet`

| | `nondet` | `cc_nondet` |
|---|---|---|
| Solutions | All available; caller may backtrack | First only; rest discarded |
| Can `solutions/2` use it? | Yes | No |
| Can `main` call it directly? | No (main is `cc_multi`) | Yes |
| Context restriction | None | Must be called from `det`, `cc_multi`, or `cc_nondet` |

`cc_nondet` is not a restriction of `nondet` — it is a different determinism class with
committed-choice semantics. Mercury enforces this at the inst level.

## The fix

**Approach 1 — collect all solutions:** use the `nondet` predicate directly:

```mercury
main(!IO) :-
    solutions(any_int, All),
    io.write_line(All, !IO).
```

**Approach 2 — commit to one solution:** call `first_int` from `main` without `solutions/2`.
`main` is `cc_multi`, which is a valid calling context for `cc_nondet`:

```mercury
main(!IO) :-
    ( first_int(N) ->
        io.format("First: %d\n", [i(N)], !IO)
    ;
        io.write_string("No solution\n", !IO)
    ).
```

## What `cc_nondet` is for

`cc_nondet` is the right tool when you have a predicate that *logically* could produce
multiple solutions but you only want the first, and you are in a committed-choice context
(`main`, a `cc_multi` pipeline, etc.). It is not a way to "limit" a `nondet` predicate
for use with collection functions — once you commit, the other solutions are gone.
