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

% ===========================================================================
% Mercury does not have GADTs.
%
% In Haskell, a GADT lets each constructor refine the return type:
%
%   data Expr a where
%     LitI :: Int  -> Expr Int
%     LitB :: Bool -> Expr Bool
%     Add  :: Expr Int -> Expr Int -> Expr Int
%     Eq   :: Expr Int -> Expr Int -> Expr Bool
%
%   eval :: Expr a -> a
%   eval (LitI n)  = n          -- result type IS Int
%   eval (LitB b)  = b          -- result type IS Bool
%   eval (Add x y) = eval x + eval y
%   eval (Eq x y)  = eval x == eval y
%
% Mercury cannot express this directly. The type of `eval` would need to
% vary per constructor, which requires dependent types or GADTs.
%
% Approximation 1: separate types for each expression kind.
% Approximation 2: a union result type (loses type safety at call sites).
% Approximation 3: typeclasses + existential types (closest to GADTs).
% ===========================================================================

% ===========================================================================
% Approximation 1: Separate types per result kind
%
% The clearest approach. Two separate expression types: int_expr and bool_expr.
% Each has its own eval. The cost: shared structure (Add, Eq) must be duplicated
% or cross-referenced. The benefit: no ambiguity at call sites.
% ===========================================================================

:- type int_expr
    --->    int_lit(int)
    ;       add(int_expr, int_expr)
    ;       sub(int_expr, int_expr)
    ;       mul(int_expr, int_expr)
    ;       int_if(bool_expr, int_expr, int_expr).  % conditional: if bool then int else int

:- type bool_expr
    --->    bool_lit(bool)
    ;       eq_int(int_expr, int_expr)              % int equality → bool
    ;       and_expr(bool_expr, bool_expr)
    ;       not_expr(bool_expr).

:- func eval_int(int_expr) = int.
eval_int(int_lit(N)) = N.
eval_int(add(A, B)) = eval_int(A) + eval_int(B).
eval_int(sub(A, B)) = eval_int(A) - eval_int(B).
eval_int(mul(A, B)) = eval_int(A) * eval_int(B).
eval_int(int_if(Cond, Then, Else)) =
    ( eval_bool(Cond) = yes -> eval_int(Then) ; eval_int(Else) ).

:- func eval_bool(bool_expr) = bool.
eval_bool(bool_lit(B)) = B.
eval_bool(eq_int(A, B)) = ( eval_int(A) = eval_int(B) -> yes ; no ).
eval_bool(and_expr(A, B)) = ( eval_bool(A) = yes -> eval_bool(B) ; no ).
eval_bool(not_expr(E)) = ( eval_bool(E) = yes -> no ; yes ).

% ===========================================================================
% Approximation 2: Union result type
%
% A single expr type and a single eval that returns a tagged union.
% Type safety is recovered at extraction — you must pattern-match the result.
% Less safe than GADTs (you can build `add(bool_val(yes), bool_val(no))`
% which would produce a runtime error), but simpler to write.
% ===========================================================================

:- type val
    --->    int_val(int)
    ;       bool_val(bool).

:- type expr
    --->    lit_i(int)
    ;       lit_b(bool)
    ;       add_e(expr, expr)
    ;       eq_e(expr, expr)
    ;       if_e(expr, expr, expr).

:- func eval(expr) = val.
eval(lit_i(N)) = int_val(N).
eval(lit_b(B)) = bool_val(B).
% NOTE: the union type approach loses safety here. An ill-typed expression
% like add_e(lit_b(yes), lit_i(1)) produces a fallback result rather than
% a compile error. This is the cost of the union approximation.
eval(add_e(A, B)) = Result :-
    ( eval(A) = int_val(NA), eval(B) = int_val(NB) ->
        Result = int_val(NA + NB)
    ;
        Result = int_val(0)
    ).
eval(eq_e(A, B)) = Result :-
    VA = eval(A),
    VB = eval(B),
    ( VA = VB -> Result = bool_val(yes) ; Result = bool_val(no) ).
eval(if_e(Cond, Then, Else)) = Result :-
    ( eval(Cond) = bool_val(yes) -> Result = eval(Then) ; Result = eval(Else) ).

% ===========================================================================
% Approximation 3: Typeclass dispatch (closest to GADT eval)
%
% A typeclass `evaluable(Expr, Val)` binds an expression type to a result type.
% Each expression type has exactly one eval result type.
% This gives compile-time dispatch without a union result, but requires
% separate types for int and bool expressions (same as Approximation 1).
% ===========================================================================

:- typeclass evaluable(Expr, Val) where [
    func tc_eval(Expr) = Val
].

:- instance evaluable(int_expr, int) where [
    tc_eval(E) = eval_int(E)
].

:- instance evaluable(bool_expr, bool) where [
    tc_eval(E) = eval_bool(E)
].

:- func show_result(E) = string <= evaluable(E, int).
show_result(E) = string.int_to_string(tc_eval(E)).

:- func show_bool_result(E) = string <= evaluable(E, bool).
show_bool_result(E) = ( tc_eval(E) = yes -> "true" ; "false" ).

% ===========================================================================
% Checks
% ===========================================================================

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    % Approximation 1: separate types
    check("eval_int: 2 + 3 = 5",
        ( eval_int(add(int_lit(2), int_lit(3))) = 5 -> yes ; no ), !IO),
    check("eval_int: (3-1)*4 = 8",
        ( eval_int(mul(sub(int_lit(3), int_lit(1)), int_lit(4))) = 8 -> yes ; no ), !IO),
    check("eval_bool: 2+3 = 5",
        ( eval_bool(eq_int(add(int_lit(2), int_lit(3)), int_lit(5))) = yes -> yes ; no ), !IO),
    check("eval_int: if (1=1) then 10 else 20",
        ( eval_int(int_if(eq_int(int_lit(1), int_lit(1)), int_lit(10), int_lit(20))) = 10
          -> yes ; no ), !IO),

    % Approximation 2: union type
    check("eval union: lit_i 42",
        ( eval(lit_i(42)) = int_val(42) -> yes ; no ), !IO),
    check("eval union: add_e 1 2",
        ( eval(add_e(lit_i(1), lit_i(2))) = int_val(3) -> yes ; no ), !IO),
    check("eval union: eq_e 5 5 = true",
        ( eval(eq_e(lit_i(5), lit_i(5))) = bool_val(yes) -> yes ; no ), !IO),

    % Approximation 3: typeclass
    check("tc_eval int: 3*3 = 9",
        ( tc_eval(mul(int_lit(3), int_lit(3))) = 9 -> yes ; no ), !IO),
    check("tc_eval bool: not(1=2) = true",
        ( tc_eval(not_expr(eq_int(int_lit(1), int_lit(2)))) = yes -> yes ; no ), !IO),
    check("show_result: 2+3",
        ( show_result(add(int_lit(2), int_lit(3))) = "5" -> yes ; no ), !IO).
