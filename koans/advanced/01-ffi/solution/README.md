# Solution: add `will_not_call_mercury`

```mercury
:- pragma foreign_proc("C",
    c_abs(N::in, Abs::out),
    [will_not_call_mercury, promise_pure, thread_safe],  % FIX: added attribute
    "
        Abs = (N < 0) ? -N : N;
    ").
```

## What `will_not_call_mercury` does

Without it: Mercury assumes the C code *might* call back into Mercury. To allow safe
re-entry, the runtime acquires a global lock before every foreign call and releases it
after. This prevents Mercury's GC and runtime from being in an inconsistent state if
the C code calls a Mercury predicate.

With `will_not_call_mercury`: Mercury knows the C code will never call back. The lock
is not acquired. For tight loops calling simple C functions, this is measurably faster.

## When it is safe to add

Safe when:
- The C code only does arithmetic, string operations, or system calls
- The C code does not call `MR_call_engine`, `MR_CALL_MERCURY_*` macros, or any Mercury
  runtime function

Unsafe when:
- The C code calls `foreign_export`-ed Mercury predicates
- The C code uses Mercury runtime APIs

## The full attribute set for simple C functions

For a simple, pure, non-blocking C function with no Mercury callbacks:
```mercury
[will_not_call_mercury, promise_pure, thread_safe, tabled_for_io]
```
