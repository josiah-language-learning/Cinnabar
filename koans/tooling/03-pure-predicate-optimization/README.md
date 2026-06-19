# Koan: pure-predicate delay vanishes in `asm_fast`

## Prerequisites

- `katas/tooling/01-grades` — grade anatomy, what `asm_fast` optimizes
- `bridge/10-parallel-pipeline` — backpressure demo context

---

**Text only — no broken `.m` file.** This koan is about optimizer behavior, not
a syntax error.

---

## The scenario

You want to simulate a slow consumer to test backpressure in a bounded channel.
You write a pure spinning predicate:

```mercury
:- pred busy_wait(int::in) is det.
busy_wait(0).
busy_wait(N) :- N > 0, busy_wait(N - 1).
```

You call `busy_wait(1000000)` inside your transformer before processing each item.
When you run the program, the consumer appears instantaneous — items fly through
with no delay. Backpressure never kicks in.

---

## What went wrong

`busy_wait` is a pure predicate: no IO, no state, no output. From Mercury's
perspective, calling it produces nothing observable. In `asm_fast` grade, the
optimizer is free to eliminate any call whose result isn't used and which has no
side effects. The entire loop is dead code and is removed at compile time.

This is not a bug — it is correct behavior. A pure predicate that always succeeds
and returns nothing *is* a no-op. Mercury is right to remove it.

---

## The fix

Thread `!IO` through the predicate to give it a real effect on each iteration:

```mercury
:- pred busy_wait(int::in, io::di, io::uo) is det.
busy_wait(0, !IO).
busy_wait(N, !IO) :-
    N > 0,
    io.write_string(".", !IO),
    io.flush_output(!IO),
    busy_wait(N - 1, !IO).
```

Now each call performs observable IO. The optimizer cannot remove it, and the
delay is real. Alternatively, use `time.sleep` for a cleaner delay without
console output.

---

## What this teaches

Mercury's purity guarantee cuts both ways. Purity means the optimizer can
freely reorder, inline, or discard pure calls — including loops that spin for
"delay." Any predicate meant to have a timing effect must thread `!IO` or use
a module that does. If your benchmark or stress test relies on a pure delay and
produces surprising results, check whether the delay survived compilation.
