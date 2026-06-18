:- module nondet_direct.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module string.

% BUG: declared det, but body calls a nondet predicate directly.
% You cannot call a nondet goal in a det context — Mercury has nowhere to put
% the extra solutions. The fix is solutions/2 to collect them into a list.
:- pred first_factor(int::in, int::out) is det.
first_factor(N, F) :-
    int.nondet_int_in_range(2, N - 1, F),
    N mod F = 0.

main(!IO) :-
    first_factor(12, F),
    io.write_string("first factor: ", !IO),
    io.write_int(F, !IO),
    io.nl(!IO).
