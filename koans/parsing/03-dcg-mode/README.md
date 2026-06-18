# Koan: wrong mode annotation on a DCG predicate

## Prerequisites
- `katas/parsing/01-dcg-basics`
- `koans/parsing/02-dcg-mixed`

A DCG rule `foo(X) --> ...` desugars to a predicate with two hidden arguments: the input list and the remaining list after consuming. The hidden state thread always has mode `in, out`.

Compile this:

```
mmc --make dcg_mode_koan
```

The mode checker rejects `token/3` with a mode error before generating any output.

---

The declaration:

```mercury
:- mode token(out, in, in) is semidet.
```

says the third argument is already instantiated when `token` is called. But the DCG expansion produces code that *binds* the third argument — it is an output, not an input. The mode system sees a mismatch.

Fix: the hidden threading arguments always go `in, out`:

```mercury
:- mode token(out, in, out) is semidet.
```

Every DCG predicate follows this pattern. The only exception is state threads using `di, uo` (for destructive update), which replaces `in, out` for unique state.

---

## What to observe

The error says something like "argument N has mode `in` but the body binds it." The
mode checker saw that the desugared DCG clause tries to produce a value the declaration
said was already ground. Try reading the desugared form mentally: what does `-->` expand
to, and what modes do the two hidden arguments have?

---

## Your task

Fix the mode declaration so the hidden threading arguments are `in, out`. Recompile.
As a follow-up: write the explicit (non-DCG) version of the same predicate to confirm
your mental model of what the DCG expands to.
