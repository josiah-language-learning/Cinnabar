:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module int.
:- import_module list.
:- import_module string.

% Exercise 1: require_complete_switch.
% Add flashing_amber to this type after completing Exercise 1 — the scope
% annotation will catch every switch that forgets to handle the new case.
:- type light ---> red ; amber ; green.

:- func action(light) = string.
action(Light) = Action :-
    require_complete_switch [Light]
    (
        Light = red,   Action = "stop"
    ;
        Light = amber, Action = "caution"
    ;
        Light = green, Action = "go"
    ).

% Exercise 2: require_det.
% Sum a non-empty list; use require_det to assert foldl is det here.
:- pred sum_nonempty(list(int)::in, int::out) is semidet.
sum_nonempty([], _) :- fail.
sum_nonempty([H | T], Sum) :-
    require_det (list.foldl(pred(X::in, A::in, B::out) is det :- B = X + A,
                            [H | T], 0, Sum)).

% Exercise 3: classify using both scopes together.
:- func classify(light) = string.
classify(Light) = Class :-
    require_complete_switch [Light]
    (
        Light = red,
        require_det (Class = "stop: " ++ action(Light))
    ;
        Light = amber,
        require_det (Class = "caution: " ++ action(Light))
    ;
        Light = green,
        require_det (Class = "go: " ++ action(Light))
    ).

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    check("action red = stop",
        ( action(red) = "stop" -> yes ; no ), !IO),
    check("action amber = caution",
        ( action(amber) = "caution" -> yes ; no ), !IO),
    check("action green = go",
        ( action(green) = "go" -> yes ; no ), !IO),
    check("sum_nonempty [1,2,3] = 6",
        ( sum_nonempty([1, 2, 3], S), S = 6 -> yes ; no ), !IO),
    check("sum_nonempty [] fails",
        ( \+ sum_nonempty([], _) -> yes ; no ), !IO),
    check("classify red",
        ( classify(red) = "stop: stop" -> yes ; no ), !IO),
    check("classify green",
        ( classify(green) = "go: go" -> yes ; no ), !IO).
    % To see require_complete_switch in action: add 'flashing_amber' to the
    % light type above, then recompile.  The build will immediately fail on
    % any switch missing a flashing_amber arm.
