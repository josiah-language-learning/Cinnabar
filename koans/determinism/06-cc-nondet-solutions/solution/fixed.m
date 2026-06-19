:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module solutions.

:- pred any_int(int::out) is nondet.
any_int(N) :- list.member(N, [1, 2, 3]).

:- pred first_int(int::out) is cc_nondet.
first_int(N) :- any_int(N).

% FIX (approach 1): pass any_int (nondet) to solutions/2 directly.
% cc_nondet cannot be used here — it has committed away the other solutions.
main(!IO) :-
    solutions(any_int, All),
    io.write_line(All, !IO).

% FIX (approach 2, not shown above): if you only want the first value,
% call first_int directly from main (which is cc_multi) without solutions/2:
%
%   main(!IO) :-
%       ( first_int(N) ->
%           io.format("First: %d\n", [i(N)], !IO)
%       ;
%           io.write_string("No solution\n", !IO)
%       ).
