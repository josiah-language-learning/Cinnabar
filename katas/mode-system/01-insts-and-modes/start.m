:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module int.
:- import_module list.
:- import_module maybe.
:- import_module string.

% User-defined inst: restricts which face values are valid die rolls.
:- inst die_face == bound(1 ; 2 ; 3 ; 4 ; 5 ; 6).

% present(T): inst for a maybe(T) that is definitely 'yes'.
:- inst present(I) == bound(yes(I)).

% roll_die: produce a value with inst die_face.
% The mode annotation guarantees the output satisfies the inst.
:- pred roll_die(int::out(die_face)) is det.
roll_die(1).   % stub: just return 1 for now; real version uses random

% require_present: extract the value from a yes(_) maybe.
% The mode annotation expresses that the caller guarantees it is 'yes'.
:- pred require_present(maybe(T)::in(present(ground)),
                        T::out) is det.
require_present(yes(X), X).
% No 'no' clause needed — the inst rules it out statically.

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    roll_die(D),
    check("die in 1..6", ( D >= 1, D =< 6 -> yes ; no ), !IO),
    require_present(yes(42), V),
    check("require_present yes(42) = 42", ( V = 42 -> yes ; no ), !IO),
    % Try: what happens if you pass 'no' to require_present?
    % The compiler will reject it — the inst mismatch is caught statically.
    io.write_string("Inst demo complete.\n", !IO).
