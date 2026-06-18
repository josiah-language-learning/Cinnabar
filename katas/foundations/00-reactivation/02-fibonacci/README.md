# 02 — Fibonacci

**Concept:** recursive `det` predicate, if-then-else expression form

**Before you open `fib.m`:** write down how you would write a recursive Fibonacci in Mercury — specifically, which determinism annotation you would use and why, and whether you would write it as a `pred` or a `func`.

---

## What to look for

A `det` predicate always succeeds exactly once. Fibonacci is a total function over non-negative integers with a single result, so `det` is the right annotation — any other annotation would be lying to the compiler about what the predicate actually does.

Notice the if-then-else form. Mercury's if-then-else is an expression, not a statement: `( Cond -> Then ; Else )`. This is different from Prolog's cut-based idiom. The parentheses and the `->` and `;` are all part of the same expression.

## After reading

Could you say:
- Why would `semidet` be wrong here? What would it claim about Fibonacci that isn't true?
- What happens if you annotate a `det` predicate as `semidet` — does Mercury accept it, reject it, or warn?

---

> **Tutorial cross-reference:** Mercury Tutorial §3–4 covers recursive predicates and determinism
> annotations. This exercise uses a different problem (Fibonacci vs. the tutorial's examples) but
> drills the same `det` + if-then-else idiom. If the expression form of if-then-else (`( Cond -> Then ; Else )`)
> is unfamiliar, §3 has a clear walkthrough.
