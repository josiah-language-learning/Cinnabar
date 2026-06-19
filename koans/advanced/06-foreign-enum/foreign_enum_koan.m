:- module foreign_enum_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- type color ---> red ; green ; blue ; yellow.

:- implementation.

:- pragma foreign_decl("C", "
    typedef enum {
        COLOR_RED,
        COLOR_GREEN,
        COLOR_BLUE,
        COLOR_YELLOW
    } color_t;
").

% BUG: pragma foreign_enum must cover every constructor of the type.
% `yellow' is declared in the type but has no foreign value in the mapping.
% Mercury checks completeness at compile time — the same guarantee as
% require_complete_switch, but for C enum bindings.
:- pragma foreign_enum("C", color/0,
    [red - "COLOR_RED", green - "COLOR_GREEN", blue - "COLOR_BLUE"]).

main(!IO) :-
    io.write_string("done\n", !IO).
