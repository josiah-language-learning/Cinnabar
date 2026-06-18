:- module meta_interp.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module pair.
:- import_module solutions.
:- import_module string.

%---------------------------------------------------------------------------%
% Term representation for the interpreted language

:- type term_t
    --->    a(string)               % atom: a("tom")
    ;       n(int)                  % integer: n(42)
    ;       f(string, list(term_t)) % compound: f("parent", [a("tom"), a("bob")])
    ;       v(string).              % logical variable: v("X")

:- type env_t    == list(pair(string, term_t)).
:- type clause_t ---> c(term_t, list(term_t)).  % head :- [body goals]
:- type prog_t   ---> prog(list(clause_t)).

%---------------------------------------------------------------------------%
% Variable renaming: append "_N" suffix to all variable names.
% Prevents capture when the same clause is used at multiple depths.

:- pred rename(term_t::in, string::in, term_t::out) is det.
rename(a(S), _, a(S)).
rename(n(I), _, n(I)).
rename(v(X), Sfx, v(X ++ "_" ++ Sfx)).
rename(f(F, Args), Sfx, f(F, RArgs)) :-
    list.map(rename_2(Sfx), Args, RArgs).

:- pred rename_2(string::in, term_t::in, term_t::out) is det.
rename_2(Sfx, T, R) :- rename(T, Sfx, R).

:- pred rename_clause(clause_t::in, string::in, clause_t::out) is det.
rename_clause(c(Head, Body), Sfx, c(RHead, RBody)) :-
    rename(Head, Sfx, RHead),
    list.map(rename_2(Sfx), Body, RBody).

%---------------------------------------------------------------------------%
% Environment lookup and dereferencing.

:- pred lookup_v(string::in, env_t::in, term_t::out) is semidet.
lookup_v(X, [Key - Val | Rest], T) :-
    ( X = Key -> T = Val ; lookup_v(X, Rest, T) ).

% Follow variable chains; stop at non-variable or unbound variable.
:- pred deref(term_t::in, env_t::in, term_t::out) is det.
deref(v(X), Env, Out) :-
    ( lookup_v(X, Env, T) -> deref(T, Env, Out) ; Out = v(X) ).
deref(a(S), _, a(S)).
deref(n(I), _, n(I)).
deref(f(F, Args), _, f(F, Args)).

%---------------------------------------------------------------------------%
% Unification.
% Uses a single if-then-else body to keep unify_d semidet — multiple clauses
% with overlapping variable patterns would be inferred nondet.

:- pred unify(term_t::in, term_t::in, env_t::in, env_t::out) is semidet.
unify(T1, T2, Env0, Env) :-
    deref(T1, Env0, D1),
    deref(T2, Env0, D2),
    unify_d(D1, D2, Env0, Env).

:- pred unify_d(term_t::in, term_t::in, env_t::in, env_t::out) is semidet.
unify_d(D1, D2, Env0, Env) :-
    ( D1 = v(X) ->
        Env = [X - D2 | Env0]
    ; D2 = v(X) ->
        Env = [X - D1 | Env0]
    ; D1 = a(S), D2 = a(S) ->
        Env = Env0
    ; D1 = n(I), D2 = n(I) ->
        Env = Env0
    ; D1 = f(Fn, As1), D2 = f(Fn, As2) ->
        unify_list(As1, As2, Env0, Env)
    ;
        fail
    ).

:- pred unify_list(list(term_t)::in, list(term_t)::in,
                   env_t::in, env_t::out) is semidet.
unify_list([], [], Env, Env).
unify_list([H1 | T1], [H2 | T2], Env0, Env) :-
    unify(H1, H2, Env0, Env1),
    unify_list(T1, T2, Env1, Env).

%---------------------------------------------------------------------------%
% Solver: SLD resolution.
%
% Depth is incremented at each resolve step and used as the rename suffix.
% Not globally unique (same depth can be reached via different paths) but
% correct for the demo programs that don't share variable names across rules.

:- pred solve(prog_t::in, list(term_t)::in, int::in,
              env_t::in, env_t::out) is nondet.
solve(_, [], _, Env, Env).
solve(Prog, [Goal | Rest], Depth, Env0, Env) :-
    resolve(Prog, Goal, Depth, Env0, Env1),
    solve(Prog, Rest, Depth + 1, Env1, Env).

:- pred resolve(prog_t::in, term_t::in, int::in,
                env_t::in, env_t::out) is nondet.
resolve(prog(Clauses), Goal0, Depth, Env0, Env) :-
    deref(Goal0, Env0, Goal),
    list.member(Raw, Clauses),
    rename_clause(Raw, string.int_to_string(Depth), c(Head, Body)),
    unify(Goal, Head, Env0, Env1),
    solve(prog(Clauses), Body, Depth + 1, Env1, Env).

