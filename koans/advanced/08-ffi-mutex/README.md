# Koan: omitting `will_not_call_mercury` — per-call engine mutex

**Broken concept:** writing a `foreign_proc` without `will_not_call_mercury`,
causing the Mercury runtime to acquire the engine mutex on every FFI call

## Prerequisites

- `katas/advanced/01-ffi-depth` — Mercury FFI anatomy
- `koans/advanced/03-impure-foreign-proc` — `promise_pure` requirement
- `katas/advanced/07-ffi-pragma-attrs` — full pragma attribute kata

---

**Text only — no broken `.m` file.** This koan is about a runtime performance
contract, not a compile-time error. The code compiles; the problem appears under
load or profiling.

---

## The scenario

You write a simple absolute-value FFI wrapper:

```mercury
:- pragma foreign_proc("C",
    c_abs(N::in, Abs::out),
    [promise_pure, thread_safe],
    "Abs = (N < 0) ? -N : N;").
```

The code compiles and runs correctly. But when called in a hot loop, it runs much
slower than expected. In multi-threaded programs, threads unexpectedly contend on
an invisible lock.

---

## What went wrong

Without `will_not_call_mercury`, Mercury assumes the C code might call back into
Mercury (via a callback or function pointer). To make that safe, it acquires the
**Mercury engine mutex** on every call. For C functions that never call back into
Mercury, this overhead is pure waste and adds thread contention.

---

## The fix

Add `will_not_call_mercury` to the pragma attribute list:

```mercury
:- pragma foreign_proc("C",
    c_abs(N::in, Abs::out),
    [will_not_call_mercury, promise_pure, thread_safe],
    "Abs = (N < 0) ? -N : N;").
```

`will_not_call_mercury` disables the reentrancy guard. The three attributes
typically go together for simple C utility functions.

---

## Pragma attribute reference — what each omission costs

| Attribute | Omit it, and... |
|---|---|
| `will_not_call_mercury` | Engine mutex acquired on every call (performance/contention) |
| `promise_pure` | Foreign proc treated as impure — compile error at declaration site |
| `thread_safe` | Separate per-thread lock acquired (performance) |

For most C utility functions (no callbacks, no global state, pure computation),
all three apply: `will_not_call_mercury, promise_pure, thread_safe`.

`will_not_call_mercury` is not just a performance hint — it is a reentrancy
contract. Only omit it when the C code genuinely might call back into Mercury
(e.g., via a stored Mercury closure).

---

## What this teaches

FFI overhead in Mercury is invisible until profiling. The three standard attributes
eliminate the three main sources of overhead for simple C wrappers. Profile FFI
calls in hot paths — the per-call mutex cost accumulates quickly.
