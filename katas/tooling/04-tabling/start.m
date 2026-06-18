:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module int.
:- import_module list.
:- import_module string.

% Part 1: pragma memo — automatic memoisation.
% The compiler rewrites calls to cache (input → output) pairs.
:- func fib(int) = int.
:- pragma memo(fib/1).
fib(N) =
    ( N =< 1 -> N ; fib(N - 1) + fib(N - 2) ).

% Part 2: pragma loop_check — prevents infinite loops in tabled predicates.
% even/odd cycle: without loop_check, mutual recursion with tabling could loop.
:- pred my_even(int::in) is semidet.
:- pred my_odd(int::in)  is semidet.
:- pragma loop_check(my_even/1).
:- pragma loop_check(my_odd/1).

my_even(N) :- N = 0.
my_even(N) :- N > 0, my_odd(N - 1).
my_odd(N)  :- N > 0, my_even(N - 1).

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    check("fib(0) = 0",   ( fib(0)  = 0  -> yes ; no ), !IO),
    check("fib(10) = 55", ( fib(10) = 55 -> yes ; no ), !IO),
    check("fib(30) = 832040", ( fib(30) = 832040 -> yes ; no ), !IO),
    check("my_even(0)", ( my_even(0) -> yes ; no ), !IO),
    check("my_even(4)", ( my_even(4) -> yes ; no ), !IO),
    check("my_odd(3)",  ( my_odd(3)  -> yes ; no ), !IO),
    check("my_even(3) fails", ( my_even(3) -> no ; yes ), !IO).
