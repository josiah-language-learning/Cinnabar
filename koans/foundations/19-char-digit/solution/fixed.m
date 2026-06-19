:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module char.
:- import_module list.
:- import_module string.

:- pred report_char(char::in, io::di, io::uo) is det.
report_char(C, !IO) :-
    ( char.decimal_digit_to_int(C, Digit) ->
        io.format("digit value: %d\n", [i(Digit)], !IO)
    ;
        io.format("not a digit: %c\n", [c(C)], !IO)
    ).

main(!IO) :-
    report_char('5', !IO),
    report_char('x', !IO).
