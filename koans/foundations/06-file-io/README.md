# Koan: file handle not closed on error path

**Broken concept:** opening a file, reading in a try block, but not closing the stream
if reading throws an exception

## Prerequisites

- `katas/foundations/07-exceptions` — `io.res`, `exception.try_io`, resource cleanup
- `koans/foundations/05-exceptions` — `io.open_input` result handling

---

This is a logic bug, not a type or mode error — the compiler cannot catch it. The program
compiles and runs correctly in the happy path. But if the reading throws, the stream
is leaked.

---

## Try it

```
mmc --make --grade asm_fast.par.gc.stseg file_io_koan
```

Builds clean. Run it on a valid file. Then run it on an unreadable file, or inject a
throw into the read loop. The stream handle is never closed on the exception path.

---

## What to observe

The code opens the file, processes it, and closes it — but only if no exception is thrown.
If `process_lines` throws, `io.close_input` is never reached.

---

## Your task

Use `exception.try_io` to ensure the stream is closed even if an exception occurs:

```mercury
io.open_input(Filename, OpenRes, !IO),
( OpenRes = ok(Stream) ->
    exception.try_io(process_lines(Stream), Outcome, !IO),
    io.close_input(Stream, !IO),   % always runs
    ( Outcome = succeeded(_) -> true
    ; Outcome = exception(E) ->
        io.format("Error: %s\n", [s(string.string(univ_value(E)))], !IO)
    )
; OpenRes = error(Err) ->
    io.format("Cannot open: %s\n", [s(io.error_message(Err))], !IO)
).
```
