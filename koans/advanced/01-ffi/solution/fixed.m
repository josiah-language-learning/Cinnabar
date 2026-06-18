:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module string.

:- pragma foreign_decl("C", "#include <stdlib.h>").

% FIX: added will_not_call_mercury — avoids per-call mutex acquisition
:- pred c_abs(int::in, int::out) is det.
:- pragma foreign_proc("C",
    c_abs(N::in, Abs::out),
    [will_not_call_mercury, promise_pure, thread_safe],
    "
        Abs = (N < 0) ? -N : N;
    ").

main(!IO) :-
    N = 1000000,
    benchmark_loop(N, 0, !IO).

:- pred benchmark_loop(int::in, int::in, io::di, io::uo) is det.
benchmark_loop(I, Acc, !IO) :-
    ( I =< 0 ->
        io.format("Final: %d\n", [i(Acc)], !IO)
    ;
        c_abs(-I, A),
        benchmark_loop(I - 1, Acc + A, !IO)
    ).
