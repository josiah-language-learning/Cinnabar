# 07 — Exceptions: `io.res`, `exception`, file I/O

**Concept:** `io.res(T)`, `io.open_input`, pattern-matching error values, `exception.throw`,
`exception.catch_any`, the resource-cleanup obligation

**Not in the Mercury tutorial.**

---

## What you will build

Two exercises in one directory (two `.m` files or two sections in one file):

**Exercise A — file line counter:** open a file, count lines, close it, handle errors
at each step.

**Exercise B — throw and catch:** deliberately throw a `software_error`, catch it, and
continue.

---

## Exercise A: File line counter

### The `io.res` type

```mercury
:- type io.res(T)
    --->    ok(T)
    ;       error(io.error).
```

`io.open_input` returns `io.res(io.text_input_stream)`. You must pattern-match on it:

```mercury
io.open_input(Filename, Res, !IO),
(
    Res = ok(Stream),
    count_lines(Stream, 0, Count, !IO),
    io.close_input(Stream, !IO),
    io.format("Lines: %d\n", [i(Count)], !IO)
;
    Res = error(Err),
    io.format("Error: %s\n", [s(io.error_message(Err))], !IO)
).
```

### The cleanup obligation

In the `ok` branch, you call `io.close_input` after reading. What if `count_lines` throws
an exception partway through? The stream leaks. For now, accept this limitation — Mercury
does not have `finally` blocks. The proper fix uses `exception.try_io` and is shown at the
bottom of this kata.

Write `count_lines/5`:
```mercury
:- pred count_lines(
    io.text_input_stream::in,
    int::in, int::out,
    io::di, io::uo) is det.
```

Use `io.read_line_as_string` which returns `io.result(string)` — a three-way variant:
`ok(Line)`, `eof`, `error(Err)`.

### The resource-safe version

Use `exception.try_io` to run the counting in a try-block, then close the stream
regardless of whether an exception was thrown:

```mercury
io.open_input(Filename, Res, !IO),
( Res = ok(Stream) ->
    exception.try_io(count_lines(Stream, 0), Outcome, !IO),
    io.close_input(Stream, !IO),
    (
        Outcome = succeeded(Count),
        io.format("Lines: %d\n", [i(Count)], !IO)
    ;
        Outcome = exception(E),
        io.format("Error during read: %s\n",
                  [s(string.string(univ_value(E)))], !IO)
    )
;
    Res = error(Err),
    io.format("Cannot open: %s\n", [s(io.error_message(Err))], !IO)
).
```

---

## Exercise B: Throw and catch

```mercury
:- import_module exception.

:- pred risky_division(int::in, int::in, int::out) is det.
risky_division(_, 0, _) :-
    throw(software_error("division by zero")).
risky_division(A, B, A // B).

main(!IO) :-
    ( exception.try(risky_division(10, 0), Outcome) ->
        % this branch is wrong — try/3 doesn't work this way
        ...
    ).
```

Read `exception.catch_any/4` instead. Correct version:

```mercury
exception.catch_any(
    (pred(R::out) is det :- R = risky_division(10, 0)),
    (pred(E::in, R::out) is det :-
        io.format("caught: %s\n", [s(string.string(E))], !IO),
        R = -1),
    Result).
```

Note: `catch_any` catches _all_ Mercury exceptions including `software_error`. Use it for
testing and recovery; in production, prefer catching specific exception types.

---

## Checkpoint

- Exercise A: file line counter builds, counts correctly, prints an error message if the
  file does not exist
- Exercise B: `risky_division(10, 0)` is caught; program does not crash
- You can explain: why does Mercury not have `finally`, and what `try_io` gives you instead
