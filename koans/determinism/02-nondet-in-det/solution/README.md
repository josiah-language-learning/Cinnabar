# Solution: use `solutions/2` to collect nondet results

`solutions/2` takes a `nondet` (or `multi`) predicate and collects all its solutions
into a sorted `list`, returning `det`:

```mercury
:- pred all_factors(int::in, list(int)::out) is det.
all_factors(N, Factors) :-
    solutions(find_factor(N), Factors).
```

`solutions(Pred, List)` runs `Pred` to completion with backtracking, collects every
solution it produces, sorts them (removing duplicates), and returns the result list.
The list may be empty. This is `det` — it always returns exactly one list.

## The containment rule

`nondet` and `multi` predicates can only be called from:
- Other `nondet`/`multi` predicates (propagates upward)
- `solutions/2`, `aggregate/4`, or similar collectors (contains the nondeterminism)
- A disjunction or if-then-else that provides the backtracking context

A `det` predicate is a "no backtracking" zone. The compiler enforces this.
