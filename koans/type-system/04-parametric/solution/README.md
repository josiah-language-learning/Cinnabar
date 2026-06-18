# Solution: make all type variables appear in the signature

## The `wrap_with_label` issue

`wrap_with_label` is actually correct — `A` appears in both the input and output types,
and `pair(string, A)` uses it. The only issue is whether the compiler can infer `A` at
call sites, which it can from the argument `X`.

## The `replicate_wrong` issue

```mercury
:- func replicate_wrong(int) = list(T).
replicate_wrong(_) = [].
```

`T` is a free type variable in the return type with no connection to the input. The
compiler cannot determine what `T` is — `replicate_wrong(3)` could be `list(int)`,
`list(string)`, or `list(anything)`. This is genuinely ambiguous.

The fix: either constrain `T` through the inputs, or accept a default value to determine
the type:

```mercury
% Option 1: carry a witness value
:- func replicate(T, int) = list(T).
replicate(Default, N) =
    ( N =< 0 -> [] ; [Default | replicate(Default, N - 1)] ).

% Option 2: use a class constraint that pins the type
:- func replicate_empty(int) = list(int).
replicate_empty(N) =
    ( N =< 0 -> [] ; [0 | replicate_empty(N - 1)] ).
```

## The general rule

Every type variable in a predicate's or function's output type must either:
1. Appear in an input type (so the compiler can infer it from the argument), or
2. Be explicitly quantified with `some [T]` (existential types)

A type variable that appears only in the output with no connection to inputs is ambiguous.
