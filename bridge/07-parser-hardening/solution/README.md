# Solution notes

## Task 1: line number tracking

Add `int` state threaded through DCG rules using `!` notation:

```mercury
:- pred parse_csv(int, int, csv, list(char), list(char)).
:- mode parse_csv(in, out, out, in, out) is det.
parse_csv(!Line, Rows) -->
    ( row(Row) ->
        ( newline(!Line) ->
            parse_csv(!Line, Rest), { Rows = [Row | Rest] }
        ;
            { Rows = [Row] }
        )
    ;
        { Rows = [] }
    ).

:- pred newline(int, int, list(char), list(char)).
:- mode newline(in, out, in, out) is semidet.
newline(Line0, Line) -->
    ( ['\r'] ->
        ['\n'], { Line = Line0 + 1 }
    ;
        ['\n'], { Line = Line0 + 1 }
    ).
```

The `!Line` notation desugars to `Line0::in, Line::out` — the pre-state and
post-state of the counter. In DCG mode, these are extra arguments alongside the
hidden list pair. Each rule that calls `newline` must also thread `!Line`.

Update `parse` to return the final line number:
```mercury
:- func parse(string) = {csv, int}.
parse(Input) = {Rows, Lines} :-
    Chars = string.to_char_list(Input),
    parse_csv(1, FinalLine, Rows, Chars, _),
    Lines = FinalLine - 1.  % lines processed = last line number - 1
```

## Task 2: structured error reporting

```mercury
:- type parse_result(T) ---> ok(T) ; error(int, string).

:- func parse_checked(string) = parse_result(csv).
parse_checked(Input) = Result :-
    Chars = string.to_char_list(Input),
    parse_csv(1, _, Rows, Chars, Rest),
    ( Rest = [] ->
        Result = ok(Rows)
    ;
        Result = error(0, "unexpected content after last row")
    ).
```

For richer error reporting (missing closing quote), the `field` rule needs to return
a success/failure status rather than silently collapsing. The key design decision:

- A `semidet` DCG rule that fails on error gives the caller no location information.
- A `det` rule that returns `maybe(T)` carries the error value but complicates the
  grammar (every caller must handle `maybe`).
- Threading a `parse_result` through the DCG is the most complete approach but the
  most verbose.

Start with the simplest option: check `Rest` at the top level. If any input remains
unconsumed after parsing, report an error at the last successfully parsed line.

## Task 3: RFC 4180 edge cases

The current `newline` rule is correct for the CRLF and bare-LF cases. The bare-`\r`
fix: the `unquoted_chars` rule already excludes `\r` from field content:

```mercury
unquoted_chars(Cs) -->
    ( [C], { C \= (','), C \= ('\n'), C \= ('\r') } ->
        ...
```

A bare `\r` followed by anything other than `\n` will be consumed as content in the
current implementation — actually it's excluded from `unquoted_chars` but not from
`quoted_chars`. In quoted fields, `\r` should be allowed as content (RFC 4180 §2.6
permits literal CR inside quotes). Bare `\r` outside a quoted field is excluded
already.

The no-trailing-newline case: the current `parse_csv` rule returns `[Row]` when
`row(Row)` succeeds but `newline` fails. This is already correct — no change needed.

Test cases:
```mercury
T1 = "a,b\r\nc,d\r\n",        % CRLF — should parse to [[a,b],[c,d]]
T2 = "a,b\nc,d",               % LF, no trailing newline — should parse to [[a,b],[c,d]]
T3 = "\"field\nwith\nnewlines\",b\n",  % quoted field with embedded LF — valid RFC 4180
```
