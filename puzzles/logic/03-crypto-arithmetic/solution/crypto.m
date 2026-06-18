:- module crypto.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module solutions.
:- import_module string.

:- pred solve(int::out, int::out, int::out, int::out,
              int::out, int::out, int::out, int::out) is nondet.
solve(S, E, N, D, M, O, R, Y) :-
    int.nondet_int_in_range(1, 9, S),
    int.nondet_int_in_range(0, 9, E), E \= S,
    int.nondet_int_in_range(0, 9, N), N \= S, N \= E,
    int.nondet_int_in_range(0, 9, D), D \= S, D \= E, D \= N,
    int.nondet_int_in_range(1, 9, M), M \= S, M \= E, M \= N, M \= D,
    int.nondet_int_in_range(0, 9, O), O \= S, O \= E, O \= N, O \= D, O \= M,
    int.nondet_int_in_range(0, 9, R), R \= S, R \= E, R \= N, R \= D, R \= M, R \= O,
    int.nondet_int_in_range(0, 9, Y), Y \= S, Y \= E, Y \= N, Y \= D, Y \= M, Y \= O, Y \= R,
    1000*S + 100*E + 10*N + D
    + 1000*M + 100*O + 10*R + E
    = 10000*M + 1000*O + 100*N + 10*E + Y.

main(!IO) :-
    solutions(
        (pred({S,E,N,D,M,O,R,Y}::out) is nondet :-
            solve(S, E, N, D, M, O, R, Y)),
        Solutions),
    list.foldl(print_solution, Solutions, !IO).

:- pred print_solution({int,int,int,int,int,int,int,int}::in,
                        io::di, io::uo) is det.
print_solution({S,E,N,D,M,O,R,Y}, !IO) :-
    io.format("S=%d E=%d N=%d D=%d M=%d O=%d R=%d Y=%d\n",
        [i(S), i(E), i(N), i(D), i(M), i(O), i(R), i(Y)], !IO),
    io.format("  %d + %d = %d\n",
        [i(1000*S+100*E+10*N+D),
         i(1000*M+100*O+10*R+E),
         i(10000*M+1000*O+100*N+10*E+Y)], !IO).
