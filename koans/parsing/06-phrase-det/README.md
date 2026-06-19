# Koan: DCG rules inherit determinism — a semidet rule makes the caller semidet

**Broken concept:** declaring the caller of a semidet DCG rule `det`

## Prerequisites

- `katas/parsing/01-dcg-basics` — DCG rules, determinism basics
- `koans/parsing/04-dcg-nondet` — DCG rule determinism

---

```
mmc phrase_det_koan.m
```

```
error: determinism declaration not satisfied.
  Declared `det', inferred `semidet'.
  Call to `digit_char'(out, in, out) can fail.
```

---

## What to observe

`digit_char` is `semidet` — it consumes one character from the input list only
if that character is a decimal digit. If the input is empty, or the first char
is not a digit, the rule fails.

Calling a `semidet` predicate from a `det` context is a determinism error.
`parse_digit` is declared `det` but its body contains a call that can fail.
Mercury infers `semidet` and rejects the declaration.

The fix has two parts:
1. Declare `parse_digit` as `is semidet`.
2. Handle the possible failure at the call site (with if-then-else or
   by making the call site also semidet).

Determinism is not just a property of the DCG rule — it propagates to every
predicate in the call chain. If your grammar can fail, plan for failure all the
way up to `main`.

---

## Your task

Change `parse_digit`'s declaration from `is det` to `is semidet`. Then update
`main` to handle the case where `parse_digit` fails.
