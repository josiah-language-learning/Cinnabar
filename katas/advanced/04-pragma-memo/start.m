:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module int.
:- import_module list.
:- import_module map.
:- import_module string.

% ---- Part 1: pragma memo on Fibonacci ----------------------------------------
:- func fib(int) = int.
:- pragma memo(fib/1).
fib(N) =
    ( N =< 1 -> N ; fib(N - 1) + fib(N - 2) ).

% ---- Part 2: Ackermann with pragma memo --------------------------------------
% Ackermann grows extremely fast — without memoisation it is impractical
% even for small arguments.
:- func ack(int, int) = int.
:- pragma memo(ack/2).
ack(M, N) =
    ( M = 0 -> N + 1
    ; N = 0 -> ack(M - 1, 1)
    ;          ack(M - 1, ack(M, N - 1))
    ).

% ---- Part 3: manual memo via map (no pragma) ---------------------------------
% Show how to simulate memoisation explicitly when pragma memo is unavailable
% or when you need more control (e.g. different eviction policies).
:- type memo_state == map(int, int).

:- pred fib_manual(int::in, int::out, memo_state::in, memo_state::out) is det.
fib_manual(N, R, !Memo) :-
    ( map.search(!.Memo, N, Cached) ->
        R = Cached
    ;
        ( N =< 1 ->
            R = N
        ;
            fib_manual(N - 1, R1, !Memo),
            fib_manual(N - 2, R2, !Memo),
            R = R1 + R2
        ),
        map.det_insert(N, R, !Memo)
    ).

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    check("fib(30) = 832040", ( fib(30) = 832040 -> yes ; no ), !IO),
    check("fib(40) = 102334155", ( fib(40) = 102334155 -> yes ; no ), !IO),
    check("ack(0,0) = 1", ( ack(0,0) = 1 -> yes ; no ), !IO),
    check("ack(1,1) = 3", ( ack(1,1) = 3 -> yes ; no ), !IO),
    check("ack(2,2) = 7", ( ack(2,2) = 7 -> yes ; no ), !IO),
    check("ack(3,3) = 61", ( ack(3,3) = 61 -> yes ; no ), !IO),
    fib_manual(30, FibM, map.init, _),
    check("fib_manual(30) = 832040", ( FibM = 832040 -> yes ; no ), !IO).
