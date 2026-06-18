# 03 — Daytype

**Concept:** multi-clause disjunctive `func` body, compound if-then-else, `io.read_from_string` with `posn` threading, `command_line_arguments`

**Before you open `daytype.m`:** write down what you remember about how Mercury handles multiple clauses for the same predicate or function — specifically, whether it is like Prolog (try each clause in order, backtrack) or something different.

---

## What to look for

A multi-clause `func` in Mercury is not backtracking over alternatives — it is a set of pattern-matching cases. Each clause matches a specific input pattern; at most one fires. This makes the determinism tractable: if every clause is `det`, the whole `func` is `det`, with no search involved.

The `io.read_from_string` call introduces `posn` — a position record Mercury uses to track where in a string the parser has reached. It is threaded through reads the same way `!IO` is threaded through I/O calls, though here it is explicit rather than using the `!` sugar. Notice how the `posn` goes in, and a new `posn` comes out — the same unique-threading pattern as I/O, applied to parsing state.

`io.command_line_arguments` retrieves command-line args as a `list(string)`. Watch how the program handles the case where arguments are absent or malformed.

## After reading

Could you say:
- What is the difference between multi-clause pattern matching in Mercury and backtracking in Prolog?
- Where does the `posn` go after the read? Is it used again, or discarded?

---

> **Tutorial cross-reference:** Mercury Tutorial §2–3 covers type declarations and basic pattern
> matching. This exercise partially overlaps: the multi-clause `func` pattern is the same. The
> `posn`-threading and `command_line_arguments` usage are not in the tutorial. If multi-clause
> pattern matching is rusty, see §2 before continuing.
