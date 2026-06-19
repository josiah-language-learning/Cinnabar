:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module string.

:- pred classify(list(string)::in, string::out) is det.
classify(Tags, Result) :-
    (
        list.find_first_match(
            pred(T::in) is semidet :- string.length(T) > 3,
            Tags, Tag)
    ->
        Result = "found: " ++ Tag
    ;
        Result = "none"
    ).

main(!IO) :-
    classify(["ok", "error", "warning", "debug"], R),
    io.format("%s\n", [s(R)], !IO).
