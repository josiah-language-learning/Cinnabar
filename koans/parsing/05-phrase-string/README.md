# Koan: DCG rules operate on `list(char)`, not `string`

**Broken concept:** passing a `string` directly to a DCG rule expecting `list(char)`

## Prerequisites

- `katas/parsing/01-dcg-basics` — DCG hidden arguments, list input

---

```
mmc phrase_string_koan.m
```

```
type error: variable `Input' has type `string',
  expected type was `list.list(character)'.
```

---

## What to observe

DCG rules defined with `-->` desugar to predicates with two hidden `list(T)`
arguments — the input list before consumption and the remainder after. A rule
declared `word_chars(out, in, out) is det` expects a `list(char)` as its second
argument, not a `string`.

`string` and `list(char)` are distinct types in Mercury. A string literal like
`"hello"` has type `string`; passing it where `list(char)` is expected is a type
error at every call site.

The conversion is `string.to_char_list(S, Chars)` or the functional form
`Chars = string.to_char_list(S)`. Every DCG parser that accepts a string as input
must perform this conversion before invoking the grammar.

---

## Your task

Add a `string.to_char_list` call in `first_word` and pass the resulting
`list(char)` to `word_chars`.
