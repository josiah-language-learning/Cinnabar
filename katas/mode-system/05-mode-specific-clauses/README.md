# 05 — Mode-specific clauses

**Concept:** separate clause bodies for separate modes, `pragma promise_equivalent_clauses`,
verifying all modes produce equivalent results

**Not in the Mercury tutorial.** This is the full treatment of what `02-multi-mode`
introduces — when a single clause set cannot serve all modes and you need separate implementations.

---

## What you will build

`my_append/3` implemented with mode-specific clause sets rather than a single recursive
definition.

---

## When single clauses fail

The standard recursive `my_append`:
```mercury
my_append([], B, B).
my_append([H | T], B, [H | C]) :- my_append(T, B, C).
```
works for modes `(in, in, out)` and `(in, out, in)`. It also works for `(out, in, in)`
if the mode checker can select the right order of operations.

But for complex cases, the mode checker cannot find a valid reordering, and you need
to write separate clause sets explicitly.

---

## Exercise: Three clause sets

```mercury
:- pred my_append(list(T), list(T), list(T)).
:- mode my_append(in, in, out) is det.
:- mode my_append(out, in, in) is multi.
:- mode my_append(in, out, in) is semidet.
:- pragma promise_equivalent_clauses(my_append/3).

% Mode (in, in, out)
my_append(A::in, B::in, C::out) :-
    ( A = [] ->
        C = B
    ;
        A = [H | T],
        my_append(T, B, T2),
        C = [H | T2]
    ).

% Mode (out, in, in)
my_append(A::out, B::in, C::in) :-
    ( C = [] ->
        A = [],
        B = []
    ;
        C = [H | T],
        ( A = [], B = C
        ; A = [H | T2], my_append(T2, B, T)
        )
    ).

% Mode (in, out, in)
my_append(A::in, B::out, C::in) :-
    ( A = [] ->
        B = C
    ;
        A = [H | T],
        C = [H | T2],
        my_append(T, B, T2)
    ).
```

Note the mode annotations on each clause: `A::in`, `B::in`, `C::out`. These tell the
compiler which mode each clause handles.

Write a test harness that exercises all three modes and confirms the results are consistent:
- `my_append([1,2], [3,4], C)` → `C = [1,2,3,4]`
- `my_append(A, [3,4], [1,2,3,4])` → `A = [1,2]` (semidet, one solution)
- `solutions(my_append(X, [3], [1,2,3]), Xs)` → all prefixes of `[1,2,3]` that
  append with `[3]` to give `[1,2,3]`... which is just `[[1,2]]`.

---

## Checkpoint

- All three modes work with mode-specific clauses
- `pragma promise_equivalent_clauses` is present and the compiler accepts it
- You can explain: what does `pragma promise_equivalent_clauses` actually promise — and
  what happens at runtime if you violate it?
