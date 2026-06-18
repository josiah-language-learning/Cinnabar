# Calculator solution notes

## Precedence via rule nesting

The grammar hierarchy encodes precedence without an explicit table:
- `expr` handles `+` and `-` (low precedence)
- `term` handles `*` and `/` (high precedence)
- `factor` handles atoms and parentheses

When `expr` calls `term`, the `term` rule "binds tighter" — it will consume as much
`*`/`/`-connected material as possible before returning to `expr`. This is how precedence
falls out of recursive descent: rules at the bottom of the call stack bind tighter.

## Left-associativity via accumulator

Right-recursive DCG rules produce right-associative evaluation. To get left-associativity
(`3 - 2 - 1 = 0`, not `3 - (2 - 1) = 2`), use an accumulator:

```mercury
expr_rest(Acc, V) --> [minus], term(T), expr_rest(Acc - T, V).
```

`expr_rest(Acc - T, V)` passes `Acc - T` as the new accumulator to the next level, not
`T - V`. This is left-to-right evaluation.

## No universal Show in Mercury

Mercury has no polymorphic `show`/`toString`. To print a `maybe(int)`, pattern-match:

```mercury
( calculate(Expr) = yes(V) -> io.format("%s = %d\n", [s(Expr), i(V)], !IO)
; io.format("%s = no\n", [s(Expr)], !IO) )
```

## Division by zero in DCG

`{ F =\= 0 }` inside a DCG rule makes the rule fail when the divisor is zero. Note:
use `=\=` (arithmetic disequality), not `\=` (term disequality), for comparing integers. The parse
succeeds structurally but fails semantically. The outer `maybe` wrapper converts this
failure to `no`.
