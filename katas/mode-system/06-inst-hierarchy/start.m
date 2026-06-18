:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module int.
:- import_module list.
:- import_module string.
:- import_module version_array.

% The inst hierarchy (simplified):
%
%   free      — completely uninstantiated
%   bound(f)  — bound to functor f, sub-insts may still be free
%   ground    — fully instantiated (= bound with all sub-insts ground)
%   unique    — ground AND the only live reference
%   clobbered — consumed (a unique value after being used destructively)
%
% Subtype: unique < ground < bound < free (in restrictiveness).
% Modes express how insts change: in = ground >> ground, out = free >> ground.

% Exercise 1: user-defined bound inst.
:- inst die_face == bound(1 ; 2 ; 3 ; 4 ; 5 ; 6).

:- pred roll(int::out(die_face)) is det.
roll(1).   % stub: return any value in 1..6

:- func double_face(int::in(die_face)) = (int::out) is det.
double_face(N) = N * 2.

% Exercise 2: parametric inst.
:- inst list_of(I) == bound([] ; [I | list_of(I)]).

:- func three_rolls = (list(int)::out(list_of(die_face))).
three_rolls = [1, 2, 3].

% Exercise 3: inst expressing a definitely-yes maybe.
:- type maybe_int ---> yes(int) ; no.
:- inst yes_int == bound(yes(ground)).

:- func unwrap_yes(maybe_int::in(yes_int)) = (int::out) is det.
unwrap_yes(yes(N)) = N.

% Exercise 4: version_array — persistent, no unique modes needed.
:- func make_va(int) = version_array(int).
make_va(Size) = version_array.init(Size, 0).

:- func va_with_two(version_array(int), int, int, int, int) = version_array(int).
va_with_two(VA, I1, V1, I2, V2) = VA2 :-
    VA1 = VA ^ elem(I1) := V1,
    VA2 = VA1 ^ elem(I2) := V2.

% all_in_range: check that all list elements satisfy lo =< X =< hi.
:- pred all_in_range(int::in, int::in, list(int)::in) is semidet.
all_in_range(Lo, Hi, Xs) :-
    list.filter(pred(X::in) is semidet :- (X < Lo ; X > Hi), Xs, Violations),
    Violations = [].

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    % Exercise 1.
    roll(Face),
    check("roll: in 1..6",
        ( Face >= 1, Face =< 6 -> yes ; no ), !IO),
    check("double_face 3 = 6",
        ( double_face(3) = 6 -> yes ; no ), !IO),
    % Exercise 2.
    Rolls = three_rolls,
    check("three_rolls has 3 elements",
        ( list.length(Rolls, 3) -> yes ; no ), !IO),
    check("three_rolls: all in 1..6",
        ( all_in_range(1, 6, Rolls) -> yes ; no ), !IO),
    % Exercise 3.
    check("unwrap_yes(yes(42)) = 42",
        ( unwrap_yes(yes(42)) = 42 -> yes ; no ), !IO),
    % Exercise 4.
    VA0 = make_va(5),
    VA1 = va_with_two(VA0, 1, 10, 3, 30),
    check("va_with_two: [1] = 10",
        ( version_array.lookup(VA1, 1) = 10 -> yes ; no ), !IO),
    check("va_with_two: [3] = 30",
        ( version_array.lookup(VA1, 3) = 30 -> yes ; no ), !IO),
    check("va_with_two: [0] = 0 (unchanged)",
        ( version_array.lookup(VA1, 0) = 0 -> yes ; no ), !IO),
    check("original VA0 unchanged after update",
        ( version_array.lookup(VA0, 1) = 0 -> yes ; no ), !IO).
