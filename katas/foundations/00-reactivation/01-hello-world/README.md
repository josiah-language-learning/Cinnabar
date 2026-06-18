# 01 — Hello World

**Concept:** bare module skeleton, `io.di`/`io.uo` mode annotations, `!IO` state threading

**Before you open `hello.m`:** write down what you remember about why `main` takes two `io` arguments rather than one, and what `di` and `uo` mean. If you can't recall, make your best guess — that is the point.

---

## What to look for

Mercury's I/O is modeled as a unique state that gets passed through the program. The `di` ("destructive input") annotation means the incoming value is consumed — the caller cannot use it again after passing it. The `uo` ("unique output") annotation means the returned value is fresh and uniquely owned by the caller.

`!IO` is syntactic sugar. `main(!IO)` expands to `main(IO0, IO)` where `IO0::di` is consumed and `IO::uo` is produced. Every I/O call in the chain threads this pair through, one step at a time.

The consequence: there is always exactly one live reference to the I/O state. Mercury can implement I/O as a real destructive update under the hood while the source code remains referentially transparent. The type system enforces this — you cannot accidentally branch I/O or ignore a state update.

## After reading

Could you say, in one sentence each:
- Why does Mercury use `di`/`uo` instead of just passing `io` by value?
- What would go wrong if you tried to use `IO0` after passing it to a predicate?

---

> **Tutorial cross-reference:** This exercise drills the same concepts as Mercury Tutorial §1 (module
> skeleton, `main/2`, `io.write_string`). This program is different. If the `di`/`uo` explanation
> above doesn't click, re-read §1 first, then come back.
