# Solution

Change `channel(int)` to `channel(maybe(int))` throughout. The `produce`
predicate already sends the right values — the type just needs to match:

```mercury
:- pred produce(channel(maybe(int))::in, list(int)::in, io::di, io::uo) is det.
produce(Chan, [], !IO) :-
    channel.put(Chan, no, !IO).
produce(Chan, [X | Xs], !IO) :-
    channel.put(Chan, yes(X), !IO),
    produce(Chan, Xs, !IO).
```

The channel is initialized as `channel(maybe(int))`:
```mercury
channel.init(Chan, !IO)  % Chan :: channel(maybe(int)) inferred from use
```

The sentinel pattern (`yes`/`no`) becomes part of the channel's type contract:
anyone taking from this channel knows to expect either a value or termination.
Mercury's type system enforces that both producer and consumer agree on this
protocol at compile time.
