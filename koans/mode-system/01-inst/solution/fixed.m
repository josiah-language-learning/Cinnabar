:- module fixed.
:- interface.
:- import_module io.
:- pred main(io::di, io::uo) is det.

:- implementation.
:- import_module bool.
:- import_module int.
:- import_module list.
:- import_module version_array.

main(!IO) :-
    VArr0 = version_array.init(5, 0),
    Flag = yes,
    % FIX: version_array does not require unique ownership
    (
        Flag = yes,
        version_array.set(0, 42, VArr0, VArr1)
    ;
        Flag = no,
        version_array.set(0, 0, VArr0, VArr1)
    ),
    io.write_line(version_array.to_list(VArr1), !IO).
