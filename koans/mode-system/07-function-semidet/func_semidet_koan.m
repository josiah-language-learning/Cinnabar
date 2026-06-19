:- module func_semidet_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module int.
:- import_module list.
:- import_module string.

:- type expr
    --->  num(int)
    ;     add(expr, expr)
    ;     neg(expr).

:- type val
    --->  int_val(int)
    ;     error_val.

% BUG: these function clauses use unification that can fail.
% eval(E) = int_val(N) succeeds only when eval(E) returns int_val(_).
% If eval returns error_val, the unification fails — making the clause semidet.
% Functions in Mercury must be det; semidet conflicts with the function contract.
:- func eval(expr) = val.
eval(num(N)) = int_val(N).
eval(neg(E)) = int_val(-N) :-
    eval(E) = int_val(N).
eval(add(A, B)) = int_val(NA + NB) :-
    eval(A) = int_val(NA),
    eval(B) = int_val(NB).

main(!IO) :-
    V = eval(add(num(3), neg(num(2)))),
    io.format("eval: %s\n", [s(string.string(V))], !IO).
