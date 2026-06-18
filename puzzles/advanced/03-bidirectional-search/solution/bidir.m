:- module bidir.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module float.
:- import_module int.
:- import_module list.
:- import_module math.
:- import_module solutions.
:- import_module string.

:- type property ---> prime ; perfect_square ; fibonacci ; triangular.

%---------------------------------------------------------------------------%
% Property predicates

:- pred is_prime(int::in) is semidet.
is_prime(N) :-
    N > 1,
    ( N =< 3 ->
        true
    ;
        N mod 2 \= 0,
        no_small_factor(N, 3)
    ).

:- pred no_small_factor(int::in, int::in) is semidet.
no_small_factor(N, F) :-
    ( F * F > N ->
        true
    ;
        N mod F \= 0,
        no_small_factor(N, F + 2)
    ).

% float.sqrt loses precision for large N; the I*I=N check catches any rounding error.
:- pred is_perfect_square(int::in) is semidet.
is_perfect_square(N) :-
    N >= 0,
    R = math.sqrt(float.float(N)),
    I = float.round_to_int(R),
    I * I = N.

% N is fibonacci iff 5*N^2+4 or 5*N^2-4 is a perfect square.
:- pred is_fibonacci(int::in) is semidet.
is_fibonacci(N) :-
    N >= 0,
    ( is_perfect_square(5 * N * N + 4) ->
        true
    ;
        is_perfect_square(5 * N * N - 4)
    ).

% N is triangular iff 8*N+1 is a perfect square.
:- pred is_triangular(int::in) is semidet.
is_triangular(N) :-
    N >= 0,
    is_perfect_square(8 * N + 1).

:- pred has_property(int::in, property::in) is semidet.
has_property(N, prime)          :- is_prime(N).
has_property(N, perfect_square) :- is_perfect_square(N).
has_property(N, fibonacci)      :- is_fibonacci(N).
has_property(N, triangular)     :- is_triangular(N).

%---------------------------------------------------------------------------%
% Forward: find the first integer in Lo..Hi with property P.
% A semidet recursive scan — no nondet generator in the condition.

:- pred first_with(property::in, int::out) is semidet.
first_with(P, N) :- first_from(1, 50, P, N).

:- pred first_from(int::in, int::in, property::in, int::out) is semidet.
first_from(Lo, Hi, P, N) :-
    Lo =< Hi,
    ( has_property(Lo, P) ->
        N = Lo
    ;
        first_from(Lo + 1, Hi, P, N)
    ).

% Collect up to K integers in 1..50 with property P.
:- pred first_k_with(property::in, int::in, list(int)::out) is det.
first_k_with(P, K, Results) :-
    solutions(
        (pred(N::out) is nondet :-
            gen(1, 50, N),
            has_property(N, P)),
        All),
    take_n(K, All, Results).

:- pred take_n(int::in, list(T)::in, list(T)::out) is det.
take_n(_, [], []).
take_n(N, [X | Xs], Result) :-
    ( N =< 0 ->
        Result = []
    ;
        take_n(N - 1, Xs, Rest),
        Result = [X | Rest]
    ).

%---------------------------------------------------------------------------%
% Reverse: all properties that N has (nondet).

:- pred properties_of(int::in, property::out) is nondet.
properties_of(N, P) :-
    property_val(P),
    has_property(N, P).

:- pred property_val(property::out) is multi.
property_val(prime).
property_val(perfect_square).
property_val(fibonacci).
property_val(triangular).

:- pred gen(int::in, int::in, int::out) is nondet.
gen(Lo, Hi, Lo) :- Lo =< Hi.
gen(Lo, Hi, N)  :- Lo < Hi, gen(Lo + 1, Hi, N).

:- func property_name(property) = string.
property_name(prime)          = "prime".
property_name(perfect_square) = "square".
property_name(fibonacci)      = "fibonacci".
property_name(triangular)     = "triangular".

%---------------------------------------------------------------------------%

:- func nums_1_to_20 = list(int).
nums_1_to_20 = [1,2,3,4,5,6,7,8,9,10,11,12,13,14,15,16,17,18,19,20].

main(!IO) :-
    io.write_string("=== Forward: first 5 per property ===\n", !IO),
    list.foldl(
        (pred(P::in, !.IO::di, !:IO::uo) is det :-
            first_k_with(P, 5, Ns),
            NStrs = list.map(string.int_to_string, Ns),
            io.format("%-10s: %s\n",
                [s(property_name(P)), s(string.join_list(", ", NStrs))], !IO)),
        [prime, perfect_square, fibonacci, triangular], !IO),

    io.nl(!IO),
    io.write_string("=== Reverse: properties of 1..20 ===\n", !IO),
    list.foldl(
        (pred(N::in, !.IO::di, !:IO::uo) is det :-
            solutions(properties_of(N), Props),
            ( Props \= [] ->
                PStrs = list.map(property_name, Props),
                io.format("%2d: %s\n",
                    [i(N), s(string.join_list(", ", PStrs))], !IO)
            ;
                true
            )),
        nums_1_to_20, !IO).
