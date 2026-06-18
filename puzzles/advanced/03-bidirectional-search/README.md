# Puzzle: bidirectional search

**Primary skills:** multi-mode predicates, `pragma promise_equivalent_clauses`,
determinism reasoning, `solutions/2`

**Why Mercury:** the mode system lets you write a single predicate that runs forward
(find a solution given constraints) and backward (recover constraints from a solution).
The determinism declared per mode reflects the shape of the relation in each direction.

## Prerequisites

- `katas/determinism/02-committed-choice`
- `katas/mode-system/02-multi-mode`
- `bridge/05-mode-reversal`

---

## The problem

A set of integers has numeric properties. Define a bidirectional predicate:

```
(property::in, int::out) is semidet    % forward: find first int with this property
(property::out, int::in) is nondet     % reverse: find all properties this int has
```

The **property** type:

```mercury
:- type property ---> prime ; perfect_square ; fibonacci ; triangular.
```

A number may have **multiple properties**: 1 is a perfect square, fibonacci, and
triangular. 144 is a perfect square and fibonacci. The reverse direction is
genuinely nondet — one number can have several properties.

The forward direction is semidet — given a property, find the smallest integer in
1..50 that has it. It fails if no such integer exists in the domain.

---

## Key operations

**Forward:** use a nondet generator + committed choice to find the first match.
The if-then-else condition commits to the first solution of a nondet predicate:

```mercury
:- pred first_with(property::in, int::out) is semidet.
first_with(P, N) :-
    ( gen(1, 50, N0), has_property(N0, P) ->
        N = N0
    ;
        fail
    ).
```

**Reverse:** a nondet predicate that generates all properties held by N.

**`pragma promise_equivalent_clauses`:** this pragma asserts that two mode-specific
clause bodies compute the same logical relation. Think carefully before applying it
here — is the forward clause (which returns ONE integer) logically equivalent to the
reverse clause (which returns ALL matching properties for an integer)? Read the
solution notes for the analysis.

---

## Suggested build order

Build and compile after each step — catching a mode error in `has_property` is
easier than catching it after you have `first_with` and `properties_of` on top of it.

### Step 1: `has_property` — compile and spot-check

Implement `has_property(int::in, property::in) is semidet` for all four properties.
In `main`, hard-code a few checks:

```mercury
( has_property(3, prime) -> io.print_line("3 is prime", !IO) ; true ),
( has_property(4, perfect_square) -> io.print_line("4 is sq", !IO) ; true ),
( has_property(3, perfect_square) -> io.print_line("3 is sq", !IO)
; io.print_line("3 is not sq", !IO) ).
```

Compile. Verify against the test table in the next section before continuing.

### Step 2: `first_with` — forward mode

Implement the forward predicate using the `gen` + committed-choice pattern shown
above. Test each property independently:

```mercury
( first_with(prime, N1) -> io.format("first prime: %d\n", [i(N1)], !IO) ; true ),
( first_with(fibonacci, N2) -> io.format("first fib: %d\n", [i(N2)], !IO) ; true ).
```

Expected: 2 for prime, 1 for fibonacci.

### Step 3: `properties_of` — reverse mode, no pragma yet

Implement `properties_of(int::in, property::out) is nondet`. Test it with
`solutions/2` before thinking about the pragma:

```mercury
Props = solutions(properties_of(36), _),
io.print_line(Props, !IO).   % expect [perfect_square, triangular]
```

### Step 4: pragma decision

Now decide: can `pragma promise_equivalent_clauses` unify the two clause bodies into
one multi-mode predicate? Re-read the "Key operations" section above — the forward
clause returns `min N` for a property, the reverse returns all properties of `N`.
Are these the same logical relation?

## What to implement

1. `has_property(int::in, property::in) is semidet` — does N have property P?
2. `first_with(property::in, int::out) is semidet` — find smallest in 1..50
3. `properties_of(int::in, property::out) is nondet` — all properties of N
4. In `main`:
   - For each property, print the first 5 integers in 1..50 that have it
   - For each of 1..20, print all properties it holds

---

## Test your output against

- 2 is prime, not square, not fibonacci, not triangular
- 3 is prime and fibonacci and triangular
- 4 is perfect square and not prime
- 36 is perfect square and triangular
- 144 is perfect square and fibonacci

---

## Design question

When IS `pragma promise_equivalent_clauses` valid for a bidirectional predicate?
What must be true of both clause bodies for the pragma to be an honest promise?
