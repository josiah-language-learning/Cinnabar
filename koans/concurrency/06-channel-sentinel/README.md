# Koan: channels have no built-in sentinel — the element type must include it

**Broken concept:** sending `maybe` values to a `channel(int)`, expecting the
channel type to support an end-of-stream signal

## Prerequisites

- `katas/concurrency/02-threads` — `thread.channel`, `put`, `take`

---

```
mmc channel_sentinel_koan.m
```

Two type errors, one for each broken `channel.put` call:

```
type error: argument has type `maybe.maybe(T)', expected type was `int'.
type error: argument has type `maybe.maybe(int)', expected type was `int'.
```

---

## What to observe

Mercury channels are monomorphic — a `channel(int)` carries only `int` values.
There is no built-in close signal or end-of-stream sentinel. If you want to
signal end-of-stream, the sentinel must be part of the element type itself.

The fix is to use `channel(maybe(int))`: send `yes(X)` for each data item and
`no` as the terminal signal. The consumer pattern-matches on `maybe`:

```mercury
channel.take(Chan, Msg, !IO),
( Msg = yes(X) -> process(X) ; true )  % no = end of stream
```

This is a deliberate design in Mercury's concurrency model: the type system
makes the communication protocol visible. A `channel(maybe(int))` is a different
type from a `channel(int)` — the sentinel is encoded at the type level, not
as a magic out-of-band value.

---

## Your task

Change the channel type to `channel(maybe(int))` everywhere. Update
`produce`'s type signature, the `channel.init` call in `main`, and the
`thread.spawn` argument's type annotation if needed.
