# Solution: thread all state variables through every branch; use if-then-else

## The error

```
In clause for `item(in, out, in, out)':
  mode mismatch in disjunction.
  The variable `A' is ground in some branches but not others.
    In this branch, `A' is ground.
    In this branch, `A' is free.
```

The mode checker checks each branch of a disjunction independently. In the digit
branch, `A` (the alpha counter output) is an output argument that is never unified —
it remains free. Mercury requires all output variables to be bound in all branches.

## Fix 1: bind the unchanged variable

In the digit branch, `A` does not change. Explicitly pass it through:

```mercury
{ A = A0, D = D0 + 1 }
```

The same pattern applies to all threaded state variables that a branch does not
modify — they must be explicitly equated to their input counterpart.

## Fix 2: replace `;` with if-then-else

A plain disjunction `;` infers `nondet` when Mercury cannot prove the branches are
mutually exclusive. The character predicates (`char.is_alpha`, `char.is_digit`) could
in principle both succeed on the same character from the compiler's perspective — it
does not specialise on the `char` type's structure. Declaring `item` as `semidet` then
fails the determinism check.

If-then-else commits to the first matching branch:

```mercury
( { char.is_alpha(C) } ->
    { A = A0 + 1, D = D0 }
;
    { char.is_digit(C) },
    { A = A0, D = D0 + 1 }
)
```

The `->` cuts after the condition succeeds — only one branch executes. Mercury infers
`semidet` (the else branch can fail if `C` is neither alpha nor digit).

## The threading invariant

In any stateful DCG rule, treat state variables like `!IO`: every branch must account
for every state variable, either by updating it or by explicitly equating in with out.
A branch that silently ignores a state variable is a bug the mode checker catches.

## Why the error names the clause, not the branch

Mercury's error message says "In clause for `item(in, out, in, out)':" and then lists
which branches differ. It identifies the problem at the clause level because it is the
clause's mode that fails — the disjunction inside prevents the output from being
uniformly ground. The line numbers on the "In this branch" lines show exactly which
branch is missing the binding.
