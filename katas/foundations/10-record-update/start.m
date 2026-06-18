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

:- type person --->
    person(
        name  :: string,
        age   :: int,
        score :: float
    ).

% Exercise 1: field access with ^.
% Return the person's name.
:- func get_name(person) = string.
get_name(P) = P^name.   % already done — demonstrates ^ syntax

% Return the person's age plus one (do NOT mutate P).
:- func next_age(person) = int.
next_age(_P) = 0.   % stub: use ^age

% Exercise 2: functional update with :=.
% Return a new person identical to P but one year older.
:- func birthday(person) = person.
birthday(_P) = person("", 0, 0.0).   % stub: P^age := P^age + 1

% Return a new person with the given name, all other fields unchanged.
:- func rename(string, person) = person.
rename(_Name, _P) = person("", 0, 0.0).   % stub: P^name := Name

% Exercise 3: chained updates.
% Reset a person: set age to 0, score to 0.0, leave name.
:- func reset_stats(person) = person.
reset_stats(_P) = person("", 0, 0.0).   % stub: two chained := updates

% Exercise 4: update inside a predicate (threading).
% Increment score by Delta, threading Person through !-style (not IO, just value).
:- pred add_score(float::in, person::in, person::out) is det.
add_score(_Delta, P, P).   % stub: Out = P^score := P^score + Delta

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    P0 = person("Alice", 30, 88.5),
    % Exercise 1.
    check("get_name = Alice",
        ( get_name(P0) = "Alice" -> yes ; no ), !IO),
    check("next_age = 31",
        ( next_age(P0) = 31 -> yes ; no ), !IO),
    % Exercise 2.
    P1 = birthday(P0),
    check("birthday: age = 31",
        ( P1^age = 31 -> yes ; no ), !IO),
    check("birthday: name unchanged",
        ( P1^name = "Alice" -> yes ; no ), !IO),
    P2 = rename("Bob", P0),
    check("rename: name = Bob",
        ( P2^name = "Bob" -> yes ; no ), !IO),
    check("rename: age unchanged",
        ( P2^age = 30 -> yes ; no ), !IO),
    % Exercise 3.
    P3 = reset_stats(P0),
    check("reset_stats: age = 0",
        ( P3^age = 0 -> yes ; no ), !IO),
    check("reset_stats: score = 0.0",
        ( P3^score = 0.0 -> yes ; no ), !IO),
    check("reset_stats: name unchanged",
        ( P3^name = "Alice" -> yes ; no ), !IO),
    % Exercise 4.
    add_score(5.5, P0, P4),
    check("add_score: score = 94.0",
        ( P4^score = 94.0 -> yes ; no ), !IO),
    check("add_score: name unchanged",
        ( P4^name = "Alice" -> yes ; no ), !IO).
