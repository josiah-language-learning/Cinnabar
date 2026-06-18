# Solution: use the public interface, not the internal constructor

The fix is to use `stack.pop` and `stack.is_empty` instead of pattern-matching on
`stack_node`:

```mercury
:- pred drain_stack(stack(int)::in, io::di, io::uo) is det.
drain_stack(S, !IO) :-
    ( stack.is_empty(S) ->
        io.write_string("(empty)\n", !IO)
    ;
        stack.pop(S, Top, Rest),
        io.format("%d\n", [i(Top)], !IO),
        drain_stack(Rest, !IO)
    ).
```

## Why the abstraction matters

`stack.m` could change its internal representation from `stack_node/2` to a `list(T)` or
an array, and all client code that uses only the public interface would continue to work
without recompilation. Client code that pattern-matches on `stack_node` would break.

Mercury's module system enforces this boundary at compile time: the constructor `stack_node`
is simply not visible outside `stack.m`, so client code cannot depend on it accidentally.
