:- module inst_koan.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module array.
:- import_module bool.

main(!IO) :-
    array.init(5, 0, Arr0),
    Flag = yes,

    % BUG: Arr0 has inst array_di (unique). In this disjunction,
    % both branches try to use Arr0. The compiler cannot guarantee
    % that Arr0 is unique at the start of the else-branch — the
    % then-branch already consumed it via array.set.
    (
        Flag = yes,
        array.set(0, 42, Arr0, Arr1)
    ;
        Flag = no,
        array.set(0, 0, Arr0, Arr1)   % MODE ERROR: Arr0 already consumed
    ),
    io.write_line(array.to_list(Arr1), !IO).
