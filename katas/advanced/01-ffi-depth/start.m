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

% ---- C declarations -------------------------------------------------------
% Bring in the timeval struct and gettimeofday from POSIX.
:- pragma foreign_decl("C", "
    #include <sys/time.h>
    #include <time.h>
").

% ---- Foreign type ---------------------------------------------------------
% Wrap the C timeval struct as an abstract Mercury type.
:- type timeval.
:- pragma foreign_type("C", timeval, "struct timeval").

% ---- Foreign procs --------------------------------------------------------
% get_time_of_day: call gettimeofday and return seconds + microseconds.
:- pred get_time_of_day(int::out, int::out, io::di, io::uo) is det.
:- pragma foreign_proc("C",
    get_time_of_day(Secs::out, Usecs::out, _IO0::di, _IO::uo),
    [promise_pure, will_not_call_mercury],
    "
    struct timeval tv;
    gettimeofday(&tv, NULL);
    Secs  = (MR_Integer) tv.tv_sec;
    Usecs = (MR_Integer) tv.tv_usec;
    "
).

% ---- Mercury wrapper -------------------------------------------------------
% elapsed_ms: capture two timestamps and return the elapsed milliseconds.
:- pred elapsed_ms(float::out, io::di, io::uo) is det.
elapsed_ms(Ms, !IO) :-
    get_time_of_day(S1, U1, !IO),
    get_time_of_day(S2, U2, !IO),
    DiffUs = (S2 - S1) * 1_000_000 + (U2 - U1),
    Ms = float(DiffUs) / 1000.0.

% ---- Foreign export (bonus) -----------------------------------------------
% Export a Mercury predicate back to C (demonstrates foreign_export).
:- pred mercury_hello(io::di, io::uo) is det.
mercury_hello(!IO) :- io.write_string("Hello from Mercury (called via C)\n", !IO).
:- pragma foreign_export("C", mercury_hello(di, uo), "mercury_hello_c").

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    get_time_of_day(Secs, _, !IO),
    check("gettimeofday returns positive secs", ( Secs > 0 -> yes ; no ), !IO),
    elapsed_ms(Ms, !IO),
    io.format("Elapsed: %.3f ms\n", [f(Ms)], !IO),
    check("elapsed >= 0", ( Ms >= 0.0 -> yes ; no ), !IO).
