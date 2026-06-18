:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is cc_multi.

:- implementation.
:- import_module array.
:- import_module bool.
:- import_module int.
:- import_module list.
:- import_module string.
:- import_module thread.
:- import_module thread.mvar.
:- import_module thread.semaphore.
:- import_module version_array.

% UNIQUENESS AND THREADS:
%
% A `unique` value cannot be passed to two threads — the mode system enforces
% this structurally. `array` requires unique (di/uo) modes, so you cannot hand
% an array to two parallel conjuncts. The fix: use `version_array` instead,
% which is persistent (non-unique) and safe to share.
%
% Data races on !IO values (mutvars, channels) are still possible — the mode
% system serializes access through the IO token, but read-modify-write on an
% mvar is not atomic without an explicit mutex.

% ---- Exercise 1: version_array — safe shared read -------------------------
%
% Build a version_array, pass it to two parallel-style operations.
% (We use sequential reads here because & would require both branches to be det.)

:- pred read_two(version_array(int)::in, int::out, int::out) is det.
read_two(VA, A, B) :-
    A = version_array.lookup(VA, 0),
    B = version_array.lookup(VA, 1).

% ---- Exercise 2: safe counter with mutex ----------------------------------
%
% Two threads increment a shared counter. Without a mutex, the
% read-modify-write cycle is a data race. With a semaphore mutex, it is safe.

:- type counter == mvar(int).
:- type mutex   == semaphore.semaphore.

:- pred counter_init(int::in, counter::out, io::di, io::uo) is det.
counter_init(N, C, !IO) :- mvar.init(N, C, !IO).

:- pred mutex_init(mutex::out, io::di, io::uo) is det.
mutex_init(M, !IO) :- semaphore.init(M, !IO), semaphore.signal(M, !IO).

:- pred safe_inc(counter::in, mutex::in, io::di, io::uo) is det.
safe_inc(C, M, !IO) :-
    semaphore.wait(M, !IO),
    mvar.take(C, N, !IO),
    mvar.put(C, N + 1, !IO),
    semaphore.signal(M, !IO).

% spawn N threads each calling safe_inc K times
:- pred spawn_incs(int::in, int::in, counter::in, mutex::in,
                   io::di, io::uo) is cc_multi.
spawn_incs(N, K, C, M, !IO) :-
    ( N =< 0 -> true
    ;
        thread.spawn(
            (pred(IO0::di, IO1::uo) is cc_multi :-
                inc_k(K, C, M, IO0, IO1)),
            !IO),
        spawn_incs(N - 1, K, C, M, !IO)
    ).

:- pred inc_k(int::in, counter::in, mutex::in, io::di, io::uo) is det.
inc_k(K, C, M, !IO) :-
    ( K =< 0 -> true
    ; safe_inc(C, M, !IO), inc_k(K - 1, C, M, !IO)
    ).

% ---- Exercise 3: why array requires uniqueness ----------------------------
%
% Attempting to pass an array to two separate computations without
% threading through unique modes is a compile error. The fix is version_array.
% This exercise documents the error — try the commented code in a test file.
%
% ERROR (does not compile):
%   VA0 = version_array.from_list([1, 2, 3]),
%   ( A = version_array.lookup(VA0, 0)
%   & B = version_array.lookup(VA0, 1)
%   )
%
% This works because version_array.lookup takes `in` (not `di`), so VA0 can
% be shared. An array would require `array_di` mode which is unique.

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    % Exercise 1: version_array shared read.
    VA = version_array.from_list([10, 20, 30]),
    read_two(VA, A, B),
    check("version_array shared read: A=10, B=20",
        ( A = 10, B = 20 -> yes ; no ), !IO),
    % Exercise 2: safe counter.
    counter_init(0, C, !IO),
    mutex_init(Mutex, !IO),
    spawn_incs(4, 25, C, Mutex, !IO),
    thread.yield(!IO),
    mvar.read(C, Final, !IO),
    io.format("4 threads x 25 safe_inc = %d (expect 100)\n", [i(Final)], !IO),
    % Exercise 3: build an array and update it through unique mode.
    array.init(5, 0, Arr0),
    array.set(2, 99, Arr0, Arr1),
    check("array unique update: Arr[2] = 99",
        ( array.lookup(Arr1, 2) = 99 -> yes ; no ), !IO),
    % Stub: rewrite spawn_incs to use array+semaphore instead of mvar
    % and observe that array must be passed through a single unique chain,
    % not distributed across threads.
    io.write_string("(See README for the uniqueness-vs-array exercise.)\n", !IO).
