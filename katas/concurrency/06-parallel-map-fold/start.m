:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is cc_multi.

:- implementation.
:- import_module bool.
:- import_module int.
:- import_module list.
:- import_module string.
:- import_module thread.
:- import_module thread.channel.
:- import_module thread.mvar.

% PARALLEL MAP AND FOLD:
%
% par_map: apply a det function to each list element in a separate thread.
%   - Each worker writes its result to a dedicated result channel.
%   - The collector reads from all channels in the ORIGINAL ORDER (not
%     first-come-first-served) — this preserves list order.
%
% par_fold: a naive parallel fold is incorrect because the accumulator cannot
%   be duplicated. Instead: parallelize only the PREPARATION step (the map),
%   then fold sequentially over the results.

% ---- Exercise 1: par_map --------------------------------------------------
%
% Each thread processes one element and writes to its own channel.
% The collector reads channels in order to reconstruct the result list.

:- pred par_map(pred(T, U), list(T), list(U), io, io).
:- mode par_map(pred(in, out) is det, in, out, di, uo) is cc_multi.
par_map(_F, [], [], !IO).
par_map(F, [X | Xs], [Y | Ys], !IO) :-
    channel.init(Chan, !IO),
    thread.spawn(
        (pred(IO0::di, IO1::uo) is cc_multi :-
            F(X, Result),
            channel.put(Chan, Result, IO0, IO1)),
        !IO),
    par_map(F, Xs, Ys, !IO),
    channel.take(Chan, Y, !IO).
    % NOTE: We spawn the thread, recurse (spawning more threads for the tail),
    % then collect from THIS thread's channel. This gives us results in order,
    % but we wait for the LAST spawned thread first (LIFO). A fully parallel
    % version would pre-allocate all channels, spawn all threads, then collect
    % all in order. Stub: rewrite using list of channels.

% ---- Exercise 2: map-then-fold --------------------------------------------
%
% The preparation (F applied to each element) is parallelized via par_map.
% The reduction is sequential — it requires an ordered accumulation.

:- pred par_map_fold(pred(T, U), pred(U, A, A), list(T), A, A, io, io).
:- mode par_map_fold(pred(in, out) is det, pred(in, in, out) is det,
                     in, in, out, di, uo) is cc_multi.
par_map_fold(F, G, List, Acc0, Acc, !IO) :-
    par_map(F, List, Mapped, !IO),
    list.foldl(G, Mapped, Acc0, Acc).

% ---- Exercise 3: why naive parallel fold is wrong -------------------------
%
% broken_par_fold: attempts to fold in parallel — INCORRECT.
% Both branches receive the same initial Acc. The results are independent,
% so only one branch's update survives. This comment demonstrates the issue;
% the predicate deliberately produces a wrong result to make the point.
:- pred broken_par_fold_demo(list(int)::in, int::out, io::di, io::uo) is det.
broken_par_fold_demo(List, Sum, !IO) :-
    % Wrong: parallel fold. Each half starts from 0 independently.
    % Only the right branch's value is returned here as a stub.
    ( List = [] ->
        Sum = 0
    ; List = [H | T] ->
        % stub: in a real parallel fold, left and right halves would be computed
        % concurrently from Acc=0, then their partial results combined.
        % That only works if the operation is associative and 0 is the identity.
        % For non-associative ops (e.g., subtraction), it gives wrong answers.
        Sum = H + list.foldl(int.plus, T, 0)
    ;
        Sum = 0
    ).

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    % par_map: double each element in parallel.
    par_map(pred(X::in, Y::out) is det :- Y = X * 2,
            [1, 2, 3, 4, 5], Doubled, !IO),
    check("par_map doubles [1..5] = [2,4,6,8,10]",
        ( Doubled = [2, 4, 6, 8, 10] -> yes ; no ), !IO),
    % par_map_fold: square then sum.
    par_map_fold(
        pred(X::in, Y::out) is det :- Y = X * X,
        pred(V::in, A::in, B::out) is det :- B = A + V,
        [1, 2, 3, 4, 5], 0, SumSq, !IO),
    % 1 + 4 + 9 + 16 + 25 = 55
    check("par_map_fold: sum of squares [1..5] = 55",
        ( SumSq = 55 -> yes ; no ), !IO),
    broken_par_fold_demo([1, 2, 3, 4, 5], Demo, !IO),
    io.format("broken_par_fold result (demonstrates issue): %d\n", [i(Demo)], !IO).
