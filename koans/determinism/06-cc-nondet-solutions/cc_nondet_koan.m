:- module cc_nondet_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module solutions.

:- pred any_int(int::out) is nondet.
any_int(N) :- list.member(N, [1, 2, 3]).

% BUG: first_int commits to one solution (cc_nondet).
% solutions/2 requires a nondet predicate — cc_nondet is not nondet.
:- pred first_int(int::out) is cc_nondet.
first_int(N) :- any_int(N).

main(!IO) :-
    % DETERMINISM ERROR: first_int has inst pred(out) is cc_nondet,
    % but solutions/2 requires pred(out) is nondet.
    solutions(first_int, All),
    io.write_line(All, !IO).
