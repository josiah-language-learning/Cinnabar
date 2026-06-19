# Solution

Add `promise_pure` to the `foreign_proc` attribute list:

```mercury
:- pragma foreign_proc("C",
    c_square(N::in, Result::out),
    [will_not_call_mercury, thread_safe, promise_pure],
    "
        Result = N * N;
    ").
```

`c_square` computes a pure function of its input — no global reads, no memory
side effects, no IO. `promise_pure` is an honest assertion here.

**Why one word fixes it:**

Mercury's purity system is conservative by design. It cannot inspect C code,
so it defaults to the worst case (impure). `promise_pure` is the programmer's
explicit sign-off that this particular piece of foreign code is safe to treat
as pure — subject to reordering, CSE, and elimination by the optimiser.

**When `promise_pure` is not honest:**

- `rand()` — reads and mutates global RNG state
- `getenv()` — reads process environment (side-effecting if environment changes)
- Reference counting or caching — mutates hidden state

For these, the Mercury wrapper must either be declared `:- impure` (and the
impurity propagates to all callers) or thread `!IO` through the call, which
makes the side effect explicit in Mercury's type system.

**The broader rule:**

Foreign code is guilty until proven innocent. `promise_pure` is the verdict —
you sign it, you own it. If the C code changes and the promise becomes false,
the compiler will not warn you. The responsibility is the programmer's.
