# Solution: wrap Mercury goals in `{...}`

```mercury
% Before (broken):
digit(C) --> [C], (char.is_digit(C)).

% After (fixed):
digit(C) --> [C], { char.is_digit(C) }.
```

`{Goal}` in a DCG rule means: evaluate `Goal` as a regular Mercury goal, without
threading the hidden list-difference arguments through it.

`(Goal)` in a DCG rule means: call `Goal` as if it were a grammar rule, threading
the hidden arguments through it — which expects `Goal` to have two extra `list` arguments.

## The mental model

DCG `-->` rules are syntactic sugar. Roughly:
```mercury
% DCG rule:
digit(C) --> [C], { char.is_digit(C) }.

% Expands to approximately:
digit(C, [C | L], L) :- char.is_digit(C).
```

The `{...}` prevents the DCG expander from inserting the hidden `L0` and `L` arguments
into `char.is_digit`. Without `{...}`, the expansion would produce
`char.is_digit(C, L0, L)`, which fails with an arity error.
