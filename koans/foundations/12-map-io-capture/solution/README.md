# Solution

Replace `list.map` with `list.foldl` and thread `!IO` through the call:

```mercury
print_all(Strs, !IO) :-
    list.foldl(
        (pred(S::in, !.IO::di, !:IO::uo) is det :-
            io.write_string(S ++ "\n", !IO)),
        Strs, !IO).
```

`list.foldl` accepts an extra pair of arguments for threading state — here
`!IO`. The lambda head declares them as `!.IO::di, !:IO::uo`, which is the
explicit form of what `!IO` expands to in a call position. Mercury threads the
IO token through each invocation sequentially, producing a linear chain.

`list.map` is for pure, effect-free transformations. Whenever you need IO (or
any stateful accumulator) inside the iteration, reach for `list.foldl`.
