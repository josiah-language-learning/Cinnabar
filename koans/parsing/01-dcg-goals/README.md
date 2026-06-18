# Koan: DCG `(Goal)` instead of `{Goal}`

**Broken concept:** writing a plain Mercury goal inside a DCG rule without `{...}` escaping

## Prerequisites

- `katas/parsing/01-dcg-basics` — DCG rule syntax, `-->`, terminal symbols, `phrase/2`

---

In DCG rules, the `-->` notation automatically threads two hidden list-difference arguments
through every sub-goal. If you write `(char.is_digit(C))` inside a DCG rule, the DCG
expander treats it as a grammar call and tries to pass the hidden list arguments to
`char.is_digit` — which does not accept them.

---

## Try it

```
mmc --make --grade asm_fast.par.gc.stseg dcg_koan
```

The error will be an arity or type error: `char.is_digit` (which takes 1 argument)
is called with 3 arguments (the original + 2 hidden list-difference args).

---

## What to observe

The grammar rule tries to match a digit character and check `char.is_digit` on it. The
check is written as a plain call `(char.is_digit(C))`. The DCG expander passes through
two extra hidden arguments, making the call `char.is_digit(C, L0, L)` — wrong arity.

---

## Your task

Wrap the Mercury goal in `{...}`: `{ char.is_digit(C) }`. This tells the DCG expander
"this is a regular goal, do not thread list arguments through it."
