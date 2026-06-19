# Kata: abstract modules and information hiding

**Concept:** abstract type declaration; hiding implementation details behind an opaque
interface; `use_module` vs `import_module` in interface sections; swapping
implementations without touching clients

**Not in the Mercury tutorial.**

---

## Background

Mercury's module system enforces information hiding at the compiler level. A type
declared in the `:- interface` section *without constructors* is **abstract**: clients
know the type exists and can hold values of it, but cannot construct or pattern-match
on it directly. All operations must go through predicates and functions you export.

This gives you two guarantees:
1. **Enforcement**: clients that try to use internal constructors get a compile error.
2. **Substitution**: you can change the implementation type without touching any
   client code, as long as the exported interface stays the same.

`mset.m` exports a multiset type (`mset(T)`) this way. The actual representation is
a `list(T)` with duplicates allowed, but `start.m` — the client — cannot see that.

---

## Your task

`mset.m` is provided with the interface already written and stub implementations.
Fill in the implementation section until `runtests` passes.

```
mmc --make --grade asm_fast.par.gc.stseg start
./runtests
```

Do not edit `start.m`.

### `empty/1`

Already done — `empty([]).`

### `insert/3`

The stub returns the bag unchanged. Add X to the front of the list.

### `count/3`

Use `list.foldl/4` to walk the list and count occurrences:

```mercury
count(X, Mset, N) :-
    list.foldl(
        pred(E::in, Acc::in, Acc1::out) is det :-
            ( E = X -> Acc1 = Acc + 1 ; Acc1 = Acc ),
        Mset, 0, N).
```

### `remove/3`

The stub only removes when X is the head element. Add a recursive clause for the tail:

```mercury
remove(X, [H | T], [H | T1]) :-
    H \= X,
    remove(X, T, T1).
```

Use if-then-else if you prefer a single-clause approach.

### `size/1`

`list.length/1` returns the length of a list as a function.

---

## Step 4: break it on purpose

Once the tests pass, temporarily add this to `start.m`'s implementation section
and try to compile:

```mercury
% cheat attempt — will not compile:
peek_inside(M) = ( M = [H | _] -> H ; 0 ).
```

The error names the abstract type and explains that its constructor is not accessible.
Revert the change after reading the error.

---

## Step 5: swap the implementation

The current representation is `list(T)`. A more space-efficient representation for
large counts is `assoc_list(T, int)` — one entry per distinct element, the `int`
is the count.

In `mset.m`, change:

```mercury
:- type mset(T) == list(T).
```

to:

```mercury
:- import_module assoc_list.
:- type mset(T) == assoc_list(T, int).
```

Then rewrite the predicate implementations for the new representation.
`start.m` must compile and all tests must pass without any changes to `start.m`.

This is the payoff: the client is completely insulated from the change.

---

## `use_module` vs `import_module` in the interface section

`mset.m` uses `use_module list` in its interface (not `import_module`). Look at the
comment explaining why. Then look at `katas/foundations/01-modules` and
`koans/foundations/04-modules` for the full explanation of why `import_module` in an
interface section leaks names to your callers.

---

## Checkpoint

- `runtests` passes
- You can state: what error does Mercury give when client code tries to access an abstract type's constructors?
- You can state: what is the difference between `use_module` and `import_module` in an interface section?
- After step 5: `start.m` compiles and all tests pass with the `assoc_list` representation
