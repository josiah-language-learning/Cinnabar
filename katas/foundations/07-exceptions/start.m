:- module start.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module list.
:- import_module exception.
:- import_module int.
:- import_module string.

% Exercise A — file line counter.
% count_lines: read from Stream until eof, accumulating a line count.
:- pred count_lines(io.text_input_stream::in, int::in, int::out,
                    io::di, io::uo) is det.
count_lines(_Stream, N, N, !IO).   % stub: should loop on io.read_line_as_string

% Exercise B — risky division.
% Throw software_error("division by zero") when Divisor = 0.
:- pred risky_division(int::in, int::in, int::out) is det.
risky_division(_A, _B, 0).   % stub: should be A // B, throw on 0

:- pred check(string::in, bool::in, io::di, io::uo) is det.
check(Name, yes, !IO) :- io.format("PASS: %s\n", [s(Name)], !IO).
check(Name, no,  !IO) :- io.format("FAIL: %s\n", [s(Name)], !IO).

main(!IO) :-
    % Exercise B tests (no filesystem needed).
    check("risky_division 10 // 2 = 5",
        ( risky_division(10, 2, R), R = 5 -> yes ; no ), !IO),
    check("risky_division 9 // 3 = 3",
        ( risky_division(9, 3, R2), R2 = 3 -> yes ; no ), !IO),
    % Catch the throw from dividing by zero.
    promise_equivalent_solutions [TryRes] exception.try(
        (pred(R3::out) is det :- risky_division(10, 0, R3)),
        TryRes),
    check("risky_division by zero throws",
        ( TryRes = exception(_) -> yes ; no ), !IO),
    % Exercise A is a manual test: open a file from argv and count its lines.
    % See README for the io.res / io.result pattern.
    io.write_string("\n(Exercise A: file I/O — run manually with a filename argument)\n",
                    !IO).
