# NAME

    tsphere - test the SPHERE speech waveform utilities

# SYNOPSIS

    tsphere [-vmeMh] [-l n] -d data_dir

# DESCRIPTION

**tsphere** performs a series of tests using the example SPHERE headered
waveform files found in the 'lib/data' directory of the SPHERE
distribution directory structure. If the program the program fails for
any reason, contact Jon Fiscus immediately.

The -h option prints a usage statement.

The -v option turns on the verbose mode.

The -m option allows memory allocation without actually freeing any
allocated memory.

The -M option does the same as the '-m' option, but the memory is
deallocated.

The -l option makes the program loop n times

the -e turns on the debugging statements for the error utility.

# EXAMPLES

**tsphere -d lib/data**  

# AUTHOR

Jon Fiscus (jon@jaguar.ncsl.nist.gov)
