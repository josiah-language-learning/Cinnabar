# Koan: `nondet` called from a `det` context

**Broken concept:** calling a `nondet` predicate from a `det` context without wrapping
it in `solutions/2` or similar

## Prerequisites

- `katas/determinism/01-six-categories` — `det`, `nondet`, `solutions/2` for collecting results

---

A `det` predicate can call `semidet` predicates (using if-then-else to handle failure),
but it cannot call `nondet` or `multi` predicates directly — the multi-solution context
is not available in a `det` predicate's body.

---

## Try it

```
mmc --make --grade asm_fast.par.gc.stseg nondet_koan
```

The error: "determinism error: cannot use nondet goal in det context" (or similar).

---

## What to observe

`find_factor` is `nondet` — it generates factors one by one and can fail if there are
none. Calling it directly inside a `det` predicate asks Mercury to do something impossible:
find exactly one result from a potentially-zero-or-many predicate.

---

## Your task

Fix by wrapping the `nondet` call in `solutions/2` to collect all results into a `list`,
then working with the list in the `det` context.
