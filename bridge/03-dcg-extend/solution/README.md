# Solution notes

## Task 1: adding `^`

Straightforward — one new constructor, one new rule:

```mercury
:- type token ---> ... ; caret.

one_token(caret) --> ['^'].
```

## Task 2: float literals — rule ordering matters

In `semidet` DCG rules, the first matching alternative wins. If `int_tok` is listed
before `float_tok`, the tokenizer will match the integer part of `"3.14"`, consume `3`,
and leave `.14` unconsumed — the overall tokenize will fail (or produce the wrong result
if you have a dot token).

Fix: put `float_tok` first:

```mercury
one_token(float_tok(F)) -->
    digits(IntDs), ['.'], digits(FracDs), { FracDs \= [] },
    {
        string.append(
            string.from_char_list(IntDs), ".",
            Prefix),
        string.append(Prefix, string.from_char_list(FracDs), FStr),
        string.to_float(FStr, F)
    }.
one_token(int_tok(N)) --> ...
```

The `{ FracDs \= [] }` guard ensures at least one digit after the dot, so `"3."` does
not accidentally match as a float.

## Task 3: `token_to_string`

```mercury
:- func token_to_string(token) = string.
token_to_string(int_tok(N))   = "int(" ++ string.int_to_string(N) ++ ")".
token_to_string(float_tok(F)) = "float(" ++ string.float_to_string(F) ++ ")".
token_to_string(plus)         = "+".
token_to_string(minus)        = "-".
token_to_string(star)         = "*".
token_to_string(slash)        = "/".
token_to_string(caret)        = "^".
```

Adding a new constructor to `token` without adding a case here will give a
non-exhaustive match warning — the same exhaustiveness guarantee you saw in
`koans/type-system/01-adt`.
