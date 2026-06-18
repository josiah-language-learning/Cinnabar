:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module int.
:- import_module list.
:- import_module string.

% my_length: two modes.
%   (in, out) — count the list: det
%   (out, in) — generate a list of the given length: det
:- pred my_length(list(int), int).
:- mode my_length(in, out) is det.
:- mode my_length(out, in) is det.
:- pragma promise_equivalent_clauses(my_length/2).

my_length(List::in, Len::out) :-
    Len = 0,        % stub: compute actual length
    _ = List.
my_length(List::out, Len::in) :-
    List = [],      % stub: generate list of Len zeros
    _ = Len.

% my_append: three modes.
%   (in, in, out) — concatenate: det
%   (in, out, in) — split prefix: semidet
%   (out, out, in) — enumerate all splits: multi
:- pred my_append(list(T), list(T), list(T)).
:- mode my_append(in, in, out) is det.
:- mode my_append(in, out, in) is semidet.
:- mode my_append(out, out, in) is multi.
:- pragma promise_equivalent_clauses(my_append/3).

my_append(A::in, B::in, C::out) :-
    C = A,          % stub: should produce A ++ B
    _ = B.
my_append(A::in, B::out, C::in) :-
    B = C,          % stub: should extract suffix after A
    _ = A.
my_append(A::out, B::out, C::in) :-
    A = [],         % stub: should enumerate all splits of C
    B = C.

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    my_length([1,2,3], Len),
    check("length [1,2,3] = 3", ( Len = 3 -> yes ; no ), !IO),
    my_length(Zeros, 3),
    check("generate length-3 list", ( list.length(Zeros) = 3 -> yes ; no ), !IO),
    my_append([1,2], [3,4], Cat),
    check("append [1,2] [3,4] = [1,2,3,4]",
          ( Cat = [1,2,3,4] -> yes ; no ), !IO),
    ( my_append([1,2], Suf, [1,2,3,4]) ->
        check("split prefix [1,2]", ( Suf = [3,4] -> yes ; no ), !IO)
    ;
        check("split prefix [1,2]", no, !IO)
    ).
