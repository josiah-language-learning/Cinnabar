# Solution: call DCG rules directly

DCG rules expand to predicates with two hidden `list` arguments. To call a DCG rule
from regular (non-DCG) Mercury code, call the expanded predicate directly:

```mercury
% Full consumption — remainder must be []
words(Ws, Input, [])

% Partial consumption — bind the remainder
words(Ws, Input, Rest)
```

Fixed `count_words`:
```mercury
:- pred count_words(list(char)::in, int::out) is det.
count_words(Input, Count) :-
    ( words(Ws, Input, []) ->
        list.length(Ws, Count)
    ;
        Count = 0
    ).
```

## The hidden argument expansion

A DCG rule `words(Ws) --> ...` expands to `words(Ws, L0, L) :- ...`. The two extra
arguments are the input list and the remainder list. Calling `words(Ws, Input, [])` is
full consumption. Calling `words(Ws, Input, Rest)` leaves the unconsumed tail in `Rest`.

Note: Mercury 22.01.8 does not provide `phrase/2` or `phrase/3` in the standard library.
Call the expanded DCG predicate directly.

Calling `words(Ws, Input)` as in the koan uses only 2 of the 3 arguments — wrong arity.
