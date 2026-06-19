# Solution

Convert the string to `list(char)` before calling the DCG rule:

```mercury
first_word(Input, Word) :-
    string.to_char_list(Input, Chars),
    word_chars(Word, Chars, _).
```

`string.to_char_list/2` is a `det` predicate — every string has a unique
character list representation. The `_` discards the remainder (the characters
after the first word).

If you also need the remainder (e.g., to continue parsing), bind it to a
named variable and convert back with `string.from_char_list` if needed.
