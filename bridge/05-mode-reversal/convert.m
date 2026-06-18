:- module convert.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module string.

% Forward-only conversion: parse a decimal integer string.
% Fails if the string does not represent a valid decimal integer.
:- pred str_to_int(string::in, int::out) is semidet.
str_to_int(S, N) :- string.to_int(S, N).

main(!IO) :-
    Tests = ["42", "0", "-7", "abc", "99", "1000"],
    list.foldl(
        (pred(S::in, !.IO::di, !:IO::uo) is det :-
            ( str_to_int(S, N) ->
                io.format("\"%s\" => %d\n", [s(S), i(N)], !IO)
            ;
                io.format("\"%s\" => (not an integer)\n", [s(S)], !IO)
            )),
        Tests, !IO).
