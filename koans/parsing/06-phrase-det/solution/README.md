# Solution

Declare `parse_digit` as `is semidet` and handle the failure case in `main`:

```mercury
:- pred parse_digit(string::in, char::out) is semidet.
parse_digit(Str, Digit) :-
    string.to_char_list(Str, Chars),
    digit_char(Digit, Chars, _).

main(!IO) :-
    ( parse_digit("7abc", D) ->
        io.write_char(D, !IO), io.nl(!IO)
    ;
        io.write_string("not a digit\n", !IO)
    ).
```

Determinism propagates from the grammar rule through every caller. `digit_char`
is `semidet` → `parse_digit` must be at least `semidet` → `main` must handle
the failure case explicitly with if-then-else.

A common design choice at this point is to wrap the parser in a `det` predicate
that returns `maybe(T)`:

```mercury
:- pred try_parse_digit(string::in, maybe(char)::out) is det.
try_parse_digit(Str, Result) :-
    ( parse_digit(Str, D) -> Result = yes(D) ; Result = no ).
```

This localises the semidet boundary and lets the rest of the program stay `det`.
