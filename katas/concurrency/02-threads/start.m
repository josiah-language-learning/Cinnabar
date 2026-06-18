:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is cc_multi.

:- implementation.
:- import_module bool.
:- import_module int.
:- import_module list.
:- import_module string.
:- import_module thread.
:- import_module thread.channel.

% producer: send N integers (1..N) to a channel, then signal done with -1.
:- pred producer(int::in, channel(int)::in, io::di, io::uo) is det.
producer(N, Chan, !IO) :-
    ( N =< 0 ->
        channel.put(Chan, -1, !IO)   % sentinel
    ;
        channel.put(Chan, N, !IO),
        producer(N - 1, Chan, !IO)
    ).

% consumer: read integers from channel until sentinel (-1), accumulate sum.
:- pred consumer(channel(int)::in, int::in, int::out, io::di, io::uo) is det.
consumer(Chan, Acc, Sum, !IO) :-
    channel.take(Chan, Val, !IO),
    ( Val = -1 ->
        Sum = Acc
    ;
        consumer(Chan, Acc + Val, Sum, !IO)
    ).

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    channel.init(Chan, !IO),
    % Spawn producer in a separate thread
    thread.spawn(
        (pred(IO0::di, IO1::uo) is cc_multi :- producer(10, Chan, IO0, IO1)),
        !IO),
    % Main thread consumes
    consumer(Chan, 0, Sum, !IO),
    % 10 + 9 + ... + 1 = 55
    check("producer-consumer sum 1..10 = 55",
          ( Sum = 55 -> yes ; no ), !IO).
