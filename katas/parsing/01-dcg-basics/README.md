# 01 — DCG basics: grammar rules and list input

**Concept:** DCG (Definite Clause Grammar) rules (`-->`), terminal symbols, alternatives,
the hidden list-difference argument, calling DCG rules directly

**Not in the Mercury tutorial.**

---

## Background

DCG rules are Mercury's built-in syntax for grammars. A rule like:

```mercury
expr --> term, [+], expr.
expr --> term.
```

desugars into a predicate with two hidden `list(T)` arguments — the input list before
parsing and the remainder after. Mercury expands `-->` rules at compile time; you never
write the difference arguments manually.

---

## What you will build

A parser for arithmetic token lists. Input is `list(token)`, output is an `expr` ADT.

### The token type

```mercury
:- type token ---> int_tok(int) ; plus ; minus ; times ; lparen ; rparen.
```

(You write a simple tokenizer separately, or just build token lists by hand for testing.)

### The expression ADT

```mercury
:- type expr ---> num(int) ; add(expr, expr) ; sub(expr, expr) ; mul(expr, expr).
```

### The grammar

```mercury
:- pred expr(expr, list(token), list(token)).
:- mode expr(out, in, out) is semidet.

expr(E) --> term(T), expr_rest(T, E).

expr_rest(T, add(T, E)) --> [plus], term(T2), expr_rest(T2, E).
expr_rest(T, sub(T, E)) --> [minus], term(T2), expr_rest(T2, E).
expr_rest(T, T) --> [].

term(num(N)) --> [int_tok(N)].
term(E) --> [lparen], expr(E), [rparen].
```

This is a left-recursive-safe grammar (right-recursive with an accumulator).

### Parsing

Call the DCG rule directly with explicit list arguments. Mercury expands `expr --> ...`
to `expr/3`, so you call it as:

```mercury
expr(E, [int_tok(3), plus, int_tok(4), times, int_tok(2)], [])
```

The final `[]` asserts that the entire token list was consumed. Mercury has no `phrase/2`
predicate in the standard library — that is a SWI-Prolog convention. In Mercury, DCG
rules are predicates; you call them directly.

### Important limitations

This grammar does not handle operator precedence — `3 + 4 * 2` parses as `(3 + 4) * 2`
or left-to-right depending on the rule order. Fixing precedence requires separate
`term`/`factor` levels — that is the puzzle in `puzzles/parsing/01-calculator`.

---

## Checkpoint

- `expr(E, Tokens, [])` parses a sum of integers correctly
- Parenthesised expressions parse correctly
- Tokens that do not match any rule leave the compiler's choice at the rule level (`semidet`)
- You can explain: what are the two hidden arguments in a DCG rule, and where do they come from?
