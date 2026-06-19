:- module state_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module string.

% Double a number using explicit state variable notation.
%
% BUG: !:N refers to the *output* state (initially unbound).
% Using !:N on the right-hand side of = reads an unbound variable.
% The read side of a state variable is !.N; the write side is !:N.
:- pred double_it(int::in, int::out) is det.
double_it(!N) :-
    !:N = !:N * 2.   % BUG: !:N is free here; should be !.N * 2

main(!IO) :-
    double_it(21, Result),
    io.format("result: %d\n", [i(Result)], !IO).
