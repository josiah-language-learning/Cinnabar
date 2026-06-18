# 10 — Record field access and update

**Concept:** `^` field access, `:=` functional update, chained updates, the copy-on-modify
mental model

**Not in the Mercury tutorial.**

---

## Field access with `^`

Given a record type with named fields:
```mercury
:- type person ---> person(name :: string, age :: int, score :: float).
```

Access a field with `^`:
```mercury
Name = Person^name,
NewAge = Person^age + 1
```

This is pure value access — `^` returns the field's value, it does not modify the record.

---

## Functional update with `:=`

Create a new record with one field changed:
```mercury
Older = Person^age := Person^age + 1
```

The `:=` operator returns a *new* value — the original `Person` is unchanged. Mercury
records are not objects; there is no mutation.

### Chained updates

Multiple field updates can be chained:
```mercury
Reset = (((P^score := 0.0)^name := "anonymous")^age := 0)
```

Or assigned step by step:
```mercury
P1 = P^score := 0.0,
P2 = P1^name := "anonymous",
P3 = P2^age := 0
```

The `P0`, `P`, `P2` naming convention marks the stages explicitly — this mirrors the `!IO`
state-threading idiom for mutable state.

---

## What you will build

### `birthday(person) = person`

Return a copy of `P` with `age` incremented by 1.
```mercury
birthday(P) = P^age := P^age + 1.
```

### `rename(string, person) = person`

Return a copy with `name` replaced.

### `reset_stats(person) = person`

Return a copy with both `age` reset to 0 and `score` reset to 0.0. Implement using
chained `:=` updates in a single expression.

### `add_score(float, person, person)`

A predicate (not function) that adds a delta to `score`. Use the `di`/`uo` naming
convention:
```mercury
add_score(Delta, P0, P) :-
    P = P0^score := P0^score + Delta.
```

---

## The gotcha: `:=` in functions vs predicates

The syntax is identical in both contexts. The difference is in how you name things.
In a function, the result is the return value. In a predicate, you bind an output variable.
Mercury does not have in-place mutation — every `:=` produces a fresh value.

---

## Checkpoint

- `birthday` and `rename` compile and produce correct values
- `reset_stats` uses a chained `:=` expression in a single line
- You can explain why `P0` and `P` naming is used for intermediate record values
- You can state: is the original record modified by `:=`?
