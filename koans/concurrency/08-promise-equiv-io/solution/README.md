# Solution

Wrap the `thread.spawn` call in `promise_equivalent_solutions [!:IO]`:

```mercury
launch(Id, !IO) :-
    promise_equivalent_solutions [!:IO]
        thread.spawn(worker(Id), !IO).
```

`promise_equivalent_solutions [!:IO]` tells Mercury: "all solutions of this goal
produce observationally equivalent `!:IO` states." Because spawning a thread does
not change what the current thread observes from IO (the worker runs independently),
this assertion is semantically correct.

The `[!:IO]` list names the variables whose final values are claimed equivalent
across all solutions. For IO threading, `!:IO` (the output state of `!IO`) is
the relevant variable.

Compare with `koans/concurrency/05-spawn-propagate`, where the fix was to declare
the predicate `cc_multi`. Here the fix preserves the `det` declaration by asserting
that the `cc_multi` non-determinism doesn't produce observably different outcomes.
Use `promise_equivalent_solutions [!:IO]` when `cc_multi` propagation is impractical
but the spawned work truly doesn't affect the caller's observable IO state.
