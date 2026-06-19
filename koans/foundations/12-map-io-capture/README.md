# Koan: `list.map` cannot thread IO — use `list.foldl`

**Broken concept:** passing a lambda that does IO to `list.map`, which has no
IO threading

## Prerequisites

- `katas/foundations/04-higher-order` — `list.map`, `list.foldl`, higher-order predicates
- `koans/mode-system/04-uniqueness-violation` — unique state cannot be aliased

---

```
mmc map_io_koan.m
```

The key error: "cannot use `!:IO` here due to the surrounding lambda expression;
you may only refer to `!.IO`."

---

## What to observe

`list.map` has signature `pred(T, U)` — it maps each element to a result with no
side effects. It has no argument for threading IO.

When the lambda tries to use `!IO`, Mercury notices that `!:IO` (the write side)
would need to be consumed and produced *once per element*. But a unique value
(`di`/`uo`) can only flow through a single linear path. Sharing it across all
invocations of the lambda violates uniqueness.

Mercury's error message flags `!:IO` specifically as the problem: you can *read*
the current IO state (`!.IO`) inside a closure, but you cannot *write* it.
Writing requires consuming and producing the unique token, which `list.map` has
no mechanism to support.

`list.foldl` is the correct combinator when IO (or any state) must be threaded:

```mercury
list.foldl(pred(S::in, !.IO::di, !:IO::uo) is det :- ..., Strs, !IO)
```

---

## Your task

Replace `list.map` with `list.foldl`. Thread `!IO` through the foldl call
directly; the lambda takes `S::in, !.IO::di, !:IO::uo`.
