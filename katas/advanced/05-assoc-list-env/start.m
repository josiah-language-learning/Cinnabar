:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module int.
:- import_module list.
:- import_module pair.
:- import_module string.

% Association list type alias
:- type env(K, V) == list(pair(K, V)).

% ---- Step 1: lookup, extend, delete ------------------------------------------

% lookup(Key, Env, Val) — find the first binding for Key in Env
:- pred lookup(K::in, env(K, V)::in, V::out) is semidet.
lookup(_, _, _) :- fail.   % replace with your implementation

% extend(Key, Val, Env) — prepend a new binding (shadows any existing one)
:- func extend(K, V, env(K, V)) = env(K, V).
extend(_, _, _) = [].   % replace with your implementation

% delete(Key, Env) — remove the first binding for Key
:- func delete(K, env(K, V)) = env(K, V).
delete(_, Env) = Env.   % replace with your implementation

% ---- Step 2: deref chains ----------------------------------------------------

:- type val ---> var(string) ; lit(int).
:- type venv == env(string, val).

% deref(V, Env, Result) — follow variable chains until non-variable or unbound
:- pred deref(val::in, venv::in, val::out) is det.
deref(V, _, V).   % replace with your implementation

% ---- Step 3: scope stack / let evaluator -------------------------------------

:- type expr
    --->    elit(int)
    ;       evar(string)
    ;       eadd(expr, expr)
    ;       elet(string, expr, expr).   % let x = E1 in E2

:- pred eval(expr::in, env(string, int)::in, int::out) is semidet.
eval(_, _, 0).   % replace with your implementation

% ---- Checks ------------------------------------------------------------------

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    % Step 1: basic lookup
    E0 = ([] : env(string, int)),
    ( lookup("x", E0, _) ->
        check("empty env lookup fails", no, !IO)
    ;
        check("empty env lookup fails", yes, !IO)
    ),
    E1 = extend("x", 42, E0),
    ( lookup("x", E1, 42) ->
        check("extend then lookup", yes, !IO)
    ;
        check("extend then lookup", no, !IO)
    ),
    E2 = extend("x", 99, E1),
    ( lookup("x", E2, 99) ->
        check("later binding shadows earlier", yes, !IO)
    ;
        check("later binding shadows earlier", no, !IO)
    ),
    E3 = delete("x", E2),
    ( lookup("x", E3, 42) ->
        check("delete reveals earlier binding", yes, !IO)
    ;
        check("delete reveals earlier binding", no, !IO)
    ),

    % Step 2: deref chains
    VE0 = ([] : venv),
    VE1 = extend("x", lit(7), VE0),
    VE2 = extend("y", var("x"), VE1),
    deref(var("y"), VE2, R1),
    check("deref chain y→x→7", ( R1 = lit(7) -> yes ; no ), !IO),
    deref(var("z"), VE2, R2),
    check("unbound deref returns var", ( R2 = var("z") -> yes ; no ), !IO),

    % Step 3: let evaluator
    Expr = elet("x", elit(5), eadd(evar("x"), evar("x"))),
    ( eval(Expr, [], 10) ->
        check("let x=5 in x+x = 10", yes, !IO)
    ;
        check("let x=5 in x+x = 10", no, !IO)
    ).
