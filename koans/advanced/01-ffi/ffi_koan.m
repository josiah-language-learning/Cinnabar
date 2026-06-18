:- module ffi_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.

:- pragma foreign_decl("C", "#include <stdlib.h>").

% BUG: missing will_not_call_mercury.
% Mercury acquires a mutex on every call to this foreign_proc because it
% does not know the C code will not call back into Mercury.
% The C code (abs) trivially does not call Mercury — the attribute is safe to add.
:- pred c_abs(int::in, int::out) is det.
:- pragma foreign_proc("C",
    c_abs(N::in, Abs::out),
    [promise_pure, thread_safe],  % BUG: missing will_not_call_mercury
    "
        Abs = (N < 0) ? -N : N;
    ").

main(!IO) :-
    N = 1000000,
    benchmark_loop(N, 0, !IO).

:- pred benchmark_loop(int::in, int::in, io::di, io::uo) is det.
benchmark_loop(0, Acc, !IO) :-
    io.format("Final: %d\n", [i(Acc)], !IO).
benchmark_loop(I, Acc0, !IO) :-
    I > 0,
    c_abs(-I, A),
    benchmark_loop(I - 1, Acc0 + A, !IO).
