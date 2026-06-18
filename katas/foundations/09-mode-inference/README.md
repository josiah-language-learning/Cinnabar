# 09 — Mode inference and goal reordering

**Concept:** Mercury's mode system reorders goals within a clause. Multiple mode declarations
for one predicate. Reading mode errors.

**Tutorial cross-reference:** Mercury Tutorial §4 introduces basic `in`/`out` annotations.
Goal reordering and multi-mode predicates are not covered there.

---

## Exercise 1: Goal reordering

Write this predicate:

```mercury
:- pred add(int::in, int::in, int::out) is det.
add(A, B, C) :-
    C = A + B,
    A = 1,
    B = 2.
```

This looks backwards — `C = A + B` appears before `A` and `B` are given values. Compile
it. It works. Mercury's mode checker reorders goals within a clause to satisfy all the
`in`/`out` constraints — it turns the source-order `C = A + B, A = 1, B = 2` into
`A = 1, B = 2, C = A + B` at compile time.

Now write one that cannot be reordered:

```mercury
:- pred broken(int::out) is det.
broken(X) :-
    Y = X + 1,   % X is not yet bound
    X = 5.
```

Wait — actually this _does_ work, because Mercury unifies `X = 5` first and then `Y = X + 1`.
The reordering is per-*goal*, not per-*line*.

Try something that genuinely fails:

```mercury
:- pred actually_broken(int::in, int::out) is det.
actually_broken(Limit, Result) :-
    Result = Partial + 1,
    ( Limit > 10 ->
        Partial = Limit * 2
    ;
        Partial = Limit
    ).
```

The if-then-else is a single goal from the mode checker's perspective. It cannot reorder
inside it and extract `Partial`. Read the mode error carefully.

## Exercise 2: Multi-mode predicates

Write `my_length/2` with two mode declarations:

```mercury
:- pred my_length(list(T), int).
:- mode my_length(in, out) is det.
:- mode my_length(out, in) is multi.

my_length([], 0).
my_length([_ | Tail], N) :-
    my_length(Tail, N0),
    N = N0 + 1.
```

The first mode computes the length of a given list. The second generates lists of a given
length (nondeterministically — there are many lists of length N). Test both:

```mercury
my_length([1, 2, 3], N),           % N = 3
solutions(my_length(_, 2), Lists). % all 2-element lists of type list(_)
```

Note: the `(out, in)` mode may need `pragma promise_equivalent_clauses` if the two clause
sets are mode-specific. Try without it first and see what happens.

## Exercise 3: Trigger a mode error deliberately

Write a predicate where a variable is genuinely used before it could possibly be bound,
in a way no reordering can fix:

```mercury
:- pred uses_unbound(int::out) is det.
uses_unbound(Y) :-
    Y = foreign_function_returning_unbound_int(Z),
    % Z is never bound by anything
    io.print(Z, !IO).   % Z used here
```

You cannot compile this without IO threading anyway, but the principle: write a predicate
where you reference a variable that has no producer in the clause. Read the error. The
compiler says something like "unbound variable Z" or "mode error: Z has inst `free`."

---

## Checkpoint

- Goal reordering exercise 1: backwards-looking unifications compile correctly
- Exercise 1 broken case: you have found and read at least one mode error
- Exercise 2: both modes of `my_length` work
- Exercise 3: you have triggered a "variable has inst free" style error and can read it

## What this unlocks

Mode errors are the most common Mercury stumbling block after determinism errors. Understanding
goal reordering — what the compiler can fix, what it cannot — is prerequisite for the
`katas/mode-system/` track.
