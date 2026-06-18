# 02 — Solver types: reference kata

**Reference only — no working build expected.** Solver types require an external CLP engine
not bundled with Mercury. This kata explains the concept and gives you the vocabulary to
work with external resources.

---

## What are solver types?

Mercury's type system includes a hook for *constraint logic programming* (CLP): the ability
to work with partially-known values that satisfy constraints, rather than fully-instantiated
values.

A solver type is declared with `:- solver type`. The `any` inst represents "constrained but
not fully determined."

```mercury
:- solver type clp_int
    where
        representation is int,
        ground is ground,
        any is any,
        constraint_store is clpfd_store.
```

The `any` inst allows a variable to be in the constraint store — it has a "known to satisfy
constraints" status, not fully ground.

---

## The `any` inst

Normal Mercury: a variable is either `free` (unbound) or `ground` (fully instantiated).

With solver types: a variable can also be `any` — in the constraint store with some
constraints applied, but not yet uniquely determined. Goals that work with `any` values
can propagate constraints without knowing the final value.

```mercury
:- mode (in(any), in(any), out(any)) is det.
```

---

## The `.tr` grade

The *trailing* grade (`.tr`) enables Mercury's undo mechanism — when a branch fails, the
runtime undoes all constraint store modifications made in that branch. Without trailing,
solver types cannot roll back constraint store updates on backtracking.

```
hlc.gc.tr
asm_fast.gc.tr
```

---

## What a CLP(FD) integration looks like

A typical CLP(FD) library for Mercury would provide:
```mercury
:- pred (#=)(clp_int::in(any), clp_int::in(any)) is det.
:- pred (#<)(clp_int::in(any), clp_int::in(any)) is semidet.
:- pred domain(clp_int::in(any), int::in, int::in) is det.
:- pred labeling(list(clp_int)::in(list_skel(any)), list(int)::out) is nondet.
```

The send-more-money problem would look like:
```mercury
solve(S, E, N, D, M, O, R, Y) :-
    domain([S, E, N, D, M, O, R, Y], 0, 9),
    S #\= 0, M #\= 0,
    1000*S + 100*E + 10*N + D + 1000*M + 100*O + 10*R + E
        #= 10000*M + 1000*O + 100*N + 10*E + Y,
    labeling([S, E, N, D, M, O, R, Y]).
```

---

## External resources

- Mercury standard library: `library/solver_builtin.m` — the hook definitions
- MercuryCLP: search for Mercury CLP bindings on GitHub (availability varies)
- SWI-Prolog CLP(FD) documentation is conceptually equivalent and widely available

---

## What this unlocks

Understanding solver types explains why Mercury's mode system has the `any` inst — it is
not a general "unknown" but specifically the "constrained but not determined" state for CLP.
This clarifies several mode system design choices that otherwise seem arbitrary.
