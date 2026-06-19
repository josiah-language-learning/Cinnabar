:- module channel_sentinel_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is cc_multi.

:- implementation.
:- import_module list.
:- import_module maybe.
:- import_module string.
:- import_module thread.
:- import_module thread.channel.

% BUG: the channel is channel(int), but the producer sends maybe(int)
% values (yes(X) for data, no for end-of-stream).
% Mercury channels have no built-in sentinel mechanism — the element
% type must include the sentinel.  Use channel(maybe(int)) instead.
:- pred produce(channel(int)::in, list(int)::in, io::di, io::uo) is det.
produce(Chan, [], !IO) :-
    channel.put(Chan, no, !IO).           % BUG: `no' has type maybe(T), not int
produce(Chan, [X | Xs], !IO) :-
    channel.put(Chan, yes(X), !IO),       % BUG: `yes(X)' has type maybe(int), not int
    produce(Chan, Xs, !IO).

main(!IO) :-
    channel.init(Chan, !IO),
    thread.spawn(
        (pred(IO0::di, IO::uo) is cc_multi :- produce(Chan, [1, 2, 3], IO0, IO)),
        !IO),
    io.write_string("producer started\n", !IO).
