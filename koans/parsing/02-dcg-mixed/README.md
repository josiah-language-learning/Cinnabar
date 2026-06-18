# Koan: DCG and non-DCG predicate confusion

**Broken concept:** calling a DCG rule from a non-DCG context (or vice versa) without
understanding the hidden argument expansion

## Prerequisites

- `katas/parsing/01-dcg-basics` — DCG rules, hidden argument expansion
- `koans/parsing/01-dcg-goals` — `{Goal}` escaping inside DCG rules

---

DCG rules expand to predicates with two extra `list` arguments (the input and remainder
lists). When you call a DCG rule like a regular predicate without those arguments, or
call a regular predicate from a DCG rule as if it were a grammar rule, you get an
arity or type error.

---

## Try it

```
mmc --make --grade asm_fast.par.gc.stseg dcg_mixed_koan
```

The error will be about wrong arity: calling `words/2` when only `words/3` exists.

---

## What to observe

`words` is a DCG rule (defined with `-->`). Mercury expands it to `words/3` with two
hidden list arguments (input and remainder). `count_words` calls `words(Ws, Input)`,
which has the wrong arity.

---

## Your task

Fix `count_words` to call the DCG rule with its full arity — pass the input list and an
empty remainder:

```mercury
words(Ws, Input, [])
```

Mercury has no `phrase/2` predicate in the standard library. DCG rules are expanded at
compile time into regular predicates; you call them directly with the hidden args explicit.
