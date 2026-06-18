:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module map.
:- import_module string.

% FIX: use func(int) = int — callable without inst annotation
:- func double(int) = int.
double(X) = X * 2.

:- func negate(int) = int.
negate(X) = -X.

:- type transform_table == map(string, func(int) = int).

:- func build_table = transform_table.
build_table = Table :-
    map.set("double", double, map.init, T1),
    map.set("negate", negate, T1, Table).

main(!IO) :-
    Table = build_table,
    ( map.search(Table, "double", Transform) ->
        Result = Transform(5),
        io.format("Result: %d\n", [i(Result)], !IO)
    ;
        io.write_string("Not found\n", !IO)
    ).
