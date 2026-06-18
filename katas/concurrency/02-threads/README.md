# 02 — Threads: producer-consumer with channels

**Concept:** `thread.spawn`, `thread.channel`, `channel.put`, `channel.take`,
`!IO` as the serialization mechanism for threads

**Requires:** `.par` grade

**Not in the Mercury tutorial.**

---

## Background

Mercury threads communicate through typed channels. A `channel(T)` is a FIFO queue that
can be shared between threads. Both `channel.put` and `channel.take` are `det` and thread
through `!IO` — the IO state serializes operations within each thread, but threads run
concurrently.

All thread communication goes through `!IO`. There are no shared mutable variables
accessible across threads (outside of `mutable`, which requires explicit synchronization).
The channel is the primitive.

---

## What you will build

A producer-consumer pair:
- **Producer**: sends integers 1 through N to a channel, then sends a sentinel
- **Consumer**: reads from the channel, accumulates, returns the total

### The sentinel pattern

Use `maybe(int)` on the channel: the producer sends `yes(1)`, `yes(2)`, ..., `yes(N)`,
then `no` to signal completion.

```mercury
:- import_module thread.
:- import_module thread.channel.
:- import_module maybe.
```

### Producer

```mercury
:- pred producer(int::in, channel(maybe(int))::in, io::di, io::uo) is det.
producer(N, Chan, !IO) :-
    ( N =< 0 ->
        channel.put(Chan, no, !IO)
    ;
        channel.put(Chan, yes(N), !IO),
        producer(N - 1, Chan, !IO)
    ).
```

### Consumer

```mercury
:- pred consumer(channel(maybe(int))::in, int::in, int::out,
                 io::di, io::uo) is det.
consumer(Chan, Acc0, Acc, !IO) :-
    channel.take(Chan, Item, !IO),
    (
        Item = no,
        Acc = Acc0
    ;
        Item = yes(N),
        consumer(Chan, Acc0 + N, Acc, !IO)
    ).
```

### Main

```mercury
main(!IO) :-
    channel.init(Chan, !IO),
    thread.spawn(producer(100, Chan), !IO),
    consumer(Chan, 0, Total, !IO),
    io.format("Total: %d\n", [i(Total)], !IO).
```

`thread.spawn` takes a predicate `pred(io::di, io::uo) is cc_multi` and runs it in a
new thread. The channel is shared by reference.

### Build

```bash
mmc --make --grade asm_fast.par.gc.stseg producer_consumer
```

### Verify

The sum of 1..100 is 5050. Verify the program produces `Total: 5050`.

---

## Checkpoint

- Program builds with `.par` grade
- Output is `Total: 5050` (or whatever N*(N+1)/2 gives for your N)
- You can explain: why does `thread.spawn` take a predicate with `!IO` rather than a
  `det` function? What would happen if two threads shared the same `!IO` reference?
