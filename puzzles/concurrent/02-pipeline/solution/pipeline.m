:- module pipeline.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module maybe.
:- import_module string.
:- import_module thread.
:- import_module thread.channel.

%---------------------------------------------------------------------------%
% Stage 1: Reader — sends integers N down to 1, then sentinel
% FIX: cc_multi so the closure has the right inst for thread.spawn;
%      if-then-else replaces two clauses (multiple clauses with guards → nondet)

:- pred reader(int::in, channel(maybe(int))::in, io::di, io::uo) is cc_multi.
reader(N, Chan, !IO) :-
    ( N =< 0 ->
        channel.put(Chan, no, !IO)
    ;
        channel.put(Chan, yes(N), !IO),
        reader(N - 1, Chan, !IO)
    ).

%---------------------------------------------------------------------------%
% Stage 2: Transformer — doubles each value, forwards sentinel
% FIX: cc_multi for same reason

:- pred transformer(channel(maybe(int))::in, channel(maybe(int))::in,
                    io::di, io::uo) is cc_multi.
transformer(In, Out, !IO) :-
    channel.take(In, Item, !IO),
    (
        Item = no,
        channel.put(Out, no, !IO)
    ;
        Item = yes(V),
        channel.put(Out, yes(V * 2), !IO),
        transformer(In, Out, !IO)
    ).

%---------------------------------------------------------------------------%
% Stage 3: Writer — accumulates total until sentinel

:- pred writer(channel(maybe(int))::in, int::in, int::out,
               io::di, io::uo) is det.
writer(Chan, Acc0, Acc, !IO) :-
    channel.take(Chan, Item, !IO),
    (
        Item = no,
        Acc = Acc0
    ;
        Item = yes(V),
        writer(Chan, Acc0 + V, Acc, !IO)
    ).

%---------------------------------------------------------------------------%

main(!IO) :-
    N = 100,
    channel.init(Chan1, !IO),
    channel.init(Chan2, !IO),
    % FIX: promise_equivalent_solutions [!:IO] calls cc_multi from det context
    promise_equivalent_solutions [!:IO]
        thread.spawn(reader(N, Chan1), !IO),
    promise_equivalent_solutions [!:IO]
        thread.spawn(transformer(Chan1, Chan2), !IO),
    % Main thread acts as writer
    writer(Chan2, 0, Total, !IO),
    % Sum of 1..N doubled = 2 * N*(N+1)/2 = N*(N+1)
    Expected = N * (N + 1),
    io.format("Total: %d (expected: %d)\n", [i(Total), i(Expected)], !IO).
