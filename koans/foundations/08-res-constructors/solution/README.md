# Solution

Change `yes(Stream)` to `ok(Stream)`.

`io.res(T)` has two constructors: `ok(T)` for success and `error(io.error)` for
failure. The `yes`/`no` constructors belong to `maybe(T)`, which is a different
type. Both carry a payload on success and signal absence on failure, but they
are not interchangeable — Mercury's type system enforces the distinction.

```mercury
( Result = ok(Stream) ->
    ...
;
    io.write_string("could not open file\n", !IO)
).
```

The inner `Contents = ok(Str)` needed no fix: `io.read_file_as_string` also
returns `io.res(string)`, so `ok` was already correct there.
