:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module pair.
:- import_module string.

:- pred wrap_with_label(A::in, pair(string, A)::out) is det.
wrap_with_label(X, "item" - X).

% FIX: T is determined by the first argument (the default value)
:- func replicate(T, int) = list(T).
replicate(Default, N) =
    ( N =< 0 -> [] ; [Default | replicate(Default, N - 1)] ).

main(!IO) :-
    wrap_with_label(42, P),
    io.write_string(string.string(P) ++ "\n", !IO),
    % Now T is determined: replicate(0, 3) produces list(int)
    Xs = replicate(0, 3),
    io.write_line(Xs, !IO).
