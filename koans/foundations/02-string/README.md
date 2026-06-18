# Koan: code units vs codepoints

**Broken concept:** using `string.length` as a codepoint count on non-ASCII input

## Prerequisites

- `katas/foundations/03-string` — `string.length`, `string.count_codepoints`, UTF-8 encoding

---

`string.length` returns the number of *code units* (bytes in UTF-8 encoding), not
the number of *codepoints* or visible characters. For ASCII text they agree. For
text containing multi-byte characters (accented letters, CJK, emoji), they diverge.

---

## Try it

```
mmc --make --grade asm_fast.par.gc.stseg string_koan
./string_koan
```

This compiles without errors — the bug is a logic error, not a type error. The output
will be wrong for the non-ASCII test case.

---

## What to observe

The program uses `string.length` to decide where to truncate a string to 5 characters.
For `"hello"` (ASCII), it gives the correct result. For `"héllo"` (where `é` is 2 bytes
in UTF-8), it truncates at byte position 5, which falls inside the multi-byte `é` sequence.

---

## Your task

Fix the truncation to use `string.count_codepoints` for the length check and
`string.codepoint_offset` + `string.between` for the actual truncation.
