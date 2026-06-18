# 07 — Zookeeper Puzzle

**Concept:** `multi`/`det` mode pairs, `nondet` generate-and-test, `solutions/2`, `<=>` (biconditional), negation-as-failure

**Before you open the files:** this is the capstone of the reactivation pass. Write down what you remember about how Mercury handles search — specifically, what `nondet` means, how `solutions/2` collects results from a `nondet` predicate into a `det` list, and what "generate-and-test" means as a strategy.

---

## What to look for

### The `multi`/`det` mode pair

A predicate annotated `multi` has at least one solution and possibly more — it generates. The same predicate, called with all arguments bound, is `det` — it checks. Mercury's mode system tracks which variables are bound and which are free at each call site, and selects the right mode automatically. One predicate, two behaviors, zero runtime dispatch.

### `nondet` generate-and-test

The puzzle works by generating all possible assignments of attributes to houses (`nondet`, may fail many times) and testing each assignment against the constraints. Most candidates are pruned early by constraint failures. The survivors — if any — are the solutions.

This is the canonical logic programming idiom. In Prolog it relies on backtracking. In Mercury it is the same conceptually, but the determinism system makes it explicit: the generator is `nondet` or `multi`, the constraints are `semidet`, and wrapping the whole thing in `solutions/2` produces a `det` `list(T)`.

### `<=>` — biconditional

`<=>` is "if and only if" — `A <=> B` means A and B are both true or both false. Used in constraint predicates to express mutual dependencies between attributes.

### Negation-as-failure

`not(Goal)` or `\+(Goal)` succeeds when `Goal` fails. This is how Mercury expresses "X is not the case" — by trying to prove it and succeeding only when the attempt fails. It has limits (it cannot bind variables), but for constraint problems it is the right tool.

## After reading

Could you say:
- Why does wrapping a `nondet` predicate in `solutions/2` give you a `det` result?
- What would happen if you used `det` instead of `nondet` for the generator predicate?
- What is the limitation of negation-as-failure that makes it unsuitable for some kinds of reasoning?
