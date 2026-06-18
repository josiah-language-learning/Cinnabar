# Solution: use codepoint-aware operations

`string.length` measures bytes (code units). For human-visible character counts, use
`string.count_codepoints`. For substring extraction by codepoint position, use
`string.codepoint_offset` to find the byte offset, then `string.between`.

```mercury
% Fixed:
:- func truncate_to(string, int) = string.
truncate_to(S, MaxLen) = Result :-
    CPCount = string.count_codepoints(S),
    ( CPCount =< MaxLen ->
        Result = S
    ;
        % Find the byte offset of codepoint MaxLen
        ( string.codepoint_offset(S, MaxLen, ByteOffset) ->
            Result = string.between(S, 0, ByteOffset)
        ;
            Result = S   % MaxLen >= length, shouldn't happen here
        )
    ).
```

## The key predicates

| Predicate | Measures | Use when |
|-----------|----------|----------|
| `string.length(S)` | bytes | byte-level indexing, FFI, `string.between` offsets |
| `string.count_codepoints(S)` | codepoints | human-visible character count |
| `string.codepoint_offset(S, N, Off)` | → byte offset of Nth codepoint | convert codepoint N to byte position for `between` |
