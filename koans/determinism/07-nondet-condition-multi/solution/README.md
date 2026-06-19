# Solution

Replace the `nondet` condition with `list.find_first_match`, which is `semidet`:

```mercury
classify(Tags, Result) :-
    (
        list.find_first_match(
            pred(T::in) is semidet :- string.length(T) > 3,
            Tags, Tag)
    ->
        Result = "found: " ++ Tag
    ;
        Result = "none"
    ).
```

`list.find_first_match/3` is `semidet`: it either finds the first element satisfying
the predicate (succeeds once) or fails. As a `semidet` condition, the if-then-else
commits to one outcome — making `classify` `det` as declared.

The key rule: a `nondet` goal used as an if-then-else condition makes the entire
expression `multi`, not `det`. For conditions that check membership or find a
value, use `semidet` predicates like `list.find_first_match` or `list.member` in
a `cc_nondet` context.

Alternatively, collect all solutions first and pattern-match the list:
```mercury
solutions(find_tag(Tags), All),
( All = [Tag | _] -> Result = "found: " ++ Tag ; Result = "none" )
```
