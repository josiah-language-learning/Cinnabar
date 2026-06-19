:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module list.
:- import_module string.

:- type direction ---> north ; south ; east ; west.

:- pred direction_name(direction::in, string::out) is det.
direction_name(Direction, Name) :-
    require_complete_switch [Direction]
    ( Direction = north, Name = "north"
    ; Direction = south, Name = "south"
    ; Direction = east,  Name = "east"
    ; Direction = west,  Name = "west"
    ).

main(!IO) :-
    direction_name(west, Name),
    io.format("Direction: %s\n", [s(Name)], !IO).
