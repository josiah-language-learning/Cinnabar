# Koan: `!:N` is the output (write side) — it starts unbound

**Broken concept:** using `!:N` on the right-hand side of an assignment before
it has been given a value

## Prerequisites

- `katas/foundations/` — state variable threading, `!X` notation

---

```
mmc state_koan.m
```

Two signals appear:
1. Warning: `STATE_VARIABLE_N_0` occurs only once (the old value of N is never read)
2. Mode error: `STATE_VARIABLE_N` has instantiatedness `free`, expected `ground`

`STATE_VARIABLE_N_0` is Mercury's internal name for `!.N` (the input value).
`STATE_VARIABLE_N` is the internal name for `!:N` (the output value).

---

## What to observe

`!X` in a clause head expands to two variables:

- `!.X` — the *current* (input) value; starts ground
- `!:X` — the *next* (output) value; starts free, must be bound before the clause exits

`!:N = !:N * 2` tries to compute `!:N * 2` before `!:N` is bound. Mercury's
mode system rejects this because `*` requires both operands to be ground.

The warning about `STATE_VARIABLE_N_0` (i.e. `!.N`) is the companion signal: if
you never read `!.N`, you are probably trying to read `!:N` instead, which is
not yet available.

---

## Your task

Replace `!:N` on the right-hand side with `!.N`. The old value is what you want
to double; the result goes into `!:N`.
