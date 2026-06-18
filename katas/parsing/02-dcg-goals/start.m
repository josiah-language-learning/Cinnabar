:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module char.
:- import_module int.
:- import_module list.
:- import_module string.

% DCG with semantic actions (goals in {}).
% The {} syntax embeds arbitrary Mercury goals that do not consume input.

% digit: consume one digit character, unify N with its numeric value.
:- pred digit(int::out,
              list(char)::in, list(char)::out) is semidet.
digit(N) -->
    [C],
    % {} goal: convert char → int via arithmetic (char.to_int - '0')
    { char.is_decimal_digit(C),
      char.to_int(C, CI),
      char.to_int('0', ZI),
      N = CI - ZI }.

% digits: consume one or more digits, build the integer.
:- pred digits(int::out,
               list(char)::in, list(char)::out) is semidet.
digits(N) -->
    digit(D),
    digits_rest(D, N).

:- pred digits_rest(int::in, int::out,
                    list(char)::in, list(char)::out) is det.
digits_rest(Acc, N) -->
    ( digit(D) ->
        { NewAcc = Acc * 10 + D },
        digits_rest(NewAcc, N)
    ;
        { N = Acc }
    ).

% number: skip leading whitespace then parse digits.
:- pred number(int::out,
               list(char)::in, list(char)::out) is semidet.
number(N) -->
    skip_spaces,
    digits(N).

:- pred skip_spaces(list(char)::in, list(char)::out) is det.
skip_spaces -->
    ( [C], { C = ' ' } ->
        skip_spaces
    ;
        []
    ).

% numbers: parse a comma-separated list of numbers.
:- pred numbers(list(int)::out,
                list(char)::in, list(char)::out) is semidet.
numbers([]) --> [].   % stub: parse number, then recurse on comma-separated rest

:- pred parse(string::in, list(int)::out) is semidet.
parse(Input, Ns) :-
    numbers(Ns, string.to_char_list(Input), []).

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    ( parse("42", [42]) ->
        check("parse 42", yes, !IO)
    ;
        check("parse 42", no, !IO)
    ),
    ( parse("1,2,3", [1,2,3]) ->
        check("parse 1,2,3", yes, !IO)
    ;
        check("parse 1,2,3", no, !IO)
    ),
    ( parse(" 10 , 20 ", [10,20]) ->
        check("parse with spaces", yes, !IO)
    ;
        check("parse with spaces", no, !IO)
    ).
