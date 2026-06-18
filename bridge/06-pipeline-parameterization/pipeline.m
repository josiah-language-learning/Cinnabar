:- module pipeline.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module float.
:- import_module int.
:- import_module list.
:- import_module maybe.
:- import_module string.

:- type item ---> item(name :: string, price :: float, qty :: int).

:- func sample_items = list(item).
sample_items = [
    item("apple",  0.5,  30),
    item("banana", 0.3,  50),
    item("cherry", 2.0,  10),
    item("date",   5.0,   5)
].

:- pred high_stock(item::in) is semidet.
high_stock(Item) :- Item^qty > 15.

:- func revenue(item) = float.
revenue(Item) = float(Item^qty) * Item^price.

:- pred tally(item::in, int::in, int::out, float::in, float::out) is det.
tally(Item, Count0, Count, Rev0, Rev) :-
    ( Item^qty > 15 ->
        Count = Count0 + 1,
        Rev = Rev0 + revenue(Item)
    ;
        Count = Count0,
        Rev = Rev0
    ).

main(!IO) :-
    list.filter(high_stock, sample_items, HighStock),
    Revenues = list.map(revenue, HighStock),
    list.foldl(pred(X::in, Acc::in, Sum::out) is det :- Sum = X + Acc,
               Revenues, 0.0, Total),
    io.format("Filter+map total:   %.2f\n", [f(Total)], !IO),

    list.foldl2(tally, sample_items, 0, Count, 0.0, TotalRev),
    io.format("foldl2 count: %d, total: %.2f\n", [i(Count), f(TotalRev)], !IO).
