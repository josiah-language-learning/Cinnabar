# Puzzle: Mercury meta-interpreter

**Primary skills:** meta-programming, term representation, unification,
nondeterministic search, `solutions/2`

**Why Mercury:** writing an interpreter for a logical language forces you to
implement the exact mechanisms — unification, environment-based substitution,
backtracking search — that Mercury's own compiler compiles away. After writing
this, Mercury's mode system and determinism annotations cease to be magic.

## Prerequisites

- All previous advanced puzzles
- `katas/determinism/01-six-categories`
- `katas/mode-system/04-higher-order-insts`
- Familiarity with Prolog or Horn clause logic

---

## The problem

Implement a meta-interpreter for a subset of Mercury's logic programming
fragment: definite Horn clause programs with one relation — goal resolution.

Your interpreter operates on programs represented as Mercury data:

```mercury
:- type term_t
    --->    a(string)               % atom
    ;       n(int)                  % integer
    ;       f(string, list(term_t)) % compound: functor(args)
    ;       v(string).              % logical variable

:- type clause_t ---> c(term_t, list(term_t)).  % head :- body
:- type prog_t   ---> prog(list(clause_t)).
```

---

## What to implement

### 1. Variable renaming

Each time a clause is used in resolution, rename its variables with a unique
suffix to prevent capture. Implement:

```mercury
:- pred rename(term_t::in, string::in, term_t::out) is det.
```

This maps `v("X")` to `v("X_N")` and leaves atoms, integers, and functor names
unchanged.

### 2. Environment and dereferencing

The environment maps variable names to terms:

```mercury
:- type env_t == list(pair(string, term_t)).
```

Implement `deref(term_t, env_t, term_t)` — follow variable chains until a
non-variable term (or an unbound variable) is reached.

### 3. Unification

```mercury
:- pred unify(term_t::in, term_t::in, env_t::in, env_t::out) is semidet.
```

Deref both sides first, then unify structurally. Use a single-clause
if-then-else body for `semidet` determinism — multiple clauses with overlapping
variable patterns would be inferred `nondet`.

### 4. The solver

```mercury
:- pred solve(prog_t::in, list(term_t)::in, int::in,
              env_t::in, env_t::out) is nondet.
```

The `int` argument is a depth counter for variable renaming. At each resolution
step, increment it and pass the string representation as the clause rename suffix.

For each goal:
1. Deref the goal under the current environment
2. Find a clause in the program whose renamed head unifies with the goal
3. Recurse on the clause body, then the remaining goals

### 5. Queries and output

Use `solutions/2` to collect all answers. Apply the final environment to the
original query term to recover the result:

```mercury
:- func apply_env(term_t, env_t) = term_t.
```

---

## Suggested build order

Implement and test each component before moving to the next. Each checkpoint is
a minimal `main` you can compile and run to verify correctness in isolation.

### Checkpoint A — rename and deref

After implementing `rename/3`, `apply_env/2`, and `deref/3`, add to `main`:

```mercury
Env0 = ["X_0" - a("alice"), "Y_0" - v("X_0")],
Renamed = rename(v("X"), "0", _),   % expect v("X_0")
Derefed = deref(v("Y_0"), Env0, _), % expect a("alice"), following Y_0 → X_0 → alice
io.print_line(Renamed, !IO),
io.print_line(Derefed, !IO).
```

This confirms variable suffix injection and chain-following before any search
machinery exists.

### Checkpoint B — unification

After implementing `unify/4`, test it in isolation:

```mercury
% unify a("alice") with v("X") — should produce env [("X", a("alice"))]
( unify(a("alice"), v("X"), [], Env1) ->
    io.print_line(Env1, !IO)
;
    io.print_line("failed", !IO)
),
% unify f("p", [v("X")]) with f("p", [a("bob")]) — should produce [("X", a("bob"))]
( unify(f("p", [v("X")]), f("p", [a("bob")]), [], Env2) ->
    io.print_line(Env2, !IO)
;
    io.print_line("failed", !IO)
).
```

Do not proceed to the solver until unification produces correct environments for
basic atoms, variables, and compounds.

### Checkpoint C — single-clause query

Before trying ancestor queries, test with a trivial one-clause program:

```mercury
% Program: fact(a).
Prog = prog([c(f("fact", [a("a")]), [])]),
Goal = f("fact", [v("X")]),
Solns = solutions(
    (pred(E::out) is nondet :- solve(Prog, [Goal], 0, [], E)),
    _),
list.foldl(
    (pred(E::in, !.IO::di, !:IO::uo) is det :-
        io.print_line(apply_env(v("X"), E), !IO)),
    Solns, !IO).
% Expected: a("a") printed once.
```

If this works, the rename → unify → recurse loop is correct for the base case.
Ancestor and append involve recursive clauses and are considerably harder to debug.

---

## Programs to interpret

**Ancestor relationships:**
```
parent(tom, bob). parent(bob, ann). parent(bob, pat).
ancestor(X, Y) :- parent(X, Y).
ancestor(X, Y) :- parent(X, Z), ancestor(Z, Y).
```

Query: `ancestor(tom, Who)` — should find `who=bob`, `who=ann`, `who=pat`.

**List append:**
```
app([], Y, Y).
app([H|T], Y, [H|R]) :- app(T, Y, R).
```

Query: `app([1,2], [3], Result)` — should find `Result = [1,2,3]`.

---

## Design questions

1. Your interpreter is `nondet` — it generates all solutions via backtracking.
   Mercury's mode system compiled this away into a single-pass deterministic
   program. What transformation would a compiler need to apply to turn a `det`
   predicate into code without backtracking?

2. The depth-counter renaming suffix is not globally unique — two clause uses
   at the same depth could collide. Describe a condition where this causes a
   wrong answer. What would a correct solution require?

3. This interpreter has no occurs check in `unify` — binding `v("X")` to
   `f("list", [v("X")])` creates a circular term. When would this cause an
   infinite loop, and where in the code would you add an occurs check?
