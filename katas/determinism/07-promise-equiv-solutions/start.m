:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is cc_multi.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module string.
:- import_module thread.

% ---------------------------------------------------------------
% promise_equivalent_solutions — two forms
% ---------------------------------------------------------------
%
% FORM 1: promise_equivalent_solutions [Var, ...]
%   Use when a cc_nondet/cc_multi goal produces results that are
%   observationally equivalent for the listed variables. Commits
%   to one solution and makes the outer goal det.
%
% FORM 2: promise_equivalent_solutions [!:IO]
%   Use when thread.spawn (cc_multi) appears inside a predicate that
%   must stay det. Asserts that all solutions produce equivalent IO
%   states — true because spawning runs the thread independently.
%
% ---------------------------------------------------------------

% Task 1 — [Var] form
%
% gen_first_even is cc_nondet: it searches a list for the first even
% number using committed-choice search. The result is logically unique.
%
% Implement first_even/1 as det using:
%   promise_equivalent_solutions [N]
%       gen_first_even(N)
%
% This commits to the one result and lets first_even be called from det.

:- pred gen_first_even(int::out) is cc_nondet.
gen_first_even(N) :-
    list.member(N, [1, 3, 4, 7, 8, 9]),
    N mod 2 = 0.

% TODO: implement first_even as det, returning the result of gen_first_even.
:- pred first_even(int::out) is det.
first_even(0).   % stub — replace body with promise_equivalent_solutions [N] wrapper

% Task 2 — [!:IO] form
%
% thread.spawn is cc_multi. launch/3 is declared det but calls spawn,
% making it cc_multi. Fix launch by wrapping the spawn call in:
%   promise_equivalent_solutions [!:IO]
%       thread.spawn(worker(Id), !IO)
%
% This asserts that the IO state after spawning is equivalent across all
% cc_multi solutions — true because the spawned thread runs independently.

:- pred worker(int::in, io::di, io::uo) is cc_multi.
worker(Id, !IO) :-
    io.format("worker %d\n", [i(Id)], !IO).

% TODO: fix launch so it is det — add promise_equivalent_solutions [!:IO]
:- pred launch(int::in, io::di, io::uo) is cc_multi.
launch(Id, !IO) :-
    thread.spawn(worker(Id), !IO).

main(!IO) :-
    first_even(N),
    io.format("first even: %d\n", [i(N)], !IO),
    launch(1, !IO),
    launch(2, !IO),
    io.write_string("done\n", !IO).
