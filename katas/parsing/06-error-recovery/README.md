# 06 — Error recovery

**Concept:** structured parse errors as values; `parse_result(T)` ADT; `det` parsers
vs `semidet` parsers; error position tracking

**Not in the Mercury tutorial.**

---

## The problem with `semidet` parsers

A `semidet` parser that fails gives the caller no information:

```mercury
:- pred parse(list(char)::in, ast::out) is semidet.
parse(Input, _) :- ...    % fails silently on bad input
```

The caller gets `fail` and nothing else. No position, no message, no way to produce a
useful diagnostic.

---

## Parse results as values

Better: return a structured result, making failure explicit:

```mercury
:- type parse_result(T)
    --->    ok(T)
    ;       error(int, string).    % position, message
```

The parser is now `det` — it always returns *something*, and that something either
carries the parsed value or describes the problem:

```mercury
:- pred parse(list(char)::in, parse_result(ast)::out) is det.
```

---

## Error position tracking

Track the current position (character offset) explicitly through the parser. When an
unexpected character is encountered, include the position in the error:

```mercury
tokenize_acc([C | _Cs], Pos, _Acc,
             error(Pos, string.format("unexpected '%c' at %d", [c(C), i(Pos)])))
    :- \+ is_valid(C).
```

The position is propagated through the accumulator, incremented with each consumed
character.

---

## `det` vs `semidet`: a design choice

| Style | Top-level determinism | Error handling | Use when |
|---|---|---|---|
| `semidet` | fails on error | caller gets `fail` | composing into larger parsers that handle failure |
| `det` + `parse_result` | always succeeds | errors are values | user-facing entry point, error reporting |

A common pattern: the internal grammar rules are `semidet`, and the top-level entry
point wraps them in a `det` predicate that converts failure into an `error(Pos, Msg)`.

---

## Error recovery strategies

**Fail silently:** `semidet` — the simplest. The caller must handle failure.

**Return error values:** `det + parse_result` — what this kata builds.

**Panic mode:** on error, skip tokens until a known synchronization point (a `;` or
newline), then resume. Returns `ok` from the recovery point even if earlier input was
bad. Useful for reporting multiple errors in one pass.

---

## What you will build

### `tokenize`

Scan a `list(char)` into `list(token)`. On encountering an unexpected character,
return `error(Pos, Msg)` instead of failing.

The token type: `num(int) | plus | minus | times | divide | lparen | rparen`.

### `panic_mode`

On tokenize error, skip to the next `)` or end of input, then return `ok([])` from
that point. Demonstrates recovery without backtracking.

### `parse_expr`

A stub parser: always `det`, returns `ok(N)` if input starts with `num(N)`, otherwise
`error(0, "expected number")`.

---

## Checkpoint

- `tokenize("1 + 2")` returns `ok([num(1), plus, num(2)])`
- `tokenize("1 @ 2")` returns `error(2, ...)` with the position of `@`
- `parse_expr([num(42)])` returns `ok(42)`
- `parse_expr([])` returns `error(_, _)`
- You can state: what does `det + parse_result` buy you over `semidet`?
