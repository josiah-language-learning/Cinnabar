# Determinism

Mercury's determinism system is the other half of the mode system. It classifies every
predicate by how many solutions it can have and whether it can fail. The six categories
form a lattice; the compiler checks that callers respect the constraints imposed by callees.

| Kata | Topic |
|---|---|
| `01-six-categories/` | One predicate per determinism class: det, semidet, multi, nondet, erroneous, failure |
| `02-committed-choice/` | `cc_multi`/`cc_nondet`, `promise_equivalent_solutions`, `main/2` as `cc_multi` |
| `03-scope-annotations/` | `require_complete_switch`, `require_det`, catching missing cases at compile time |
| `07-promise-equiv-solutions/` | `promise_equivalent_solutions [Var]` (commit to one cc_nondet result) and `[!:IO]` (spawn in det predicate) |

**Tutorial cross-reference:** Mercury Tutorial §3 covers `det`/`semidet`/`nondet`. This
track names and exercises all six categories and covers the committed-choice subset, which
the tutorial does not address.
