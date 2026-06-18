:- module parametric_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module pair.
:- import_module string.

% BUG: type variable B appears in the body (return type) but the
% predicate's interface only mentions A. The compiler cannot determine
% what type B should be at call sites.
:- pred wrap_with_label(A::in, pair(string, A)::out) is det.
wrap_with_label(X, "item" - X).

% The actual error is more subtle: this compiles, but a second issue occurs
% when trying to use a type variable that only appears in a nested context
% without proper quantification.

:- func replicate_wrong(int) = list(T).
% BUG: T in the return type has no constraint and no connection to the input.
% The compiler cannot determine what list this should be.
replicate_wrong(_) = [].

main(!IO) :-
    wrap_with_label(42, P),
    io.write_string(string.string(P) ++ "\n", !IO),
    % This call is also ambiguous: what is T in replicate_wrong?
    Xs = replicate_wrong(3),
    io.write_line(Xs, !IO).
