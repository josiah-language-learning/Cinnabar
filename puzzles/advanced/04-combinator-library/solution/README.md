# Solution notes

## The inst-in-type error

The first obstacle when building this library is that Mercury forbids inst
information inside a type declaration:

```mercury
% WRONG — inst info in the type position
:- pred satisfy(pred(char::in) is semidet, char, list(char), list(char)).
```

The error: "the type `((pred (char :: in)) is semidet)' contains higher order
inst information, but this is not allowed in a predicate's argument."

The fix is always the same: separate type and mode declarations.

```mercury
% CORRECT
:- pred satisfy(pred(char), char, list(char), list(char)).
:- mode satisfy(in(pred(in) is semidet), out, in, out) is semidet.
```

The same applies to `seq_det`, `seq_semidet`, `choice_det`, `choice_semidet`,
`many`, and any other combinator that takes a higher-order argument. Define the
`pred(T)` type separately, then attach insts in `:- mode` declarations.

## inst aliases for parser shapes

Defining inst aliases up front keeps mode declarations readable:

```mercury
:- inst parser_det     == (pred(out, in, out) is det).
:- inst parser_semidet == (pred(out, in, out) is semidet).
```

Mode declarations then read like contracts:
```mercury
:- mode seq_semidet(in(parser_semidet), in(parser_semidet), out, in, out) is semidet.
```

## many — the determinism argument

`many` wraps `call(P, ...)` in an if-then-else condition. The semidet branch is
the condition (try P once, commit or stop). The overall predicate is `det`
because it always terminates with a list:

```mercury
many(P, Results, Input, Rest) :-
    ( call(P, V, Input, Mid) ->
        many(P, Vs, Mid, Rest),
        Results = [V | Vs]
    ;
        Results = [],
        Rest = Input
    ).
```

If `call(P, ...)` were `nondet`, the if-then-else would still commit to one
solution — but you declared the combinator accepts a `parser_semidet`, so the
mode checker knows to expect at most one.

## choice_det vs choice_semidet

`choice_det` ignores its second argument entirely — if P is `det` it never fails,
so Q is dead code. Mercury will still type-check Q's inst.

`choice_semidet` uses if-then-else to implement the committed-choice OR:

```mercury
choice_semidet(P, Q, V, Input, Rest) :-
    ( call(P, V0, Input, Rest0) ->
        V = V0, Rest = Rest0
    ;
        call(Q, V, Input, Rest)
    ).
```

This is semidet: P or Q each have at most one solution, and the if-then-else
commits to whichever branch fires. The combined predicate fails only if both fail.

## Why determinism-polymorphic combinators require dependent types

`seq` is det when given two det parsers, and semidet when given two semidet
parsers. Mercury cannot express this as a single predicate because determinism is
not a type variable — it lives in the mode system, not the type system.

For determinism-polymorphic combinators to work, the determinism of a
higher-order argument would need to be a first-class parameter that other
declarations can reference — essentially a dependent type where the declared mode
depends on the value (or class) of an argument. Mercury's design trades this
expressiveness for a mode system that is decidably checkable at compile time.

Languages like Liquid Haskell or Idris can express such constraints through
refinement types or dependent types, but the decidability cost is higher.

## The `empty` predicate

`empty` has determinism `failure` — it always fails. The `out` argument in:

```mercury
:- pred empty(T, list(char), list(char)).
:- mode empty(out, in, out) is failure.
```

is never bound because the predicate never produces a solution. Mercury accepts
this. `empty` is the identity of `choice_semidet` (analogous to `[]` for lists)
and is included for algebraic completeness of the API.
