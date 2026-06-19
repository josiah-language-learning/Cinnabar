# Solution: remove `pragma memo` from IO predicate

## The error

```
memo_io_koan.m: Error: `:- pragma memo' declaration not allowed for
    procedure with unique modes.
```

Mercury's tabling system requires inputs to be ground values that can be
key-compared. The IO state (`io::di`) is unique — it encodes a temporal
sequence of effects, not a data value. Two IO states cannot be compared, so
tabling an IO-threading predicate is rejected at declaration time.

## The fix

Remove `pragma memo`:

```mercury
:- pred greet(string::in, io::di, io::uo) is det.
greet(Name, !IO) :-
    io.write_string("Hello, " ++ Name ++ "!\n", !IO).
```

## When memo does and doesn't apply

| Predicate kind | `pragma memo`? |
|---|---|
| Pure, ground inputs and outputs | ✅ works |
| Semidet, ground inputs | ✅ works |
| Multi/nondet, ground inputs | ✅ works (all-solutions tabling) |
| Any IO (`di`/`uo`) argument | ❌ rejected — unique modes |
| Any unique argument | ❌ rejected — unique modes |

If you want to avoid re-evaluating an expensive pure computation, `pragma memo`
is the right tool. If the predicate threads IO, you cannot memo it — IO effects
are not idempotent.
