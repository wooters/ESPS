# NAME

muplay - play mu-encoded, headerless files through /dev/audio

# SYNOPSIS

**muplay** \[ **-x** \] *infile1* \[ *infile2, infile3, ...* \]

# DESCRIPTION

On a SPARCstation 1, *muplay* plays the named file(s) by using the built
in speech codec. The data files must be mu-encoded, and the play back
rate is fixed at 8000 samples/second. If *infile1* is replaced by "-",
*muplay* will read from standard input.

This program is based on the *sound* demo that Sun Microsystems Inc.
distributes with the SPARCstation 1.

# OPTIONS

The following options are supported:

**-x**  
By default, the internal speaker is used. If **-x** is set, the signal
output goes to the external headphone jack. A powered speaker can be
plugged in for general purpose listening.

# ESPS HEADER

None is read or written.

# ESPS PARAMETERS

This program does not access the parameter file.

# ESPS COMMON

This program does not access common.

# DIAGNOSTICS

*Muplay* informs the user and quits if no input file is specified.

# WARNINGS

Playing data that is not mu encoded results in a horrible noise.
Remember that the SPARCstation 1 audio chip operates only at 8000
sample/second.

# SEE ALSO

*linear_to_mu* (3-ESPS), *esps2mu* (1-ESPS), *splay* (1-ESPS), *wplay*
(1-ESPS)

# BUGS

None known.

# AUTHOR

Manual page and code by David Burton
