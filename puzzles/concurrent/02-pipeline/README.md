# Puzzle: three-stage pipeline

**Primary skills:** `thread.spawn`, `thread.channel`, `!IO`, producer-consumer chains

**Requires:** `.par` grade

**Why Mercury:** the pipeline makes three Mercury-specific mechanics work together.
`!IO` is a unique token that cannot be shared across threads — each spawned predicate
receives its own `!IO` pair, enforcing that IO actions in different stages cannot
interleave unsafely. `channel(T)` is the only sanctioned way to hand values between
threads; there is no shared mutable state to corrupt. And `maybe(T)` is the natural
close sentinel: when the producer puts `no`, each stage propagates it downstream and
exits, giving you clean shutdown without a separate signal channel.

## Prerequisites

- `katas/concurrency/02-threads` — `thread.spawn`, `thread.channel`, `channel.put`/`channel.take`

---

## The problem

Build a three-stage pipeline:

```
[Reader] → channel1 → [Transformer] → channel2 → [Writer]
```

- **Reader:** reads integers from 1 to N, sends them to `channel1`
- **Transformer:** reads from `channel1`, doubles each value, sends to `channel2`
- **Writer:** reads from `channel2`, accumulates a total, prints it when done

Use a sentinel value (`no`) to signal end-of-stream.

---

## The structure

```mercury
main(!IO) :-
    N = 1000,
    channel.init(Chan1, !IO),
    channel.init(Chan2, !IO),
    thread.spawn(reader(N, Chan1), !IO),
    thread.spawn(transformer(Chan1, Chan2), !IO),
    writer(Chan2, 0, Total, !IO),
    io.format("Total: %d\n", [i(Total)], !IO).
```

The main thread blocks in `writer` until all data has been processed.

---

## Stage implementations

```mercury
:- pred reader(int::in, channel(maybe(int))::in, io::di, io::uo) is det.
reader(0, Chan, !IO) :- channel.put(Chan, no, !IO).
reader(N, Chan, !IO) :-
    N > 0,
    channel.put(Chan, yes(N), !IO),
    reader(N - 1, Chan, !IO).

:- pred transformer(channel(maybe(int))::in, channel(maybe(int))::in,
                    io::di, io::uo) is det.
transformer(In, Out, !IO) :-
    channel.take(In, Item, !IO),
    (
        Item = no,   channel.put(Out, no, !IO)
    ;
        Item = yes(V), channel.put(Out, yes(V * 2), !IO),
        transformer(In, Out, !IO)
    ).

:- pred writer(channel(maybe(int))::in, int::in, int::out,
               io::di, io::uo) is det.
writer(Chan, Acc0, Acc, !IO) :-
    channel.take(Chan, Item, !IO),
    (
        Item = no,    Acc = Acc0
    ;
        Item = yes(V), writer(Chan, Acc0 + V, Acc, !IO)
    ).
```

---

## What to observe

- The pipeline is naturally composable: add a fourth stage without changing existing stages
- All IO state threading happens within each thread's predicate — threads do not share `!IO`
- The `maybe` sentinel avoids explicit close/join operations

## Extensions

- Add a filter stage between transformer and writer
- Use `int` sentinels with a special value (-1) instead of `maybe`
- Add back-pressure: make `channel.put` block if the channel is full (requires a bounded channel)

---

## Design questions

1. Each stage threads `!IO` independently. Why can't two stages share a single `!IO`
   token across thread boundaries? What would break if they could?

2. The `maybe` sentinel signals end-of-stream without an explicit channel-close
   operation. What are the trade-offs of using `maybe(T)` vs a separate "close"
   message vs checking `channel.is_empty`?

3. `thread.spawn` takes a `cc_multi` closure. What does `cc_multi` mean here, and why
   can't a plain `det` predicate be spawned?
