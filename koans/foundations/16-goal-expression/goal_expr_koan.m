:- module goal_expr_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module list.
:- import_module string.

:- type flagged ---> flagged(bool).

% BUG: A = B is a goal (unification predicate), not an expression.
% flagged(A = B) tries to pass the "result" of A = B as a bool argument,
% but goals do not return values — they succeed or fail.
:- func tag_equal(int, int) = flagged.
tag_equal(A, B) = flagged(A = B).

main(!IO) :-
    io.format("3 = 3: %s\n", [s(string.string(tag_equal(3, 3)))], !IO),
    io.format("3 = 4: %s\n", [s(string.string(tag_equal(3, 4)))], !IO).
