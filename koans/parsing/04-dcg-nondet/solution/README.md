# Solution

Rewrite `token` as a single clause with if-then-else branches:

```mercury
token(T) -->
    ( digit(_) ->
        { T = int_tok }
    ; ['+'] ->
        { T = plus_tok }
    ; ['*'] ->
        { T = star_tok }
    ;
        { fail }
    ).
```

The if-then-else is a committed-choice construct. Once a branch's condition
succeeds, Mercury commits to that branch — no other alternatives are tried.
This is what gives the rule `semidet` semantics: it either matches exactly one
alternative and succeeds, or it falls through to `{ fail }` and fails.

The multi-clause form (`token(int_tok) --> ...` / `token(plus_tok) --> ...`) is
structurally equivalent to a disjunction where all clauses are tried. Mercury
cannot prove they're mutually exclusive — character classes can overlap — so it
infers `nondet`.

This is the core pattern for writing deterministic parsers in Mercury: avoid
multi-clause DCG rules; use single-clause if-then-else inside the body.
