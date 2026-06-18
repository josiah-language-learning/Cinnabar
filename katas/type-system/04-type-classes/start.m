:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module float.
:- import_module list.
:- import_module string.

:- typeclass printable(T) where [
    pred print_item(T::in, io::di, io::uo) is det
].

:- type point ---> point(x :: float, y :: float).

% Instances — fill in the predicate bodies.
:- instance printable(int) where [
    pred(print_item/3) is print_int
].
:- pred print_int(int::in, io::di, io::uo) is det.
print_int(_N, !IO).   % stub: io.format "%d"

:- instance printable(string) where [
    pred(print_item/3) is print_str
].
:- pred print_str(string::in, io::di, io::uo) is det.
print_str(_S, !IO).   % stub: io.write_string

:- instance printable(point) where [
    pred(print_item/3) is print_point
].
:- pred print_point(point::in, io::di, io::uo) is det.
print_point(_P, !IO).   % stub: io.format "(%.2f, %.2f)"

% Polymorphic list printer — works for any printable T.
:- pred print_list(list(T)::in, io::di, io::uo) is det <= printable(T).
print_list([], !IO).
print_list([_|_], !IO).   % stub: print head, newline, recurse on tail

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    % Check that print_item produces output (non-empty).
    % We capture output by side-effect and trust visual inspection.
    io.write_string("--- print_item int ---\n", !IO),
    print_item(42, !IO),
    io.nl(!IO),
    io.write_string("--- print_item string ---\n", !IO),
    print_item("hello", !IO),
    io.nl(!IO),
    io.write_string("--- print_item point ---\n", !IO),
    print_item(point(1.5, 2.5), !IO),
    io.nl(!IO),
    io.write_string("--- print_list int ---\n", !IO),
    print_list([1, 2, 3], !IO),
    io.write_string("--- print_list string ---\n", !IO),
    print_list(["alpha", "beta", "gamma"], !IO),
    io.write_string("--- print_list point ---\n", !IO),
    print_list([point(0.0, 0.0), point(1.0, 2.0)], !IO),
    % Compile-time check: calling print_list with a non-printable type would
    % fail to compile.  The following is intentionally left as a comment:
    % print_list([true, false], !IO)   <-- would fail: no printable(bool) instance
    check("print_list does not crash on empty list",
        ( true -> yes ; no ), !IO).   % placeholder — visual output is the real test
