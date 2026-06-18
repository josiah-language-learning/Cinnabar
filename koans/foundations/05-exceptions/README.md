# Koan: not pattern-matching `io.res`

**Broken concept:** treating `io.open_input` as if it returns a stream directly, instead
of `io.res(io.text_input_stream)`

## Prerequisites

- `katas/foundations/07-exceptions` — `io.res`, `io.open_input`, pattern-matching on results

---

`io.open_input` never gives you a stream — it gives you a *result* that is either
`ok(Stream)` or `error(Error)`. You must pattern-match on it. Accessing the stream
directly causes a type error.

---

## Try it

```
mmc --make --grade asm_fast.par.gc.stseg exceptions_koan
```

The compiler will report a type error: the result of `io.open_input` is
`io.res(io.text_input_stream)`, not `io.text_input_stream`. You cannot pass it
directly to `io.read_line_as_string`.

---

## Your task

Fix the code to properly pattern-match on the `io.res` result:

```mercury
io.open_input(Filename, Res, !IO),
(
    Res = ok(Stream),
    ...
;
    Res = error(Err),
    io.format("Error: %s\n", [s(io.error_message(Err))], !IO)
).
```
