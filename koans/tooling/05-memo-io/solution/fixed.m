:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module string.

% FIX: remove pragma memo — greet cannot be tabled because it threads
% io::di (unique input). Use pragma loop_check if you want cycle detection
% on a recursive predicate without IO, or rethink the design.
:- pred greet(string::in, io::di, io::uo) is det.
greet(Name, !IO) :-
    io.write_string("Hello, " ++ Name ++ "!\n", !IO).

main(!IO) :-
    greet("world", !IO),
    greet("Mercury", !IO).
