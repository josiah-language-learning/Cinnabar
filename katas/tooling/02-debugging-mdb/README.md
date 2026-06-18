# 02 — Debugging with `mdb`: 4-port tracing

**Concept:** `.debug` grade, `mdb` 4-port model (call/exit/fail/redo), declarative
debugging mode, reading trace output

**Requires:** a Mercury installation compiled with the `asm_fast.gc.debug.stseg` grade. If the build step below fails with a grade-not-found error, this kata cannot be completed in your current environment.

---

## What you will build

A deliberately buggy list-processing program. You will find the bug twice:
1. Using 4-port tracing (procedural debugging)
2. Using declarative debugging mode

---

## The buggy program: `buggy_index.m`

```mercury
:- func nth_element(int, list(string)) = string.
nth_element(_, []) = "out of bounds".
nth_element(I, [H|T]) =
    ( I =< 0 ->      % BUG: should be I = 0, not I =< 0
        H
    ;
        nth_element(I - 1, T)
    ).
```

The bug: `I =< 0` accepts any non-positive index, so `nth_element(-1, Items)` returns the
first element instead of `"out of bounds"`. Use mdb to step through and observe `I` at
each recursive call.

---

## Build with debug grade

```bash
mmc --make --grade asm_fast.gc.debug.stseg buggy_index
```

---

## Session 1: 4-port tracing

Run under `mdb`:
```bash
mdb ./buggy_index
```

At the `mdb>` prompt:
```
mdb> break nth_element
mdb> run
```

Each time the debugger stops at a port, you see which port it is (call/exit/fail/redo)
and the current argument values. The four ports:
- **call**: predicate is being entered
- **exit**: predicate succeeded (shows output variable values)
- **fail**: predicate failed
- **redo**: backtracking into a predicate

Use `next` to step to the next port, `print` to inspect variables. Watch `I` on the
`nth_element(-1, ...)` call — it satisfies `I =< 0` immediately and returns `"zero"`
instead of `"out of bounds"`.

---

## Session 2: Declarative debugging

Restart under `mdb` and switch to declarative mode:
```
mdb> dd
```

Mercury's declarative debugger asks you questions about the correctness of individual
predicate calls. You answer `y` (correct) or `n` (incorrect). It performs a binary search
over the call tree to find the first incorrect call.

Answer questions based on what the predicate *should* return vs. what it actually returns.
The debugger will isolate `nth_element` as the first call whose behavior is wrong.

---

## Checkpoint

- The program compiles with debug grade
- You have found the off-by-one bug via 4-port tracing
- You have found it via declarative debugging
- You can explain: what is the difference between procedural and declarative debugging,
  and when is each more useful?
