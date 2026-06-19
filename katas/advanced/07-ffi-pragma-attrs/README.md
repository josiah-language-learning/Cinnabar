# Kata: FFI pragma attributes

## Concept

Mercury `foreign_proc` declarations carry an attribute list that controls how the
runtime handles the foreign call. Three attributes apply to nearly all pure C
utility functions:

**`will_not_call_mercury`** — the C code never calls back into Mercury. The runtime
skips the reentrancy lock. Without it: per-call engine mutex acquisition.

**`promise_pure`** — declare the proc as pure, allowing it in pure Mercury contexts.
Without it: compile error ("foreign proc must be declared pure or impure").

**`thread_safe`** — the C code does not rely on Mercury's engine global state.
Without it: per-call thread lock acquisition.

The canonical combination for simple C utility functions:
```mercury
[will_not_call_mercury, promise_pure, thread_safe]
```

## Prerequisites

- `katas/advanced/01-ffi-depth` — Mercury FFI anatomy, basic foreign_proc
- `koans/advanced/03-impure-foreign-proc` — `promise_pure` requirement
- `koans/advanced/08-ffi-mutex` — `will_not_call_mercury` performance cost

## Exercises

**Task 1:** Add the three standard pragma attributes to `c_abs`. Without
`promise_pure`, the compiler rejects it at the declaration site.

**Task 2:** Complete `c_clamp` — add the attributes AND fill in the C body
(`N < Lo ? Lo : N > Hi ? Hi : N`).

**Task 3 (reading):** `c_with_mercury_callback` would invoke a Mercury predicate
from C via a function pointer. Write a comment explaining why `will_not_call_mercury`
must NOT be used in that case, even if the C wrapper code itself is trivial.

## Run the tests

```
./runtests
```

Expected output:
```
PASS: abs(-7) = 7
PASS: abs(3) = 3
PASS: clamp(15,0,10) = 10
PASS: clamp(-1,0,10) = 0
PASS: clamp(5,0,10) = 5
```
