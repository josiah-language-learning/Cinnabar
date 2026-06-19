:- module solver_any_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

% A minimal solver type. The representation is int; the constraint engine
% would normally narrow the domain. Here we use a stub FFI implementation.
:- solver type token_var.

:- pred make_var(token_var::out(any)) is det.
% BUG: extract/2 declares its first argument as ::in (ground).
% A token_var produced by make_var has inst `any`, not `ground`.
:- pred extract(token_var::in, int::out) is det.

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
    extract(X::in, V::out),
    [will_not_call_mercury, promise_pure, thread_safe],
    "V = X;").

main(!IO) :-
    make_var(T),
    extract(T, V),
    io.write_int(V, !IO),
    io.nl(!IO).
