:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- type color ---> red ; green ; blue ; yellow.

:- implementation.

% C enum definition that backs the Mercury type.
:- pragma foreign_decl("C", "
    typedef enum {
        COLOR_RED,
        COLOR_GREEN,
        COLOR_BLUE,
        COLOR_YELLOW
    } color_t;
").

% FIX: add the missing constructor `yellow' to the foreign_enum mapping.
% Every constructor of the type must have a corresponding foreign value.
:- pragma foreign_enum("C", color/0,
    [red    - "COLOR_RED",
     green  - "COLOR_GREEN",
     blue   - "COLOR_BLUE",
     yellow - "COLOR_YELLOW"]).

main(!IO) :-
    io.write_string("done\n", !IO).