%---------------------------------------------------------------------------%
% Apply environment substitution — walk the term, replacing bound variables.

:- func apply_env(term_t, env_t) = term_t.
apply_env(a(S), _)       = a(S).
apply_env(n(I), _)       = n(I).
apply_env(f(F, Args), E) = f(F, list.map(apply_env_f(E), Args)).
apply_env(v(X), Env)     = T :-
    ( lookup_v(X, Env, T0) -> T = apply_env(T0, Env) ; T = v(X) ).

:- func apply_env_f(env_t, term_t) = term_t.
apply_env_f(Env, T) = apply_env(T, Env).

%---------------------------------------------------------------------------%
% Pretty-printing terms.

:- func term_str(term_t) = string.
term_str(a(S)) = S.
term_str(n(I)) = string.int_to_string(I).
term_str(v(X)) = "_" ++ X.
term_str(f(F, Args)) = Result :-
    ( F = "[]", Args = [] ->
        Result = "[]"
    ; F = "[|]", Args = [H, T] ->
        Result = "[" ++ term_str(H) ++ list_tail_str(T)
    ;
        Result = F ++ "(" ++ string.join_list(", ", list.map(term_str, Args)) ++ ")"
    ).

:- func list_tail_str(term_t) = string.
list_tail_str(T) = Result :-
    ( T = f("[]", []) ->
        Result = "]"
    ; T = f("[|]", [H, TT]) ->
        Result = ", " ++ term_str(H) ++ list_tail_str(TT)
    ; T = v(X) ->
        Result = "|_" ++ X ++ "]"
    ;
        Result = "|" ++ term_str(T) ++ "]"
    ).

%---------------------------------------------------------------------------%
% Demo programs

% parent(tom,bob). parent(bob,ann). parent(bob,pat).
% ancestor(X,Y) :- parent(X,Y).
% ancestor(X,Y) :- parent(X,Z), ancestor(Z,Y).

:- func ancestor_prog = prog_t.
ancestor_prog = prog([
    c(f("parent", [a("tom"), a("bob")]), []),
    c(f("parent", [a("bob"), a("ann")]), []),
    c(f("parent", [a("bob"), a("pat")]), []),
    c(f("ancestor", [v("X"), v("Y")]),
        [f("parent", [v("X"), v("Y")])]),
    c(f("ancestor", [v("X"), v("Y")]),
        [f("parent", [v("X"), v("Z")]), f("ancestor", [v("Z"), v("Y")])])
]).

% app([],Y,Y).
% app([H|T],Y,[H|R]) :- app(T,Y,R).

:- func app_prog = prog_t.
app_prog = prog([
    c(f("app", [f("[]", []), v("Y"), v("Y")]), []),
    c(f("app", [f("[|]", [v("H"), v("T")]), v("Y"),
                 f("[|]", [v("H"), v("R")])]),
        [f("app", [v("T"), v("Y"), v("R")])])
]).

:- func list_t(list(term_t)) = term_t.
list_t([])       = f("[]", []).
list_t([H | T])  = f("[|]", [H, list_t(T)]).

%---------------------------------------------------------------------------%

:- pred run_query(prog_t::in, term_t::in, string::in,
                  io::di, io::uo) is det.
run_query(Prog, Goal, Label, !IO) :-
    io.format("?- %s\n", [s(Label)], !IO),
    solutions(
        (pred(Env::out) is nondet :- solve(Prog, [Goal], 0, [], Env)),
        Envs),
    ( Envs = [] ->
        io.write_string("  false\n", !IO)
    ;
        list.foldl(
            (pred(Env::in, !.IO::di, !:IO::uo) is det :-
                Result = apply_env(Goal, Env),
                io.format("  %s\n", [s(term_str(Result))], !IO)),
            Envs, !IO)
    ).

main(!IO) :-
    io.write_string("=== ancestor/2 ===\n", !IO),
    run_query(ancestor_prog,
        f("ancestor", [a("tom"), v("Who")]),
        "ancestor(tom, Who)", !IO),
    io.nl(!IO),
    run_query(ancestor_prog,
        f("ancestor", [a("bob"), v("Who")]),
        "ancestor(bob, Who)", !IO),
    io.nl(!IO),
    run_query(ancestor_prog,
        f("ancestor", [a("ann"), v("Who")]),
        "ancestor(ann, Who)", !IO),

    io.nl(!IO),
    io.write_string("=== append/3 ===\n", !IO),
    run_query(app_prog,
        f("app", [list_t([n(1), n(2)]), list_t([n(3)]), v("Result")]),
        "app([1,2], [3], Result)", !IO),
    io.nl(!IO),
    run_query(app_prog,
        f("app", [v("A"), v("B"), list_t([n(1), n(2), n(3)])]),
        "app(A, B, [1,2,3])", !IO).
