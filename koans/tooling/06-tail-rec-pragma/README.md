# Koan: `require_tail_recursion` with `[error]` on non-tail-recursive predicate

**Broken concept:** a recursive predicate that does work after the recursive call
returns — a "call-then-add" pattern — declared to require tail recursion with the
`[error]` option, so the compiler rejects it rather than just warning

## Prerequisites

- `katas/tooling/01-grades` — grades and optimization
- `katas/foundations/03-higher-order` — recursion patterns

---

A *tail-recursive* predicate has its recursive call as the very last operation
in every clause. The Mercury runtime can optimize tail calls into loops, using
O(1) stack space instead of O(n).

`pragma require_tail_recursion(pred/arity, [error])` makes the tail-recursion
requirement a hard compile-time error. Without `[error]`, the pragma defaults
to `[warn]` — the compiler reports a warning but still generates code. The
`[error]` option turns the pragma into an enforcement tool: the program cannot
compile until the recursion is genuinely tail-recursive.

---

## Try it

```
mmc --make tail_rec_koan
```

The compiler reports that the self-recursive call in `sum_list` is not a
tail call.

---

## What to observe

In the broken version:
```mercury
sum_list([X|Xs], Sum) :-
    sum_list(Xs, Rest),   % recursive call
    Sum = X + Rest.       % addition happens AFTER the call returns
```
The recursive call is not last — the addition must happen after it returns.
Each stack frame must be kept alive to hold `X` until `Rest` comes back.

---

## Your task

Rewrite `sum_list` to be tail-recursive using an accumulator. The accumulator
carries the running total so no work remains after the recursive call. The
helper predicate `sum_list_acc(list(int)::in, int::in, int::out)` is the
standard shape.
