# Solution

This koan has no broken source file — the predicate compiles without error. The
problem is that it does nothing at runtime.

**The fix:** thread `!IO` through the predicate so every iteration performs
observable output:

```mercury
:- pred busy_wait(int::in, io::di, io::uo) is det.
busy_wait(0, !IO).
busy_wait(N, !IO) :-
    N > 0,
    io.write_string(".", !IO),
    io.flush_output(!IO),
    busy_wait(N - 1, !IO).
```

`io.flush_output/3` is necessary — without it, output is buffered and the
observable effect may still be deferred. The key invariant: if a predicate must
have a timing effect, it must have an IO effect. Mercury will not preserve a
pure predicate's execution just because you want it to take time.
