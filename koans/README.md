# Koans

Each koan is a small Mercury program with one specific flaw. The flaw is real — the
compiler catches it. Your task: read the error, understand why it occurs, and fix it.

The `solution/` subdirectory contains the corrected code and an explanation. Resist
looking until you have read the error and formed a hypothesis.

## Structure of each koan

```
01-koan-name/
  README.md        ← what to look for and what the compiler says
  koan.m           ← broken code
  solution/
    README.md      ← explanation of the fix
    fixed.m        ← corrected code
```

## Tracks

| Track | Koans |
|-------|-------|
| `foundations/` | 01-maybe, 02-string, 03-higher-order, 04-modules, 05-exceptions, 06-file-io, 07-built-in-types |
| `type-system/` | 01-adt, 02-typeclass, 03-abstract, 04-parametric |
| `mode-system/` | 01-inst, 02-inference, 03-higher-order-inst |
| `determinism/` | 01-det-mismatch, 02-nondet-in-det, 03-committed-choice |
| `parsing/` | 01-dcg-goals, 02-dcg-mixed |
| `tooling/` | 01-grade (text only) |
| `concurrency/` | 01-parallel |
| `advanced/` | 01-ffi |
