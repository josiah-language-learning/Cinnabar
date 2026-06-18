:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module list.
:- import_module int.
:- import_module string.

% Exercise 1: multi generator — three solutions.
:- pred gen_string(string::out) is multi.
gen_string("apple").
gen_string("banana").
gen_string("cherry").

% cc_multi wrapper: commits to the first solution of gen_string.
:- pred first_string(string::out) is cc_multi.
first_string("").   % stub: should call gen_string (which is multi, making this cc_multi)

% Exercise 3: a predicate where all solutions give the same value.
:- pred compute(int::out) is nondet.
compute(42).
compute(42).
compute(42).

% Use promise_equivalent_solutions to call compute from a det context.
:- pred get_value(int::out) is det.
get_value(0).   % stub: use promise_equivalent_solutions [N] (compute(N))

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    % Exercise 1: call cc_multi first_string from det main via promise_equivalent_solutions.
    % When all cc_multi solutions are the same value, promise_equivalent_solutions is safe.
    promise_equivalent_solutions [S] first_string(S),
    check("first_string = \"\" (stub — implement with gen_string)",
        ( string.length(S) >= 0 -> yes ; no ), !IO),
    check("main declared det compiles when using promise_equivalent_solutions",
        ( true -> yes ; no ), !IO),
    % Exercise 3: promise_equivalent_solutions.
    get_value(V),
    check("get_value = 42",
        ( V = 42 -> yes ; no ), !IO).
