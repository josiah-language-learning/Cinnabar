:- module ho_inst_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module map.
:- import_module string.

:- pred double(int::in, int::out) is det.
double(X, Y) :- Y = X * 2.

:- pred negate(int::in, int::out) is det.
negate(X, Y) :- Y = -X.

% BUG: map value type is pred(int, int) without inst.
% When retrieved, the pred has inst 'ground', which is not callable.
:- type transform_table == map(string, pred(int, int)).

:- func build_table = transform_table.
build_table = map.from_assoc_list([
    "double" - double,
    "negate" - negate
]).

main(!IO) :-
    Table = build_table,
    ( map.search(Table, "double", Transform) ->
        % MODE ERROR: Transform has inst 'ground', cannot call with call/2
        call(Transform, 5, Result),
        io.format("Result: %d\n", [i(Result)], !IO)
    ;
        io.write_string("Not found\n", !IO)
    ).
