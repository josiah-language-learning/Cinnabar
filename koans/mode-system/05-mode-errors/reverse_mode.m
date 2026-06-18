:- module reverse_mode.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module string.

% BUG: string_to_int is declared with mode (in, out) only.
% The call in display_sum passes a free variable for the first argument,
% which would require an (out, in) mode that doesn't exist.
% Mercury reports that the argument has inst `free` where `ground` is needed.
:- pred string_to_int(string::in, int::out) is semidet.
string_to_int(S, N) :- string.to_int(S, N).

:- pred display_sum(int::in, io::di, io::uo) is det.
display_sum(Total, !IO) :-
    % WRONG: trying to use string_to_int in reverse — find S such that
    % string_to_int(S, 42). But string_to_int has no (out, in) mode.
    ( string_to_int(S, 42) ->
        io.write_string("42 as string: " ++ S ++ "\n", !IO)
    ;
        io.write_string("could not reverse\n", !IO)
    ),
    io.write_int(Total, !IO),
    io.nl(!IO).

main(!IO) :-
    display_sum(100, !IO).
