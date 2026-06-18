# Solution notes

## The bidirectionality

The forward and reverse directions are implemented as two separate predicates:

```mercury
first_with(property::in, int::out) is semidet    % forward
properties_of(int::in, property::out) is nondet  % reverse
```

The relation is: `{(P, N) | N has property P, N ∈ 1..50}`. In the forward direction
the relation is many-to-one from the integer side (many N for each P) — we use a
recursive scan to commit to the first match. In the reverse direction it's
one-to-many from the integer side — one N can have several properties.

## Why `pragma promise_equivalent_clauses` does not apply here

The pragma requires both clause bodies to compute the **same relation**. Here:
- `first_with` computes `{(P, min_N_with_P) | ...}` — only the smallest N per P.
- `properties_of` computes `{(P, N) | has_property(N, P)}` — all (P, N) pairs.

These are different relations. The pragma would be a lie.

For the pragma to be valid, both clause bodies must implement the exact same logical
set of pairs. The classic examples are predicates like `append/3` (the same clauses
work in both directions) or `str_to_int` (two different algorithms that both compute
the bijection between decimal strings and integers).

## Forward: recursive scan instead of nondet generator in condition

A common mistake: trying to use a nondet generator inside an if-then-else condition
to commit to the first solution:

```mercury
first_with(P, N) :-
    ( gen(1, 50, N0), has_property(N0, P) ->  % ERROR: inferred nondet
        N = N0
    ; fail ).
```

Mercury infers `first_with` as `nondet` because `gen` is declared `nondet` and the
mode checker propagates this upward before applying the committed-choice reduction.

The correct pattern: a semidet recursive scan that checks each integer explicitly:

```mercury
first_from(Lo, Hi, P, N) :-
    Lo =< Hi,
    ( has_property(Lo, P) ->
        N = Lo
    ;
        first_from(Lo + 1, Hi, P, N)
    ).
```

Each `has_property` call is `semidet`. The if-then-else over a `semidet` condition
is itself `semidet`. The recursion is `semidet`. Mercury infers the whole predicate
as `semidet`. ✓

## Fibonacci check

A positive integer N is Fibonacci iff 5N²+4 or 5N²-4 is a perfect square. The
disjunction is implemented with if-then-else rather than `;` to keep the
determinism `semidet`:

```mercury
is_fibonacci(N) :-
    N >= 0,
    ( is_perfect_square(5 * N * N + 4) ->
        true
    ;
        is_perfect_square(5 * N * N - 4)
    ).
```

Using `;` directly would cause Mercury to infer `nondet` (two semidet branches in
disjunction = nondet, since Mercury cannot prove mutual exclusion statically).

## Output check

- 1: square, fibonacci, triangular — all three; 1 is special
- 3: prime, fibonacci, triangular — the only prime triangular fibonacci
- 36: square and triangular (not in 1..20 but worth verifying with the predicate)
- 12 has no properties in our list — confirms non-empty output filter works
