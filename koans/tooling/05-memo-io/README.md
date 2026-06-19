# Koan: `pragma memo` on a predicate with IO

**Broken concept:** applying `pragma memo` to a predicate that threads
`io::di, io::uo` — tabling requires ground, comparable inputs; unique IO
state is neither

## Prerequisites

- `katas/tooling/04-tabling` — `pragma memo`, `pragma loop_check`, tabling semantics
- `katas/mode-system/04-uniqueness-violation` — uniqueness and `di`/`uo` modes

---

Mercury's tabling infrastructure memoizes a predicate by storing its ground
inputs in a table and returning the cached output on repeated calls.
This requires that all inputs are ground and can be compared for equality.

The IO state (`io::di`) is a *unique* token, not a ground value. It tracks
the history of all IO operations; no two IO states are meaningfully equal.
Tabling a predicate that threads IO would require comparing two unique values —
which is impossible — and would replay IO side effects from the cache rather than
executing them again, which is wrong.

---

## Try it

```
mmc --make memo_io_koan
```

The compiler reports that `pragma memo` is not allowed for a procedure with
unique modes.

---

## What to observe

The error fires at the `pragma memo` declaration itself, before any call site.
The compiler does not need to see a call to `greet` — it rejects the pragma
at declaration time because the mode `io::di` is unique, and unique-mode
arguments are incompatible with tabling.

---

## Your task

Remove `pragma memo` from `greet`. If you want loop-termination detection on a
pure recursive predicate (no IO), `pragma loop_check` is the right tool — but
it also requires non-unique modes.
