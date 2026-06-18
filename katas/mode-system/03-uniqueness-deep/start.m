:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module array.
:- import_module bool.
:- import_module int.
:- import_module list.
:- import_module string.
:- import_module version_array.

% Part 1: mutable array (unique — destructive update, O(1)).
% init_array: create an array of N zeros.
:- pred init_array(int::in, array(int)::array_uo) is det.
init_array(N, A) :-
    array.init(N, 0, A).

% set_element: destructively update index I to value V.
:- pred set_element(int::in, int::in,
                    array(int)::array_di, array(int)::array_uo) is det.
set_element(I, V, !A) :-
    array.set(I, V, !A).

% Part 2: version_array (persistent — can alias, but update is amortised O(1)).
% shared_demo: show that two handles can read the same version_array after init.
:- pred shared_demo(version_array(int)::in, int::out, int::out) is det.
shared_demo(VA, A0, A1) :-
    A0 = version_array.lookup(VA, 0),
    A1 = version_array.lookup(VA, 1).

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    % Mutable array demo
    init_array(3, A0),
    set_element(1, 99, A0, A1),
    check("array set index 1",
          ( array.lookup(A1, 1) = 99 -> yes ; no ), !IO),
    check("array index 0 untouched",
          ( array.lookup(A1, 0) = 0  -> yes ; no ), !IO),

    % Version array demo: two aliases of the same initial state
    VA0 = version_array.from_list([10, 20, 30]),
    shared_demo(VA0, E0, E1),
    check("version_array lookup 0", ( E0 = 10 -> yes ; no ), !IO),
    check("version_array lookup 1", ( E1 = 20 -> yes ; no ), !IO),

    % Update version_array — original VA0 still readable
    version_array.set(0, 99, VA0, VA1),
    check("VA1 updated 0 = 99",
          ( version_array.lookup(VA1, 0) = 99 -> yes ; no ), !IO),
    check("VA0 still has 10 (persistent)",
          ( version_array.lookup(VA0, 0) = 10 -> yes ; no ), !IO).
