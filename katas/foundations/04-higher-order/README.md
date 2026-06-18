# 04 — Higher-order: predicates as values

**Concept:** `list.map`, `list.filter`, `list.filter_map`, `list.foldl2`, storing predicates
in variables with inst annotations, `call/N`

**Tutorial note:** the Mercury tutorial may cover basic `list.map`. This kata focuses on
what the tutorial does not: storing predicates in variables, the mandatory inst annotation,
and `call/N`.

---

## What you will build

A small data pipeline. You have a hardcoded list of sales records — use whatever domain
suits you (items with name, price, quantity; employees with name, salary, department; etc.).
Build a pipeline that:
1. Filters to a subset
2. Transforms each element
3. Folds to compute a summary

Then: stores a step of the pipeline in a variable and calls it via `call`.

---

## Steps

### 1. Define a record type and sample data

```mercury
:- type item ---> item(name :: string, price :: float, qty :: int).

:- func sample_items = list(item).
sample_items = [
    item("apple",  0.5,  30),
    item("banana", 0.3,  50),
    item("cherry", 2.0,  10),
    item("date",   5.0,   5)
].
```

### 2. Filter, map, fold

```mercury
% Keep items with qty > 15
:- pred high_stock(item::in) is semidet.
high_stock(Item) :- Item^qty > 15.

% Compute revenue for one item
:- func revenue(item) = float.
revenue(Item) = float(Item^qty) * Item^price.

% Sum revenues
:- pred add_revenue(item::in, float::in, float::out) is det.
add_revenue(Item, Acc, Acc + revenue(Item)).
```

Wire them together inside your `main(!IO)` body:
```mercury
list.filter(high_stock, sample_items, HighStock),
Revenues = list.map(revenue, HighStock),
list.foldl(pred(X::in, Acc::in, Sum::out) is det :- Sum = X + Acc,
           Revenues, 0.0, Total),
io.format("Total revenue: %.2f\n", [f(Total)], !IO).
```

Note: `list.map(revenue, HighStock)` uses the function form (result on the left of `=`).
The three-argument predicate form expects a `pred(T, U)`, not a `func(T) = U`. Also,
`float.plus` does not exist in the standard library — use an explicit lambda for the fold.

Then do it in one pass with `list.filter_map`. Write this helper:
```mercury
:- func high_stock_revenue(item) = maybe(float).
high_stock_revenue(Item) =
    ( Item^qty > 15 -> yes(revenue(Item)) ; no ).
```

And call it in `main`:
```mercury
list.filter_map(high_stock_revenue, sample_items, Revenues2),
list.foldl(pred(X::in, Acc::in, Sum::out) is det :- Sum = X + Acc,
           Revenues2, 0.0, Total2),
io.format("Total revenue (filter_map): %.2f\n", [f(Total2)], !IO).
```

Both should give the same total.

### 3. Two-accumulator fold with `foldl2`

Count high-stock items and sum their revenue simultaneously. Write `tally`:
```mercury
:- pred tally(item::in, int::in, int::out, float::in, float::out) is det.
tally(Item, Count0, Count, Rev0, Rev) :-
    ( Item^qty > 15 ->
        Count = Count0 + 1,
        Rev = Rev0 + revenue(Item)
    ;
        Count = Count0,
        Rev = Rev0
    ).
```

Call it in `main`:
```mercury
list.foldl2(tally, sample_items, 0, Count, 0.0, TotalRev),
io.format("Count: %d, Revenue: %.2f\n", [i(Count), f(TotalRev)], !IO).
```

### 4. Store a predicate in a variable

```mercury
:- pred apply_transform(
    pred(item, item)::in(pred(in, out) is det),
    list(item)::in,
    list(item)::out) is det.
apply_transform(Transform, Items, Mapped) :-
    list.map(Transform, Items, Mapped).
```

Now write a concrete transform:
```mercury
:- pred double_qty(item::in, item::out) is det.
double_qty(Item, item(Item^name, Item^price, Item^qty * 2)).
```

Store it and call from `main`:
```mercury
Transform = double_qty,   % type error without inst annotation — see step 5
apply_transform(Transform, sample_items, Doubled),
io.write_line(Doubled, !IO).
```

### 5. The inst annotation

The line `Transform = double_qty` above will fail to compile. The compiler does not know
the *inst* of `Transform` — whether it is a variable or a specific predicate. Add the
annotation:

```mercury
Transform = (pred(I::in, O::out) is det :- double_qty(I, O)),
```

or declare a named inst:
```mercury
:- inst item_transform == (pred(in, out) is det).
:- pred apply_transform(
    pred(item, item)::in(item_transform), ...).
```

Read the exact compiler error you get without the annotation. Save it — this error is what
`koans/foundations/03-higher-order` recreates.

---

## Checkpoint

- All three pipeline approaches produce the same result
- `foldl2` counts and sums in one pass
- The inst-annotated version compiles; the unannotated version gives the expected error
- You can explain: why does Mercury need the inst annotation on higher-order arguments
  when OCaml or Haskell does not?
