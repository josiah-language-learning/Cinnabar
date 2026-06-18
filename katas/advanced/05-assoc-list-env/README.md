# Kata: association-list environments

An *association list* is a `list(pair(K, V))` used as a simple key-value store.
Unlike `map`, it allows shadowing: a later binding for a key takes precedence over an
earlier one, and the earlier one is still reachable by removing the later binding.

This idiom is the backbone of logic-programming environments, interpreter variable
stores, and scope stacks. The Mercury meta-interpreter puzzle uses it directly.

---

## The pattern

```mercury
:- type env(K, V) == list(pair(K, V)).

:- pred lookup(K::in, env(K, V)::in, V::out) is semidet.
lookup(Key, [Key - Val | _], Val).
lookup(Key, [Other - _ | Rest], Val) :-
    Key \= Other,
    lookup(Key, Rest, Val).

:- func extend(K, V, env(K, V)) = env(K, V).
extend(Key, Val, Env) = [Key - Val | Env].
```

`lookup` finds the first (most-recent) binding. `extend` prepends a new binding,
shadowing any existing one for `Key`.

---

## Steps

### 1. Implement lookup, extend, delete

```mercury
:- type env(K, V) == list(pair(K, V)).
:- pred lookup(K, env(K, V), V) <= (ground(K), ground(V)).
:- func extend(K, V, env(K, V)) = env(K, V).
:- func delete(K, env(K, V)) = env(K, V).
```

`delete(Key, Env)` removes the first binding for `Key`.

Write tests:
- Lookup in an empty env fails
- Extend then lookup returns the added value
- Extend twice with the same key, lookup finds the later one
- Delete removes the first binding; a second binding for the same key is now found

### 2. Deref chains

A *variable environment* maps names to values that may themselves be variable names.
A deref loop follows the chain until it reaches a non-variable or an unbound name:

```mercury
:- type val ---> var(string) ; lit(int).
:- type env == list(pair(string, val)).

:- pred deref(val::in, env::in, val::out) is det.
deref(lit(N), _, lit(N)).
deref(var(X), Env, Result) :-
    ( lookup(X, Env, Bound) ->
        deref(Bound, Env, Result)
    ;
        Result = var(X)   % unbound — return as-is
    ).
```

Write tests:
- `deref(var("x"), ["x" - lit(42)], Result)` → `lit(42)`
- `deref(var("x"), ["x" - var("y"), "y" - lit(7)], Result)` → `lit(7)`
- `deref(var("x"), [], Result)` → `var("x")` (unbound)
- `deref(var("x"), ["x" - var("x")], Result)` → think carefully: does this loop?

### 3. Scope stack (shadowing in practice)

An environment models lexical scope when you push a new binding on entry and pop it
on exit. Implement a simple evaluator for arithmetic expressions over a variable
environment:

```mercury
:- type expr
    --->    lit(int)
    ;       var(string)
    ;       add(expr, expr)
    ;       let(string, expr, expr).    % let x = E1 in E2

:- pred eval(expr::in, env(string, int)::in, int::out) is semidet.
```

`eval(let("x", lit(5), add(var("x"), var("x"))), [], 10)`.

The `let` case evaluates `E1`, extends the env with the result, evaluates `E2`, then
returns — the binding exists only inside `E2`.

### 4. Association list vs map — when to use each

Write a predicate that takes either an `env(string, int)` (assoc list) or a
`map(string, int)` and answer: given 100 lookups in a 10-item environment, which is
faster? Which supports shadowing? Which preserves insertion order? Discuss in a
comment block.

---

## Getting started

```mercury
:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module int.
:- import_module list.
:- import_module pair.
:- import_module string.

:- type env(K, V) == list(pair(K, V)).

main(!IO) :- true.
```
