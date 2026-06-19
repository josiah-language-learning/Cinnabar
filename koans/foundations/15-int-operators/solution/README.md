# Solution

Replace `=\=` with `\=`:

```mercury
( A \= B ->
    io.format("%d and %d differ\n", [i(A), i(B)], !IO)
;
    io.write_string("equal\n", !IO)
).
```

`\=` succeeds when two terms cannot unify. For ground integers this is the correct
arithmetic inequality check, because unification on ground terms compares values.

There is also no `=:=` — use plain `=` for equality on ground integers for the
same reason.
