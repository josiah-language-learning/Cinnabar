# 02 — DCG goals: `{...}` semantic actions

**Concept:** `{Goal}` escaping in DCG rules, why plain `(Goal)` fails, calling regular
Mercury predicates inside grammar rules

**Not in the Mercury tutorial.**

---

## The problem

Inside a DCG rule, everything is implicitly threaded through the hidden list-difference
arguments. A plain Mercury goal — something that does not consume input — confuses the
DCG expansion if written as `(Goal)`.

The fix: `{Goal}` tells the DCG transformer "this is a regular Mercury goal, not a
grammar rule — do not thread list arguments through it."

---

## What you will build

A tokenizer that parses a string character by character, using `{...}` for Mercury goals
inside DCG rules.

### The setup

```mercury
:- pred digit(char, list(char), list(char)).
:- mode digit(out, in, out) is semidet.

digit(C) --> [C], { char.is_digit(C) }.
```

`[C]` consumes one character from the input. `{ char.is_digit(C) }` checks a condition
on the consumed character without consuming more input. The `{}` tells the DCG expansion
that `char.is_digit(C)` is a regular call, not a grammar rule.

### Without `{}`

Try writing:
```mercury
digit_broken(C) --> [C], (char.is_digit(C)).
```

The DCG expander treats `(char.is_digit(C))` as a grammar rule call and passes the hidden
list arguments through it. `char.is_digit/1` does not have two extra `list(char)` arguments
— you get a type error or arity error.

### A number parser

```mercury
:- pred digits(list(char), list(char), list(char)).
:- mode digits(out, in, out) is semidet.

digits([D | Ds]) --> digit(D), digits(Ds).
digits([D]) --> digit(D).

:- pred number(int, list(char), list(char)).
:- mode number(out, in, out) is semidet.

number(N) --> digits(Cs), { string.from_char_list(Cs, Str), string.to_int(Str, N) }.
```

`{ string.from_char_list(Cs, Str), string.to_int(Str, N) }` contains two Mercury goals
joined by `,` inside a single `{}`. Both are regular Mercury calls that do not consume
input.

### A simple expression tokenizer

Extend to tokenize `"3+42-7"` into `[int_tok(3), plus, int_tok(42), minus, int_tok(7)]`.
Whitespace optional. Call your DCG rule directly — Mercury 22.01.8 does not provide
`phrase/2` or `phrase/3`. Instead call `token_list(Tokens, string.to_char_list(Input), _)`
where the third argument is the remainder (use `_` if you expect full consumption).

---

## Checkpoint

- `digit_broken` gives the expected type/arity error
- `digit` with `{}` compiles
- The number parser correctly extracts integers from a character list
- The tokenizer handles multi-digit numbers and operator characters
- You can state in one sentence: what does `{}` do in a DCG rule?
