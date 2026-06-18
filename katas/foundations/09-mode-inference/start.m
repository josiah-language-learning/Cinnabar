:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module string.
:- import_module int.
:- import_module list.
:- import_module solutions.

% Exercise 1: write add so that goals are listed backwards inside the clause.
% i.e. C = A + B appears BEFORE A = 1 and B = 2 in the source.
% The mode checker will reorder them.  Result must still be correct.
:- pred add(int::in, int::in, int::out) is det.
add(_, _, 0).   % stub: write with backwards goal order per README

% Exercise 2: my_length with two modes.
% (in, out) is det — compute length of a given list.
% (out, in) is det — generate a list of given length (stub: returns []).
:- pred my_length(list(T), int).
:- mode my_length(in, out) is det.
:- mode my_length(out, in) is det.
:- pragma promise_equivalent_clauses(my_length/2).
my_length(List::in, Len::out) :-
    Len = 0, _ = List.   % stub: compute actual length
my_length(List::out, Len::in) :-
    List = [], _ = Len.  % stub: generate list of Len elements

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    check("add(1, 2, R): R = 3",
        ( add(1, 2, R), R = 3 -> yes ; no ), !IO),
    check("add(4, 6, R): R = 10",
        ( add(4, 6, R2), R2 = 10 -> yes ; no ), !IO),
    check("my_length in-out: [a,b,c] has length 3",
        ( my_length(["a","b","c"], N), N = 3 -> yes ; no ), !IO),
    check("my_length in-out: [] has length 0",
        ( my_length([], N0), N0 = 0 -> yes ; no ), !IO),
    my_length(SomeList : list(string), 0),
    check("my_length out-in: length-0 list is []",
        ( SomeList = [] -> yes ; no ), !IO).
