# Koan: `thread.spawn` requires a `cc_multi` callback

**Broken concept:** declaring the callback predicate passed to `thread.spawn` as `det`

## Prerequisites

- `katas/concurrency/02-threads` — `thread.spawn`, callback predicate

---

```
mmc spawn_det_koan.m
```

The error names the expected and actual higher-order insts:

```
mode error: variable `V_6' has instantiatedness
  `/* unique */ (pred(di, uo) is det)',
  expected instantiatedness was
  `(pred(di, uo) is cc_multi)'.
```

---

## What to observe

`thread.spawn` has mode `(pred(di, uo) is cc_multi, di, uo) is cc_multi`. The
callback must have inst `pred(di, uo) is cc_multi` — not `det`, not `multi`.

`cc_multi` means "committed choice, multiple solutions" — the spawned predicate
runs in a context where Mercury's parallel engine can choose one solution path
non-deterministically. This is the runtime contract for spawned threads: Mercury
does not guarantee which solution of a `cc_multi` goal executes, only that
exactly one will.

A `det` callback would promise exactly one outcome with no possibility of
backtracking or committed choice — a stricter contract than the thread runtime
provides. The inst mismatch is a design constraint, not just a technicality.

Note: Mercury may warn that the fixed `cc_multi` declaration "could be tighter"
for a trivially `det` body. This is correct — but the declaration must be
`cc_multi` to satisfy `thread.spawn`'s mode.

---

## Your task

Change `worker`'s determinism declaration from `is det` to `is cc_multi`.
