:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module int.
:- import_module list.
:- import_module string.

% DCG DESUGARING:
%
% Every DCG rule `head --> body` is syntactic sugar for a predicate with two
% extra list arguments (S0 and S — "input state" and "output state").
%
%   terminal [t]      --> S0 = [t | S]
%   rule_call r(X)    --> r(X, S0, S)
%   sequence (A, B)   --> A(S0, S1), B(S1, S)
%   alternative (A;B) --> (A(S0, S) ; B(S0, S))
%   embedded goal {G} --> G, S0 = S
%   empty []          --> S0 = S
%   pushback rule//3  --> adds a third hidden arg for pushback tokens
%
% This kata: implement a DCG desugarer in Mercury.
% Input: a simplified DCG body as an ADT.
% Output: the desugared goal as a Mercury term (also an ADT).

% ---- ADT for simplified DCG rules -----------------------------------------

:- type dcg_body
    --->    terminal(string)            % [token]
    ;       rule_call(string)           % rule_name
    ;       rule_call_arg(string, int)  % rule_name(arg)  (arg as int for simplicity)
    ;       seq(dcg_body, dcg_body)     % (A, B)
    ;       alt(dcg_body, dcg_body)     % (A ; B)
    ;       embed(string)               % {goal as string}
    ;       empty.                      % []

% ---- ADT for desugared Mercury goals --------------------------------------

:- type mercury_goal
    --->    unify_head(string, string)           % S0 = [token | S1]
    ;       call(string, string, string)         % pred(S0, S1)
    ;       call_arg(string, int, string, string)% pred(arg, S0, S1)
    ;       conj(mercury_goal, mercury_goal)     % (A, B)
    ;       disj(mercury_goal, mercury_goal)     % (A ; B)
    ;       pure_goal(string)                    % embedded goal (string)
    ;       state_pass(string, string).          % S0 = S (no consumption)

% ---- Desugarer ------------------------------------------------------------

% desugar: convert a DCG body to a Mercury goal, threading state variables.
% s0_name: the "input state" variable name for this fragment.
% s_name:  the "output state" variable name for this fragment.
% Returns the desugared goal plus the final output variable name.
:- pred desugar(dcg_body::in, string::in, string::in, mercury_goal::out) is det.
desugar(terminal(Tok), S0, S, unify_head(S0, Tok ++ "|" ++ S)).
desugar(rule_call(Name), S0, S, call(Name, S0, S)).
desugar(rule_call_arg(Name, Arg), S0, S, call_arg(Name, Arg, S0, S)).
desugar(seq(A, B), S0, S, conj(GoalA, GoalB)) :-
    S1 = S0 ++ "_1",
    desugar(A, S0, S1, GoalA),
    desugar(B, S1, S, GoalB).
desugar(alt(A, B), S0, S, disj(GoalA, GoalB)) :-
    desugar(A, S0, S, GoalA),
    desugar(B, S0, S, GoalB).
desugar(embed(Goal), S0, S, conj(pure_goal(Goal), state_pass(S0, S))).
desugar(empty, S0, S, state_pass(S0, S)).

% ---- Pretty-printer for mercury_goal --------------------------------------

:- func goal_to_string(mercury_goal) = string.
goal_to_string(unify_head(S0, Tok)) =
    S0 ++ " = [" ++ Tok ++ "]".
goal_to_string(call(Name, S0, S)) =
    Name ++ "(" ++ S0 ++ ", " ++ S ++ ")".
goal_to_string(call_arg(Name, Arg, S0, S)) =
    Name ++ "(" ++ string.int_to_string(Arg) ++ ", " ++ S0 ++ ", " ++ S ++ ")".
goal_to_string(conj(A, B)) =
    "(" ++ goal_to_string(A) ++ ",\n " ++ goal_to_string(B) ++ ")".
goal_to_string(disj(A, B)) =
    "(" ++ goal_to_string(A) ++ " ;\n " ++ goal_to_string(B) ++ ")".
goal_to_string(pure_goal(G)) = "{" ++ G ++ "}".
goal_to_string(state_pass(S0, S)) = S0 ++ " = " ++ S.

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    % Desugar: [x] --> terminal("x")
    desugar(terminal("x"), "S0", "S", G1),
    check("terminal desugars to unification",
        ( G1 = unify_head("S0", _) -> yes ; no ), !IO),
    io.format("  terminal: %s\n", [s(goal_to_string(G1))], !IO),
    % Desugar: ([x], rule_r)
    desugar(seq(terminal("x"), rule_call("r")), "S0", "S", G2),
    check("seq desugars to conjunction",
        ( G2 = conj(_, _) -> yes ; no ), !IO),
    io.format("  seq: %s\n", [s(goal_to_string(G2))], !IO),
    % Desugar: ([x] ; [y])
    desugar(alt(terminal("x"), terminal("y")), "S0", "S", G3),
    check("alt desugars to disjunction",
        ( G3 = disj(_, _) -> yes ; no ), !IO),
    io.format("  alt: %s\n", [s(goal_to_string(G3))], !IO),
    % Desugar: {Goal}
    desugar(embed("X = 42"), "S0", "S", G4),
    check("embed desugars to pure goal + state pass",
        ( G4 = conj(pure_goal(_), state_pass(_, _)) -> yes ; no ), !IO),
    % Desugar: []
    desugar(empty, "S0", "S", G5),
    check("empty desugars to state pass",
        ( G5 = state_pass("S0", "S") -> yes ; no ), !IO),
    % Stub: extend the desugarer to handle pushback notation (//3 rules),
    % where a third extra argument carries "pushed back" unconsumed tokens.
    io.write_string("(See README for pushback extension.)\n", !IO).
