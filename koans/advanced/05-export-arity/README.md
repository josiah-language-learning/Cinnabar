# Koan: `pragma foreign_export` with wrong arity

**Broken concept:** the mode list in `pragma foreign_export` does not match
the declared arity of the predicate — fewer modes are listed than the predicate
has arguments

## Prerequisites

- `katas/advanced/01-ffi-depth` — `foreign_proc`, `foreign_export`, FFI attributes

---

`pragma foreign_export("C", pred(mode1, mode2, ...), "c_name")` generates a
C function that calls the Mercury predicate. The mode list must exactly match
one declared mode of the predicate — both in length and in the mode of each
argument. If the arity in the pragma doesn't match any `:- pred` declaration
for that predicate name, Mercury rejects it.

---

## Try it

```
mmc --make export_arity_koan
```

The compiler reports that `scale/2` has no corresponding `:- pred` declaration,
and helpfully notes that `scale` does exist with arity 3.

---

## What to observe

`scale/3` has three arguments: `X::in`, `Factor::in`, `Y::out`. The broken
`foreign_export` pragma lists only two modes: `(in, out)`. Mercury looks for
a predicate named `scale` with arity 2 and finds none — only `scale/3` exists.

The error message names the wrong arity (2) and the correct arity (3),
making the fix obvious.

---

## Your task

Add the missing mode to the `pragma foreign_export` declaration for `scale`
so that all three arguments are included.
