# 04 — Sillylist

**Concept:** functor/operator overloading — and its limits

> **Read this note before predicting.** This program is called "sillylist" for a reason.

---

## The warning

`sillylist.m` redefines the list constructors `[]` and `[T|Tail]` as `func`s that return `string`. This is a legal demonstration of Mercury's functor flexibility — you can define new meanings for operator-like symbols — but it is **not** how lists normally work in Mercury.

The standard `list(T)` type uses `[]` and `[H|T]` as type constructors, not as functions you call to get strings. The `list` module — `list.length`, `list.map`, `list.foldl`, and so on — operates on the real `list(T)`, not on this program's string-producing overloads.

Do not carry the pattern from this program forward as your mental model of Mercury lists.

**Before you open `sillylist.m`:** write down what you would expect a program that "overloads the list constructors as string-producing funcs" to look like. What would `[]` return? What would `[x|rest]` return?

---

## What to look for

After reading `sillylist.m`, locate where the *real* `list(T)` is defined and used in Mercury. The standard library reference at [mercurylang.org](https://mercurylang.org/information/doc-latest/mercury_library/list.html) is the authoritative source. The real list type has two constructors: `[]` (nil) and `[H|T]` (cons). These are data constructors, not functions — they build values of type `list(T)`, they do not produce strings.

## After reading

Could you say:
- What would happen if you tried to pass this program's `[]` result to `list.length`?
- What is the *actual* type of `[]` in the Mercury standard library?
