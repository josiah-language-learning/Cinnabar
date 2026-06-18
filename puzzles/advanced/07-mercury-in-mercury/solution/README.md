# Solution notes

## The core loop

`resolve` picks a clause from the program, renames its variables, unifies the
clause head with the current goal, then calls `solve` on the clause body.
`solve` loops through a list of goals, calling `resolve` for each one. Both are
`nondet` — backtracking over `list.member` in `resolve` is what generates
multiple solutions.

```mercury
resolve(prog(Clauses), Goal0, Depth, Env0, Env) :-
    deref(Goal0, Env0, Goal),
    list.member(Raw, Clauses),
    rename_clause(Raw, string.int_to_string(Depth), c(Head, Body)),
    unify(Goal, Head, Env0, Env1),
    solve(prog(Clauses), Body, Depth + 1, Env1, Env).
```

The `nondet` of `list.member` is the source of all nondeterminism. Mercury's
`solutions/2` forces `solve` to enumerate all branches and collect the resulting
environments.

## Unification: semidet by if-then-else

A two-clause `unify_d` with variable patterns is inferred `nondet`:

```mercury
unify_d(v(X), T, Env0, [X - T | Env0]).          % clause 1
unify_d(T, v(X), Env0, [X - T | Env0]) :- T \= v(_). % clause 2
```

When both arguments are variables, only clause 1 applies (clause 2's guard
`T \= v(_)` fails since the first arg IS a var). But Mercury can't prove the
mutual exclusion statically — it must assume both could apply, inferring `nondet`.

The fix: a single clause with if-then-else. Mercury commits to the first
matching branch:

```mercury
unify_d(D1, D2, Env0, Env) :-
    ( D1 = v(X) -> Env = [X - D2 | Env0]
    ; D2 = v(X) -> Env = [X - D1 | Env0]
    ; D1 = a(S), D2 = a(S) -> Env = Env0
    ; ...
    ; fail ).
```

This is `semidet` — exactly one branch fires, or the predicate fails.

## lookup_v: same multi-clause problem

```mercury
lookup_v(X, [X - T | _], T).           % can succeed if first key matches
lookup_v(X, [Y - _ | Rest], T) :- X \= Y, lookup_v(X, Rest, T).
```

Mercury infers `nondet` because when X matches the key in the first element,
both clauses can fire (clause 2 may also recurse). The guard `X \= Y` is
`semidet`, but Mercury doesn't prove that it's the logical negation of `X = Y`.

Fix: single-clause if-then-else:

```mercury
lookup_v(X, [Key - Val | Rest], T) :-
    ( X = Key -> T = Val ; lookup_v(X, Rest, T) ).
```

Semidet: succeeds at most once. ✓

## term_str: overlapping f/2 patterns → multi

Multiple function clauses matching `f/2` with different string literals in
the first argument:

```mercury
term_str(f("[]", [])) = "[]".
term_str(f("[|]", [H, T])) = ...
term_str(f(F, Args)) = ...   % catches everything else
```

Mercury cannot prove these patterns are mutually exclusive without evaluating
the string arguments — it infers `multi`. The fix is the same: one clause, one
if-then-else.

## Variable renaming and the depth-counter limitation

Each resolution step increments `Depth` and uses it as the suffix. Variables
in the ancestor rules (`X`, `Y`, `Z`) become `X_0`, `Y_0` on the first step,
`X_1`, `Y_1` on the second, and so on.

This breaks if two sibling backtrack branches at the **same depth** use different
clauses — both would share suffix `_N`, creating phantom bindings. For the demo
programs it doesn't arise because each ancestor step uses exactly one clause at
each depth. A production-quality interpreter would use a global counter (via
Mercury `mutable` or threading an `int::in int::out` state through `solutions`
— which would require a state-threaded version of the solver).

## Answering the design questions

**Q1: det compilation of a Mercury predicate**

A `det` Mercury predicate with pattern matching is compiled to a single-pass
switch: the compiler generates a C `switch` on the functor tag. Each arm runs
at most once and doesn't backtrack. The "choice point" stack used during
nondeterministic resolution is entirely absent for `det` code — that's the
fundamental difference between the interpreter (which builds explicit choice
points via `list.member`) and compiled Mercury (which elides them by
static determinism analysis).

**Q2: Depth-counter collision**

If the ancestor program had a clause like:
```
ancestor(X, Y) :- parent(X, Y).
ancestor(X, Y) :- parent(X, Y).  % duplicate
```
and both clauses are tried at the same depth, both would be renamed with `_2`
and would share bindings. If one clause leaves a binding `X_2 = tom` and the
next is tried (backtracking), the old binding is still in the environment (we
never remove bindings — only add). This can cause incorrect unification failures.
A correct solution: use a monotonically increasing counter across all backtrack
branches — e.g., threading `int::in int::out` through the entire solver.

**Q3: Occurs check**

`unify` binds `v(X)` to any term, including one containing `v(X)` itself.
If a query produces a circular substitution (e.g., `X = f(X)`), then
`apply_env` would loop forever following `X → f(X) → f(f(X)) → ...`.
The occurs check would go in `unify_d`, in the `D1 = v(X)` branch:

```mercury
D1 = v(X) ->
    ( occurs(X, D2, Env0) -> fail ; Env = [X - D2 | Env0] )
```

where `occurs/3` checks whether `X` appears anywhere in `D2` after dereffing.
Standard Prolog omits the occurs check for performance; Mercury programs compiled
with the mode system don't need it because the type system prevents circular terms
at the source level.
