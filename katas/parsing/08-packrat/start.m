:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module int.
:- import_module list.
:- import_module string.

% PACKRAT PARSING VIA TABLING:
%
% Standard DCG rules backtrack, giving potentially exponential time on
% grammars with common prefixes. Adding `pragma memo` to top-level DCG
% rules memoizes each (rule, position) pair — each rule evaluates at most
% once per input position. This is the packrat parsing algorithm.
%
% The constraint: tabled predicates must be `det` or `semidet`. Tabling
% `nondet` predicates requires a different pragma (`pragma minimal_model`).
%
% GRAMMAR (common-prefix, nearly ambiguous):
%   s --> a, b, [c]
%       | a, b, [d]
%   a --> [x], a | []
%   b --> [y], b | []
%   (Both alternatives of s share a long common prefix parsed by a and b.)

:- type token ---> x ; y ; c ; d.

% ---- Without tabling (may re-parse common prefixes) -----------------------
%
% Note: multi-clause DCG rules are nondet/multi. To get det/semidet, use
% if-then-else inside the rule — that commits to one branch.

:- pred s_naive(list(token)::in, list(token)::out) is semidet.
s_naive --> a_naive, b_naive, ( [c] -> [] ; [d] ).

:- pred a_naive(list(token)::in, list(token)::out) is det.
a_naive --> ( [x] -> a_naive ; [] ).

:- pred b_naive(list(token)::in, list(token)::out) is det.
b_naive --> ( [y] -> b_naive ; [] ).

% ---- With tabling (packrat) -----------------------------------------------
%
% pragma memo on a DCG rule memoizes it per input-list position.
% The hidden list arguments are the two extra args memo operates on.

:- pred s_tabled(list(token)::in, list(token)::out) is semidet.
s_tabled --> a_tabled, b_tabled, ( [c] -> [] ; [d] ).

:- pred a_tabled(list(token)::in, list(token)::out) is det.
:- pragma memo(a_tabled/2).
a_tabled --> ( [x] -> a_tabled ; [] ).

:- pred b_tabled(list(token)::in, list(token)::out) is det.
:- pragma memo(b_tabled/2).
b_tabled --> ( [y] -> b_tabled ; [] ).

% ---- Helpers ---------------------------------------------------------------

:- func make_input(int, int, token) = list(token).
make_input(NX, NY, Suffix) = list.duplicate(NX, x) ++ list.duplicate(NY, y) ++ [Suffix].

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    % Basic parse: xxx yyy c → succeeds.
    Input1 = make_input(3, 3, c),
    check("s_naive parses xxxyyc",
        ( s_naive(Input1, []) -> yes ; no ), !IO),
    check("s_tabled parses xxxyyc",
        ( s_tabled(Input1, []) -> yes ; no ), !IO),
    % Suffix 'd' also works.
    Input2 = make_input(2, 2, d),
    check("s_naive parses xxyyd",
        ( s_naive(Input2, []) -> yes ; no ), !IO),
    check("s_tabled parses xxyyd",
        ( s_tabled(Input2, []) -> yes ; no ), !IO),
    % Does not parse when suffix is missing.
    check("s_naive rejects xxy (no c/d)",
        ( s_naive([x, x, y], []) -> no ; yes ), !IO),
    % Stub: time both parsers on a large input (NX=NY=1000) and report.
    % See README for timing instructions.
    io.write_string("Packrat compile-checks done. See README for timing.\n", !IO).
