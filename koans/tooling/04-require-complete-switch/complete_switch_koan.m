:- module complete_switch_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module list.
:- import_module string.

:- type direction ---> north ; south ; east ; west.

% Convert a direction to its display name.
%
% BUG: east and west are not handled. Without require_complete_switch this
% would be a vague determinism mismatch on direction_name's det declaration.
% With the pragma the error is local and names the missing constructors.
:- pred direction_name(direction::in, string::out) is det.
direction_name(Direction, Name) :-
    require_complete_switch [Direction]
    ( Direction = north, Name = "north"
    ; Direction = south, Name = "south"
    % east and west missing
    ).

main(!IO) :-
    direction_name(west, Name),
    io.format("Direction: %s\n", [s(Name)], !IO).
