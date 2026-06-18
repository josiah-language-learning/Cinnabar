:- module convert.
:- interface.

:- func c_to_f(float) = float.
:- func f_to_c(float) = float.

:- implementation.

c_to_f(_C) = 0.0.   % stub: formula is (C * 9/5) + 32
f_to_c(_F) = 0.0.   % stub: formula is (F - 32) * 5/9
