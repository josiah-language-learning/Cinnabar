# Solution notes

## Task 1: adding `category`

Adding a field to a constructor type forces you to update every pattern match on that
constructor. In this codebase, the only pattern match on `item(...)` is in `tally` —
the rest use field access (`Item^qty`, `Item^price`). Mercury's exhaustiveness checking
will flag the pattern-match if you forget to update it.

## Task 2: `group_by_category`

The accumulator pattern:

```mercury
:- import_module map.

group_by_category(Items, Groups) :-
    list.foldl(insert_item, Items, map.init, Groups).

:- pred insert_item(item::in,
                    map(string, list(item))::in,
                    map(string, list(item))::out) is det.
insert_item(Item, !Map) :-
    Cat = Item^category,
    ( map.search(!.Map, Cat, Existing) ->
        map.set(Cat, [Item | Existing], !Map)
    ;
        map.set(Cat, [Item], !Map)
    ).
```

Note: items within each group are in reverse insertion order due to `[Item | Existing]`.
If order matters, reverse each group after building the map.

## Task 3: sorting and inst annotation

The inst annotation on `print_category` for `list.foldl`:

```mercury
:- pred print_category(map(string, list(item))::in, string::in,
                       io::di, io::uo) is det.
```

`list.foldl` over `!IO` requires the predicate to have a specific inst. The standard
form is `pred(in, di, uo) is det` — Mercury infers this from the predicate declaration.

## Task 4: generic `group_by`

```mercury
:- pred group_by(func(T) = K, list(T), map(K, list(T))).
:- mode group_by(in(func(in) = out is det), in, out) is det.
group_by(KeyFn, Items, Groups) :-
    list.foldl(
        (pred(Item::in, M0::in, M::out) is det :-
            Key = apply(KeyFn, Item),
            ( map.search(M0, Key, Existing) ->
                map.set(Key, [Item | Existing], M0, M)
            ;
                map.set(Key, [Item], M0, M)
            )),
        Items, map.init, Groups).
```

The inst annotation `in(func(in) = out is det)` tells the mode checker that `KeyFn` is
a callable function taking one `in` argument and returning a value deterministically.
Without this, the compiler cannot verify the `apply` call is safe.
