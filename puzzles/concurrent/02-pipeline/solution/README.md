# Pipeline solution notes

## The `!IO` threading model

Each thread has its own `!IO` state. The main thread passes its `!IO` to `thread.spawn`,
which consumes it (di) and produces a fresh one (uo). The spawned thread runs with its
own IO state, completely independent of the main thread's.

Channels bridge the threads: they are shared data structures (reference counted under
the hood) that accept values from any thread and deliver them to any thread.

## Composability

Each stage's signature follows the same pattern:
```mercury
:- pred stage_name(channel(maybe(T))::in, channel(maybe(U))::in,
                   io::di, io::uo) is det.
```

Adding a stage is: create a new channel, spawn the new stage, wire it between the
existing stages. No existing stage code changes.

## The sentinel pattern

Using `maybe(T)` channels with `no` as sentinel is idiomatic Mercury. Alternatives:

| Approach | Pros | Cons |
|----------|------|------|
| `maybe(T)` sentinel | Clean types | Wraps every value |
| Magic sentinel value | No wrapper | Type-unsafe, easy to mistake |
| Out-of-band channel | No sentinel needed | Two channels to manage per edge |
| `thread.join` + result | Explicit lifecycle | More complex setup |

The `maybe` approach is the simplest correct approach for this pattern size.
