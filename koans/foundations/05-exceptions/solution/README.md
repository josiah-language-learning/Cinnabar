# Solution: pattern-match on `io.res`

`io.open_input` has the signature:
```mercury
:- pred io.open_input(string::in, io.res(io.text_input_stream)::out,
                      io::di, io::uo) is det.
```

The third argument is `io.res(io.text_input_stream)`, not `io.text_input_stream`. You
must pattern-match on `ok(Stream)` or `error(Err)` before using the stream.

```mercury
io.open_input(Filename, OpenRes, !IO),
(
    OpenRes = ok(Stream),
    io.read_line_as_string(Stream, ReadRes, !IO),
    io.close_input(Stream, !IO),
    (
        ReadRes = ok(Line), io.write_string(Line, !IO)
    ;
        ReadRes = eof, io.write_string("(empty)\n", !IO)
    ;
        ReadRes = error(E),
        io.format("Read error: %s\n", [s(io.error_message(E))], !IO)
    )
;
    OpenRes = error(Err),
    io.format("Cannot open: %s\n", [s(io.error_message(Err))], !IO)
).
```

## The pattern

`io.res(T)` is:
```mercury
:- type io.res(T) ---> ok(T) ; error(io.error).
```

Every file operation that can fail returns `io.res`. You must handle both branches.
Mercury's type system enforces this — you cannot extract the value without pattern matching.
