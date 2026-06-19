:- module array_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module array.
:- import_module int.
:- import_module list.
:- import_module string.

% Build an array with three slots set to non-zero values.
%
% BUG: array.set consumes its input array (mode array_di -> array_uo).
% Arr0 is consumed by the first set; it cannot be passed to the second.
% Each update must thread through the *output* of the previous call.
:- pred build_array(array(int)::array_uo) is det.
build_array(Result) :-
    array.init(5, 0, Arr0),
    array.set(0, 10, Arr0, Arr1),
    array.set(1, 20, Arr0, Arr2),    % BUG: Arr0 already consumed; should be Arr1
    array.set(2, 30, Arr2, Result).

main(!IO) :-
    build_array(A),
    io.format("array: %s\n", [s(string.string(A))], !IO).
