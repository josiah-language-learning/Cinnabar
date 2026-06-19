:- module error_patterns.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module assoc_list.
:- import_module list.
:- import_module maybe.
:- import_module pair.
:- import_module string.

% A user record parsed from raw key-value input.
% Fields that may legitimately be absent use maybe(T).
:- type user --->
    user(
        username :: string,
        email    :: maybe(string),
        age      :: maybe(int)
    ).

% parse_user/2: build a user from a key-value list.
% Missing optional fields become no.
% A missing username is left as "(unknown)" for now — we will revisit this.
:- pred parse_user(assoc_list(string, string)::in, user::out) is det.
parse_user(Fields, user(Username, Email, Age)) :-
    ( assoc_list.search(Fields, "username", U) ->
        Username = U
    ;
        Username = "(unknown)"
    ),
    ( assoc_list.search(Fields, "email", E) ->
        Email = yes(E)
    ;
        Email = no
    ),
    ( assoc_list.search(Fields, "age", S), string.to_int(S, N) ->
        Age = yes(N)
    ;
        Age = no
    ).

:- func display_user(user) = string.
display_user(U) = Str :-
    EmailStr = ( U^email = yes(E) -> " <" ++ E ++ ">" ; "" ),
    AgeStr   = ( U^age   = yes(A) ->
                     " (age " ++ string.int_to_string(A) ++ ")"
               ; "" ),
    Str = U^username ++ EmailStr ++ AgeStr.

main(!IO) :-
    Rows = [
        ["username" - "alice", "email" - "alice@example.com", "age" - "30"],
        ["username" - "bob",   "age" - "25"],
        ["username" - "carol"],
        ["email" - "ghost@example.com"]   % no username
    ],
    list.foldl(print_row, Rows, !IO).

:- pred print_row(assoc_list(string, string)::in, io::di, io::uo) is det.
print_row(Fields, !IO) :-
    parse_user(Fields, U),
    io.write_string(display_user(U) ++ "\n", !IO).
