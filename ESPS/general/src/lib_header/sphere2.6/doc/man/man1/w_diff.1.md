# NAME

    w_diff -  Compare two NIST SPHERE header waveform files

# SYNOPSIS

    w_diff w_diff [-hvdws] [-cCSTR] file1 file2

# DESCRIPTION

W_diff is a waveform comparing program. It can compare the SPHERE
headers of two files as well as the data portions of two SPHERE files.
If the files do not differ, a zero is returned by the program, otherwise
a non-zero value is returned.

**-cCSTR**  
Convert the files by the 'CSTR' used in a call to sp_set_data_mode()

**-d**  
Compare the data portions of the files byte by byte.

**-h**  
Print this help message.

**-s**  
Compare the SPHERE headers of the files.

**-w**  
Compare the waveforms of the two files after converting them using the
conversion string in 'CSTR'. This is the default

**-v**  
Set the verbosity level up by one, repeat the v for higher levels. A
verbosity setting of 1 will provide a description of each tests outcome.

# EXAMPLES

**w_diff -vdws lib/data/ex1_01.wav lib/data/ex1_01.wav**  
Compare a file to itself.

**w_diff -vdws lib/data/ex1_01.wav lib/data/ex1_10.wav**  
Compare a files of differing byte order.

# SEE ALSO

sp_set_data_mode(3)

# AUTHOR

Jon Fiscus (jon@jaguar.ncsl.nist.gov)
