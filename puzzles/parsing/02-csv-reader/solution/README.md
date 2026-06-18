# CSV reader solution notes

## The quoting challenge

Quoted fields require "one character lookahead" for the `""` escape:

```mercury
quoted_chars(['"' | Rest]) --> ['"'], ['"'], quoted_chars(Rest).
quoted_chars([C | Rest])   --> [C], { C \= '"' }, quoted_chars(Rest).
quoted_chars([]) --> [].
```

The first rule matches `""` (two quotes) and produces a single `"` in the output.
The second rule matches any non-quote character.
The third rule matches the empty case (before the closing `"`).

This relies on DCG's left-to-right, backtracking search: the first rule is tried first;
if the next two characters are `""`, it succeeds. Otherwise, fall through to the single-character rule.

## Whitespace trimming for unquoted fields

```mercury
unquoted_chars(Cs) --> raw_unquoted(Raw), { string.strip(string.from_char_list(Raw)) = S, string.to_char_list(S, Cs) }.
```

`string.strip` removes leading and trailing whitespace. Apply it after collecting the
raw characters.

## Why DCGs are a good fit here

Each CSV rule maps directly onto a grammar production. The alternative — a hand-written
character scanner — requires explicit state tracking. The DCG version is 20-30 lines;
a C-style scanner for the same grammar would be 100+.
