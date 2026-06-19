# Solution

Delegate the multi-goal body to a module-level predicate:

```mercury
:- instance drawable(shape) where [
    draw(S, !IO) :- draw_shape(S, !IO)
].

:- pred draw_shape(shape::in, io::di, io::uo) is det.
draw_shape(S, !IO) :-
    describe(S, Str),
    io.write_string(Str ++ "\n", !IO).
```

The comma in `where [...]` is an *item separator*, not a goal conjunction. A clause
body inside a `where [...]` list ends at the first bare comma at the top level of
that item — the comma after `describe(S, Str)` terminates the body, and
`io.write_string(...)` becomes the next (invalid) item.

Single-goal bodies are always safe inside `where [...]`. The standard pattern for
multi-goal bodies is delegation to a module-level predicate. You can also group
goals explicitly in the clause body, but delegation keeps the instance declaration
clean and readable.
