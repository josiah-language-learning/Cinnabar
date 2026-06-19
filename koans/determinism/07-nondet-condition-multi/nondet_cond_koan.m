:- module nondet_cond_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module string.

% find_tag is nondet — it generates all tags with length > 3, one at a time.
:- pred find_tag(list(string)::in, string::out) is nondet.
find_tag(Tags, Tag) :-
    list.member(Tag, Tags),
    string.length(Tag) > 3.

% BUG: find_tag is nondet; using it as the condition of an if-then-else
% makes classify multi, not det. Each solution of find_tag produces a
% separate result — this is NOT committed-choice (cc_nondet).
:- pred classify(list(string)::in, string::out) is det.
classify(Tags, Result) :-
    ( find_tag(Tags, Tag) ->
        Result = "found: " ++ Tag
    ;
        Result = "none"
    ).

main(!IO) :-
    classify(["ok", "error", "warning", "debug"], R),
    io.format("%s\n", [s(R)], !IO).
