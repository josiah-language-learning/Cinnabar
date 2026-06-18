:- module semidet_io.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.

% BUG: a predicate that threads io state cannot be semidet.
% If the predicate fails, the io state is lost — the io token disappears.
% Mercury requires any predicate with io::di, io::uo to be at least det.
:- pred print_if_positive(int::in, io::di, io::uo) is semidet.
print_if_positive(N, !IO) :-
    N > 0,
    io.write_string("positive\n", !IO).

main(!IO) :-
    print_if_positive(5, !IO),
    print_if_positive(-1, !IO).
