# Koan: stateful DCG — variable not threaded through all branches

**Broken concept:** a disjunction inside a stateful DCG rule binds output variables
in one branch but not the other — the unthreaded state variable is left free

## Prerequisites

- `katas/parsing/07-stateful-dcg` — threading extra state arguments through DCG rules
- `katas/parsing/04-dcg-determinism` — why disjunction infers `nondet`; if-then-else for `semidet`

---

In a stateful DCG rule, extra arguments thread state through every rule call. When the
rule body contains a disjunction, **every branch** must bind every output variable —
including the threaded state variables. A branch that updates one counter but ignores
another leaves that variable free, which Mercury catches as a mode mismatch.

---

## Try it

```
mmc --make --grade asm_fast.par.gc.stseg stateful_koan
```

The error:

```
In clause for `item(in, out, in, out)':
  mode mismatch in disjunction.
  The variable `A' is ground in some branches but not others.
    In this branch, `A' is ground.
    In this branch, `A' is free.
```

---

## What to observe

`item` tracks two counters: `A` (alphabetic chars) and `D` (digit chars). The alpha
branch binds both. The digit branch updates `D` but never mentions `A` — so `A` is free
in that branch. Mercury requires every output variable to be bound in every branch of a
disjunction.

The error points at the `item` clause, not the disjunction branch directly — reading
the line numbers it gives (`In this branch... In this branch...`) reveals which branch
is missing the binding.

---

## Your task

Fix `item` so that both branches bind `A` and `D`. Two changes are needed:

1. Thread `A` through the digit branch unchanged: `A = A0`.
2. Switch the disjunction to if-then-else — a plain `;` disjunction infers `nondet`
   because Mercury cannot tell at compile time that the two character tests are
   mutually exclusive. If-then-else commits to the first matching branch and allows
   `semidet` inference.

The solution shows the idiomatic pattern for branching in stateful DCG rules.
