:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module int.
:- import_module list.
:- import_module string.

:- type person
    --->    person(
                name :: string,
                age  :: int
            ).

% oldest: return the oldest person in a non-empty list.
% Use foldl to accumulate the maximum.
:- func oldest(list(person)) = person.
oldest([]) = person("nobody", 0).  % stub: handle non-empty list
oldest([H|_]) = H.                 % stub: this ignores the rest

% full_name: for now, just return the name field.
% Later: add a `title` field and prepend it.
:- func full_name(person) = string.
full_name(P) = P ^ name.

% count_adults: count persons aged >= 18.
:- func count_adults(list(person)) = int.
count_adults(_) = 0.   % stub

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    People = [
        person("Alice", 30),
        person("Bob",   17),
        person("Carol", 45),
        person("Dan",   12)
    ],
    Oldest = oldest(People),
    check("oldest is Carol",
          ( Oldest ^ name = "Carol" -> yes ; no ), !IO),
    check("count_adults = 2",
          ( count_adults(People) = 2 -> yes ; no ), !IO),
    check("full_name",
          ( full_name(person("Alice", 30)) = "Alice" -> yes ; no ), !IO).
