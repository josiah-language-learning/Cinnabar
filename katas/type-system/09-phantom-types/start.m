:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module float.
:- import_module int.
:- import_module list.
:- import_module string.

% ===========================================================================
% Exercise 1: Phantom types as unit tags
%
% A phantom type carries a type parameter that appears in NO constructor.
% The parameter exists only at the type level — it vanishes at runtime.
% Its sole purpose is to prevent mixing values of different units.
%
% quantity(Unit) ---> quantity(float)
%
% `Unit` does not appear in the `quantity(float)` constructor body.
% It is "phantom" — present in the type, absent in the data.
% ===========================================================================

% Unit tags — used only as phantom parameters; the constructor is never called.
% Mercury requires at least one constructor per type, so each gets a dummy one.
:- type metres             ---> metres_unit.
:- type seconds            ---> seconds_unit.
:- type metres_per_second  ---> metres_per_second_unit.
:- type kilograms          ---> kilograms_unit.
:- type newtons            ---> newtons_unit.    % kg·m/s²

% The quantity type. Unit is phantom — no constructor uses it.
:- type quantity(Unit) ---> quantity(float).

% Smart constructors: the only way to create typed quantities.
:- func metres(float) = quantity(metres).
metres(X) = quantity(X).

:- func seconds(float) = quantity(seconds).
seconds(X) = quantity(X).

:- func kilograms(float) = quantity(kilograms).
kilograms(X) = quantity(X).

% Extract the raw value — loses type information.
:- func raw(quantity(U)) = float.
raw(quantity(X)) = X.

% Unit-safe arithmetic.
:- func add_qty(quantity(U), quantity(U)) = quantity(U).
add_qty(quantity(A), quantity(B)) = quantity(A + B).

:- func scale(float, quantity(U)) = quantity(U).
scale(K, quantity(X)) = quantity(K * X).

% Unit-converting operations. The result type encodes the derived unit.
:- func divide_speed(quantity(metres), quantity(seconds)) = quantity(metres_per_second).
divide_speed(quantity(D), quantity(T)) = quantity(D / T).

:- func force(quantity(kilograms), quantity(metres_per_second)) = quantity(newtons).
% F = m * (Δv/Δt) — simplified: treat the second arg as acceleration
force(quantity(M), quantity(A)) = quantity(M * A).

% ===========================================================================
% Exercise 2: Phantom types as compile-time state machines
%
% file_handle(State) ---> file_handle(string)
%
% `State` is phantom. Two phantom states: `open` and `closed`.
% Operations that require an open handle won't accept a closed one —
% and vice versa — enforced entirely by the type system.
% ===========================================================================

:- type open   ---> open_state.
:- type closed ---> closed_state.

:- type file_handle(State) ---> file_handle(string).

% "Open" a handle — transitions from closed to open.
:- func open_handle(file_handle(closed)) = file_handle(open).
open_handle(file_handle(Name)) = file_handle(Name).

% "Close" a handle — transitions from open to closed.
:- func close_handle(file_handle(open)) = file_handle(closed).
close_handle(file_handle(Name)) = file_handle(Name).

% Read from an open handle — only accepts file_handle(open).
:- func read_handle(file_handle(open)) = string.
read_handle(file_handle(Name)) = "contents of " ++ Name.

% Create an initial closed handle.
:- func new_handle(string) = file_handle(closed).
new_handle(Name) = file_handle(Name).

% ===========================================================================
% Checks
% ===========================================================================

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    % Exercise 1: unit arithmetic
    D = metres(100.0),
    T = seconds(9.58),
    Speed = divide_speed(D, T),
    check("100m / 9.58s ≈ 10.44 m/s",
        ( raw(Speed) > 10.0 -> yes ; no ), !IO),

    D2 = add_qty(metres(50.0), metres(50.0)),
    check("50m + 50m = 100m",
        ( raw(D2) = 100.0 -> yes ; no ), !IO),

    Scaled = scale(2.0, metres(5.0)),
    check("2 * 5m = 10m",
        ( raw(Scaled) = 10.0 -> yes ; no ), !IO),

    % Type safety demo (compile-time):
    % The following would be a TYPE ERROR — cannot mix metres and seconds:
    %   _ = add_qty(metres(1.0), seconds(1.0))   % ERROR: quantity(metres) ≠ quantity(seconds)
    %   _ = divide_speed(seconds(1.0), metres(1.0))  % ERROR: wrong unit order

    % Exercise 2: state machine
    H0 = new_handle("test.txt"),
    H1 = open_handle(H0),
    Contents = read_handle(H1),
    H2 = close_handle(H1),
    check("read from open handle",
        ( Contents = "contents of test.txt" -> yes ; no ), !IO),

    % Demonstrate the handle transitions don't lose the filename.
    H3 = open_handle(H2),
    Contents2 = read_handle(H3),
    check("re-opened handle reads same file",
        ( Contents2 = Contents -> yes ; no ), !IO).

    % The following would be TYPE ERRORS — enforced at compile time:
    %   _ = read_handle(H0)  % ERROR: H0 is file_handle(closed), not file_handle(open)
    %   _ = read_handle(H2)  % ERROR: H2 is file_handle(closed)
    %   _ = open_handle(H1)  % ERROR: H1 is already file_handle(open)
