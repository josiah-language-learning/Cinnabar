# Koan: `cc_nondet` is not `nondet`

**Broken concept:** passing a `cc_nondet` predicate where `nondet` is required — the two
are not interchangeable even though both produce at most one committed result

## Prerequisites

- `katas/determinism/02-committed-choice` — `cc_multi`, `cc_nondet`, committed-choice semantics
- `koans/determinism/03-committed-choice` — `cc_nondet` calling-context rules

---

`cc_nondet` and `nondet` both allow 0 or more solutions at the implementation level,
but they differ in what they promise:

- `nondet` — all solutions are available; callers may backtrack to get more
- `cc_nondet` — committed to the first solution; the rest are discarded

`solutions/2` collects *all* solutions, so it requires a `nondet` predicate. A `cc_nondet`
predicate has already committed away the other solutions — asking it to enumerate them all
is a contradiction. Mercury catches this at compile time as a mode/inst mismatch.

---

## Try it

```
mmc --make --grade asm_fast.par.gc.stseg cc_nondet_koan
```

The error names the inst mismatch: `first_int` has inst `pred(out) is cc_nondet` but
`solutions/2` requires `pred(out) is nondet`:

```
in call to predicate `solutions.solutions'/2:
  mode error: arguments `V_7, All' have the following insts:
    /* unique */ (pred(out) is cc_nondet),
    free
  which does not match any of the modes for predicate `solutions.solutions'/2.
  The first argument `V_7' has inst `/* unique */ (pred(out) is cc_nondet)',
  which does not match any of those modes.
```

---

## What to observe

`first_int` and `any_int` both produce integers, but their insts are different.
`cc_nondet` is not a subtype of `nondet` — it is a separate committed-choice category.
The fix is not to "cast" one to the other; it is to decide which semantics you actually
want and use the right predicate.

---

## Your task

Fix `main` so that it compiles. There are two valid approaches:

1. **Collect all solutions:** use `any_int` directly with `solutions/2`.
2. **Commit to one solution:** call `first_int` from `main` (which is `cc_multi`)
   without using `solutions/2` at all.

The solution shows approach 1, with a note on approach 2.
