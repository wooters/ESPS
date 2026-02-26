# NAME

mu2esps - convert a headerless mu-encoded file to an ESPS file

# SYNOPSIS

**mu2esps** \[ *-s* \] \[ **-x** *debug_level* \] *infile* *outfile*

# DESCRIPTION

*Mu2esps* converts a headerless, mu-encoded file into an ESPS sampled
data file. The sampling frequency is assumed to be 8000 samples/second.
The program *addgen* (1-ESPS) can be used to change the ESPS header
value (*record_freq*) if the data has a different sampling frequency.

If *infile* is replaced by "-", *mu2esps* will read from standard input,
and if *outfile* is replaced by "-", standard output is written.

# OPTIONS

The following options are supported:

**-s**  
This option is only available on SUN platforms. It indicates *infile*
has a SUNOS 4.1 audio file header. This causes *mu2esps* to skip the
header before reading and converting the data.

**-x** *debug_level*  
If *debug_level* is positive, *mu2esps* prints diagnostic messages. The
default level is zero, which causes no debug output.

# ESPS HEADER

A FEA_SD (5-ESPS) header is written.

# ESPS PARAMETERS

This program does not access the parameter file.

# ESPS COMMON

This program does not access common.

# DIAGNOSTICS

None.

# WARNINGS

*mu2esps* (1-ESPS) maps the mu-encoded values into the range -8059 to
8059. If the original linear data had a full 16 bit dynamic range, the
output data can be scaled up by using *copysd* (1-ESPS).

# SEE ALSO

*mu_to_linear* (3-ESPS), *linear_to_mu* (3-ESPS),\
*play* (1-ESPS), *esps2mu* (1-ESPS)

# BUGS

None known.

# AUTHOR

Manual page and code by David Burton.
