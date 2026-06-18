# Koan: `cc_nondet` called from a `semidet` context

**Broken concept:** `cc_nondet` (committed-choice nondet) called from a `semidet` predicate

## Prerequisites

- `katas/determinism/02-committed-choice` — `cc_multi`, `cc_nondet`, committed-choice semantics

---

`cc_nondet` is a restricted form of `nondet` that commits to the first solution. It can
only be called from `cc_multi` or `det` contexts (not from `semidet` or `nondet`). A
`semidet` predicate is not a committed-choice context.

---

## Try it

```
mmc --make --grade asm_fast.par.gc.stseg committed_koan
```

The error: calling a `cc_nondet` predicate from a `semidet` context is not allowed.

---

## What to observe

`find_first` is `semidet` — it either finds something or fails. Committed-choice
predicates need a context that can absorb the "first solution only" commitment. A
`semidet` predicate has different semantics: it can fail for other reasons, and calling
`cc_nondet` inside it mixes the two paradigms in a way Mercury disallows.

---

## Your task

Fix by changing `find_first`'s context to `det` (using a fallback default value),
or wrap the `cc_nondet` call in a way that is compatible with `semidet`. The solution
changes `find_first` to `det` with a `maybe` return type.
