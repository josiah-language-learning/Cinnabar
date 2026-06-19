# Koan: `cc_multi` propagates to any predicate that calls `thread.spawn`

**Broken concept:** calling `thread.spawn` from a predicate declared `det`

## Prerequisites

- `katas/concurrency/02-threads` — `thread.spawn`, determinism
- `koans/concurrency/03-spawn-det` — spawn callback requires `cc_multi`

---

```
mmc spawn_propagate_koan.m
```

Two errors fire:

```
error: determinism declaration not satisfied.
  Declared `det', inferred `multi'.
  Call to `thread.spawn'(...) can succeed more than once.

Error: call to predicate `thread.spawn'/3 with determinism `cc_multi'
  occurs in a context which requires all solutions.
```

---

## What to observe

`thread.spawn` is itself `cc_multi`. Any predicate that calls it acquires the
`cc_multi` property — the committed-choice, might-succeed-more-than-once
semantics propagate upward through the call chain.

Mercury reports `multi` (not `cc_multi`) for `launch_workers` because it
analyzes the goal without the committed-choice assumption. The second error
explains the real constraint: `cc_multi` cannot appear in a "requires all
solutions" context (i.e., the body of a `det` predicate).

This is the same pattern as `cc_multi` from `thread.spawn` propagating to
`main` — any predicate in the call chain that spawns a thread must be `cc_multi`.

---

## Your task

Change `launch_workers`'s declaration from `is det` to `is cc_multi`.
`main` is already correctly declared `cc_multi`.
