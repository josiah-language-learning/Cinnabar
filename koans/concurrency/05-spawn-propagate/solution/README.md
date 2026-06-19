# Solution

Change `launch_workers` from `is det` to `is cc_multi`:

```mercury
:- pred launch_workers(io::di, io::uo) is cc_multi.
```

`thread.spawn` is `cc_multi`. Any predicate that calls it must be at least
`cc_multi`. The property propagates: if `launch_workers` is `cc_multi`,
then `main` (which calls it) must also be at least `cc_multi` — which it
already is in this example.

The general rule: `cc_multi` is contagious upward through the call graph.
Anywhere you introduce `thread.spawn`, trace the callers all the way up and
update each declaration.
