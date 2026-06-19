# Koan: `univ_to_type` used in a `det` context

**Broken concept:** declaring `extract_int` as `det` while calling `univ_to_type`,
which is `semidet` — the type cast can fail at runtime if the dynamic type
doesn't match the requested type

## Prerequisites

- `katas/advanced/03-rtti` — `univ`, `type_to_univ`, `univ_to_type`, RTTI patterns
- `katas/determinism/01-six-categories` — det vs semidet

---

`univ` is Mercury's existential wrapper: it boxes a value of any type together
with its runtime type descriptor. `univ_to_type/2` unboxes the value — but only
if the dynamic type matches the requested static type. If it doesn't match,
the predicate *fails*. This failure is part of the contract, and Mercury's
determinism system enforces it: `univ_to_type` is `semidet`.

Declaring a wrapper as `det` while calling a `semidet` predicate propagates
the can-fail property upward and is rejected.

---

## Try it

```
mmc --make univ_det_koan
```

The compiler reports that `extract_int` is declared `det` but inferred `semidet`,
because `univ.univ_to_type/2` can fail.

---

## What to observe

The error fires in `extract_int`, not in `main`. The `det` declaration on the
wrapper is the source of the conflict — not the call site. Changing the declaration
to `semidet` propagates the can-fail requirement upward, and the caller (`main`)
must then handle failure with an if-then-else.

---

## Your task

Change `extract_int` to `is semidet` and update `main` to handle the failure
case (using an if-then-else with an appropriate else branch).
