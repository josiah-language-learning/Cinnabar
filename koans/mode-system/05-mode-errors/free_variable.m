:- module free_variable.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.

% BUG: variable `Value` is only bound inside the then-branch of the if-then-else.
% After the if-then-else, Value may still be free (the else-branch doesn't bind it).
% Mercury's mode analysis catches this: Value has inst `free` at the io.write_int call.
% Goal reordering cannot fix this — there's no single goal that always binds Value.
:- pred find_and_print(list(int)::in, int::in, io::di, io::uo) is det.
find_and_print(List, Idx, !IO) :-
    ( list.index0(List, Idx, Value) ->
        true          % Value is bound here, but only in this branch
    ;
        true          % Value is NOT bound here
    ),
    % BUG: Value may be free here — the else branch never bound it
    io.write_int(Value, !IO),
    io.nl(!IO).

main(!IO) :-
    find_and_print([10, 20, 30], 1, !IO).
