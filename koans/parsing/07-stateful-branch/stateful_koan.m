:- module stateful_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module char.
:- import_module int.
:- import_module list.
:- import_module string.

% A stateful DCG parser that counts alphabetic and digit characters.
% State is threaded as extra arguments (in, out) on every rule.

:- type stats ---> stats(alpha_count :: int, digit_count :: int).

% scan/4: consume all chars in the input, accumulating stats.
% Single-clause with if-then-else to keep determinism unambiguous.
:- pred scan(stats::in, stats::out, list(char)::in, list(char)::out) is det.
scan(S0, S, Cs, Rest) :-
    ( item(S0, S1, Cs, Cs1) ->
        scan(S1, S, Cs1, Rest)
    ;
        S = S0, Rest = Cs
    ).

% item/4: consume one char and update the appropriate counter.
% BUG: the digit branch never binds Alpha — it falls out of scope unbound.
:- pred item(stats::in, stats::out, list(char)::in, list(char)::out) is semidet.
item(stats(A0, D0), stats(A, D)) -->
    [C],
    (
        { char.is_alpha(C) },
        { A = A0 + 1, D = D0 }
    ;
        { char.is_digit(C) },
        { D = D0 + 1 }          % DETERMINISM/MODE ERROR: A is not bound here
    ).

main(!IO) :-
    Input = string.to_char_list("abc123"),
    scan(stats(0, 0), Stats, Input, _),
    io.format("alpha=%d digits=%d\n",
        [i(Stats^alpha_count), i(Stats^digit_count)], !IO).
