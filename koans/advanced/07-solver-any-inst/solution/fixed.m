:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- solver type token_var.

:- pred make_var(token_var::out(any)) is det.
:- pred extract(token_var::in(any), int::out) is det.

:- implementation.
:- import_module int.

:- solver type token_var
    where
        representation is int,
        ground is ground,
        any is any.

:- pragma foreign_proc("C",
    make_var(X::out(any)),
    [will_not_call_mercury, promise_pure, thread_safe],
    "X = 42;").

:- pragma foreign_proc("C",
    extract(X::in(any), V::out),
    [will_not_call_mercury, promise_pure, thread_safe],
    "V = X;").

main(!IO) :-
    make_var(T),
    extract(T, V),
    io.write_int(V, !IO),
    io.nl(!IO).
