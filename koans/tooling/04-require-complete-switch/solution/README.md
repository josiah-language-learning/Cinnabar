# Solution

Add the missing arms for `east` and `west`:

```mercury
direction_name(Direction, Name) :-
    require_complete_switch [Direction]
    ( Direction = north, Name = "north"
    ; Direction = south, Name = "south"
    ; Direction = east,  Name = "east"
    ; Direction = west,  Name = "west"
    ).
```

**Why the pragma matters beyond this fix:**

Once `require_complete_switch` is in place, adding a new constructor to
`direction` — say `northeast` — will immediately produce a compiler error
at this switch. Without the pragma, the predicate silently becomes `semidet`
(or fails at runtime if called with `northeast`), and the only way to discover
the gap is by running the code with the new constructor.

The pragma is a maintenance contract: it says "this switch must handle all
constructors, now and in the future."

**Without the pragma:** the incomplete switch in a `det` predicate produces:

```
error: determinism declaration not satisfied.
Declared `det', inferred `semidet'.
```

The error is correct but distant — it points at the declaration, not the switch,
and gives no hint which constructor is missing. `require_complete_switch` makes
the error local and precise.
