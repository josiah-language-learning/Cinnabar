# Koan (text): `io.error_message` — function vs predicate dual form

**Concept:** `io.error_message` exists in two forms; inline use in ambiguous
contexts can cause type ambiguity in some Mercury versions

## No koan.m for this entry

In Mercury 22.01.8, using `io.error_message(E)` inline inside `s(...)` in an
`io.format` call compiles without error — the compiler resolves the function
form unambiguously because `s(string)` constrains the type. A compile-time
ambiguity error can appear in older Mercury versions or in polymorphic contexts
where the return type is unconstrained.

The lesson is defensive: **always bind `io.error_message` to a variable first**
rather than relying on type propagation to resolve the form.

---

## The dual form

```mercury
:- func io.error_message(io.error) = string.
:- pred io.error_message(io.error::in, string::out) is det.
```

Inline use inside `io.format`:
```mercury
io.format("Error: %s\n", [s(io.error_message(E))], !IO)  % may be ambiguous
```

Safe pattern — bind to variable first:
```mercury
io.error_message(E, Msg),
io.format("Error: %s\n", [s(Msg)], !IO)
```

---

## Your task (reading exercise)

Read `solution/fixed.m` to see the safe pattern. No compile error to trigger
— just understand which idiom to reach for when handling `io.error` values.
