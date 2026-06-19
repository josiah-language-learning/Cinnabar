:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module string.

:- typeclass show(T) where [
    pred show(T::in, string::out) is det
].

:- instance show(int) where [
    show(N, S) :- S = string.int_to_string(N)
].

% FIX: add `<= show(T)' constraint so Mercury knows show is available for T.
:- pred print_value(T::in, io::di, io::uo) is det <= show(T).
print_value(X, !IO) :-
    show(X, Str),
    io.write_string(Str ++ "\n", !IO).

main(!IO) :-
    print_value(42, !IO).
