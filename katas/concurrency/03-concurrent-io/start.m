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

:- type sem == semaphore.semaphore.
:- type ivar == mvar(int).

% worker: add Index to the shared mvar, then signal the semaphore.
% NOTE: read-modify-write is a race condition without a mutex.
% The exercise asks you to add a semaphore mutex to make this safe.
:- pred worker(int::in, ivar::in, sem::in, io::di, io::uo) is det.
worker(Index, Var, Sem, !IO) :-
    mvar.take(Var, Cur, !IO),
    mvar.put(Var, Cur + Index, !IO),
    semaphore.signal(Sem, !IO).

% parallel_sum: sum 1..N using N threads.
:- pred parallel_sum(int::in, int::out, io::di, io::uo) is cc_multi.
parallel_sum(N, Sum, !IO) :-
    mvar.init(0, Var, !IO),
    semaphore.init(Sem, !IO),
    spawn_workers(1, N, Var, Sem, !IO),
    wait_all(N, Sem, !IO),
    mvar.read(Var, Sum, !IO).

:- pred spawn_workers(int::in, int::in, ivar::in, sem::in,
                      io::di, io::uo) is cc_multi.
spawn_workers(I, N, Var, Sem, !IO) :-
    ( I > N -> true
    ;
        thread.spawn(
            (pred(IO0::di, IO1::uo) is cc_multi :- worker(I, Var, Sem, IO0, IO1)),
            !IO),
        spawn_workers(I + 1, N, Var, Sem, !IO)
    ).

:- pred wait_all(int::in, sem::in, io::di, io::uo) is det.
wait_all(N, Sem, !IO) :-
    ( N =< 0 -> true
    ;
        semaphore.wait(Sem, !IO),
        wait_all(N - 1, Sem, !IO)
    ).

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    parallel_sum(10, Sum, !IO),
    % 1+2+...+10 = 55. The mvar take/put cycle is a race without a mutex —
    % the exercise asks you to add semaphore-based locking to fix it.
    io.format("Parallel sum (may race): %d\n", [i(Sum)], !IO),
    check("sum nonzero", ( Sum > 0 -> yes ; no ), !IO).
