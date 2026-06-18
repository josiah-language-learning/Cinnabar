:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module list.
:- import_module string.

:- type day ---> mon ; tue ; wed ; thu ; fri ; sat ; sun.

% is_weekday: multi-clause (or if-then-else) function over a discriminated union.
% Each constructor of `day` should map to yes or no.
:- func is_weekday(day) = bool.
is_weekday(_) = no.   % stub: cover each constructor separately

% day_name: map a day to its string name (for display).
:- func day_name(day) = string.
day_name(_) = "???".  % stub

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    check("mon is weekday",   ( is_weekday(mon) = yes -> yes ; no ), !IO),
    check("fri is weekday",   ( is_weekday(fri) = yes -> yes ; no ), !IO),
    check("sat not weekday",  ( is_weekday(sat) = no  -> yes ; no ), !IO),
    check("sun not weekday",  ( is_weekday(sun) = no  -> yes ; no ), !IO),
    check("wed name",         ( day_name(wed) = "Wednesday" -> yes ; no ), !IO).
