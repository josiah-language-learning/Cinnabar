# Solution notes

## Task 1: recursive-descent parser (+ and - only)

```mercury
% parse_expr accumulates left-to-right using a "left-rest" pattern.
:- pred parse_expr(expr, list(token), list(token)).
:- mode parse_expr(out, in, out) is semidet.
parse_expr(E) -->
    parse_term(T),
    parse_expr_rest(T, E).

:- pred parse_expr_rest(expr, expr, list(token), list(token)).
:- mode parse_expr_rest(in, out, in, out) is det.
parse_expr_rest(Left, Result) -->
    ( [plus] ->
        parse_term(Right),
        parse_expr_rest(add(Left, Right), Result)
    ; [minus] ->
        parse_term(Right),
        parse_expr_rest(sub(Left, Right), Result)
    ;
        { Result = Left }
    ).

:- pred parse_term(expr, list(token), list(token)).
:- mode parse_term(out, in, out) is semidet.
parse_term(num(N)) --> [int_tok(N)].
```

`parse_expr_rest` is `det` — it always produces a result (either by consuming an
operator or by returning `Left` unchanged). `parse_expr` is `semidet` because
`parse_term` may fail (no integer token at the head).

Fix `tokenize` warning: change `is semidet` to `is det`.

## Task 2: precedence and left-associativity

Two-level grammar with the accumulator pattern at both levels:

```mercury
parse_expr(E)       --> parse_factor_level(T), parse_expr_rest(T, E).
parse_expr_rest(L, R) -->
    ( [plus]  -> parse_factor_level(T), parse_expr_rest(add(L, T), R)
    ; [minus] -> parse_factor_level(T), parse_expr_rest(sub(L, T), R)
    ;            { R = L }
    ).

parse_factor_level(E) --> parse_atom(T), parse_term_rest(T, E).
parse_term_rest(L, R) -->
    ( [star]  -> parse_atom(T), parse_term_rest(mul(L, T), R)
    ; [slash] -> parse_atom(T), parse_term_rest(div(L, T), R)
    ;            { R = L }
    ).

parse_atom(num(N)) --> [int_tok(N)].
```

The key insight: left-associativity comes from passing the growing left subtree
(`L`) into each recursive call of `_rest`. The "rightmost" rule returns the
accumulated tree when no more operators match.

`"10 - 3 - 2"` parses as `sub(sub(num(10), num(3)), num(2))` because each `-`
folds into `sub(accumulated_so_far, next_term)` — the left spine grows left.

## Task 3: evaluator

```mercury
:- func eval(expr) = int.
eval(num(N))    = N.
eval(add(A, B)) = eval(A) + eval(B).
eval(sub(A, B)) = eval(A) - eval(B).
eval(mul(A, B)) = eval(A) * eval(B).
eval(div(A, B)) = Result :-
    ( eval(B) = 0 ->
        Result = 0   % fallback: document this as a design choice
    ;
        Result = eval(A) // eval(B)
    ).
```

Full pipeline:
```mercury
:- func calculate(string) = maybe(int).
calculate(S) = Result :-
    ( tokenize(S, Tokens), parse_expr(E, Tokens, []) ->
        Result = yes(eval(E))
    ;
        Result = no
    ).
```

## Task 4: variables and let

Token extension:
```mercury
:- type token
    --->    int_tok(int)
    ;       ident_tok(string)
    ;       let_tok
    ;       in_tok
    ;       eq_tok
    ;       plus ; minus ; star ; slash.
```

Lexer: after recognising the first letter of an identifier, accumulate the rest:
```mercury
; ( [C], { char.is_alpha(C) } ) ->
    ident_chars(Cs),
    { Word = string.from_char_list([C | Cs]) },
    { ( Word = "let" -> T = let_tok ; Word = "in" -> T = in_tok ; T = ident_tok(Word) ) }
```

Parser extension for `let`:
```mercury
parse_atom(let(X, E1, E2)) -->
    [let_tok], [ident_tok(X)], [eq_tok],
    parse_expr(E1), [in_tok], parse_expr(E2).
```

Evaluator with environment:
```mercury
:- func eval_env(map(string, int), expr) = maybe(int).
eval_env(_, num(N))        = yes(N).
eval_env(Env, var(X))      = ( map.search(Env, X, V) -> yes(V) ; no ).
eval_env(Env, let(X, E1, E2)) =
    bind_maybe(eval_env(Env, E1),
               (func(V) = eval_env(map.set(Env, X, V), E2))).
eval_env(Env, add(A, B))   =
    bind_maybe(eval_env(Env, A),
               (func(VA) = map_maybe((func(VB) = VA + VB), eval_env(Env, B)))).
% ... similar for sub, mul, div
```

## Task 5: error messages

Add position to tokens at the lexer stage:

```mercury
:- type tok ---> tok(token, int).  % token + byte offset
```

Thread the current offset through `token_list` as an extra DCG state argument.
Return `error(Pos, Msg)` when `parse_expr` fails: the position of the last token
consumed before failure is the error position.

The cleanest approach: return `parse_result(expr)` from the top-level call, where
`error(Pos, "unexpected token")` uses the offset of the first unconsumed token from
the remainder list.
