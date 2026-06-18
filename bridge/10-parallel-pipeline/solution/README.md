# Solution notes

## Task 1: parallel transform stage

Route items from the reader to two workers based on value parity:

```mercury
:- pred dispatch(channel(maybe(int))::in,
                 channel(maybe(int))::in,
                 channel(maybe(int))::in,
                 io::di, io::uo) is cc_multi.
dispatch(In, ChanA, ChanB, !IO) :-
    channel.take(In, Item, !IO),
    (
        Item = no,
        channel.put(ChanA, no, !IO),
        channel.put(ChanB, no, !IO)
    ;
        Item = yes(V),
        ( V rem 2 = 0 ->
            channel.put(ChanA, yes(V), !IO)
        ;
            channel.put(ChanB, yes(V), !IO)
        ),
        dispatch(In, ChanA, ChanB, !IO)
    ).
```

Each worker is the original `transformer` predicate, writing to a shared output
channel. Spawn dispatch and both workers; the writer collects from the shared
output channel.

The output order is non-deterministic: items from worker A and worker B interleave
based on scheduling. The total is still correct (addition is commutative) but the
order of items in the output channel is not guaranteed.

## Task 2: bounded-buffer channel

```mercury
:- import_module thread.semaphore.

:- type bounded_chan(T) ---> bounded_chan(
    chan  :: channel(T),
    slots :: semaphore
).

:- pred bounded_init(int::in, bounded_chan(T)::out,
                     io::di, io::uo) is det.
bounded_init(Capacity, bounded_chan(Chan, Slots), !IO) :-
    channel.init(Chan, !IO),
    semaphore.init(Slots, !IO),
    % Signal Capacity times to set the initial slot count
    int.fold_up(
        (pred(_::in, !.IO::di, !:IO::uo) is det :-
            semaphore.signal(Slots, !IO)),
        1, Capacity, !IO).

:- pred bounded_put(bounded_chan(T)::in, T::in,
                    io::di, io::uo) is det.
bounded_put(bounded_chan(Chan, Slots), Item, !IO) :-
    semaphore.wait(Slots, !IO),    % block if full
    channel.put(Chan, Item, !IO).

:- pred bounded_take(bounded_chan(T)::in, T::out,
                     io::di, io::uo) is det.
bounded_take(bounded_chan(Chan, Slots), Item, !IO) :-
    channel.take(Chan, Item, !IO),
    semaphore.signal(Slots, !IO).  % release a slot
```

The `semaphore.signal` in `bounded_take` must happen after `channel.take`, not
before — otherwise a slot is released before the space is actually freed.

`int.fold_up` threads `!IO` through Capacity signal calls to initialize the
semaphore count. Alternatively use a recursive predicate.

## Task 3: backpressure verification

Add a simulated delay to the transformer:

```mercury
:- pred busy_wait(int::in) is det.
busy_wait(0).
busy_wait(N) :- N > 0, busy_wait(N - 1).
```

Call `busy_wait(100000)` before processing each item. With an unbounded channel,
the reader enqueues all N items instantly and then the transformer processes them
slowly. With the bounded channel (capacity 10), the reader blocks after 10 items
until the transformer consumes some.

For timing, use the real-time clock via `time.clock` or simply observe the
behaviour with printed progress messages.

## Task 4: supervisor thread

```mercury
:- pred transformer_safe(channel(maybe(int))::in,
                         channel(maybe(int))::in,
                         channel(maybe(string))::in,
                         io::di, io::uo) is cc_multi.
transformer_safe(In, Out, Report, !IO) :-
    channel.take(In, Item, !IO),
    (
        Item = no,
        channel.put(Out, no, !IO),
        channel.put(Report, no, !IO)    % clean exit
    ;
        Item = yes(V),
        ( V rem 7 = 0 ->
            % Simulate failure on multiples of 7
            throw(software_error("bad item: " ++ string.int_to_string(V)))
        ;
            channel.put(Out, yes(V * 2), !IO),
            transformer_safe(In, Out, Report, !IO)
        )
    ).

:- pred supervisor(channel(maybe(string))::in,
                   io::di, io::uo) is det.
supervisor(Report, !IO) :-
    channel.take(Report, Status, !IO),
    (
        Status = no  % transformer exited cleanly
    ;
        Status = yes(Err),
        io.format("supervisor: transformer crashed: %s\n", [s(Err)], !IO),
        io.write_string("supervisor: would restart here\n", !IO)
    ).
```

`exception.try_all` or `exception.catch_any` can be used to catch the throw inside
the transformer's spawned thread and write the error message to `Report`. The
supervisor reads `Report` and decides whether to restart.

Full restart logic requires re-spawning the transformer with the same input channel —
straightforward but requires tracking the channel reference in the supervisor's loop.
