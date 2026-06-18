# Solution: use `exception.try_io` to guarantee cleanup

Mercury does not have `finally` blocks. The equivalent is `exception.try_io`, which
runs a predicate and captures any exception, then lets you perform cleanup before
re-raising or handling.

```mercury
io.open_input(Filename, OpenRes, !IO),
( OpenRes = ok(Stream) ->
    exception.try_io(process_lines(Stream), Outcome, !IO),
    io.close_input(Stream, !IO),   % runs whether or not exception occurred
    (
        Outcome = succeeded(_)
    ;
        Outcome = exception(E),
        io.format("Error during read: %s\n",
            [s(string.string(univ_value(E)))], !IO)
    )
; OpenRes = error(Err) ->
    io.format("Cannot open: %s\n", [s(io.error_message(Err))], !IO)
).
```

`exception.try_io(Goal, Outcome, !IO)` runs `Goal` with `!IO` threading. If `Goal`
throws, it catches the exception and binds `Outcome = exception(E)`. Either way,
execution continues after `try_io`, so `io.close_input` always runs.

## The general pattern

For any resource that must be cleaned up:
1. Acquire resource
2. `exception.try_io(use_resource(Resource), Outcome, !IO)`
3. Release resource (always)
4. Handle `Outcome`
