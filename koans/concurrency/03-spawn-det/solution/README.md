# Solution

Change `worker`'s declaration from `is det` to `is cc_multi`:

```mercury
:- pred worker(io::di, io::uo) is cc_multi.
```

`thread.spawn` mandates the `cc_multi` inst for its callback. Every predicate
passed to `thread.spawn` must carry this annotation — even one whose body is
trivially `det`.

Mercury may warn that the declaration "could be tighter" (since the body
is inferred `det`). The warning is accurate about the body, but the `cc_multi`
declaration is still required to satisfy the higher-order mode of `thread.spawn`.
This is one of the few places in Mercury where you intentionally declare a
predicate at a *weaker* determinism than the body strictly requires.
