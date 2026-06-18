:- module main.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module convert.
:- import_module float.
:- import_module string.

main(!IO) :-
    % Expected: 32.0, 212.0, 0.0, 100.0
    io.format("0 C   -> %.1f F  (expected 32.0)\n",  [f(c_to_f(0.0))],   !IO),
    io.format("100 C -> %.1f F  (expected 212.0)\n", [f(c_to_f(100.0))], !IO),
    io.format("32 F  -> %.1f C  (expected 0.0)\n",   [f(f_to_c(32.0))],  !IO),
    io.format("212 F -> %.1f C  (expected 100.0)\n", [f(f_to_c(212.0))], !IO).
