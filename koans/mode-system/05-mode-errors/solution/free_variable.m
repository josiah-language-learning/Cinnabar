:- module free_variable.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.

% FIX: bind Value before using it. Use a default for the missing-index case
% so Value is always bound in both branches.
:- pred find_and_print(list(int)::in, int::in, io::di, io::uo) is det.
find_and_print(List, Idx, !IO) :-
    ( list.index0(List, Idx, Value) ->
        io.write_int(Value, !IO)
    ;
        io.write_string("not found", !IO)
    ),
    io.nl(!IO).

main(!IO) :-
    find_and_print([10, 20, 30], 1, !IO).
