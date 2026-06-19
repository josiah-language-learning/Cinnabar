:- module phrase_det_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module char.
:- import_module list.
:- import_module string.

% A semidet DCG rule: consumes one char only if it is a decimal digit.
:- pred digit_char(char, list(char), list(char)).
:- mode digit_char(out, in, out) is semidet.
digit_char(C) --> [C], { char.is_digit(C) }.

% BUG: parse_digit is declared `det' but the DCG call inside is `semidet'.
% A DCG rule inherits the determinism of its body.  digit_char can fail
% (the first char might not be a digit), so parse_digit can fail too.
% Declared `det', inferred `semidet'.
:- pred parse_digit(string::in, char::out) is det.
parse_digit(Str, Digit) :-
    string.to_char_list(Str, Chars),
    digit_char(Digit, Chars, _).    % BUG: semidet call in det predicate

main(!IO) :-
    parse_digit("7abc", D),
    io.write_char(D, !IO), io.nl(!IO).
