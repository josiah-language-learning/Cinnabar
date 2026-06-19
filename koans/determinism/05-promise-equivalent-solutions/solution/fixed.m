:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module string.

% Fix: declared semidet — honest about the empty-list case.
:- pred list_max(list(int)::in, int::out) is semidet.
list_max(Xs, Max) :-
    promise_equivalent_solutions [Max] (
        list.member(Max, Xs),
        \+ (list.member(Y, Xs), Y > Max)
    ).

main(!IO) :-
    ( list_max([3, 1, 4, 1, 5, 9, 2, 6], Max) ->
        io.format("Max: %d\n", [i(Max)], !IO)
    ;
        io.write_string("empty list\n", !IO)
    ).
