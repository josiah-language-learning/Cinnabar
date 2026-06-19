# Koan: `io.res` uses `ok`/`error`, not `yes`/`no`

**Broken concept:** pattern-matching on `io.res` with `maybe` constructors

## Prerequisites

- `katas/foundations/07-exceptions` — `io.res`, `io.open_input`, result types

---

```
mmc res_koan.m
```

The error names `yes/1` as undefined. `yes` belongs to `maybe/1`; it has never
been a constructor of `io.res`.

`io.res(T)` is defined as:

```mercury
:- type io.res(T) ---> ok(T) ; error(io.error).
```

Students who know `maybe(T) ---> yes(T) ; no` sometimes assume `io.res` follows
the same naming — it does not. The constructors are `ok` / `error`.

---

## What to observe

The compiler error says `yes/1` is defined in `bool` and `maybe`, neither of
which is imported. Mercury tells you not just that the symbol is wrong but where
it *does* exist — useful for diagnosing cross-type confusion.

---

## Your task

Replace the `yes` match with `ok`. Note that the inner `Contents = ok(Str)` is
already correct — `io.read_file_as_string` also returns `io.res`, so both levels
use `ok`/`error`.
