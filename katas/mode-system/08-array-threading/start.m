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

% ---------------------------------------------------------------
% array vs version_array — uniqueness and aliasing
% ---------------------------------------------------------------
%
% array(T) is UNIQUE (di/uo modes):
%   - Destructive update: O(1) per operation
%   - After array.set, the ORIGINAL is consumed — you cannot read it again
%   - Multiple aliases to the same array are forbidden
%   - Thread the array through every update with ! or explicit di/uo args
%
% version_array(T) is PERSISTENT (ordinary in/out modes):
%   - Copy-on-write: O(1) amortised (O(n) if you backtrack to old version)
%   - Original remains readable after an update — you can keep multiple refs
%   - Safe to read from multiple threads without threading constraints
%   - Cost: if you never need the old version, version_array wastes a copy
%
% ---------------------------------------------------------------

% Task 1 — build a histogram using a unique array.
%
% Given a list of integers in [0, max_val), count occurrences.
% Use array.init(Size, 0, A0) to create the initial array.
% Use array.set and array.lookup to update and read counts.
% Thread the array with !A (di/uo modes).
%
% Hint: array modes are array_di / array_uo (not di / uo directly).

:- pred histogram(list(int)::in, int::in, array(int)::array_uo) is det.
histogram(_Items, Size, A) :-
    array.init(Size, 0, A).   % stub — add item counting

% Task 2 — build the same histogram using version_array.
%
% version_array is not unique — you can keep old references.
% Use version_array.init(Size, 0, VA0) and version_array.set.
%
% Implement va_histogram with the same interface as histogram but
% returning a version_array(int). Thread with ordinary variables.

:- pred va_histogram(list(int)::in, int::in, version_array(int)::out) is det.
va_histogram(_Items, Size, VA) :-
    VA = version_array.init(Size, 0).   % stub — add item counting

% Task 3 — aliasing demo (version_array only).
%
% Create a version_array, make a copy of the reference (alias), then
% update the array. Show that the original alias still reads the old values.
% This is impossible with a unique array — the unique di mode forbids aliasing.

:- pred aliasing_demo(io::di, io::uo) is det.
aliasing_demo(!IO) :-
    VA0 = version_array.from_list([10, 20, 30]),
    % TODO: create VA1 by alias and VA2 by update, then show both are readable
    io.write_string("aliasing_demo: (stub)\n", !IO).

% ---------------------------------------------------------------

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    % Task 1: unique array histogram
    histogram([0, 1, 2, 1, 0, 0], 3, H),
    check("hist[0] = 3", ( array.lookup(H, 0) = 3 -> yes ; no ), !IO),
    check("hist[1] = 2", ( array.lookup(H, 1) = 2 -> yes ; no ), !IO),
    check("hist[2] = 1", ( array.lookup(H, 2) = 1 -> yes ; no ), !IO),

    % Task 2: version_array histogram
    va_histogram([0, 1, 2, 1, 0, 0], 3, VH),
    check("va hist[0] = 3", ( version_array.lookup(VH, 0) = 3 -> yes ; no ), !IO),
    check("va hist[1] = 2", ( version_array.lookup(VH, 1) = 2 -> yes ; no ), !IO),
    check("va hist[2] = 1", ( version_array.lookup(VH, 2) = 1 -> yes ; no ), !IO),

    % Task 3: aliasing demo
    aliasing_demo(!IO).
