# Solution

Bind the error message to a named variable before using it in `io.format`:

```mercury
io.error_message(E, Msg),
io.format("Error: %s\n", [s(Msg)], !IO)
```

This uses the predicate form `io.error_message(io.error::in, string::out) is det`,
which is unambiguous: the output is always `string`.

The inline form `io.format("...", [s(io.error_message(E))], !IO)` is ambiguous
because `io.error_message(E)` could be the function call (returning `string`) or
a partial application of the predicate (returning `pred(string)`). Mercury requires
a unique type resolution and rejects the ambiguity rather than picking one.

Alternatively, use explicit function application: `Msg = io.error_message(E)`.
