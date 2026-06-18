:- module semidet_io.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.

% FIX: change to det. Use if-then-else to handle the non-positive case.
% A predicate with io::di, io::uo must be at least det — the io token
% must always be consumed.
:- pred print_if_positive(int::in, io::di, io::uo) is det.
print_if_positive(N, !IO) :-
    ( N > 0 ->
        io.write_string("positive\n", !IO)
    ;
        true
    ).

main(!IO) :-
    print_if_positive(5, !IO),
    print_if_positive(-1, !IO).
