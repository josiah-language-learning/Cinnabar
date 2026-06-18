:- module nqueens.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module solutions.
:- import_module string.

:- pred queens(int::in, list(int)::out) is nondet.
queens(N, Qs) :-
    queens_acc(N, N, [], Qs).

:- pred queens_acc(int::in, int::in, list(int)::in, list(int)::out) is nondet.
queens_acc(_, 0, Placed, Placed).
queens_acc(N, Row, Placed, Qs) :-
    Row > 0,
    int.nondet_int_in_range(1, N, Col),
    safe(Col, Placed, 1),
    queens_acc(N, Row - 1, [Col | Placed], Qs).

:- pred safe(int::in, list(int)::in, int::in) is semidet.
safe(_, [], _).
safe(Col, [Q | Qs], Dist) :-
    Col \= Q,
    int.abs(Col - Q) \= Dist,
    safe(Col, Qs, Dist + 1).

:- pred print_board(int::in, list(int)::in, io::di, io::uo) is det.
print_board(N, Qs, !IO) :-
    list.foldl(print_row(N), Qs, !IO).

:- pred print_row(int::in, int::in, io::di, io::uo) is det.
print_row(N, Col, !IO) :-
    Row = string.join_list("", list.map(cell(Col), 1 `..` N)),
    io.write_string(Row ++ "\n", !IO).

:- func cell(int, int) = string.
cell(QCol, Col) = ( Col = QCol -> "Q " ; ". " ).

main(!IO) :-
    N = 8,
    solutions(queens(N), All),
    list.length(All, Count),
    io.format("%d-queens: %d solutions\n", [i(N), i(Count)], !IO),
    ( All = [First | _] ->
        io.write_string("\nFirst solution:\n", !IO),
        print_board(N, First, !IO)
    ;
        true
    ).
