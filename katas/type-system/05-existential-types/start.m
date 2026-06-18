:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module float.
:- import_module list.
:- import_module string.

% Reuse the printable typeclass from 04-type-classes (inlined here).
:- typeclass printable(T) where [
    pred print_item(T::in, io::di, io::uo) is det
].

:- type point ---> point(x :: float, y :: float).

:- instance printable(int) where [
    pred(print_item/3) is print_int
].
:- pred print_int(int::in, io::di, io::uo) is det.
print_int(N, !IO) :- io.format("%d", [i(N)], !IO).

:- instance printable(string) where [
    pred(print_item/3) is print_str
].
:- pred print_str(string::in, io::di, io::uo) is det.
print_str(S, !IO) :- io.write_string(S, !IO).

:- instance printable(point) where [
    pred(print_item/3) is print_point
].
:- pred print_point(point::in, io::di, io::uo) is det.
print_point(point(X, Y), !IO) :- io.format("(%.2f, %.2f)", [f(X), f(Y)], !IO).

% Existential type: a heterogeneous container for any printable value.
:- type any_printable
    --->    some [T] wrap(T) => printable(T).

:- func wrap_int(int) = any_printable.
wrap_int(_N) = 'new wrap'(0).   % stub: 'new wrap'(N)

:- func wrap_str(string) = any_printable.
wrap_str(_S) = 'new wrap'("").   % stub: 'new wrap'(S)

:- func wrap_point(point) = any_printable.
wrap_point(_P) = 'new wrap'(point(0.0, 0.0)).   % stub: 'new wrap'(P)

% Unwrap and dispatch to the correct print_item.
:- pred print_any(any_printable::in, io::di, io::uo) is det.
print_any(_AP, !IO).   % stub: pattern-match on wrap(V), call print_item(V, !IO)

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    Items = [
        wrap_int(42),
        wrap_str("hello"),
        wrap_point(point(1.5, 2.5))
    ],
    io.write_string("Heterogeneous list output:\n", !IO),
    list.foldl(
        (pred(AP::in, !.IO::di, !:IO::uo) is det :-
            print_any(AP, !IO), io.nl(!IO)),
        Items, !IO),
    check("list has 3 elements",
        ( list.length(Items) = 3 -> yes ; no ), !IO).
    % The key test is visual: each element should print in its own format.
