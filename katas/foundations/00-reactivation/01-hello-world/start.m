:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.

% The !IO token is unique: each IO predicate consumes the incoming token (di)
% and produces a fresh one (uo).  No two calls can share the same token.
main(!IO) :-
    io.write_string("Hello, Mercury!\n", !IO),
    % Each call below receives the fresh token produced by the previous call.
    io.write_string("IO token threaded: write_string 2\n", !IO),
    io.write_string("IO token threaded: write_string 3\n", !IO).
    % Reflection prompt: what would happen if you tried to use the IO token from
    % the first write_string call in the third write_string call directly?
