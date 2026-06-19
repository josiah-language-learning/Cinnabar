# Solution

`\+` discards all bindings produced by its inner goal. `T` is free before and
after the `\+` — it never gets bound in the outer clause.

**Fix — use `list.find_first_match`:**

```mercury
:- pred find_important(list(task)::in, task::out) is semidet.
find_important(Tasks, T) :-
    list.find_first_match(
        (pred(X::in) is semidet :- X ^ priority \= low),
        Tasks, T).
```

`list.find_first_match` binds `T` to the first element that satisfies the
predicate. The result is `semidet` — it fails if no element passes the test.

A naive generate-and-test with `list.member` would be `nondet` (multiple
non-low tasks → multiple solutions), which makes `main` inferred `multi` when
called in an if-then-else condition from a `det` context. `find_first_match`
commits to the first match, giving `semidet`.

**Why `\+` cannot do this:**

`\+` is defined as `( Goal -> fail ; true )`. It never succeeds *and* produces
bindings — it either fails (if Goal succeeded) or succeeds with no bindings
(if Goal failed). There is no "succeed with the bindings from a goal that
failed" because that is contradictory: the goal failed, so those bindings
were never produced.

Use `\+` for pure boolean checks on already-ground values:
`\+ list.member(Known, Exclusions)`. Use generate-and-test when you need
to both select and validate.
