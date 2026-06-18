:- module utils.
:- interface.

% BUG: import_module in the interface section re-exports string's names
% to all callers of utils. Use use_module here instead.
:- import_module string.

:- pred format_greeting(string::in, string::out) is det.

:- implementation.

format_greeting(Name, Greeting) :-
    Greeting = "Hello, " ++ Name ++ "!".
