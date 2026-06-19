# Koan: `require_complete_switch` surfaces a missing arm

**Broken concept:** a switch that does not cover all constructors of a type —
`require_complete_switch` makes the incompleteness a local, explicit error
rather than a vague determinism mismatch propagated from the declaration

## Prerequisites

- `katas/tooling/01-grades` — building Mercury programs
- `katas/type-system/01-discriminated-unions` — constructors, exhaustive pattern matching

---

## Try it

```
mmc --make --grade asm_fast.par.gc.stseg complete_switch_koan
```

The error names the missing constructors directly and points at the switch,
not at the `det` declaration.

---

## What to observe

Without `require_complete_switch`, an incomplete switch in a `det` predicate
produces a determinism mismatch: the compiler infers `semidet` (the predicate
can fail for unhandled constructors) and rejects the `det` declaration. The
error points at the declaration, not the switch — you have to deduce which
arm is missing yourself.

With `require_complete_switch [Var] ( Goal )`, the compiler checks completeness
at the switch site and names each missing constructor in the error. The error is
local, precise, and actionable.

Beyond better errors: `require_complete_switch` is a forward-looking guard. When
you add a constructor to the type later, every switch annotated with this pragma
becomes a compile error — the compiler tells you exactly where to add code. A
switch without the pragma silently adds a new failure path.

---

## Your task

Add the missing arms for `east` and `west` to make the switch complete.

Then consider: which switches in your own code should have this pragma? Any
`det` predicate that dispatches on a type with more than a handful of
constructors is a candidate.
