:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is cc_multi.

:- implementation.
:- import_module list.
:- import_module maybe.
:- import_module string.
:- import_module thread.
:- import_module thread.channel.

% Fix: use channel(maybe(int)) so the element type includes the sentinel.
:- pred produce(channel(maybe(int))::in, list(int)::in, io::di, io::uo) is det.
produce(Chan, [], !IO) :-
    channel.put(Chan, no, !IO).
produce(Chan, [X | Xs], !IO) :-
    channel.put(Chan, yes(X), !IO),
    produce(Chan, Xs, !IO).

main(!IO) :-
    channel.init(Chan, !IO),
    thread.spawn(
        (pred(IO0::di, IO::uo) is cc_multi :- produce(Chan, [1, 2, 3], IO0, IO)),
        !IO),
    io.write_string("producer started\n", !IO).
