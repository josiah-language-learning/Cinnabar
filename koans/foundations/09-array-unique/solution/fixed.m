:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module array.
:- import_module int.
:- import_module list.
:- import_module string.

:- pred build_array(array(int)::array_uo) is det.
build_array(Result) :-
    array.init(5, 0, Arr0),
    array.set(0, 10, Arr0, Arr1),
    array.set(1, 20, Arr1, Arr2),    % fixed: use Arr1 (output of previous set)
    array.set(2, 30, Arr2, Result).

main(!IO) :-
    build_array(A),
    io.format("array: %s\n", [s(string.string(A))], !IO).
