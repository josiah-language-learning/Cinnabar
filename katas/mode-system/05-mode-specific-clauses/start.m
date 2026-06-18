:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module int.
:- import_module list.
:- import_module pair.
:- import_module solutions.
:- import_module string.

% my_append with mode-specific clause heads.
% Each clause head annotates its arguments with the expected mode.
% promise_equivalent_clauses tells Mercury to trust that these clauses
% are semantically equivalent across all modes.
%
% Mode 1 (in,in,out): concatenate two known lists.
% Mode 2 (out,out,in): enumerate all splits of the third argument.
:- pred my_append(list(T), list(T), list(T)).
:- mode my_append(in,  in,  out) is det.
:- mode my_append(out, out, in)  is multi.
:- pragma promise_equivalent_clauses(my_append/3).

my_append(A::in, B::in, C::out) :-
    C = A,    % stub: should produce A ++ B
    _ = B.
my_append(A::out, B::out, C::in) :-
    A = [],   % stub: should enumerate all splits of C
    B = C.

:- type list_pair(T) ---> lp(list(T), list(T)).

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    my_append([1,2], [3,4], Cat),
    check("append [1,2] [3,4]", ( Cat = [1,2,3,4] -> yes ; no ), !IO),
    solutions(
        (pred(lp(A,B)::out) is multi :- my_append(A, B, [1,2,3])),
        Splits),
    check("all splits of [1,2,3] — count 4",
          ( list.length(Splits) = 4 -> yes ; no ), !IO),
    io.format("Splits: %s\n", [s(string.string(Splits))], !IO).
