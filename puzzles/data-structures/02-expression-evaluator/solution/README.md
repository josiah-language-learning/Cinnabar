# Expression evaluator solution notes

## The QBN connection

This evaluator's structure — a chain of `bind_maybe` steps where any `no` propagates —
is exactly the shape of a QBN eligibility check. In a QBN engine:

```
eligibility(storylet, world_state) =
    bind_maybe(check_condition_1(world_state), fun(ok) ->
    bind_maybe(check_condition_2(world_state), fun(ok) ->
    ...
    yes(storylet_is_eligible)))
```

Any failing condition short-circuits to `no` (not eligible). The `eval` function here
is a simplified version of the same pattern.

## No universal Show in Mercury

Mercury has no polymorphic `show`/`toString` equivalent. There is no `string.string/1`
that works on any type. To print a `maybe(int)`, pattern-match explicitly:

```mercury
( Result = yes(N) -> io.format("yes(%d)\n", [i(N)], !IO)
; io.write_string("no\n", !IO) )
```

Use `string.int_to_string/1`, `string.float_to_string/1`, etc. for primitive types.
RTTI (`deconstruct`) can print any value for debugging, but it is not a production Show.

---

## `bind_maybe` as flatMap

`bind_maybe : maybe(T) -> (func(T) = maybe(U)) -> maybe(U)`

- `bind_maybe(no, _)` = `no` — short-circuit
- `bind_maybe(yes(V), F)` = `F(V)` — continue with V

This is the Haskell `Maybe` monad's `>>=` operator. Mercury does not have do-notation,
so the chain is written explicitly, but the structure is identical. Define `bind_maybe`
locally in your module — Mercury 22.01.8 does not export it from the `maybe` module.
