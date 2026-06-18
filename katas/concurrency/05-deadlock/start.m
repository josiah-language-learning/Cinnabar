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
:- import_module thread.mvar.
:- import_module thread.semaphore.

% DEADLOCK PATTERNS AND AVOIDANCE:
%
% Deadlock requires a cycle in the "waiting-for" graph.
% Classic causes:
% 1. Two threads each hold one resource and wait for the other's resource.
% 2. Two threads each write to a channel the other reads from (with blocking).
%
% AVOIDANCE: resource ordering — always acquire resources in a fixed order.

% ---- Exercise 1: safe counter using a semaphore mutex ----------------------

:- type counter == mvar(int).
:- type mutex == semaphore.semaphore.

:- pred counter_init(counter::out, io::di, io::uo) is det.
counter_init(C, !IO) :- mvar.init(C, !IO), mvar.put(C, 0, !IO).

:- pred mutex_init(mutex::out, io::di, io::uo) is det.
mutex_init(M, !IO) :-
    semaphore.init(M, !IO),
    semaphore.signal(M, !IO).   % signal once = unlocked

:- pred counter_inc(counter::in, mutex::in, io::di, io::uo) is det.
counter_inc(C, M, !IO) :-
    semaphore.wait(M, !IO),
    mvar.take(C, N, !IO),
    mvar.put(C, N + 1, !IO),
    semaphore.signal(M, !IO).

:- pred counter_read(counter::in, int::out, io::di, io::uo) is det.
counter_read(C, N, !IO) :- mvar.read(C, N, !IO).

% ---- Exercise 2: N incrementors ----------------------------------------

:- pred spawn_incrementors(int::in, int::in, counter::in,
                           mutex::in, io::di, io::uo) is cc_multi.
spawn_incrementors(N, K, C, M, !IO) :-
    ( N =< 0 -> true
    ;
        thread.spawn(
            (pred(IO0::di, IO1::uo) is cc_multi :-
                increment_k_times(K, C, M, IO0, IO1)),
            !IO),
        spawn_incrementors(N - 1, K, C, M, !IO)
    ).

:- pred increment_k_times(int::in, counter::in, mutex::in,
                          io::di, io::uo) is det.
increment_k_times(K, C, M, !IO) :-
    ( K =< 0 -> true
    ;
        counter_inc(C, M, !IO),
        increment_k_times(K - 1, C, M, !IO)
    ).

% ---- Exercise 3: resource ordering to avoid deadlock ----------------------

:- pred transfer(counter::in, counter::in, int::in,
                 mutex::in, mutex::in, io::di, io::uo) is det.
transfer(From, To, Amount, MFrom, MTo, !IO) :-
    semaphore.wait(MFrom, !IO),
    semaphore.wait(MTo, !IO),
    mvar.take(From, F, !IO),
    mvar.take(To, T, !IO),
    mvar.put(From, F - Amount, !IO),
    mvar.put(To, T + Amount, !IO),
    semaphore.signal(MTo, !IO),
    semaphore.signal(MFrom, !IO).

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    % Exercise 1: basic counter with mutex.
    counter_init(C, !IO),
    mutex_init(Mutex, !IO),
    counter_inc(C, Mutex, !IO),
    counter_inc(C, Mutex, !IO),
    counter_inc(C, Mutex, !IO),
    counter_read(C, Val, !IO),
    check("3 increments = 3", ( Val = 3 -> yes ; no ), !IO),
    % Exercise 2: concurrent incrementors (N=4, K=25 → expect 100).
    counter_init(C2, !IO),
    mutex_init(Mutex2, !IO),
    spawn_incrementors(4, 25, C2, Mutex2, !IO),
    thread.yield(!IO),
    counter_read(C2, Final, !IO),
    io.format("4 threads x 25 increments = %d (expect 100)\n", [i(Final)], !IO),
    % Exercise 3: transfer between two counters.
    counter_init(CA, !IO),
    counter_init(CB, !IO),
    mvar.take(CA, _, !IO), mvar.put(CA, 100, !IO),
    mvar.take(CB, _, !IO), mvar.put(CB, 0, !IO),
    mutex_init(MA, !IO),
    mutex_init(MB, !IO),
    transfer(CA, CB, 40, MA, MB, !IO),
    counter_read(CA, VA, !IO),
    counter_read(CB, VB, !IO),
    check("transfer: A = 60", ( VA = 60 -> yes ; no ), !IO),
    check("transfer: B = 40", ( VB = 40 -> yes ; no ), !IO).
