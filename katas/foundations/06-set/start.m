:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module list.
:- import_module set.
:- import_module string.

:- type flag_cmd
    --->    turn_on(string)
    ;       turn_off(string)
    ;       check_flag(string).

:- pred set_flag(string::in, set(string)::in, set(string)::out) is det.
set_flag(_, Flags, Flags).   % stub: insert the flag

:- pred clear_flag(string::in, set(string)::in, set(string)::out) is det.
clear_flag(_, Flags, Flags).   % stub: delete the flag

:- pred has_flag(string::in, set(string)::in) is semidet.
has_flag(_, _) :- fail.   % stub: check membership

:- pred apply_cmd(flag_cmd::in, set(string)::in, set(string)::out,
                  io::di, io::uo) is det.
apply_cmd(turn_on(F),    !Flags, !IO) :- set_flag(F, !Flags).
apply_cmd(turn_off(F),   !Flags, !IO) :- clear_flag(F, !Flags).
apply_cmd(check_flag(F), !Flags, !IO) :-
    ( has_flag(F, !.Flags) ->
        io.format("flag %s: present\n", [s(F)], !IO)
    ;
        io.format("flag %s: absent\n", [s(F)], !IO)
    ).

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    set_flag("a", set.init, S1),
    check("set_flag: a is now present",
        ( has_flag("a", S1) -> yes ; no ), !IO),
    check("set_flag: b not yet present",
        ( \+ has_flag("b", S1) -> yes ; no ), !IO),
    clear_flag("a", S1, S2),
    check("clear_flag: a is now absent",
        ( \+ has_flag("a", S2) -> yes ; no ), !IO),
    check("has_flag: absent on empty set",
        ( \+ has_flag("z", set.init) -> yes ; no ), !IO),
    % Drive with a command sequence and check foldl behaviour.
    Cmds = [turn_on("x"), turn_on("y"), check_flag("x"),
            turn_off("x"), check_flag("x"), check_flag("y")],
    io.write_string("\nCommand sequence output:\n", !IO),
    list.foldl2(apply_cmd, Cmds, set.init, FinalFlags, !IO),
    check("after sequence: x is off",
        ( \+ has_flag("x", FinalFlags) -> yes ; no ), !IO),
    check("after sequence: y is on",
        ( has_flag("y", FinalFlags) -> yes ; no ), !IO).
