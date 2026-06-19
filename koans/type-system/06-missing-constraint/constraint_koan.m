:- module constraint_koan.
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

% BUG: print_value uses the `show' typeclass method on the type variable T,
% but does not declare `<= show(T)' in its signature.
% Without the constraint, Mercury cannot prove show(T) is satisfied for
% an arbitrary T.
:- pred print_value(T::in, io::di, io::uo) is det.
print_value(X, !IO) :-
    show(X, Str),
    io.write_string(Str ++ "\n", !IO).

main(!IO) :-
    print_value(42, !IO).
