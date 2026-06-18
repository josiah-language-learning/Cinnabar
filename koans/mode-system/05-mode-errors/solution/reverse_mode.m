:- module reverse_mode.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module string.

% FIX: use string.int_to_string directly — it is the forward-only function
% for int-to-string conversion. There is no reverse mode for string_to_int;
% you must use the right predicate for the direction you need.
:- pred display_sum(int::in, io::di, io::uo) is det.
display_sum(Total, !IO) :-
    io.write_string("42 as string: " ++ string.int_to_string(42) ++ "\n", !IO),
    io.write_int(Total, !IO),
    io.nl(!IO).

main(!IO) :-
    display_sum(100, !IO).
