# Koan: `cc_multi` from `thread.spawn` in a `det` predicate

**Broken concept:** calling `thread.spawn` from a predicate declared `det`, without
suppressing `cc_multi` propagation

## Prerequisites

- `koans/concurrency/03-spawn-det` — spawn callback must be `cc_multi`
- `koans/concurrency/05-spawn-propagate` — `cc_multi` propagates upward

---

```
mmc --grade asm_fast.par.gc.stseg promise_equiv_koan.m
```

Error: "declared `det', inferred `multi'."

(Mercury infers `multi` rather than `cc_multi` because from a `det` context,
any `cc_multi` call "can succeed more than once" — the committed-choice aspect
is invisible at the call site.)

---

## What to observe

`thread.spawn` is `cc_multi`. Any predicate that calls it is inferred `cc_multi`
and this propagates up the call chain. `koans/concurrency/05-spawn-propagate`
covers the case where you let it propagate. This koan covers the alternative: keep
the calling predicate `det` using `promise_equivalent_solutions [!:IO]`.

```mercury
promise_equivalent_solutions [!:IO]
    thread.spawn(worker(Id), !IO)
```

This asserts that all solutions of `thread.spawn(worker(Id), !IO)` produce
observationally equivalent IO states — the spawned thread runs independently, so
the current thread's IO state after the spawn is the same regardless of which
`cc_multi` resolution is chosen.

---

## Your task

Wrap the `thread.spawn` call in `promise_equivalent_solutions [!:IO]` so `launch`
stays `det` as declared.
