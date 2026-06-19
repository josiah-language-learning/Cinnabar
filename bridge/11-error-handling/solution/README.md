# Solution notes

## Task 1: `maybe` chaining

```mercury
:- func email_domain(user) = maybe(string).
email_domain(U) = Domain :-
    ( U^email = yes(E),
      string.sub_string_search(E, "@", Pos)
    ->
        Domain = yes(string.right(E, string.length(E) - Pos - 1))
    ;
        Domain = no
    ).

:- func contact_handle(user) = maybe(string).
contact_handle(U) = Handle :-
    ( U^username \= "(unknown)",
      email_domain(U) = yes(Domain)
    ->
        Handle = yes(U^username ++ "@" ++ Domain)
    ;
        Handle = no
    ).
```

`email_domain` uses an if-then-else with a conjunction in the condition: both the email
field must be present *and* the `@` search must succeed. Either failure sends it to the
else branch (`no`).

`contact_handle` chains on top: if `contact_handle` returns `no`, the caller gets `no`
without needing to inspect the intermediate steps. This is `maybe`'s key property —
absent propagates without case analysis at every stage.

---

## Task 2: Custom error type

```mercury
:- type validation_error
    --->    missing_username
    ;       invalid_email(string)
    ;       invalid_age(int).

:- type validation_result(T)
    --->    ok(T)
    ;       error(validation_error).

:- func validate_user(user) = validation_result(user).
validate_user(U) = Result :-
    ( U^username = "(unknown)" ->
        Result = error(missing_username)
    ; U^email = yes(E), not string.contains_char(E, '@') ->
        Result = error(invalid_email(E))
    ; U^age = yes(A), A =< 0 ->
        Result = error(invalid_age(A))
    ;
        Result = ok(U)
    ).

:- func describe_validation_error(validation_error) = string.
describe_validation_error(missing_username) = "username required".
describe_validation_error(invalid_email(E)) = "invalid email: " ++ E.
describe_validation_error(invalid_age(A))  =
    "invalid age: " ++ string.int_to_string(A).
```

In `main`, pattern-match on `validation_result`:

```mercury
list.foldl(
    (pred(Fields::in, !.IO::di, !:IO::uo) is det :-
        parse_user(Fields, U),
        ( validate_user(U) = ok(Valid) ->
            io.write_string(display_user(Valid) ++ "\n", !IO)
        ; validate_user(U) = error(Err) ->
            io.write_string("Skipped: " ++ describe_validation_error(Err) ++ "\n", !IO)
        ;
            true
        )
    ),
    Rows, !IO).
```

The custom error type is better than `maybe(user)` here because the downstream code
can distinguish `missing_username` from `invalid_email` — it can report the problem,
log it, or route to different handlers. With `maybe`, the distinction is gone.

---

## Task 3: `io.res` file loading

```mercury
:- pred load_users(string::in, io.res(list(user))::out,
    io::di, io::uo) is det.
load_users(Filename, Result, !IO) :-
    io.open_input(Filename, OpenResult, !IO),
    (
        OpenResult = ok(Stream),
        read_lines(Stream, RevLines, !IO),
        io.close_input(Stream, !IO),
        Lines = list.reverse(RevLines),
        NonEmpty = list.filter(pred(L::in) is semidet :- L \= "", Lines),
        Users = list.map(parse_line, NonEmpty),
        Result = ok(Users)
    ;
        OpenResult = error(Err),
        Result = error(Err)
    ).

:- pred read_lines(io.text_input_stream::in, list(string)::out,
    io::di, io::uo) is det.
read_lines(Stream, Lines, !IO) :-
    io.read_line_as_string(Stream, LineResult, !IO),
    (
        LineResult = ok(Line),
        read_lines(Stream, Rest, !IO),
        Lines = [string.rstrip(Line) | Rest]
    ;
        LineResult = eof,
        Lines = []
    ;
        LineResult = error(_),
        Lines = []
    ).

:- func parse_line(string) = user.
parse_line(Line) = U :-
    Parts = string.split_at_char(',', Line),
    Pairs = list.filter_map(
        (pred(S::in, K - V::out) is semidet :-
            string.split_at_char('=', S) = [K, V]
        ),
        Parts),
    parse_user(Pairs, U).
```

Usage in `main`:

```mercury
load_users("users.txt", LoadResult, !IO),
(
    LoadResult = ok(Users),
    list.foldl(
        (pred(U::in, !.IO::di, !:IO::uo) is det :-
            io.write_string(display_user(U) ++ "\n", !IO)
        ),
        Users, !IO)
;
    LoadResult = error(Err),
    io.write_string("Error: " ++ io.error_message(Err) ++ "\n", !IO)
).
```

`io.res(T)` is right here because `io.open_input` can fail with "no such file",
"permission denied", etc. These are OS-level strings. `maybe` would lose that
information; `io.res` carries it as `io.error`, and `io.error_message/1` retrieves it.

---

## When to use which

| Mechanism | Use when | Example |
|---|---|---|
| `maybe(T)` | Absence is normal; reason doesn't matter | Optional config fields |
| Custom error type | Failure has structured reasons the caller acts on | Validation with multiple failure modes |
| `io.res(T)` | IO can fail with an OS-level error message | File open, network connect |
| Exception (`error/1`, `throw`) | Invariant violation — should not happen in correct code | Missing required field in already-validated data |

The key question: **does the caller need to know why it failed, and can they recover?**

- No reason needed, absence is ok → `maybe`
- Reason matters, caller handles it → custom error type or `io.res`
- Should never fail in correct usage → exception

Avoid using exceptions for recoverable failures — they bypass the type system's
enforcement that you handle the error case.
