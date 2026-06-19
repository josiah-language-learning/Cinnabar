# Koan: comma in `where [...]` is an item separator, not goal conjunction

**Broken concept:** writing a multi-goal method body inside an instance declaration,
with the goals separated by a bare comma at the top level of the `where [...]` list

## Prerequisites

- `katas/type-system/` — typeclasses and instances

---

```
mmc instance_body_koan.m
```

Error: "In instance declaration for `drawable/1': the type class has no predicate
method named `write_string'/3."

---

## What to observe

Inside `where [...]`, commas separate *instance items* (method declarations or
clauses), not goals within a clause body. Writing:

```mercury
:- instance drawable(shape) where [
    draw(S, !IO) :- describe(S, Str),
    io.write_string(Str ++ "\n", !IO)
].
```

Mercury reads this as **two items**:

1. `draw(S, !IO) :- describe(S, Str)` — clause for `draw`, body is `describe(S, Str)`
2. `io.write_string(Str ++ "\n", !IO)` — a second item, not a method of `drawable`

The body of `draw` ends at the comma. `io.write_string` is parsed as the next item.

---

## Your task

Delegate the multi-goal body to a module-level predicate. Instance method bodies
in `where [...]` work cleanest when each clause body is a single call:

```mercury
:- instance drawable(shape) where [
    draw(S, !IO) :- draw_shape(S, !IO)
].
```
