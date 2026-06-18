:- module expr_eval.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module map.
:- import_module maybe.
:- import_module pair.
:- import_module string.

:- type expr
    --->    lit(int)
    ;       var(string)
    ;       add(expr, expr)
    ;       sub(expr, expr)
    ;       mul(expr, expr)
    ;       div(expr, expr)
    ;       neg(expr).

:- type env == map(string, int).

:- func bind_maybe(maybe(T), func(T) = maybe(U)) = maybe(U).
bind_maybe(no, _) = no.
bind_maybe(yes(X), F) = F(X).

:- func eval(env, expr) = maybe(int).
eval(_, lit(N)) = yes(N).
eval(Env, var(Name)) =
    ( map.search(Env, Name, V) -> yes(V) ; no ).
eval(Env, neg(E)) = map_maybe((func(V) = -V), eval(Env, E)).
eval(Env, add(A, B)) =
    bind_maybe(eval(Env, A), (func(VA) =
        map_maybe((func(VB) = VA + VB), eval(Env, B)))).
eval(Env, sub(A, B)) =
    bind_maybe(eval(Env, A), (func(VA) =
        map_maybe((func(VB) = VA - VB), eval(Env, B)))).
eval(Env, mul(A, B)) =
    bind_maybe(eval(Env, A), (func(VA) =
        map_maybe((func(VB) = VA * VB), eval(Env, B)))).
eval(Env, div(A, B)) =
    bind_maybe(eval(Env, A), (func(VA) =
        bind_maybe(eval(Env, B), (func(VB) =
            ( VB = 0 -> no ; yes(VA // VB) ))))).

main(!IO) :-
    Env = map.from_assoc_list(["x" - 10, "y" - 3]),
    Exprs = [
        add(var("x"), lit(5)),           % x + 5 = 15
        div(var("x"), var("y")),         % x / y = 3
        div(var("x"), lit(0)),           % x / 0 = no
        add(var("x"), var("z")),         % z unbound = no
        mul(add(var("x"), lit(2)), var("y"))  % (x+2)*y = 36
    ],
    list.foldl(eval_and_print(Env), Exprs, !IO).

:- pred eval_and_print(env::in, expr::in, io::di, io::uo) is det.
eval_and_print(Env, Expr, !IO) :-
    Result = eval(Env, Expr),
    ( Result = yes(N) ->
        io.format("yes(%d)\n", [i(N)], !IO)
    ;
        io.write_string("no\n", !IO)
    ).
