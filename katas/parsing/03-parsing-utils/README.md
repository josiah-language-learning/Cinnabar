# 03 — `parsing_utils`: combinator-style parsing

**Concept:** `parsing_utils.whitespace`, `parsing_utils.next_char`, `parsing_utils.literal`,
`new_src_and_skip_whitespace`, parser state, error recovery

**Not in the Mercury tutorial.**

---

## Background

`parsing_utils` is Mercury's standard library for combinator-style string parsing. It
manages a `parsing_utils.state` (the current parse position) and provides predicates
that advance the state. No DCG — you call predicates directly.

Key predicates:
```mercury
parsing_utils.new_src_and_skip_whitespace(Str, Src)
    % creates initial state from a string, skipping leading whitespace

parsing_utils.whitespace(Src0, Src)
    % skip optional whitespace

parsing_utils.next_char(Src0, Ch, Src)
    % consume one character

parsing_utils.literal(Str, Src0, Src)
    % consume a specific string literal

parsing_utils.float_literal_as_string(Src0, Str, Src)
    % consume a float literal, return as string

parsing_utils.int_literal(Src0, N, Src)
    % consume an integer literal
```

All are `semidet` (they fail if the input does not match).

---

## What you will build

A parser for `key = value` config lines, returning `map(string, string)`.

### Config format

```
host = localhost
port = 8080
debug = true
```

No sections, no comments (those are the puzzle in `puzzles/parsing/03-config-parser`).

### Parsing one line

```mercury
:- pred parse_pair(string::in, pair(string, string)::out) is semidet.
parse_pair(Line, Key - Value) :-
    parsing_utils.new_src_and_skip_whitespace(Line, Src0),
    parse_key(Src0, Key, Src1),
    parsing_utils.whitespace(Src1, Src2),
    parsing_utils.literal("=", Src2, Src3),
    parsing_utils.whitespace(Src3, Src4),
    parse_value(Src4, Value, _Src5).
```

Write `parse_key` and `parse_value`:
- `parse_key`: consume characters while alphanumeric or `_`; use `next_char` in a loop
- `parse_value`: consume the rest of the line (all remaining characters until end)

### Parsing many lines

```mercury
:- pred parse_config(string::in, map(string, string)::out) is det.
parse_config(Input, Config) :-
    Lines = string.split_at_char('\n', Input),
    list.filter_map(parse_pair, Lines, Pairs),
    map.from_assoc_list(Pairs, Config).
```

### Reading from a file

Add a `main` that reads a config filename from command-line args, reads the file with
`io.read_file_as_string`, parses it, and prints the resulting map.

---

## Checkpoint

- Single `key = value` line parses correctly
- Multi-line config string parses to a correct `map`
- Lines that do not match `key = value` are silently skipped (via `filter_map`)
- File read + parse + print pipeline works end-to-end
- You can explain: what is the advantage of `parsing_utils` over a hand-written DCG
  for this kind of line-oriented input?
