# 03 — Strings: the UTF-8 gotcha and the standard idioms

**Concept:** `string.length`, `string.count_codepoints`, `string.words`, `string.join_list`,
`string.append`, `string.format`, the code-unit vs codepoint distinction

---

## What you will build

A word-wrap formatter. Input: a string and a column width. Output: the string re-wrapped so
that no line exceeds the column width, breaking only on word boundaries.

---

## The gotcha first

Open an interactive Mercury session or write a short test:

```mercury
:- import_module string.
S = "café",
N = string.length(S).
% What is N?
```

`string.length` returns the number of **code units** (bytes in UTF-8, characters in the
internal encoding), not the number of **codepoints** or grapheme clusters. For ASCII text
they are the same. For "café", the `é` is two bytes, so `string.length` returns 5, not 4.

For human-facing display widths, use `string.count_codepoints/1`. For indexing into
byte positions (e.g., for `string.between`), `string.length` is correct.

Note this before you start, because the word-wrap formatter should use
`string.count_codepoints` for measuring display width.

---

## Steps

### 1. Tokenize

```mercury
:- func wrap(string, int) = string.
```

Start by calling `string.words(Input)` to get a `list(string)` of words. Words are split
on whitespace; adjacent whitespace collapses.

### 2. Accumulate lines

Write a `foldl` over the word list. The accumulator holds:
- the current line (as a string or list of words)
- the list of completed lines

For each word:
- if adding it would push the current line over the column limit, flush the current line
  and start a new one with this word
- otherwise, append it (with a space separator)

Use `string.count_codepoints` for width measurement.

### 3. Assemble output

Use `string.join_list("\n", Lines)` to join completed lines. Ensure the last partial line
is included.

### 4. Test it

Run on:
```
"The quick brown fox jumps over the lazy dog"
```
at widths 20, 40, and 10. Verify line lengths.

Then test on a string containing non-ASCII characters (e.g., `"naïve café résumé"`)
at width 15. Verify the break point is based on visible characters, not bytes.

---

## Checkpoint

- Builds clean
- ASCII wrapping is correct at all tested widths
- Non-ASCII wrapping uses codepoint counts, not byte counts
- You can explain in one sentence when `string.length` is the right call and when
  `string.count_codepoints` is the right call

## Extra credit

Handle hard hyphens in long words: if a single word exceeds the column width, break it
with a hyphen. Use `string.to_char_list` and `string.from_char_list`.
