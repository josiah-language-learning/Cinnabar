:- module char_digit_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module char.
:- import_module list.
:- import_module string.

% BUG 1: char.digit_to_int does not exist — use char.decimal_digit_to_int.
% BUG 2: Digit is bound in the condition; it is NOT in scope in the else branch.
%        The else branch runs when the condition failed — Digit was never bound.
:- pred report_char(char::in, io::di, io::uo) is det.
report_char(C, !IO) :-
    ( char.digit_to_int(C, Digit) ->
        io.format("digit value: %d\n", [i(Digit)], !IO)
    ;
        io.format("not a digit, would be: %d\n", [i(Digit)], !IO)
    ).

main(!IO) :-
    report_char('5', !IO),
    report_char('x', !IO).
