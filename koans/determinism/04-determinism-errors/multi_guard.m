:- module multi_guard.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module string.

% BUG: declared det, but the two clauses are not mutually exclusive.
% For N = 0 both the first clause (N >= 0) and the second clause (N =< 0)
% match, so Mercury infers multi, not det.
:- pred categorize(int::in, string::out) is det.
categorize(N, Cat) :-
    N >= 0,
    Cat = "non-negative".
categorize(N, Cat) :-
    N =< 0,
    Cat = "non-positive".

main(!IO) :-
    categorize(5, C1),
    io.write_string(C1, !IO),
    io.nl(!IO),
    categorize(-3, C2),
    io.write_string(C2, !IO),
    io.nl(!IO),
    categorize(0, C3),
    io.write_string(C3, !IO),
    io.nl(!IO).
