:- module purity_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module string.

% BUG: foreign_proc without promise_pure is impure by default.
% Mercury cannot inspect foreign code, so it conservatively assumes
% all foreign_proc predicates are impure unless told otherwise.
% Calling c_square from a pure Mercury predicate is a compiler error.
:- pred c_square(int::in, int::out) is det.
:- pragma foreign_proc("C",
    c_square(N::in, Result::out),
    [will_not_call_mercury, thread_safe],   % BUG: missing promise_pure
    "
        Result = N * N;
    ").

:- pred describe_square(int::in, string::out) is det.
describe_square(N, Desc) :-
    c_square(N, Sq),    % ERROR: calling impure predicate in pure context
    ( Sq > 100 ->
        Desc = "large square"
    ;
        Desc = "small square"
    ).

main(!IO) :-
    describe_square(12, D),
    io.write_string(D ++ "\n", !IO).
