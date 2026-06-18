# 07 — Stateful DCGs

**Concept:** threading extra state through DCG rules as additional arguments; the `!State`
notation in DCG context; position tracking and symbol tables

**Not in the Mercury tutorial.**

---

## DCG rules are predicates with hidden arguments

Every DCG rule `head --> body` desugars to a predicate with two extra `list(T)` arguments —
the input list and the remaining (unconsumed) output list. A rule `r --> [x], s` becomes
`r(S0, S) :- S0 = [x | S1], s(S1, S)`.

You can add a *third* argument (or more) to thread arbitrary state through the parse:

```mercury
:- pred token_with_pos(token, pos, pos, list(char), list(char)).
:- mode token_with_pos(out, in, out, in, out) is semidet.
```

The extra `pos` arguments thread line/column position through every rule call. The `!Pos`
notation desugars to `Pos0, Pos` as extra arguments — identical to `!IO` threading.

---

## Position tracking

Define a `pos` type and an `advance` predicate:

```mercury
:- type pos ---> pos(line :: int, col :: int).

:- pred advance(char::in, pos::in, pos::out) is det.
advance('\n', pos(L, _), pos(L + 1, 1)).
advance(_,    pos(L, C), pos(L, C + 1)).
```

Every time a character is consumed, call `advance` to update the position. When an error
occurs, the position argument holds the precise location.

---

## Symbol-table-aware parsing

Thread a symbol table (`map(string, int)`) through the parse. When an identifier is
encountered, look it up:

```mercury
:- pred lookup_var(string::in, symtable::in, lookup_result::out) is det.

:- type lookup_result ---> ok(int) ; undefined(string).
```

If the identifier is not in the table, return `undefined(Name)` instead of failing.
This gives structured error reporting without backtracking.

---

## What you will build

### `chars_with_pos`

Pair each character with its position. Returns a `list(pair(char, pos))`. Implement
using a recursive accumulator that calls `advance` on each character.

Verify on `"ab\ncd"` — characters on the second line should show `line = 2`.

### `eval_with_table`

Evaluate a simple "expression" (a single string) against a symbol table:
- If the string is a decimal integer literal, return `ok(N)`
- If it's an identifier in the table, return `ok(N)` where `N` is the table value
- If it's an unknown identifier, return `undefined(Name)`

### Extension: DCG rule with `!Pos` threading

Rewrite `chars_with_pos` as a DCG rule that uses `!Pos` notation:
```mercury
:- pred scan(list(pair(char, pos)), pos, pos, list(char), list(char)).
:- mode scan(out, in, out, in, out) is det.
scan([]) --> [].
scan([C - Pos | Rest]) --> [C], { advance(C, Pos, Pos1) }, scan(Rest, Pos1, _).
```

Note: in DCG rules, `!State` threading desugars to extra arguments in the same way
as `!IO`. This is not special syntax — it is just the state-threading pair convention
applied to a new type.

---

## Checkpoint

- `chars_with_pos("ab\ncd")` returns pairs with correct line/column positions
- `eval_with_table("x", {"x"→42})` returns `ok(42)`
- `eval_with_table("z", {"x"→42})` returns `undefined("z")`
- `eval_with_table("10", _)` returns `ok(10)`
- You can state: how does `!State` notation work inside a DCG rule?
