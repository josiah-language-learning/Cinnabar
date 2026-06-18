:- module counter.
:- interface.

:- type counter.

:- func init(int) = counter.
:- func value(counter) = int.
:- pred increment(counter::in, counter::out) is det.
:- pred decrement(counter::in, counter::out) is det.
:- pred reset(counter::in, counter::out) is det.

:- implementation.

:- type counter ---> counter(int).

init(N) = counter(N).
value(counter(N)) = N.
increment(counter(N), counter(N)).   % stub: should be counter(N + 1)
decrement(counter(N), counter(N)).   % stub: should be counter(N - 1)
reset(_, counter(0)).
