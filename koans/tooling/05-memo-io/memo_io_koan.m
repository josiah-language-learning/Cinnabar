:- module memo_io_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module string.

% BUG: pragma memo cannot be applied to predicates with unique-mode arguments.
% io::di is a unique mode — the IO token is consumed destructively.
% The tabling infrastructure requires inputs to be ground values that
% can be compared for equality; a unique IO state is neither groundable
% nor comparable.
:- pragma memo(greet/3).
:- pred greet(string::in, io::di, io::uo) is det.
greet(Name, !IO) :-
    io.write_string("Hello, " ++ Name ++ "!\n", !IO).

main(!IO) :-
    greet("world", !IO),
    greet("Mercury", !IO).
