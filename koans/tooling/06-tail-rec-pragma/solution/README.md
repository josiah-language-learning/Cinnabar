# Solution: rewrite with accumulator to achieve tail recursion

## The error

```
tail_rec_koan.m: In mode number 1 of predicate `sum_list'/2:
    error: self-recursive call is not tail recursive.
```

The sum-then-add pattern keeps each stack frame alive to perform the addition
after the recursive call returns. With n elements, n frames accumulate — O(n)
stack, which overflows on large lists.

## The fix

Use an accumulator:

```mercury
sum_list(Xs, Sum) :- sum_list_acc(Xs, 0, Sum).

sum_list_acc([], Acc, Acc).
sum_list_acc([X|Xs], Acc, Sum) :-
    sum_list_acc(Xs, Acc + X, Sum).   % recursive call is LAST
```

`sum_list_acc`'s recursive call is the last goal in its clause. The frame
can be reused — the Mercury runtime effectively compiles this to a loop.

## `[warn]` vs `[error]`

| Option | Effect |
|---|---|
| `[warn]` (default) | Warning printed, compilation succeeds |
| `[error]` | Compilation fails until recursion is tail-recursive |

Use `[warn]` to audit a codebase and `[error]` to enforce the property as a
correctness contract. The pragma belongs on the *public* entry point
(`sum_list/2`) not the helper — it documents intent, and the helper's
tail-recursion is an implementation detail.

## Pragma on the entry point, not the helper

`pragma require_tail_recursion(sum_list/2, [error])` checks that `sum_list`
does not call *itself* non-tail-recursively. Since `sum_list` only calls
`sum_list_acc`, the pragma is trivially satisfied. The actual recursion is
in `sum_list_acc`, which is genuinely tail-recursive. This is the right design.
