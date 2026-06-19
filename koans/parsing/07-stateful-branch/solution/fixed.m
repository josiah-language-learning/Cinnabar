:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module char.
:- import_module int.
:- import_module list.
:- import_module string.

:- type stats ---> stats(alpha_count :: int, digit_count :: int).

:- pred scan(stats::in, stats::out, list(char)::in, list(char)::out) is det.
scan(S0, S, Cs, Rest) :-
    ( item(S0, S1, Cs, Cs1) ->
        scan(S1, S, Cs1, Rest)
    ;
        S = S0, Rest = Cs
    ).

% FIX 1: use if-then-else so Mercury commits to the first matching branch
%   (disjunction infers nondet when both branches could succeed in principle).
% FIX 2: the digit branch now binds A = A0, threading the count through unchanged.
:- pred item(stats::in, stats::out, list(char)::in, list(char)::out) is semidet.
item(stats(A0, D0), stats(A, D)) -->
    [C],
    ( { char.is_alpha(C) } ->
        { A = A0 + 1, D = D0 }
    ;
        { char.is_digit(C) },
        { A = A0, D = D0 + 1 }
    ).

main(!IO) :-
    Input = string.to_char_list("abc123"),
    scan(stats(0, 0), Stats, Input, _),
    io.format("alpha=%d digits=%d\n",
        [i(Stats^alpha_count), i(Stats^digit_count)], !IO).
