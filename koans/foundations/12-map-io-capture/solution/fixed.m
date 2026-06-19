:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module list.
:- import_module string.

:- pred print_all(list(string)::in, io::di, io::uo) is det.
print_all(Strs, !IO) :-
    list.foldl(
        (pred(S::in, !.IO::di, !:IO::uo) is det :-
            io.write_string(S ++ "\n", !IO)),
        Strs, !IO).

main(!IO) :-
    print_all(["alpha", "beta", "gamma"], !IO).
