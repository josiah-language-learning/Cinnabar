:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module string.
:- import_module float.
:- import_module list.

:- type item ---> item(name :: string, price :: float, qty :: int).

% Use power-of-2 prices so float arithmetic is exact in tests.
:- func sample_items = list(item).
sample_items = [
    item("apple",  1.0,  20),   % revenue 20.0, high stock
    item("banana", 2.0,  16),   % revenue 32.0, high stock
    item("cherry", 4.0,   8),   % revenue 32.0, not high stock
    item("date",   8.0,   4)    % revenue 32.0, not high stock
].

% Keep items with qty > 15.
:- pred high_stock(item::in) is semidet.
high_stock(_) :- fail.   % stub

% Revenue for one item: float(qty) * price.
:- func revenue(item) = float.
revenue(_) = 0.0.   % stub

% Two-accumulator fold: count high-stock items and sum their revenue.
:- pred tally(item::in, int::in, int::out, float::in, float::out) is det.
tally(_, Count, Count, Rev, Rev).   % stub

% Apply a det transform pred to every item in a list.
:- pred apply_transform(
    pred(item, item)::in(pred(in, out) is det),
    list(item)::in,
    list(item)::out) is det.
apply_transform(_, Items, Items).   % stub

% Double the qty field of an item.
:- pred double_qty(item::in, item::out) is det.
double_qty(Item, Item).   % stub

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    check("high_stock: apple (qty=20) passes",
        ( high_stock(item("apple", 1.0, 20)) -> yes ; no ), !IO),
    check("high_stock: cherry (qty=8) fails",
        ( \+ high_stock(item("cherry", 4.0, 8)) -> yes ; no ), !IO),
    check("revenue: apple = 20.0",
        ( revenue(item("apple", 1.0, 20)) = 20.0 -> yes ; no ), !IO),
    check("revenue: banana = 32.0",
        ( revenue(item("banana", 2.0, 16)) = 32.0 -> yes ; no ), !IO),
    list.filter(high_stock, sample_items, HighStock),
    check("filter: 2 high-stock items",
        ( list.length(HighStock) = 2 -> yes ; no ), !IO),
    Revenues = list.map(revenue, HighStock),
    list.foldl(pred(X::in, Acc::in, Sum::out) is det :- Sum = X + Acc,
               Revenues, 0.0, Total),
    check("total revenue: 52.0",
        ( Total = 52.0 -> yes ; no ), !IO),
    list.foldl2(tally, sample_items, 0, Count, 0.0, TallyRev),
    check("tally count = 2",
        ( Count = 2 -> yes ; no ), !IO),
    check("tally revenue = 52.0",
        ( TallyRev = 52.0 -> yes ; no ), !IO),
    Transform = (pred(I::in, O::out) is det :- double_qty(I, O)),
    apply_transform(Transform, [item("apple", 1.0, 20)], Doubled),
    check("double_qty: qty goes from 20 to 40",
        ( Doubled = [item("apple", 1.0, 40)] -> yes ; no ), !IO).
